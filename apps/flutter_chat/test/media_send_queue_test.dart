import 'package:flutter_chat/features/chat/presentation/media_send_queue.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('多个媒体任务独立更新、取消和完成', () {
    final queue = MediaSendQueue();
    addTearDown(queue.dispose);
    final image = queue.start('图片');
    final video = queue.start('视频');

    queue.upload(image.id);
    queue.progress(image.id, 40, 100);
    queue.fail(video.id, '网络异常');

    expect(queue.tasks, hasLength(2));
    expect(queue.tasks.first.progress, .4);
    expect(queue.tasks.last.phase, MediaSendPhase.failed);
    expect(queue.hasActive, isTrue);

    queue.complete(image.id);
    expect(queue.hasActive, isFalse);
    queue.cancel(video.id);
    expect(video.cancelToken.isCancelled, isTrue);
    expect(queue.tasks, isEmpty);
  });

  test('失败任务可重试且不影响其他任务', () async {
    final queue = MediaSendQueue();
    addTearDown(queue.dispose);
    var retries = 0;
    final failed = queue.start('文件');
    final active = queue.start('图片');
    queue.fail(
      failed.id,
      '上传失败',
      retry: () async => retries++,
      retryLabel: '重新选择',
    );

    expect(queue.tasks.first.retryLabel, '重新选择');

    await queue.retry(failed.id);

    expect(retries, 1);
    expect(queue.tasks.single.id, active.id);
  });

  test('处理缩略图时重置进度并更新阶段文案', () {
    final queue = MediaSendQueue();
    addTearDown(queue.dispose);
    final task = queue.start('正在上传图片');

    queue.upload(task.id);
    queue.progress(task.id, 100, 100);
    queue.prepare(task.id, label: '正在生成聊天预览…');

    expect(queue.tasks.single.phase, MediaSendPhase.preparing);
    expect(queue.tasks.single.progress, 0);
    expect(queue.tasks.single.label, '正在生成聊天预览…');

    queue.upload(task.id, label: '正在上传聊天预览…');
    queue.progress(task.id, 1, 4);
    expect(queue.tasks.single.phase, MediaSendPhase.uploading);
    expect(queue.tasks.single.progress, .25);
  });
}
