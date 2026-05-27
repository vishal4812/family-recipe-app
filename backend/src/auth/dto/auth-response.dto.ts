import { UserProfileResponseDto } from '../../users/dto/user-profile-response.dto';

export class AuthResponseDto {
  constructor(
    public readonly accessToken: string,
    public readonly user: UserProfileResponseDto,
  ) {}
}
