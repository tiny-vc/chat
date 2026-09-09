import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

enum CallTone { incoming, ringback }

class CallTonePlayer {
  final AudioPlayer _player = AudioPlayer();

  Future<void> start(CallTone tone) async {
    await stop();
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/chat_${tone.name}_tone.wav');
    if (!await file.exists()) await file.writeAsBytes(_wav(tone), flush: true);
    await _player.setAudioSource(AudioSource.file(file.path));
    await _player.setLoopMode(LoopMode.one);
    await _player.setVolume(tone == CallTone.incoming ? .72 : .34);
    unawaited(_player.play());
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> dispose() async {
    await _player.dispose();
  }

  Uint8List _wav(CallTone tone) {
    const sampleRate = 16000;
    final duration = tone == CallTone.incoming ? 4.0 : 3.0;
    final samples = (sampleRate * duration).round();
    final data = ByteData(44 + samples * 2);
    void ascii(int offset, String text) {
      for (var i = 0; i < text.length; i++) {
        data.setUint8(offset + i, text.codeUnitAt(i));
      }
    }

    ascii(0, 'RIFF');
    data.setUint32(4, 36 + samples * 2, Endian.little);
    ascii(8, 'WAVEfmt ');
    data.setUint32(16, 16, Endian.little);
    data.setUint16(20, 1, Endian.little);
    data.setUint16(22, 1, Endian.little);
    data.setUint32(24, sampleRate, Endian.little);
    data.setUint32(28, sampleRate * 2, Endian.little);
    data.setUint16(32, 2, Endian.little);
    data.setUint16(34, 16, Endian.little);
    ascii(36, 'data');
    data.setUint32(40, samples * 2, Endian.little);
    for (var i = 0; i < samples; i++) {
      final t = i / sampleRate;
      final cycle = tone == CallTone.incoming ? t % 4 : t % 3;
      final audible = tone == CallTone.incoming
          ? cycle < 1.1
          : cycle < .4 || (cycle >= .6 && cycle < 1.0);
      final envelope = audible
          ? math.min(1.0, math.min(cycle * 40, 40 * (1.1 - cycle).abs()))
          : 0.0;
      final value = audible
          ? ((math.sin(2 * math.pi * 440 * t) +
                        math.sin(2 * math.pi * 480 * t)) *
                    5500 *
                    envelope)
                .round()
          : 0;
      data.setInt16(44 + i * 2, value.clamp(-32768, 32767), Endian.little);
    }
    return data.buffer.asUint8List();
  }
}
