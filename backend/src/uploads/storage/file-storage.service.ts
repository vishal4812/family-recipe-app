export interface StoredFileResult {
  path: string;
  url: string;
  originalName: string;
  mimeType: string;
  size: number;
}

export abstract class FileStorageService {
  abstract saveImage(file: Express.Multer.File): Promise<StoredFileResult>;
}
