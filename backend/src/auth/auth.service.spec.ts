import { ConflictException, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { User } from '@prisma/client';
import * as bcrypt from 'bcrypt';
import { UsersService } from '../users/users.service';
import { AuthService } from './auth.service';

describe('AuthService', () => {
  let authService: AuthService;
  let usersService: jest.Mocked<Pick<UsersService, 'findByEmail' | 'create'>>;
  let jwtService: jest.Mocked<Pick<JwtService, 'signAsync'>>;

  beforeEach(() => {
    usersService = {
      findByEmail: jest.fn(),
      create: jest.fn(),
    };
    jwtService = {
      signAsync: jest.fn().mockResolvedValue('jwt-token'),
    };

    authService = new AuthService(
      usersService as unknown as UsersService,
      jwtService as unknown as JwtService,
    );
  });

  it('signs up a new user and returns an access token', async () => {
    usersService.findByEmail.mockResolvedValue(null);
    usersService.create.mockImplementation(async (data) =>
      buildUser({
        email: data.email,
        name: data.name ?? null,
        passwordHash: data.passwordHash,
      }),
    );

    const response = await authService.signup({
      email: '  DEMO@FamilyRecipe.App ',
      password: 'Password123!',
      fullName: ' Anita Sharma ',
    });

    expect(usersService.findByEmail).toHaveBeenCalledWith(
      'demo@familyrecipe.app',
    );
    expect(usersService.create).toHaveBeenCalledTimes(1);
    const createArgument = usersService.create.mock.calls[0][0];
    expect(createArgument.email).toBe('demo@familyrecipe.app');
    expect(createArgument.name).toBe('Anita Sharma');
    expect(
      await bcrypt.compare('Password123!', createArgument.passwordHash),
    ).toBe(true);
    expect(response.accessToken).toBe('jwt-token');
    expect(response.user.email).toBe('demo@familyrecipe.app');
    expect(response.user.name).toBe('Anita Sharma');
  });

  it('rejects duplicate signups', async () => {
    usersService.findByEmail.mockResolvedValue(
      buildUser({
        email: 'demo@familyrecipe.app',
      }),
    );

    await expect(
      authService.signup({
        email: 'demo@familyrecipe.app',
        password: 'Password123!',
        fullName: 'Anita Sharma',
      }),
    ).rejects.toBeInstanceOf(ConflictException);
  });

  it('logs in an existing user with a valid password', async () => {
    const passwordHash = await bcrypt.hash('Password123!', 10);
    usersService.findByEmail.mockResolvedValue(
      buildUser({
        email: 'demo@familyrecipe.app',
        passwordHash,
      }),
    );

    const response = await authService.login({
      email: 'demo@familyrecipe.app',
      password: 'Password123!',
    });

    expect(jwtService.signAsync).toHaveBeenCalledWith({
      sub: '15ad0b9d-2bc3-4a6d-a44f-7db4d6c77777',
      email: 'demo@familyrecipe.app',
    });
    expect(response.user.email).toBe('demo@familyrecipe.app');
  });

  it('rejects invalid login credentials', async () => {
    usersService.findByEmail.mockResolvedValue(null);

    await expect(
      authService.login({
        email: 'demo@familyrecipe.app',
        password: 'Password123!',
      }),
    ).rejects.toBeInstanceOf(UnauthorizedException);
  });
});

function buildUser(overrides: Partial<User>): User {
  return {
    id: '15ad0b9d-2bc3-4a6d-a44f-7db4d6c77777',
    email: 'demo@familyrecipe.app',
    name: 'Anita Sharma',
    passwordHash: 'hashed-password',
    createdAt: new Date('2026-04-07T00:00:00.000Z'),
    updatedAt: new Date('2026-04-07T00:00:00.000Z'),
    ...overrides,
  };
}
