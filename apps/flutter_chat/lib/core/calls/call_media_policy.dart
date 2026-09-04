/// Decisions made by [CallMediaPolicy] after sampling call quality.
enum CallMediaDecision { none, pauseVideo, videoCanResume }

/// Adds hysteresis around LiveKit connection-quality samples.
///
/// LiveKit already adapts simulcast layers. This policy is the final fallback:
/// after a sustained bad connection it pauses camera publication while leaving
/// microphone publication untouched. Video is never restarted automatically,
/// so a recovered connection cannot unexpectedly turn a camera back on.
class CallMediaPolicy {
  CallMediaPolicy({
    this.poorSamplesBeforePause = 8,
    this.goodSamplesBeforeResume = 12,
  }) : assert(poorSamplesBeforePause > 0),
       assert(goodSamplesBeforeResume > 0);

  final int poorSamplesBeforePause;
  final int goodSamplesBeforeResume;

  int _poorSamples = 0;
  int _goodSamples = 0;
  bool _pausedForNetwork = false;
  bool _resumeReported = false;

  bool get pausedForNetwork => _pausedForNetwork;
  bool get canResumeVideo => _pausedForNetwork && _resumeReported;

  CallMediaDecision sample({
    required bool poor,
    required bool videoCall,
    required bool cameraEnabled,
  }) {
    if (!videoCall) return CallMediaDecision.none;

    if (poor) {
      _goodSamples = 0;
      _resumeReported = false;
      if (!cameraEnabled || _pausedForNetwork) return CallMediaDecision.none;
      _poorSamples++;
      if (_poorSamples < poorSamplesBeforePause) {
        return CallMediaDecision.none;
      }
      _poorSamples = 0;
      _pausedForNetwork = true;
      return CallMediaDecision.pauseVideo;
    }

    _poorSamples = 0;
    if (!_pausedForNetwork || _resumeReported) {
      return CallMediaDecision.none;
    }
    _goodSamples++;
    if (_goodSamples < goodSamplesBeforeResume) {
      return CallMediaDecision.none;
    }
    _goodSamples = 0;
    _resumeReported = true;
    return CallMediaDecision.videoCanResume;
  }

  /// Call when the user explicitly changes the camera state.
  void userChangedCamera() {
    _poorSamples = 0;
    _goodSamples = 0;
    _pausedForNetwork = false;
    _resumeReported = false;
  }

  void reset() {
    _poorSamples = 0;
    _goodSamples = 0;
    _pausedForNetwork = false;
    _resumeReported = false;
  }
}
