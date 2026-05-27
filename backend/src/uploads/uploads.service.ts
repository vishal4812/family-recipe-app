import { Inject, Injectable } from '@nestjs/common';
import { UploadImageResponseDto } from './dto/upload-image-response.dto';
import { FileStorageService } from './storage/file-storage.service';

@Injectable()
export class UploadsService {
  constructor(
    @Inject(FileStorageService)
    private readonly fileStorageService: FileStorageService,
  ) {}

  async uploadImage(
    file: Express.Multer.File,
  ): Promise<UploadImageResponseDto> {
    const storedFile = await this.fileStorageService.saveImage(file);
    return new UploadImageResponseDto(
      storedFile.url,
      storedFile.path,
      storedFile.originalName,
      storedFile.mimeType,
      storedFile.size,
    );
  }
}
