import { Body, Controller, Delete, Get, Param, Post, Req, UseGuards } from '@nestjs/common';
import { Request } from 'express';
import { AuthService } from './auth.service';
import { CurrentUser } from './current-user.decorator';
import { LoginDto } from './dto/login.dto';
import { RefreshTokenDto } from './dto/refresh-token.dto';
import { RegisterDto } from './dto/register.dto';
import { JwtAuthGuard } from './jwt-auth.guard';
import { JwtPayload } from './jwt-payload';
import { ChangePasswordDto } from './dto/change-password.dto';
import { DeactivateAccountDto } from './dto/deactivate-account.dto';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('register')
  register(@Body() input: RegisterDto, @Req() request: Request) {
    return this.authService.register(input, this.requestContext(request));
  }

  @Post('login')
  login(@Body() input: LoginDto, @Req() request: Request) {
    return this.authService.login(input, this.requestContext(request));
  }

  @Post('refresh')
  refresh(@Body() input: RefreshTokenDto, @Req() request: Request) {
    return this.authService.refresh(input.refreshToken, this.requestContext(request));
  }

  @UseGuards(JwtAuthGuard)
  @Get('devices')
  devices(@CurrentUser() user: JwtPayload) {
    return this.authService.listDevices(user.sub, user.sid);
  }

  @UseGuards(JwtAuthGuard)
  @Delete('devices/:sessionId')
  revokeDevice(@CurrentUser() user: JwtPayload, @Param('sessionId') sessionId: string) {
    return this.authService.revokeDevice(user.sub, sessionId);
  }

  @UseGuards(JwtAuthGuard)
  @Post('logout')
  logout(@CurrentUser() user: JwtPayload) {
    return this.authService.logout(user.sub, user.sid);
  }

  @UseGuards(JwtAuthGuard)
  @Post('logout-all')
  logoutAll(@CurrentUser() user: JwtPayload) {
    return this.authService.logoutAll(user.sub);
  }

  @UseGuards(JwtAuthGuard)
  @Post('change-password')
  changePassword(
    @CurrentUser() user: JwtPayload,
    @Body() input: ChangePasswordDto,
    @Req() request: Request,
  ) {
    return this.authService.changePassword(
      user.sub,
      user.sid,
      input.currentPassword,
      input.newPassword,
      this.requestContext(request),
    );
  }

  @UseGuards(JwtAuthGuard)
  @Delete('account')
  deactivateAccount(
    @CurrentUser() user: JwtPayload,
    @Body() input: DeactivateAccountDto,
    @Req() request: Request,
  ) {
    return this.authService.deactivateAccount(
      user.sub,
      input.currentPassword,
      this.requestContext(request),
    );
  }

  private requestContext(request: Request) {
    return {
      ipAddress: request.ip,
      userAgent: request.headers['user-agent']?.slice(0, 500),
    };
  }
}
