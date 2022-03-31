/*
 * # Copyright (c) 2016-2019 The Khronos Group Inc.
 * #
 * # Licensed under the Apache License, Version 2.0 (the "License");
 * # you may not use this file except in compliance with the License.
 * # You may obtain a copy of the License at
 * #
 * #     http://www.apache.org/licenses/LICENSE-2.0
 * #
 * # Unless required by applicable law or agreed to in writing, software
 * # distributed under the License is distributed on an "AS IS" BASIS,
 * # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * # See the License for the specific language governing permissions and
 * # limitations under the License.
 */

library gltf.data_access.image_decoder;

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

enum ImageCodec { JPEG, PNG, WebP }

extension ImageCodecMimeType on ImageCodec {
  String get mimeType {
    switch (this) {
      case ImageCodec.JPEG:
        return 'image/jpeg';
      case ImageCodec.PNG:
        return 'image/png';
      case ImageCodec.WebP:
        return 'image/webp';
    }
    throw ArgumentError();
  }
}

enum _ColorPrimaries { Unknown, sRGB, Custom }

enum _ColorTransfer { Unknown, Linear, sRGB, Custom }

enum Format { Unknown, RGB, RGBA, Luminance, LuminanceAlpha }

class ImageInfo {
  final String mimeType;
  final int bits;
  final Format format;
  final int width;
  final int height;
  final _ColorPrimaries colorPrimaries;
  final _ColorTransfer colorTransfer;
  final bool hasNonSquarePixels;
  final bool hasAnimation;

  bool get hasCustomColorInfo =>
      colorPrimaries == _ColorPrimaries.Custom ||
      colorTransfer == _ColorTransfer.Custom;

  ImageInfo._(this.mimeType, this.bits, this.format, this.width, this.height,
      {this.colorPrimaries = _ColorPrimaries.Unknown,
      this.colorTransfer = _ColorTransfer.Unknown,
      this.hasNonSquarePixels = false,
      this.hasAnimation = false});

  Map<String, Object> toMap() => <String, Object>{
        'width': width,
        'height': height,
        if (format != Format.Unknown)
          'format': const [
            null,
            'rgb',
            'rgba',
            'luminance',
            'luminance-alpha'
          ][format.index],
        if (colorPrimaries != _ColorPrimaries.Unknown)
          'primaries': const [
            null,
            'srgb',
            'custom',
          ][colorPrimaries.index],
        if (colorTransfer != _ColorTransfer.Unknown)
          'transfer': const [
            null,
            'linear',
            'srgb',
            'custom',
          ][colorTransfer.index],
        if (bits > 0) 'bits': bits
      };

  static Future<ImageInfo> parseStreamAsync(Stream<List<int>> data) {
    ImageInfoDecoder decoder;
    StreamSubscription<List<int>> subscription;
    final completer = Completer<ImageInfo>();

    var isDetected = false;

    subscription = data.listen((data) {
      if (!isDetected) {
        if (data.length < 9) {
          subscription.cancel();
          completer.completeError(const UnexpectedEndOfStreamException());
          return;
        } else {
          switch (detectCodec(data as Uint8List)) {
            case ImageCodec.JPEG:
              decoder = JpegInfoDecoder(subscription, completer);
              break;
            case ImageCodec.PNG:
              decoder = PngInfoDecoder(subscription, completer);
              break;
            case ImageCodec.WebP:
              decoder = WebPInfoDecoder(subscription, completer);
              break;
            default:
              subscription.cancel();
              completer.completeError(const UnsupportedImageFormatException());
              return;
          }
          isDetected = true;
        }
      }
      decoder.add(data);
    }, onError: (Object e) {
      subscription.cancel();
      completer.completeError(e);
    }, onDone: () {
      decoder.close();
    });

    return completer.future;
  }

  static ImageCodec detectCodec(Uint8List firstChunk) {
    final byteData = firstChunk.buffer.asByteData();
    final dword0 = byteData.getUint32(0, Endian.little);

    // JPEG signature: FF D8 FF
    if (dword0 & 0xFFFFFF == 0xFFD8FF) {
      return ImageCodec.JPEG;
    }

    // PNG signature: 89 50 4E 47 0D 0A 1A 0A
    if (dword0 == 0x474E5089 &&
        byteData.getUint32(4, Endian.little) == 0x0A1A0A0D) {
      return ImageCodec.PNG;
    }

    // WebP signature: 52 49 46 46 XX XX XX XX 57 45 42 50 56 50
    if (dword0 == 0x46464952 &&
        byteData.getUint32(8, Endian.little) == 0x50424557 &&
        byteData.getUint16(12, Endian.little) == 0x5056) {
      return ImageCodec.WebP;
    }
    return null;
  }
}

abstract class ImageInfoDecoder implements Sink<List<int>> {
  final Completer<ImageInfo> completer;
  final StreamSubscription<List<int>> subscription;
  ImageInfoDecoder(this.subscription, this.completer);
  String get mimeType;

  @override
  void close() {
    subscription.cancel();
    if (!completer.isCompleted) {
      completer.completeError(const UnexpectedEndOfStreamException());
    }
  }
}

class JpegInfoDecoder extends ImageInfoDecoder {
  @override
  String get mimeType => 'image/jpeg';

  JpegInfoDecoder(StreamSubscription<List<int>> subscription,
      Completer<ImageInfo> completer)
      : super(subscription, completer);

  int _state = 0;
  int _type = 0;
  int _segmentLength = 0;
  int _segmentIndex = 0;

  Uint8List _sofBuffer;

  @override
  void add(List<int> data) {
    try {
      _add(data);
    } on InvalidDataFormatException catch (e) {
      subscription.cancel();
      completer.completeError(e);
    }
  }

  void _add(List<int> data) {
    var index = 0;
    var availableDataLength = 0;

    // States
    const START = 0x00;
    const LENGTH_START = 0x01;
    const LENGTH_END = 0x02;
    const SEGMENT = 0x03;

    const MARKER_START = 0xFF;

    const SOI = 0xD8; // Start of image
    const EOI = 0xD9; // End of image
    const TEM = 0x01; // Temporary AC use

    const RST = 0xD0; // Restart interval termination
    const RST_MASK = 0xF8;

    // Only Start-of-Frame markers contain dimensions:
    // C0-CF, except C4, C8, and CC; DE
    const SOF = 0xC0; // Start of frame
    const SOF_MASK = 0xF0;

    const DHP = 0xDE; // Define hierarchical progression

    const DHT = 0xC4; // Huffman table spec
    const SOF_EXT = 0xC8; // Reserved
    const DAC = 0xCC; // AC spec

    bool isSOF(int marker) =>
        (marker & SOF_MASK == SOF &&
            marker != DHT &&
            marker != SOF_EXT &&
            marker != DAC) ||
        marker == DHP;

    bool hasSegment(int marker) => !(marker == TEM ||
        marker & RST_MASK == RST ||
        marker == SOI ||
        marker == EOI ||
        marker == MARKER_START);

    while (index != data.length) {
      final byte = data[index];
      switch (_state) {
        case START:
          if (MARKER_START == byte) {
            _state = MARKER_START;
          } else {
            throw const InvalidDataFormatException('Invalid start of file.');
          }
          break;

        case MARKER_START:
          if (hasSegment(byte)) {
            _state = LENGTH_START;
            _type = byte;
            _segmentIndex = 0;
            _segmentLength = 0;
          }
          break;

        case LENGTH_START:
          _segmentLength = byte << 8;
          _state = LENGTH_END;
          break;

        case LENGTH_END:
          _segmentLength += byte;
          if (_segmentLength < 2) {
            throw const InvalidDataFormatException(
                'Invalid JPEG marker segment length.');
          }
          if (isSOF(_type)) {
            _sofBuffer = Uint8List(_segmentLength - 2);
          }
          _state = SEGMENT;
          break;

        case SEGMENT:
          availableDataLength =
              min(data.length - index, _segmentLength - _segmentIndex - 2);
          if (isSOF(_type)) {
            _sofBuffer.setRange(_segmentIndex,
                _segmentIndex += availableDataLength, data, index);

            if (_segmentIndex == _segmentLength - 2) {
              _parseSof();
              return;
            }
          } else {
            _segmentIndex += availableDataLength;
            if (_segmentIndex == _segmentLength - 2) {
              _state = MARKER_START;
            }
          }
          index += availableDataLength;
          continue;
      }
      index++;
    }
  }

  void _parseSof() {
    subscription.cancel();
    final data = _sofBuffer;
    final bits = data[0];
    final height = data[1] << 8 | data[2];
    final width = data[3] << 8 | data[4];

    var format = Format.Unknown;
    if (data[5] == 3) {
      format = Format.RGB;
    } else if (data[5] == 1) {
      format = Format.Luminance;
    } else {
      throw const InvalidDataFormatException(
          'Invalid number of JPEG color channels.');
    }

    completer.complete(ImageInfo._(mimeType, bits, format, width, height));
  }
}

class PngInfoDecoder extends ImageInfoDecoder {
  @override
  String get mimeType => 'image/png';

  PngInfoDecoder(StreamSubscription<List<int>> subscription,
      Completer<ImageInfo> completer)
      : super(subscription, completer);

  int _chunkLength = 0;
  int _chunkLengthIndex = 0;

  int _chunkType = 0;
  int _chunkTypeIndex = 0;

  int _chunkCrcIndex = 0;

  int _chunkDataIndex = 0;

  int _state = 0;

  bool _hasHeader = false;
  bool _hasTrns = false;

  _ColorTransfer _transfer = _ColorTransfer.Unknown;
  _ColorPrimaries _primaries = _ColorPrimaries.Unknown;

  bool _hasNonSquarePixels = false;

  final Uint8List _headerChunkBytes = Uint8List(13); // IHDR length
  final Uint8List _chunkBytes = Uint8List(32); // cHRM length

  @override
  void add(List<int> data) {
    const wrongChunkLengthException =
        InvalidDataFormatException('Wrong chunk length.');

    var index = 0;
    var availableDataLength = 0;

    const START = 0;
    const CHUNK_LENGTH = 1;
    const CHUNK_TYPE = 2;
    const CHUNK_DATA = 3;
    const CHUNK_CRC = 4;

    void reset() {
      _chunkLength = 0;
      _chunkLengthIndex = 0;
      _chunkType = 0;
      _chunkTypeIndex = 0;
      _chunkDataIndex = 0;
      _chunkCrcIndex = 0;
    }

    while (index != data.length) {
      final byte = data[index];

      switch (_state) {
        case START:
          index += 8; // skip PNG header, it should be already verified
          _state = CHUNK_LENGTH;
          continue;

        case CHUNK_LENGTH:
          _chunkLength = (_chunkLength << 8) | byte;
          _chunkLengthIndex++;
          if (_chunkLengthIndex == 4) {
            _state = CHUNK_TYPE;
          }
          break;

        case CHUNK_TYPE:
          _chunkType = (_chunkType << 8) | byte;
          _chunkTypeIndex++;
          if (_chunkTypeIndex == 4) {
            switch (_chunkType) {
              case _PngChunk.IHDR:
                if (_chunkLength != 13) {
                  _abort(wrongChunkLengthException);
                  return;
                }
                _hasHeader = true;
                break;
              case _PngChunk.tRNS:
                _hasTrns = true;
                break;
              case _PngChunk.cHRM:
                if (_chunkLength != 32) {
                  _abort(wrongChunkLengthException);
                  return;
                }
                break;
              case _PngChunk.sRGB:
                if (_chunkLength != 1) {
                  _abort(wrongChunkLengthException);
                  return;
                }
                break;
              case _PngChunk.pHYs:
                if (_chunkLength != 9) {
                  _abort(wrongChunkLengthException);
                  return;
                }
                break;
              case _PngChunk.gAMA:
                if (_chunkLength != 4) {
                  _abort(wrongChunkLengthException);
                  return;
                }
                break;
              case _PngChunk.iCCP:
                _transfer = _ColorTransfer.Custom;
                _primaries = _ColorPrimaries.Custom;
                break;
              case _PngChunk.IDAT:
                _parseIHDR();
                return;
            }

            if (_chunkLength == 0) {
              _state = CHUNK_CRC;
            } else {
              _state = CHUNK_DATA;
            }
          }
          break;

        case CHUNK_DATA:
          availableDataLength =
              min(data.length - index, _chunkLength - _chunkDataIndex);
          switch (_chunkType) {
            case _PngChunk.IHDR:
              _headerChunkBytes.setRange(_chunkDataIndex,
                  _chunkDataIndex += availableDataLength, data, index);
              break;

            case _PngChunk.cHRM:
            case _PngChunk.gAMA:
            case _PngChunk.pHYs:
              _chunkBytes.setRange(_chunkDataIndex,
                  _chunkDataIndex += availableDataLength, data, index);
              break;

            case _PngChunk.sRGB:
              // The chunk contains one byte describing rendering intent
              // 0 - perceptual
              // 1 - relative colorimetric
              // 2 - saturation-preserving
              // 3 - absolute colorimetric
              _transfer = _ColorTransfer.sRGB;
              _primaries = _ColorPrimaries.sRGB;

              _chunkDataIndex++;
              break;

            default:
              _chunkDataIndex += availableDataLength;
          }

          if (_chunkDataIndex == _chunkLength) {
            switch (_chunkType) {
              case _PngChunk.cHRM:
                if (_primaries == _ColorPrimaries.Unknown) {
                  _checkChrm();
                }
                break;
              case _PngChunk.gAMA:
                if (_transfer == _ColorTransfer.Unknown) {
                  _checkGama();
                }
                break;
              case _PngChunk.pHYs:
                _checkPhys();
                break;
            }

            _state = CHUNK_CRC;
          }

          index += availableDataLength;
          continue;

        case CHUNK_CRC:
          _chunkCrcIndex++;
          if (_chunkCrcIndex == 4) {
            reset();
            _state = CHUNK_LENGTH;
          }
          break;
      }
      index++;
    }
  }

  void _parseIHDR() {
    subscription.cancel();

    if (!_hasHeader) {
      completer.completeError(
          const InvalidDataFormatException('PNG header not found.'));
    }

    final data = _headerChunkBytes.buffer.asByteData();

    final width = data.getUint32(0, Endian.big);
    final height = data.getUint32(4, Endian.big);
    final bits = data.getUint8(8);

    var format = Format.Unknown;
    switch (data.getUint8(9)) {
      case 0: // Greyscale
        format = _hasTrns ? Format.LuminanceAlpha : Format.Luminance;
        break;
      case 2: // Truecolor
      case 3: // Indexed color
        format = _hasTrns ? Format.RGBA : Format.RGB;
        break;
      case 4: // Greyscale with alpha
        format = Format.LuminanceAlpha;
        break;
      case 6: // Truecolor with alpha
        format = Format.RGBA;
        break;
    }

    // No primaries defined, assume sRGB
    if (_primaries == _ColorPrimaries.Unknown) {
      _primaries = _ColorPrimaries.sRGB;
    }

    // No transfer function defined, assume sRGB
    if (_transfer == _ColorTransfer.Unknown) {
      _transfer = _ColorTransfer.sRGB;
    }

    completer.complete(ImageInfo._(mimeType, bits, format, width, height,
        colorPrimaries: _primaries,
        colorTransfer: _transfer,
        hasNonSquarePixels: _hasNonSquarePixels));
  }

  void _checkGama() {
    // sRGB chunk overrides gAMA chunk
    if (_transfer == _ColorTransfer.sRGB) {
      return;
    }

    // The value is encoded as a four-byte PNG unsigned integer,
    // representing gamma times 100000.

    // Default value is 45455 (1/2.2); linear (1) is also allowed
    switch (_chunkBytes.buffer.asByteData().getUint32(0, Endian.big)) {
      case 45455:
        _transfer = _ColorTransfer.sRGB;
        break;
      case 100000:
        _transfer = _ColorTransfer.Linear;
        break;
      default:
        _transfer = _ColorTransfer.Custom;
    }
  }

  void _checkPhys() {
    // Check that pixels are square
    final byteData = _chunkBytes.buffer.asByteData();
    final pixelsPerXUnit = byteData.getUint32(0, Endian.big);
    final pixelsPerYUnit = byteData.getUint32(4, Endian.big);

    if (pixelsPerXUnit != pixelsPerYUnit) {
      _hasNonSquarePixels = true;
    }
  }

  void _checkChrm() {
    // sRGB chunk overrides cHRM chunk
    if (_primaries == _ColorPrimaries.sRGB) {
      return;
    }

    // Each value is encoded as a four-byte PNG unsigned integer,
    // representing the x or y value times 100000.

    // Default values are

    // White point x 31270
    // White point y 32900
    // Red         x 64000
    // Red         y 33000
    // Green       x 30000
    // Green       y 60000
    // Blue        x 15000
    // Blue        y  6000

    final data = _chunkBytes.buffer.asByteData();

    if (data.getUint32(0, Endian.big) == 31270 &&
        data.getUint32(4, Endian.big) == 32900 &&
        data.getUint32(8, Endian.big) == 64000 &&
        data.getUint32(12, Endian.big) == 33000 &&
        data.getUint32(16, Endian.big) == 30000 &&
        data.getUint32(20, Endian.big) == 60000 &&
        data.getUint32(24, Endian.big) == 15000 &&
        data.getUint32(28, Endian.big) == 6000) {
      _primaries = _ColorPrimaries.sRGB;
    } else {
      _primaries = _ColorPrimaries.Custom;
    }
  }

  void _abort(Object error) {
    subscription.cancel();
    if (!completer.isCompleted) {
      completer.completeError(error);
    }
  }
}

class WebPInfoDecoder extends ImageInfoDecoder {
  @override
  String get mimeType => 'image/webp';

  // Accumulate no more than 30 bytes of WebP header
  final Uint8List _buffer = Uint8List(30);
  int _bufferIndex = 0;

  WebPInfoDecoder(StreamSubscription<List<int>> subscription,
      Completer<ImageInfo> completer)
      : super(subscription, completer);

  @override
  void add(List<int> bytes) {
    final availableDataLength =
        min(bytes.length, _buffer.length - _bufferIndex);
    _buffer.setRange(_bufferIndex, _bufferIndex += availableDataLength, bytes);

    // We need 30 bytes for VP8 and VP8X, but only 25 for VP8L.
    if (_bufferIndex < 25 || _bufferIndex < 30 && _buffer[0xF] != 0x4C) {
      return;
    }

    subscription.cancel();

    const RIFF = 0x52494646;
    const WEBP = 0x57454250;
    const VP8_ = 0x56503820;
    const VP8L = 0x5650384C;
    const VP8X = 0x56503858;

    final byteData = _buffer.buffer.asByteData();

    // RIFF size WEBP
    if (byteData.getUint32(0, Endian.big) != RIFF ||
        byteData.getUint32(8, Endian.big) != WEBP) {
      _abort(const InvalidDataFormatException('Wrong WebP header.'));
      return;
    }

    var format = Format.Unknown;
    var width = -1;
    var height = -1;
    var hasCustomColorInfo = false;
    var hasAnimation = false;

    // 4 bytes with chunk type followed by its size
    final type = byteData.getUint32(12, Endian.big);
    switch (type) {
      case VP8_:
        // Skipping first 6 bytes of VP8 bitstream

        // No alpha channel
        format = Format.RGB;

        // 14 bits of width
        width = byteData.getUint16(26, Endian.little) & 0x3FFF;

        // 14 bits of height
        height = byteData.getUint16(28, Endian.little) & 0x3FFF;
        break;
      case VP8L:
        // Skipping the first byte of VP8L bitstream

        // 1-based, 14 bits of width, LSB-packed
        width = 1;
        width += _buffer[21] | ((_buffer[22] & 0x3F) << 8);

        // 1-based, 14 bits of height, LSB-packed
        height = 1;
        height += (_buffer[22] >> 6) |
            (_buffer[23] << 2) |
            ((_buffer[24] & 0xF) << 10);

        // alpha_is_used
        format = _buffer[24] & 0x10 == 0x10 ? Format.RGBA : Format.RGB;
        break;
      case VP8X:
        // Used features byte
        final features = _buffer[20];
        hasAnimation = features & 2 == 2;
        hasCustomColorInfo = features & 0x20 == 0x20;
        format = features & 0x10 == 0x10 ? Format.RGBA : Format.RGB;

        // 1-based, 24 bits of width
        width = (_buffer[24] | (_buffer[25] << 8) | (_buffer[26] << 16)) + 1;

        // 1-based, 24 bits of height
        height = (_buffer[27] | (_buffer[28] << 8) | (_buffer[29] << 16)) + 1;
        break;
      default:
        _abort(const InvalidDataFormatException('Wrong WebP header.'));
        return;
    }
    completer.complete(ImageInfo._(mimeType, 8, format, width, height,
        colorTransfer:
            hasCustomColorInfo ? _ColorTransfer.Custom : _ColorTransfer.sRGB,
        colorPrimaries:
            hasCustomColorInfo ? _ColorPrimaries.Custom : _ColorPrimaries.sRGB,
        hasAnimation: hasAnimation));
  }

  void _abort(Object error) {
    subscription.cancel();
    if (!completer.isCompleted) {
      completer.completeError(error);
    }
  }
}

class UnsupportedImageFormatException implements Exception {
  const UnsupportedImageFormatException();
}

class UnexpectedEndOfStreamException implements Exception {
  const UnexpectedEndOfStreamException();
}

class InvalidDataFormatException implements Exception {
  final String message;
  const InvalidDataFormatException(this.message);

  @override
  String toString() => message;
}

abstract class _PngChunk {
  static const int IHDR = 0x49484452;
  static const int IDAT = 0x49444154;
  static const int tRNS = 0x74524E53;
  static const int cHRM = 0x6348524D;
  static const int sRGB = 0x73524742;
  static const int iCCP = 0x69434350;
  static const int gAMA = 0x67414D41;
  static const int pHYs = 0x70485973;
}
