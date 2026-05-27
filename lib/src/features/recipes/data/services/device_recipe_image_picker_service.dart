import 'package:image_picker/image_picker.dart';

import '../../domain/services/recipe_image_picker_service.dart';

class DeviceRecipeImagePickerService implements RecipeImagePickerService {
  DeviceRecipeImagePickerService({ImagePicker? imagePicker})
    : _imagePicker = imagePicker ?? ImagePicker();

  final ImagePicker _imagePicker;

  @override
  Future<String?> pickFromGallery() async {
    final picked = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    return picked?.path;
  }
}
