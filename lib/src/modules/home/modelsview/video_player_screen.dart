import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:web/web.dart' as web; // Usando prefixo para o pacote web
import 'package:video_player/video_player.dart';
import '../home_controller.dart';
import 'template_page.dart';

class VideoPlayerYouTubeStyleScreen extends StatefulWidget {
  const VideoPlayerYouTubeStyleScreen({super.key});

  @override
  State<VideoPlayerYouTubeStyleScreen> createState() =>
      _VideoPlayerYouTubeStyleScreenState();
}

class _VideoPlayerYouTubeStyleScreenState
    extends State<VideoPlayerYouTubeStyleScreen> {
  final _controller = Modular.get<HomeController>();
  late bool _controlsVisible;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    _controlsVisible = true;
    _controller.videoController
      ..addListener(() {
        if (mounted) {
          setState(() {}); // Atualiza o progresso e estado
        }
      })
      ..initialize().then((_) {
        if (mounted) {
          setState(() {}); // Atualiza após inicialização
        }
      });
    _scheduleHideControls();
  }

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
    _cancelHideControlsTimer(); // Cancela o timer anterior
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _controlsVisible) {
        setState(() {
          _controlsVisible = false;
        });
      }
    });
  }

  void _cancelHideControlsTimer() {
    _hideControlsTimer?.cancel();
  }

  Future<void> _enterBrowserFullscreen() async {
    try {
      final document = web.window.document;
      final element = document.documentElement;
      if (element != null) {
        element.requestFullscreen();
      }
    } catch (e) {
      debugPrint('Erro ao entrar no modo fullscreen: $e');
    }
  }

  Future<void> _exitBrowserFullscreen() async {
    try {
      final document = web.window.document;
      if (document.fullscreenElement != null) {
        document.exitFullscreen();
      }
    } catch (e) {
      debugPrint('Erro ao sair do modo fullscreen: $e');
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
              'Informações:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                height: 1.5,
                color: Colors.white,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(2.0, 2.0),
                    blurRadius: 1.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ],
              ),
            ),
            itens: (HomeController controller,
                    GlobalKey<FormFieldState<List<ValueNotifier<String>>>>
                        state) =>
                [
              const Text(
                textAlign: TextAlign.justify,
                'Aqui você pode fazer a diferença! Veja como é simples.',
                style: TextStyle(color: Colors.black, fontSize: 16.0),
              ),
              SizedBox(
                height: 400,
                child: _buildNormalScreen(),
              ),
              const Text(
                textAlign: TextAlign.justify,
                '\nAgora que você já entendeu como usar, volte à página inicial e proporcione alegria a uma das famílias assistidas.',
                style: TextStyle(color: Colors.black, fontSize: 16.0),
              ),
            ],
          );
  }

  Widget _buildNormalScreen() {
    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: _controller.videoController.value.isInitialized
              ? _controller.videoController.value.aspectRatio
              : 16 / 9,
          child: _controller.videoController.value.isInitialized
              ? VideoPlayer(_controller.videoController)
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              _toggleControlsVisibility();
              _scheduleHideControls(); // Reinicia o timer
            },
          ),
        ),
        if (_controlsVisible)
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: _buildVideoControls(),
            ),
          ),
      ],
    );
  }

  Widget _buildFullScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller.videoController.value.isInitialized
                ? _controller.videoController.value.aspectRatio
                : 16 / 9,
            child: _controller.videoController.value.isInitialized
                ? VideoPlayer(_controller.videoController)
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                _toggleControlsVisibility();
                _scheduleHideControls(); // Reinicia o timer
              },
            ),
          ),
          if (_controlsVisible)
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: _buildVideoControls(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVideoControls() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildProgressBar(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  _controller.videoController.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    if (_controller.videoController.value.isPlaying) {
                      _controller.videoController.pause();
                    } else {
                      _controller.videoController.play();
                    }
                  });
                },
              ),
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
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final duration = _controller.videoController.value.duration;
    final position = _controller.videoController.value.position;

    return Row(
      children: [
        Text(
          _formatDuration(position),
          style: const TextStyle(color: Colors.white),
        ),
        Expanded(
          child: Slider(
            value: position.inSeconds.toDouble(),
            max: duration.inSeconds.toDouble(),
            onChanged: (value) {
              _controller.videoController
                  .seekTo(Duration(seconds: value.toInt()));
            },
            activeColor: Colors.red,
            inactiveColor: Colors.white,
          ),
        ),
        Text(
          _formatDuration(duration),
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return '00:00'; // Valor padrão para duração nula
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _cancelHideControlsTimer(); // Cancela o timer ao destruir o widget
    _controller.videoController.dispose();
    super.dispose();
  }
}
