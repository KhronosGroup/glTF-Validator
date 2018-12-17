/*
 * # Copyright (c) 2016-2017 The Khronos Group Inc.
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

import '../test/base/00.0_gltf_reader_test.dart' as gltf_reader;
import '../test/base/00.1_glb_reader_test.dart' as glb_reader;
//import '../test/base/01_utils_test.dart' as utils;
import '../test/base/02_asset_test.dart' as asset;
import '../test/base/03_buffer_test.dart' as buffer;
import '../test/base/04_buffer_view_test.dart' as buffer_view;
import '../test/base/05_camera_test.dart' as camera;
import '../test/base/06_image_test.dart' as image;
import '../test/base/07_sampler_test.dart' as sampler;
import '../test/base/08_texture_test.dart' as texture;
import '../test/base/09_material_test.dart' as material;
import '../test/base/10.0_accessor_test.dart' as accessor;
import '../test/base/10.1_accessor_get_elements_test.dart' as accessor_elements;
import '../test/base/10.2_accessor_get_elements_matrix_test.dart'
    as matrix_elements;
import '../test/base/10.3_accessor_get_elements_sparse_test.dart'
    as accessor_sparse;
import '../test/base/11_mesh_test.dart' as mesh;
import '../test/base/12_node_test.dart' as node;
import '../test/base/13_skin_test.dart' as skin;
import '../test/base/14_scene_test.dart' as scene;
import '../test/base/15_animation_test.dart' as animation;
import '../test/base/16_gltf_test.dart' as gltf;
import '../test/data_access/00_load_buffers_test.dart' as load_buffers;
import '../test/data_access/01_load_images_test.dart' as load_images;
import '../test/data_access/02_validate_accessor_elements_test.dart'
    as validate_accessors;
import '../test/ext/KHR_lights_punctual/ext_khr_lights_punctual_test.dart'
    as lights_punctual;
import '../test/ext/KHR_materials_pbrSpecularGlossiness/ext_khr_spec_gloss_test.dart'
    as spec_gloss;
import '../test/ext/KHR_materials_unlit/ext_khr_unlit_test.dart' as unlit;
import '../test/ext/KHR_texture_transform/ext_khr_texture_transform_test.dart'
    as texture_transform;

void main() {
  gltf_reader.main();
  glb_reader.main();
  // utils.main();
  asset.main();
  buffer.main();
  buffer_view.main();
  camera.main();
  image.main();
  sampler.main();
  texture.main();
  material.main();
  accessor.main();
  accessor_elements.main();
  matrix_elements.main();
  accessor_sparse.main();
  mesh.main();
  node.main();
  skin.main();
  scene.main();
  animation.main();
  gltf.main();
  lights_punctual.main();
  spec_gloss.main();
  unlit.main();
  texture_transform.main();
  load_buffers.main();
  load_images.main();
  validate_accessors.main();
}
