import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'home_build_tag_button.dart';

class HomeBuildTagPage extends StatelessWidget {
  final ValueNotifier<int> activeTagButtom;
  const HomeBuildTagPage({super.key, required this.activeTagButtom});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ValueListenableBuilder(
        valueListenable: activeTagButtom,
        builder: (BuildContext context, int value, Widget? child) {
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
                  tag: 0,
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
                  tag: 1, 
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
                  tag: 2, 
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
                  tag: 3,
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
                  tag: 4, //'Informações',
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
            content: const Text("""
As contribuições serão direcionadas aos quarto (4) postos de assistência das Obras Sociais do Grupo Espírita Paulo de Tarso, para o bem-estar de nossa comunidade! 

Ao fazer uma doação de cestas básicas, ou adotar diretamente uma família, você está apoiando diretamente os assistidos que são acompanhados pelos Postos de Assistência. 

Sua generosidade faz a diferença na vida de quem mais precisa. 

Junte-se a nós nessa causa e ajude a construir um natal melhor e recheado para todos.

Que Deus lhe abençoe.

"""),
          );
        });
  }
}
