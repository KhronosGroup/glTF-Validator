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

library gltf.context;

import 'dart:collection';

import 'package:gltf/src/base/gltf_property.dart';
import 'package:gltf/src/ext/extensions.dart';
import 'package:gltf/src/gl.dart' as gl;

class ValidationOptions {
  final int maxIssues;
  final Set<String> ignoredIssues = <String>{};
  final Map<String, Severity> severityOverrides;

  ValidationOptions(
      {int maxIssues, List<String> ignoredIssues, this.severityOverrides})
      : maxIssues = maxIssues ?? 0 {
    if (ignoredIssues != null) {
      this.ignoredIssues.addAll(ignoredIssues);
    }
  }
}

class Context {
  final bool validate;

  final ValidationOptions options;
  final List<String> path = <String>[];

  static final _extNameFormat = RegExp(r'^([A-Z0-9]+)_[A-Za-z0-9_]+$');

  static Iterable<String> get defaultExtensionNames =>
      kDefaultExtensions.map((e) => e.name);

  Context({this.validate = true, ValidationOptions options})
      : options = options ?? ValidationOptions() {
    _extensionsLoadedView = UnmodifiableListView(_extensionsLoaded);
    _extensionsUsedView = UnmodifiableListView(_extensionsUsed);
    _extensionDescriptorsView = UnmodifiableMapView(_extensionDescriptors);
    _resourcesView = UnmodifiableListView(_resources);
  }

  void addElementChecker(Accessor accessor, ElementChecker checker) {
    accessorElementCheckers
        .putIfAbsent(accessor, () => <ElementChecker>[])
        .add(checker);
  }

  final Map<Accessor, List<ElementChecker>> accessorElementCheckers =
      <Accessor, List<ElementChecker>>{};

  final Map<Object, Object> owners = <Object, Object>{};

  final Map<Type, List<LinkableExtensionEntry>> linkableExtensions =
      <Type, List<LinkableExtensionEntry>>{};

  final List<ResourceValidatableExtensionEntry> resourceValidatableExtensions =
      <ResourceValidatableExtensionEntry>[];

  final Map<BufferView, Set<Accessor>> bufferViewAccessors =
      <BufferView, Set<Accessor>>{};

  final Map<SafeList<Usable>, List<String>> extensionCollections =
      <SafeList<Usable>, List<String>>{};

  void registerObjectsOwner(Object owner, Iterable<Object> objects) {
    for (final o in objects) {
      if (o != null) {
        owners[o] = owner;
      }
    }
  }

  bool _isTruncated = false;
  bool get isTruncated => _isTruncated;

  final Map<ExtensionTuple, ExtensionDescriptor> _extensionDescriptors =
      <ExtensionTuple, ExtensionDescriptor>{};
  Map<ExtensionTuple, ExtensionDescriptor> _extensionDescriptorsView;
  Map<ExtensionTuple, ExtensionDescriptor> get extensionDescriptors =>
      _extensionDescriptorsView;

  final List<String> _extensionsUsed = <String>[];
  List<String> _extensionsUsedView;
  List<String> get extensionsUsed => _extensionsUsedView;

  final List<String> _extensionsLoaded = <String>[];
  List<String> _extensionsLoadedView;
  List<String> get extensionsLoaded => _extensionsLoadedView;

  final List<Map<String, Object>> _resources = <Map<String, Object>>[];
  List<Map<String, Object>> _resourcesView;
  List<Map<String, Object>> get resources => _resourcesView;

  final Set<Extension> _userExtensions = <Extension>{};

  final List<Issue> _issues = <Issue>[];

  List<Issue> get issues => _issues;

  Iterable<Issue> get errors =>
      _issues.where((issue) => issue.severity == Severity.Error);

  Iterable<Issue> get warnings =>
      _issues.where((issue) => issue.severity == Severity.Warning);

  Iterable<Issue> get infos =>
      _issues.where((issue) => issue.severity == Severity.Information);

  Iterable<Issue> get hints =>
      _issues.where((issue) => issue.severity == Severity.Hint);

  final StringBuffer _sb = StringBuffer();

  String getPointerString([String token]) {
    if (path.isEmpty && token != null && token.startsWith('/')) {
      return token; // Special case: token is already a pointer string
    }

    if (token != null) {
      path.add(token);
    }

    _sb
      ..write('/')
      ..writeAll(
          path.map<String>(
              (s) => s.replaceAll('~', '~0').replaceAll('/', '~1')),
          '/');

    if (token != null) {
      path.removeLast();
    }

    final result = _sb.toString();
    _sb.clear();
    return result;
  }

  void registerExtensions(List<Extension> userExtensions) {
    _userExtensions.addAll(userExtensions);
  }

  void initExtensions(
      List<String> extensionsUsed, List<String> extensionsRequired) {
    _extensionsUsed.addAll(extensionsUsed);

    for (var i = 0; i < extensionsUsed.length; ++i) {
      final extensionName = extensionsUsed[i];

      final prefix = _extNameFormat.firstMatch(extensionName)?.group(1);
      if (prefix == null) {
        addIssue(SemanticError.invalidExtensionNameFormat,
            name: '/$EXTENSIONS_USED/$i');
      } else if (!kReservedPrefixes.contains(prefix)) {
        addIssue(SemanticError.unreservedExtensionPrefix,
            name: '/$EXTENSIONS_USED/$i', args: [prefix]);
      }

      final extension = _userExtensions.firstWhere(
          (extension) => extension.name == extensionName,
          orElse: () => kDefaultExtensions.firstWhere(
              (extension) => extension.name == extensionName,
              orElse: () => null));

      if (extension == null) {
        addIssue(LinkError.unsupportedExtension,
            name: '/$EXTENSIONS_USED/$i', args: [extensionName]);
        continue;
      }

      extension.functions?.forEach((type, funcs) {
        _extensionDescriptors[ExtensionTuple(type, extension.name)] = funcs;
      });

      if (extension.init != null) {
        extension.init(this);
      }

      if (validate &&
          extension.required &&
          !extensionsRequired.contains(extensionName)) {
        addIssue(SemanticError.nonRequiredExtension,
            name: '/$EXTENSIONS_USED/$i', args: [extensionName]);
      }

      _extensionsLoaded.add(extensionName);
    }

    if (validate) {
      for (var i = 0; i < extensionsRequired.length; ++i) {
        final value = extensionsRequired[i];
        if (!extensionsUsed.contains(value)) {
          addIssue(SemanticError.unusedExtensionRequired,
              name: '/$EXTENSIONS_REQUIRED/$i', args: [value]);
        }
      }
    }
  }

  void addIssue(IssueType issueType,
      {String name,
      List<Object> args,
      int offset,
      int index,
      bool noPointer = false}) {
    if (options.ignoredIssues.contains(issueType.code)) {
      return;
    }

    if (options.maxIssues > 0 && _issues.length == options.maxIssues) {
      _isTruncated = true;
      throw const IssuesLimitExceededException();
    }

    final severityOverride = (options.severityOverrides != null)
        ? options.severityOverrides[issueType.code]
        : null;

    if (offset != null) {
      _issues.add(Issue(issueType, args,
          offset: offset, severityOverride: severityOverride));
    } else {
      final token = index != null ? index.toString() : name;
      _issues.add(Issue(issueType, args,
          pointer: noPointer ? '' : getPointerString(token),
          severityOverride: severityOverride));
    }
  }

  void addResource(Map<String, Object> info) => _resources.add(info);

  bool _isGlb = false;
  bool get isGlb => _isGlb;

  void setGlb() {
    _isGlb = true;
  }

  final List<String> imageMimeTypes = <String>[IMAGE_JPEG, IMAGE_PNG];

  final Map<String, Set<AccessorFormat>> attributeAccessorFormats =
      <String, Set<AccessorFormat>>{
    POSITION: {const AccessorFormat(VEC3, gl.FLOAT)},
    NORMAL: {const AccessorFormat(VEC3, gl.FLOAT)},
    TANGENT: {const AccessorFormat(VEC4, gl.FLOAT)},
    TEXCOORD_: {
      const AccessorFormat(VEC2, gl.FLOAT),
      const AccessorFormat(VEC2, gl.UNSIGNED_BYTE, normalized: true),
      const AccessorFormat(VEC2, gl.UNSIGNED_SHORT, normalized: true)
    },
    COLOR_: {
      const AccessorFormat(VEC3, gl.FLOAT),
      const AccessorFormat(VEC3, gl.UNSIGNED_BYTE, normalized: true),
      const AccessorFormat(VEC3, gl.UNSIGNED_SHORT, normalized: true),
      const AccessorFormat(VEC4, gl.FLOAT),
      const AccessorFormat(VEC4, gl.UNSIGNED_BYTE, normalized: true),
      const AccessorFormat(VEC4, gl.UNSIGNED_SHORT, normalized: true)
    },
    JOINTS_: {
      const AccessorFormat(VEC4, gl.UNSIGNED_BYTE),
      const AccessorFormat(VEC4, gl.UNSIGNED_SHORT)
    },
    WEIGHTS_: {
      const AccessorFormat(VEC4, gl.FLOAT),
      const AccessorFormat(VEC4, gl.UNSIGNED_BYTE, normalized: true),
      const AccessorFormat(VEC4, gl.UNSIGNED_SHORT, normalized: true)
    }
  };

  final Map<String, Set<AccessorFormat>> morphAttributeAccessorFormats =
      <String, Set<AccessorFormat>>{
    POSITION: {const AccessorFormat(VEC3, gl.FLOAT)},
    NORMAL: {const AccessorFormat(VEC3, gl.FLOAT)},
    TANGENT: {const AccessorFormat(VEC3, gl.FLOAT)},
    TEXCOORD_: {
      const AccessorFormat(VEC2, gl.FLOAT),
      const AccessorFormat(VEC2, gl.BYTE, normalized: true),
      const AccessorFormat(VEC2, gl.UNSIGNED_BYTE, normalized: true),
      const AccessorFormat(VEC2, gl.SHORT, normalized: true),
      const AccessorFormat(VEC2, gl.UNSIGNED_SHORT, normalized: true)
    },
    COLOR_: {
      const AccessorFormat(VEC3, gl.FLOAT),
      const AccessorFormat(VEC3, gl.BYTE, normalized: true),
      const AccessorFormat(VEC3, gl.UNSIGNED_BYTE, normalized: true),
      const AccessorFormat(VEC3, gl.SHORT, normalized: true),
      const AccessorFormat(VEC3, gl.UNSIGNED_SHORT, normalized: true),
      const AccessorFormat(VEC4, gl.FLOAT),
      const AccessorFormat(VEC4, gl.BYTE, normalized: true),
      const AccessorFormat(VEC4, gl.UNSIGNED_BYTE, normalized: true),
      const AccessorFormat(VEC4, gl.SHORT, normalized: true),
      const AccessorFormat(VEC4, gl.UNSIGNED_SHORT, normalized: true)
    }
  };
}

class IssuesLimitExceededException implements Exception {
  const IssuesLimitExceededException();
}
