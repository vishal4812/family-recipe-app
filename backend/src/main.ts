import { ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';
import { NestExpressApplication } from '@nestjs/platform-express';
import { join } from 'path';
import { AppEnvironment } from './common/config/env.validation';
import { HttpExceptionFilter } from './common/filters/http-exception.filter';
import { PrismaService } from './prisma/prisma.service';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule);
  const configService =
    app.get<ConfigService<AppEnvironment, true>>(ConfigService);
  const prismaService = app.get(PrismaService);
  const storageRoot = configService.get('STORAGE_ROOT', { infer: true });

  app.enableCors({
    origin: true,
    credentials: true,
  });

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );
  app.useGlobalFilters(new HttpExceptionFilter());
  app.useStaticAssets(join(process.cwd(), storageRoot), {
    prefix: '/',
  });

  await prismaService.enableShutdownHooks(app);
  await app.listen(configService.get('PORT', { infer: true }));
}
bootstrap();
