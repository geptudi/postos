import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import '../../models/styles.dart';
import 'home_controller.dart';
import 'models/doador_assistido_model.dart';
import 'modelsview/template_page.dart';
import 'package:video_player/video_player.dart';

class YoutubePage extends StatefulWidget {
  const YoutubePage({super.key});

  @override
  State<YoutubePage> createState() => _YoutubePageState();
}

class _YoutubePageState extends State<YoutubePage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse('https://drive.google.com/uc?export=download&id=1HwFqUR_4i0qMn_updBPeHVpIMUkxNJyq'), // Insira sua URL
    )
      ..initialize().then((_) {
        setState(() {}); // Atualiza a interface após a inicialização
        _controller.play(); // Inicia o vídeo automaticamente
      });
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
        _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
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
    _controller.dispose();
    super.dispose();
  }

  Widget row(DoadorAssistido pessoa) {
    final aux = ([pessoa.dataNascM1] + pessoa.datasNasc).map(
      (e) {
        return e == "" ? 0 : calculateAge(DateFormat('dd/MM/yyyy').parse(e));
      },
    ).toList();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: pessoa.nomeDoador.isNotEmpty ? Colors.green : null,
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        minimum: const EdgeInsets.only(
          left: 16,
          top: 8,
          bottom: 8,
          right: 8,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: pessoa.nomeDoador.isNotEmpty
                      ? <Widget>[
                          const Text(
                            'Família adotada por:',
                            style: Styles.linhaProdutoNomeDoItem,
                          ),
                          const Padding(padding: EdgeInsets.only(top: 8)),
                          Text(
                            pessoa.nomeDoador,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ]
                      : <Widget>[
                          Text(
                            'Família com ${aux.length} moradores, de\n${pessoa.nomeM1}, ',
                            style: Styles.linhaProdutoNomeDoItem,
                          ),
                          const Padding(padding: EdgeInsets.only(top: 8)),
                          Text(
                            '${aux.where((e) => e < 12).length} - Crianças\n${aux.where((e) => (e >= 12 && e <= 18)).length} - Adolescente(s) e\n${aux.where((e) => e > 18).length} - Adultos\n',
                            style: Styles.linhaProdutoPrecoDoItem,
                          )
                        ],
                ),
              ),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => Modular.to.pushNamed(
                'insert',
                arguments: {
                  "assistido": pessoa,
                },
              ),
              child: const Icon(
                Icons.edit,
                size: 30.0,
                color: Colors.blue,
                semanticLabel: 'Edit',
              ),
            ),
          ],
        ),
      ),
    );
  }

  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }
}
