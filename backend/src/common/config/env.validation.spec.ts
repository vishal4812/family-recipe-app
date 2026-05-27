import { validateEnv } from './env.validation';

describe('validateEnv', () => {
  it('applies defaults for optional environment values', () => {
    const environment = validateEnv({
      DATABASE_URL:
        'postgresql://postgres:postgres@localhost:5432/family_recipe_app',
      JWT_SECRET: 'test-secret',
    });

    expect(environment).toEqual({
      PORT: 3000,
      DATABASE_URL:
        'postgresql://postgres:postgres@localhost:5432/family_recipe_app',
      JWT_SECRET: 'test-secret',
      JWT_EXPIRES_IN: '7d',
      APP_URL: 'http://localhost:3000',
      STORAGE_DRIVER: 'local',
      STORAGE_ROOT: 'storage',
    });
  });

  it('throws when required variables are missing', () => {
    expect(() =>
      validateEnv({
        JWT_SECRET: 'test-secret',
      }),
    ).toThrow('DATABASE_URL is required.');
  });

  it('rejects unsupported storage drivers', () => {
    expect(() =>
      validateEnv({
        DATABASE_URL:
          'postgresql://postgres:postgres@localhost:5432/family_recipe_app',
        JWT_SECRET: 'test-secret',
        STORAGE_DRIVER: 's3',
      }),
    ).toThrow('STORAGE_DRIVER must be "local" for the MVP backend.');
  });
});
