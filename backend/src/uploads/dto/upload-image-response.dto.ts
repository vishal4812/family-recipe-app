export class UploadImageResponseDto {
  constructor(
    public readonly url: string,
    public readonly path: string,
    public readonly originalName: string,
    public readonly mimeType: string,
    public readonly size: number,
  ) {}
}
