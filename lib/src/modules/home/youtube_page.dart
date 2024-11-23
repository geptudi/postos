import 'package:flutter/material.dart';
// import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'home_controller.dart';
import 'modelsview/template_page.dart';
import 'modelsview/video_player_screen.dart';

class YoutubePage extends StatefulWidget {
  const YoutubePage({super.key});

  @override
  State<YoutubePage> createState() => _YoutubePageState();
}

class _YoutubePageState extends State<YoutubePage> {
  //late YoutubePlayerController _controllerYoutube;

  @override
  void initState() {
    super.initState();
    // _controllerYoutube = YoutubePlayerController.fromVideoId(
    //   videoId: '2OTMsrmyGvA',
    //   autoPlay: false,
    //   params: const YoutubePlayerParams(
    //     showControls: true,
    //     mute: false,
    //     showFullscreenButton: true,
    //     loop: false,
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
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
              GlobalKey<FormFieldState<List<ValueNotifier<String>>>> state) =>
          [
        const Text(
          textAlign: TextAlign.justify,
          'Aqui\tvocê\tpode\tfazer\ta\tdiferença!!\tVeja\tcomo\té\tsimples!!\n\nBasta\tescolher\tum\tdos\tquatro\t(4)\tpostos\tde\tassistência\tdas\tObras\tSociais\tdo\tGrupo\tEspírita\tPaulo\tde\tTarso,\tnos\tbotões\tabaixo,\tselecionar\tuma\tfamília\tna\tsequência\te\tpreencher\tseus\tdados\tcomo\tdoador.\n\nPronto.\tAgora\tbasta\tsalvar\to\tarquivo\tcom\to\tresumo\tdesta\tfamília.\tNeste\tarquivo\tvocê\tterá\tas\tinformações\tpara\tpoder\tentregar\tpessoalmente\testa\tcesta,\tou\tos\tdados\tdo\tcoordenador\tdo\trespectivo\tposto\tpara\tvocê\talinhar\tcom\tele\tcomo\tserá\testa\tentrega.\n\nVeja\to\tvideo\tpara\tsaber\tmais!!\n',
          style: TextStyle(color: Colors.black, fontSize: 16.0),
        ),
        VideoPlayerYouTubeStyleScreen(),
        const Text(
          textAlign: TextAlign.justify,
          '\nAgora\tque\tvocê\tja\tentendeu\tcomo\tusar,\tretorne\ta\tpagina\tinicial\te\tvenha\tproporcionar\tmuita\talegria\tà\tuma\tdas\tfamílias\tassistidas.',
          style: TextStyle(color: Colors.black, fontSize: 16.0),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
