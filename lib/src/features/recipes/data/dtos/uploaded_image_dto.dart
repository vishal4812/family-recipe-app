class UploadedImageDto {
  const UploadedImageDto({
    required this.url,
    required this.path,
    required this.originalName,
    required this.mimeType,
    required this.size,
  });

  final String url;
  final String path;
  final String originalName;
  final String mimeType;
  final int size;

  factory UploadedImageDto.fromJson(Map<String, dynamic> json) {
    return UploadedImageDto(
      url: (json['url'] as String?) ?? '',
      path: (json['path'] as String?) ?? '',
      originalName: (json['originalName'] as String?) ?? '',
      mimeType: (json['mimeType'] as String?) ?? '',
      size: (json['size'] as num?)?.toInt() ?? 0,
    );
  }
}
