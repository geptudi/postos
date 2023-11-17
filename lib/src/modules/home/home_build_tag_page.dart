import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'home_build_tag_button.dart';

class HomeBuildTagPage extends StatelessWidget {
  final ValueNotifier<String> activeTagButtom;
  const HomeBuildTagPage(
      {Key? key, required this.activeTagButtom})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ValueListenableBuilder(
        valueListenable: activeTagButtom,
        builder: (BuildContext context, String value, Widget? child) {
          return Container(
            margin: const EdgeInsets.only(
              left: 30.0,
              top: 20.0,
              bottom: 20.0,
              right: 20.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                BorderedText(
                  strokeWidth: 1.0,
                  strokeColor: Colors.blueAccent,
                  child: const Text(
                    'Postos de Assistência',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                BorderedText(
                  strokeWidth: 1.0,
                  strokeColor: Colors.blueAccent,
                  child: const Text(
                    'Espírita',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                BuildTagButton(
                  onPressed: () {
                    Modular.to.pop();
                  },
                  activeTagButtom: activeTagButtom,
                  tag: const ['Bezerra de Menezes', 'Bairro: Pacaembu'],
                  icon: const Icon(Icons.travel_explore),
                ),
                const SizedBox(
                  height: 10,
                ),
                BuildTagButton(
                  onPressed: () {
                    Modular.to.pop();
                  },
                  activeTagButtom: activeTagButtom,
                  tag: const ['Eurípedes Barsanulfo', 'Bairro: Morada Nova'],
                  icon: const Icon(Icons.people),
                ),
                const SizedBox(
                  height: 10,
                ),
                BuildTagButton(
                  onPressed: () {
                    Modular.to.pop();
                  },
                  activeTagButtom: activeTagButtom,
                  tag: const ['Mãe Zeferina', 'Bairro: Taiaman'],
                  icon: const Icon(Icons.login),
                ),
                const SizedBox(
                  height: 10,
                ),
                BuildTagButton(
                  onPressed: () {
                    Modular.to.pop();
                  },
                  activeTagButtom: activeTagButtom,
                  tag: const ['Simão Pedro', 'Bairro: São Francisco'],
                  icon: const Icon(Icons.settings),
                ),
                const SizedBox(
                  height: 10,
                ),
                BuildTagButton(
                  onPressed: () {
                    Modular.to.pop();
                    _info(context);                    
                  },
                  activeTagButtom: activeTagButtom,
                  tag: const ['Informações'],
                  icon: const Icon(Icons.info),
                ),
                const Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }

  Future _info(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.background,
            title: const Text("Informações"),
            titleTextStyle: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
            actionsOverflowButtonSpacing: 20,
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Modular.to.pop();
                  },
                  child: const Text("Close")),
            ],
            content: const Text("Esta pagina foi criada para que as familias assistidas pela OSGET - Obras Sociais do Grupo Espirita Paulo de Tarso, sejam adotadas com sextas natalinas."),
          );
        });
  }
}
