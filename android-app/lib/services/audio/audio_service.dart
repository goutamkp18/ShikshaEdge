import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  String? _currentAssetPath;
  bool _isAssetAvailable = false;

  AudioPlayer get player => _player;
  String? get currentAssetPath => _currentAssetPath;
  bool get isAssetAvailable => _isAssetAvailable;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;

  /// Loads and prepares local audio asset with graceful validation
  Future<bool> loadAssetAudio(String assetPath) async {
    if (assetPath.isEmpty) {
      _isAssetAvailable = false;
      _currentAssetPath = null;
      return false;
    }

    try {
      // Check if asset exists in bundle
      await rootBundle.load(assetPath);
      _currentAssetPath = assetPath;
      _isAssetAvailable = true;

      await _player.setAsset(assetPath);
      return true;
    } catch (e) {
      _isAssetAvailable = false;
      _currentAssetPath = null;
      return false;
    }
  }

  Future<void> play() async {
    if (_isAssetAvailable) {
      await _player.play();
    }
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> replay() async {
    if (_isAssetAvailable) {
      await _player.seek(Duration.zero);
      await _player.play();
    }
  }

  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed);
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  void dispose() {
    _player.dispose();
  }
}
