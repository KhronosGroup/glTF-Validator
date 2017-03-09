/*
 * # Copyright (c) 2016 The Khronos Group Inc.
 * # Copyright (c) 2016 Alexey Knyazev
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

import "package:test/test.dart";
import "package:gltf/gltf.dart";

void main() {
  const String VERSION = "version"; //should we import members.dart?

  test("An empty Asset is invalid", () {
    Map<String, Object> map = new Map();
    Context context = new Context();

    Asset.fromMap(map, context);

    expect(context.errors.isEmpty, false);
    expect(context.warnings.isEmpty, true);
  });

  test("Verify version 1.1 is invalid", () {
    Map<String, Object> map = new Map();
    map[VERSION] = "1.1";
    Context context = new Context();

    Asset.fromMap(map, context);

  expect(context.errors.isEmpty, false);
  expect(context.warnings.isEmpty, true);
  });

  test("Verify version 2.0 is valid", () {
    Map<String, Object> map = new Map();
    map[VERSION] = "2.0";
    Context context = new Context();

    Asset.fromMap(map, context);

  expect(context.errors.isEmpty, true);
  expect(context.warnings.isEmpty, true);
  });
}
