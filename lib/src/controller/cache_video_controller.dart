import 'dart:io';

import 'package:nbp_custom_widgets/src/enum/video_type.dart';
import 'package:video_player/video_player.dart';

class VideoControllerCache {
  static final Map<String, VideoPlayerController> _controllers = {};

  static VideoPlayerController getController(String path, VideoType videoType) {
    if (!_controllers.containsKey(path)) {
      final controller = videoType == VideoType.network
          ? VideoPlayerController.networkUrl(Uri.parse(path))
          : videoType == VideoType.file
              ? VideoPlayerController.file(File(path))
              : VideoPlayerController.asset(path);
      _controllers[path] = controller;
    }
    return _controllers[path]!;
  }

  static Future<void> initialize(String path, VideoType videoType) async {
    final controller = getController(path, videoType);
    if (!controller.value.isInitialized) {
      await controller.initialize();
    }
  }

  static void disposeController(String path) {
    if (_controllers.containsKey(path)) {
      _controllers[path]?.dispose();
      _controllers.remove(path);
    }
  }

  static void disposeAll() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
  }
}
