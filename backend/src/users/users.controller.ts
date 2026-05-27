import { Controller, Get, UseGuards } from '@nestjs/common';
import { CurrentUser } from '../common/decorators/current-user.decorator';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { AuthenticatedUser } from '../common/interfaces/authenticated-user.interface';
import { UserProfileResponseDto } from './dto/user-profile-response.dto';

@Controller('users')
export class UsersController {
  @Get('me')
  @UseGuards(JwtAuthGuard)
  getCurrentUser(
    @CurrentUser() user: AuthenticatedUser,
  ): UserProfileResponseDto {
    return new UserProfileResponseDto(user.id, user.email, user.name);
  }
}
