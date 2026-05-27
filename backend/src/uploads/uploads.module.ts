import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { AppEnvironment } from '../common/config/env.validation';
import { UploadsController } from './uploads.controller';
import { UploadsService } from './uploads.service';
import { FileStorageService } from './storage/file-storage.service';
import { LocalFileStorageService } from './storage/local-file-storage.service';

@Module({
  imports: [ConfigModule],
  controllers: [UploadsController],
  providers: [
    UploadsService,
    LocalFileStorageService,
    {
      provide: FileStorageService,
      inject: [ConfigService, LocalFileStorageService],
      useFactory: (
        configService: ConfigService<AppEnvironment, true>,
        localFileStorageService: LocalFileStorageService,
      ) => {
        const driver = configService.get('STORAGE_DRIVER', { infer: true });

        switch (driver) {
          case 'local':
            return localFileStorageService;
        }
      },
    },
  ],
  exports: [UploadsService, FileStorageService],
})
export class UploadsModule {}
