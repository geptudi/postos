import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';

import 'home_build_tag_button.dart';

class BuildTagPage extends StatelessWidget {
  final ValueNotifier<List<Map<String, dynamic>>> listaTelas;
  final ValueNotifier<String> activeTagButtom;
  const BuildTagPage(
      {Key? key, required this.activeTagButtom, required this.listaTelas})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: activeTagButtom,
        builder: (BuildContext context, String value, Widget? child) {
          return Container(
              margin: const EdgeInsets.only(
                left: 0.0,
                top: 10.0,
                bottom: 10.0,
                right: 10.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //const Spacer(),
                  BorderedText(
                      strokeWidth: 1.0,
                      strokeColor: Colors.blueAccent,
                      child: const Text(
                        'Posto de Assistência',
                        style: TextStyle(
                            fontSize: 40,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      )),
                  BorderedText(
                      strokeWidth: 1.0,
                      strokeColor: Colors.blueAccent,
                      child: const Text(
                        'Eurípedes Barsanulfo',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold),
                      )),
                  BuildTagButton(
                    listaTelas: listaTelas,
                    activeTagButtom: activeTagButtom,
                    tag: 'Assistidos',
                    icon: const Icon(Icons.travel_explore),
                  ),
                  BuildTagButton(
                      listaTelas: listaTelas,
                      activeTagButtom: activeTagButtom,
                      tag: 'Colaboradores',
                      icon: const Icon(Icons.people)),
                  BuildTagButton(
                      listaTelas: listaTelas,
                      activeTagButtom: activeTagButtom,
                      tag: 'LogIn',
                      icon: const Icon(Icons.login)),
                  BuildTagButton(
                      listaTelas: listaTelas,
                      activeTagButtom: activeTagButtom,
                      tag: 'Configurações',
                      icon: const Icon(Icons.settings)),
                  BuildTagButton(
                      listaTelas: listaTelas,
                      activeTagButtom: activeTagButtom,
                      tag: 'Informações',
                      icon: const Icon(Icons.info)),
                ],
              ));
        });
  }
}
