import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:ui_web' as ui_web;
import 'package:web/web.dart' as web;

import '../home_controller.dart';
import 'template_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  final _controller = Modular.get<HomeController>();

  late final String _viewId;
  late final web.HTMLVideoElement _video;

  bool _controlsVisible = true;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();

    _viewId = "video-${DateTime.now().millisecondsSinceEpoch}";

    // 🎥 Criando o <video> nativo Web
    _video = web.HTMLVideoElement()
      ..src = "assets/cestasnatal.mp4"
      ..controls = false
      ..autoplay = false
      ..preload = 'auto'
      ..style.width = "100%"
      ..style.height = "100%"
      ..style.border = "none";

    // Registrar com o Flutter
    ui_web.platformViewRegistry.registerViewFactory(
      _viewId,
      (int _) => _video,
    );

    // Ocultar controles após um delay
    _scheduleHideControls();
  }

  // Alternar visibilidade
  void _toggleControlsVisibility() {
    setState(() {
      _controlsVisible = !_controlsVisible;
    });

    if (_controlsVisible) {
      _scheduleHideControls();
    } else {
      _cancelHideControlsTimer();
    }
  }

  void _scheduleHideControls() {
    _cancelHideControlsTimer();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      if (_controlsVisible) {
        setState(() => _controlsVisible = false);
      }
    });
  }

  void _cancelHideControlsTimer() {
    _hideControlsTimer?.cancel();
  }

  // Entrar em fullscreen do navegador
  Future<void> _enterBrowserFullscreen() async {
    try {
      final document = web.window.document;
      final element = document.documentElement;
      element?.requestFullscreen();
    } catch (e) {
      debugPrint("Erro fullscreen: $e");
    }
  }

  // Sair do fullscreen
  Future<void> _exitBrowserFullscreen() async {
    try {
      final document = web.window.document;
      if (document.fullscreenElement != null) {
        document.exitFullscreen();
      }
    } catch (e) {
      debugPrint("Erro fullscreen exit: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return _controller.isFullScreem
        ? _buildFullScreen()
        : TemplatePage(
            hasProx: null,
            isLeading: true,
            answerLenght: 1,
            header: const Text(
              "Informações:",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                height: 1.5,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: Offset(2, 2),
                    blurRadius: 1,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            itens: (
              HomeController controller,
              GlobalKey<FormFieldState<List<ValueNotifier<String>>>> state,
            ) {
              return [
                const Text(
                  "Aqui você pode fazer a diferença! Veja como é simples.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                SizedBox(
                  height: 400,
                  child: _buildNormalScreen(),
                ),
                const Text(
                  "\nAgora que você já entendeu como usar, volte à página inicial e proporcione alegria a uma das famílias assistidas.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ];
            },
          );
  }

  // TELA NORMAL
  Widget _buildNormalScreen() {
    return Stack(
      alignment: Alignment.center,
      children: [
        HtmlElementView(viewType: _viewId),
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              _toggleControlsVisibility();
              _scheduleHideControls();
            },
          ),
        ),
        if (_controlsVisible)
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: _buildWebControls(),
            ),
          ),
      ],
    );
  }

  // TELA FULLSCREEN
  Widget _buildFullScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          HtmlElementView(viewType: _viewId),
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                _toggleControlsVisibility();
                _scheduleHideControls();
              },
            ),
          ),
          if (_controlsVisible)
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: _buildWebControls(),
              ),
            ),
        ],
      ),
    );
  }

  // Controles do player
  Widget _buildWebControls() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Play / pause
          IconButton(
            icon: Icon(
              _video.paused ? Icons.play_arrow : Icons.pause,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                if (_video.paused) {
                  _video.play();
                } else {
                  _video.pause();
                }
              });
            },
          ),

          // Fullscreen
          IconButton(
            icon: Icon(
              _controller.isFullScreem
                  ? Icons.fullscreen_exit
                  : Icons.fullscreen,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                if (_controller.isFullScreem) {
                  _exitBrowserFullscreen();
                } else {
                  _enterBrowserFullscreen();
                }
                _controller.isFullScreem = !_controller.isFullScreem;
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cancelHideControlsTimer();
    super.dispose();
  }
}
