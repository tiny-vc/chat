import { BadRequestException, ForbiddenException } from '@nestjs/common';
import { BlocksService } from '../src/blocks/blocks.service';
import { ConversationsService } from '../src/conversations/conversations.service';

describe('conversation and block rules', () => {
  it('requires at least one conversation setting', async () => {
    const service = new ConversationsService({} as never);
    await expect(
      service.update('user-a', { channelId: 'user-b', channelType: 1 }),
    ).rejects.toBeInstanceOf(BadRequestException);
  });

  it('does not allow blocking yourself', async () => {
    const service = new BlocksService({} as never, {} as never);
    await expect(service.block('same-user', 'same-user')).rejects.toBeInstanceOf(
      ForbiddenException,
    );
  });
});
