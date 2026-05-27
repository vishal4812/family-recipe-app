import { readFile, rm } from 'fs/promises';
import { tmpdir } from 'os';
import { join } from 'path';
import { ConfigService } from '@nestjs/config';
import { AppEnvironment } from '../../common/config/env.validation';
import { LocalFileStorageService } from './local-file-storage.service';

describe('LocalFileStorageService', () => {
  it('writes uploaded images to the configured local storage directory', async () => {
    const tempRoot = await import('fs/promises').then(({ mkdtemp }) =>
      mkdtemp(join(tmpdir(), 'family-recipe-backend-')),
    );
    const cwdSpy = jest.spyOn(process, 'cwd').mockReturnValue(tempRoot);
    const configService = {
      get: jest.fn((key: keyof AppEnvironment) => {
        if (key === 'STORAGE_ROOT') {
          return 'storage';
        }

        if (key === 'APP_URL') {
          return 'http://localhost:3000';
        }

        return undefined;
      }),
    } as unknown as ConfigService<AppEnvironment, true>;

    const service = new LocalFileStorageService(configService);

    try {
      const result = await service.saveImage({
        originalname: 'chai.jpg',
        mimetype: 'image/jpeg',
        size: 4,
        buffer: Buffer.from('test'),
      } as Express.Multer.File);

      expect(result.path).toMatch(/^\/uploads\/images\/.+\.jpg$/);
      expect(result.url).toMatch(
        /^http:\/\/localhost:3000\/uploads\/images\/.+\.jpg$/,
      );

      const savedBuffer = await readFile(
        join(tempRoot, 'storage', result.path.slice(1)),
      );
      expect(savedBuffer.toString()).toBe('test');
    } finally {
      cwdSpy.mockRestore();
      await rm(tempRoot, { recursive: true, force: true });
    }
  });
});
