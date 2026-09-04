import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_chat/core/calls/call_media_policy.dart';

void main() {
  test('pauses video only after sustained poor samples', () {
    final policy = CallMediaPolicy(
      poorSamplesBeforePause: 3,
      goodSamplesBeforeResume: 2,
    );

    expect(
      policy.sample(poor: true, videoCall: true, cameraEnabled: true),
      CallMediaDecision.none,
    );
    expect(
      policy.sample(poor: false, videoCall: true, cameraEnabled: true),
      CallMediaDecision.none,
    );
    expect(
      policy.sample(poor: true, videoCall: true, cameraEnabled: true),
      CallMediaDecision.none,
    );
    expect(
      policy.sample(poor: true, videoCall: true, cameraEnabled: true),
      CallMediaDecision.none,
    );
    expect(
      policy.sample(poor: true, videoCall: true, cameraEnabled: true),
      CallMediaDecision.pauseVideo,
    );
    expect(policy.pausedForNetwork, isTrue);
  });

  test('reports recovery once and never auto-enables camera', () {
    final policy = CallMediaPolicy(
      poorSamplesBeforePause: 1,
      goodSamplesBeforeResume: 2,
    );
    expect(
      policy.sample(poor: true, videoCall: true, cameraEnabled: true),
      CallMediaDecision.pauseVideo,
    );
    expect(
      policy.sample(poor: false, videoCall: true, cameraEnabled: false),
      CallMediaDecision.none,
    );
    expect(
      policy.sample(poor: false, videoCall: true, cameraEnabled: false),
      CallMediaDecision.videoCanResume,
    );
    expect(policy.canResumeVideo, isTrue);
    expect(
      policy.sample(poor: false, videoCall: true, cameraEnabled: false),
      CallMediaDecision.none,
    );
  });

  test('does not affect voice calls or an already disabled camera', () {
    final policy = CallMediaPolicy(poorSamplesBeforePause: 1);
    expect(
      policy.sample(poor: true, videoCall: false, cameraEnabled: true),
      CallMediaDecision.none,
    );
    expect(
      policy.sample(poor: true, videoCall: true, cameraEnabled: false),
      CallMediaDecision.none,
    );
    expect(policy.pausedForNetwork, isFalse);
  });

  test('manual camera change clears network-owned state', () {
    final policy = CallMediaPolicy(poorSamplesBeforePause: 1);
    policy.sample(poor: true, videoCall: true, cameraEnabled: true);
    policy.userChangedCamera();
    expect(policy.pausedForNetwork, isFalse);
    expect(policy.canResumeVideo, isFalse);
  });
}
