import { Body, Controller, Delete, Get, Param, Post, UseGuards } from '@nestjs/common';
import { CurrentUser } from '../auth/current-user.decorator';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { JwtPayload } from '../auth/jwt-payload';
import { CreateUploadDto } from './dto/create-upload.dto';
import { FilesService } from './files.service';
import { SetThumbnailDto } from './dto/set-thumbnail.dto';
import { ForwardFileDto } from './dto/forward-file.dto';

@UseGuards(JwtAuthGuard)
@Controller('files')
export class FilesController {
  constructor(private readonly filesService: FilesService) {}

  @Post('uploads')
  createUpload(@CurrentUser() user: JwtPayload, @Body() input: CreateUploadDto) {
    return this.filesService.createUpload(user.sub, input);
  }

  @Post(':fileId/complete')
  complete(@CurrentUser() user: JwtPayload, @Param('fileId') fileId: string) {
    return this.filesService.complete(user.sub, fileId);
  }

  @Post(':fileId/forward')
  forward(
    @CurrentUser() user: JwtPayload,
    @Param('fileId') fileId: string,
    @Body() input: ForwardFileDto,
  ) {
    return this.filesService.forward(user.sub, fileId, input);
  }

  @Get(':fileId/download')
  download(@CurrentUser() user: JwtPayload, @Param('fileId') fileId: string) {
    return this.filesService.createDownload(user.sub, fileId);
  }

  @Get('usage')
  usage(@CurrentUser() user: JwtPayload) {
    return this.filesService.usage(user.sub);
  }

  @Post(':fileId/thumbnail')
  setThumbnail(
    @CurrentUser() user: JwtPayload,
    @Param('fileId') fileId: string,
    @Body() input: SetThumbnailDto,
  ) {
    return this.filesService.setThumbnail(user.sub, fileId, input.thumbnailFileId);
  }

  @Delete(':fileId')
  deleteFile(@CurrentUser() user: JwtPayload, @Param('fileId') fileId: string) {
    return this.filesService.deleteFile(user.sub, fileId);
  }
}
