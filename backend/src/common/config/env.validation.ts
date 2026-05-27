export interface AppEnvironment {
  PORT: number;
  DATABASE_URL: string;
  JWT_SECRET: string;
  JWT_EXPIRES_IN: string;
  APP_URL: string;
  STORAGE_DRIVER: 'local';
  STORAGE_ROOT: string;
}

export function validateEnv(config: Record<string, unknown>): AppEnvironment {
  const port = toNumber(config.PORT, 3000);
  const databaseUrl = toRequiredString(config.DATABASE_URL, 'DATABASE_URL');
  const jwtSecret = toRequiredString(config.JWT_SECRET, 'JWT_SECRET');

  return {
    PORT: port,
    DATABASE_URL: databaseUrl,
    JWT_SECRET: jwtSecret,
    JWT_EXPIRES_IN: toStringWithDefault(config.JWT_EXPIRES_IN, '7d'),
    APP_URL: toStringWithDefault(config.APP_URL, `http://localhost:${port}`),
    STORAGE_DRIVER: toStorageDriver(config.STORAGE_DRIVER),
    STORAGE_ROOT: toStringWithDefault(config.STORAGE_ROOT, 'storage'),
  };
}

function toRequiredString(value: unknown, key: string): string {
  const normalized = String(value ?? '').trim();
  if (!normalized) {
    throw new Error(`${key} is required.`);
  }
  return normalized;
}

function toStringWithDefault(value: unknown, fallback: string): string {
  const normalized = String(value ?? '').trim();
  return normalized || fallback;
}

function toNumber(value: unknown, fallback: number): number {
  const normalized = Number(value);
  if (Number.isFinite(normalized) && normalized > 0) {
    return normalized;
  }
  return fallback;
}

function toStorageDriver(value: unknown): 'local' {
  const normalized = toStringWithDefault(value, 'local');
  if (normalized !== 'local') {
    throw new Error('STORAGE_DRIVER must be "local" for the MVP backend.');
  }

  return 'local';
}
