import { FilePurpose } from './dto/create-upload.dto';

export const fileSizeLimits: Record<FilePurpose, number> = {
  AVATAR: 5 * 1024 * 1024,
  CHAT_IMAGE: 20 * 1024 * 1024,
  CHAT_VOICE: 10 * 1024 * 1024,
  CHAT_VIDEO: 100 * 1024 * 1024,
  CHAT_FILE: 100 * 1024 * 1024,
};
