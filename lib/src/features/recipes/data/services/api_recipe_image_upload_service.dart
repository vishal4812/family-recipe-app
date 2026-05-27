import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exception.dart';
import '../dtos/uploaded_image_dto.dart';

class ApiRecipeImageUploadService {
  ApiRecipeImageUploadService({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<String> uploadImage(String filePath) async {
    try {
      final response = await _apiClient.postMultipart(
        '/uploads/image',
        fileField: 'file',
        filePath: filePath,
      );
      if (response is! Map<String, dynamic>) {
        throw Exception('We could not upload the photo.');
      }

      final uploadedImage = UploadedImageDto.fromJson(response);
      if (uploadedImage.url.trim().isEmpty) {
        throw Exception('We could not upload the photo.');
      }

      final uploadedImageUrl = Uri.tryParse(uploadedImage.url.trim());
      if (uploadedImageUrl == null ||
          !uploadedImageUrl.hasScheme ||
          uploadedImageUrl.host.trim().isEmpty ||
          (uploadedImageUrl.scheme != 'http' &&
              uploadedImageUrl.scheme != 'https')) {
        throw Exception(
          'Photo uploaded, but the server returned an invalid image URL.',
        );
      }

      return uploadedImage.url;
    } on ApiException catch (error) {
      final message = error.message.toLowerCase();
      if (error.statusCode == 413 || message.contains('too large')) {
        throw Exception('Photo is too large. Choose an image under 5 MB.');
      }
      if (message.contains('only image')) {
        throw Exception('Please choose an image file for this recipe.');
      }
      rethrow;
    }
  }
}
