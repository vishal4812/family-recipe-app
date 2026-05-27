import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { randomUUID } from 'crypto';
import { mkdir, writeFile } from 'fs/promises';
import { extname, join, posix } from 'path';
import { AppEnvironment } from '../../common/config/env.validation';
import { FileStorageService, StoredFileResult } from './file-storage.service';

@Injectable()
export class LocalFileStorageService extends FileStorageService {
  constructor(
    private readonly configService: ConfigService<AppEnvironment, true>,
  ) {
    super();
  }

  async saveImage(file: Express.Multer.File): Promise<StoredFileResult> {
    const storageRoot = this.configService.get('STORAGE_ROOT', { infer: true });
    const uploadsDirectory = join(
      process.cwd(),
      storageRoot,
      'uploads',
      'images',
    );
    await mkdir(uploadsDirectory, { recursive: true });

    const extension = extname(file.originalname) || '.jpg';
    const filename = `${Date.now()}-${randomUUID()}${extension}`;
    const absolutePath = join(uploadsDirectory, filename);
    await writeFile(absolutePath, file.buffer);

    const relativePath = posix.join('/uploads', 'images', filename);
    const appUrl = this.configService
      .get('APP_URL', { infer: true })
      .replace(/\/$/, '');

    return {
      path: relativePath,
      url: `${appUrl}${relativePath}`,
      originalName: file.originalname,
      mimeType: file.mimetype,
      size: file.size,
    };
  }
}
