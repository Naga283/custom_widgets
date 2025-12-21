import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:nbp_custom_widgets/src/controller/cache_video_controller.dart';
import 'package:nbp_custom_widgets/src/enum/video_type.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:video_player/video_player.dart';

const kDefaultAspectRatio = 16 / 9;

class UrbanTeacherVideoPlayer extends StatefulWidget {
  const UrbanTeacherVideoPlayer({
    super.key,
    required this.path,
    this.videoType = VideoType.network,
    this.width,
    this.height,
    this.aspectRatio,
    this.autoPlay = false,
    this.looping = false,
    this.showControls = true,
    this.allowFullScreen = true,
    this.allowPlaybackSpeedMenu = false,
    this.lazyLoad = false,
    this.isExpanded = false,
    this.loaderWidget,
  });

  final String path;
  final VideoType videoType;
  final double? width;
  final double? height;
  final double? aspectRatio;
  final bool autoPlay;
  final bool looping;
  final bool showControls;
  final bool allowFullScreen;
  final bool allowPlaybackSpeedMenu;
  final bool lazyLoad;
  final bool isExpanded;
  final Widget? loaderWidget;

  @override
  State<UrbanTeacherVideoPlayer> createState() =>
      _UrbanTeacherVideoPlayerState();
}

class _UrbanTeacherVideoPlayerState extends State<UrbanTeacherVideoPlayer>
    with WidgetsBindingObserver {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  bool _showControls = false;
  bool _isDisposed = false;
  bool _isAppInBackground = false;
  bool _isVisibleOnScreen = false;
  bool _userManuallyPaused = false;
  bool _hasPlayedOnce = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializePlayer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _isDisposed = true;

    try {
      _videoController?.pause();
      _videoController?.removeListener(_videoListener);
    } catch (_) {}

    _chewieController?.dispose();
    _chewieController = null;
    _videoController = null;

    super.dispose();
  }

  @override
  void didUpdateWidget(UrbanTeacherVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded && widget.isExpanded) {
      _videoController?.pause();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_videoController == null || !_videoController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _isAppInBackground = true;
      try {
        _videoController?.pause();
      } catch (_) {}
    } else if (state == AppLifecycleState.resumed) {
      _isAppInBackground = false;

      if (_isVisibleOnScreen && !_userManuallyPaused) {
        try {
          _videoController?.play();
        } catch (_) {}
      }
    }
  }

  Future<void> _initializePlayer() async {
    _videoController =
        VideoControllerCache.getController(widget.path, widget.videoType);

    if (_videoController == null) {
      await VideoControllerCache.initialize(widget.path, widget.videoType);
      _videoController =
          VideoControllerCache.getController(widget.path, widget.videoType);
    } else {
      if (!_videoController!.value.isInitialized) {
        await _videoController!.initialize();
      }
    }

    if (_isDisposed || _videoController == null) return;

    _videoController!.removeListener(_videoListener);
    _videoController!.addListener(_videoListener);

    _createChewieController();
  }

  void _videoListener() {
    if (!_videoController!.value.isPlaying &&
        _videoController!.value.position < _videoController!.value.duration) {
      _userManuallyPaused = true;
    }
  }

  void _createChewieController() {
    _chewieController?.dispose();

    if (_videoController == null || !_videoController!.value.isInitialized) {
      return;
    }

    _chewieController = ChewieController(
      videoPlayerController: _videoController!,
      aspectRatio: widget.aspectRatio ?? _videoController!.value.aspectRatio,
      autoPlay: false,
      looping: widget.looping,
      showControls: _showControls,
      allowFullScreen: widget.allowFullScreen,
      allowPlaybackSpeedChanging: widget.allowPlaybackSpeedMenu,
    );

    if (mounted) {
      setState(() {});
    }
  }

  void _toggleControls() {
    _showControls = !_showControls;
    _createChewieController();

    if (_showControls) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && !_isDisposed && _showControls) {
          _showControls = false;
          _createChewieController();
        }
      });
    }
  }

  void _handleUserPause() {
    _userManuallyPaused = true;
    try {
      _videoController?.pause();
    } catch (_) {}
  }

  void _handleUserPlay() {
    _userManuallyPaused = false;
    try {
      _videoController?.play();
    } catch (_) {}
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    _isVisibleOnScreen = info.visibleFraction >= 0.9;

    if (_isDisposed || _videoController == null) return;

    try {
      if (_isVisibleOnScreen && !_isAppInBackground && !_userManuallyPaused) {
        if (widget.autoPlay && !_hasPlayedOnce && !widget.isExpanded) {
          _hasPlayedOnce = true;
          _videoController!.play();
        }
      } else {
        _videoController!.pause();
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.width ?? MediaQuery.sizeOf(context).width;
    final aspectRatio = widget.aspectRatio ?? kDefaultAspectRatio;
    final height = widget.height ?? width / aspectRatio;

    if (_chewieController == null ||
        _videoController == null ||
        !_videoController!.value.isInitialized) {
      return widget.loaderWidget ?? CircularProgressIndicator();
    }

    return VisibilityDetector(
      key: Key(widget.path),
      onVisibilityChanged: _onVisibilityChanged,
      child: GestureDetector(
        onTap: _toggleControls,
        onDoubleTap: () {
          if (_videoController!.value.isPlaying) {
            _handleUserPause();
          } else {
            _handleUserPlay();
          }
        },
        child: SizedBox(
          width: width,
          height: height,
          child: AspectRatio(
            aspectRatio:
                widget.aspectRatio ?? _videoController!.value.aspectRatio,
            child: Chewie(controller: _chewieController!),
          ),
        ),
      ),
    );
  }
}
