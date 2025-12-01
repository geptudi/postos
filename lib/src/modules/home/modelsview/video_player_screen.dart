import 'package:flutter/material.dart';
import 'dart:ui_web' as ui_web; // 👈 API moderna do Flutter Web
import 'package:web/web.dart' as web; // 👈 HTMLVideoElement, etc.

class VideoPlayerScreen extends StatefulWidget {
  final String url;

  const VideoPlayerScreen({
    super.key,
    required this.url,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late final String _viewId;
  late final web.HTMLVideoElement _video;

  @override
  void initState() {
    super.initState();

    // id único para o elemento <video>
    _viewId = 'video-${DateTime.now().millisecondsSinceEpoch}';

    // cria o elemento <video> usando package:web (API moderna)
    _video = web.HTMLVideoElement()
      ..src = widget.url
      ..controls = true
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%'
      ..autoplay = false
      ..preload = 'auto';

    // registra o elemento HTML no Flutter Web via dart:ui_web
    ui_web.platformViewRegistry.registerViewFactory(
      _viewId,
      (int _) => _video,
    );
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewId);
  }
}
