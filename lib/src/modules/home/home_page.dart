import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:icon_badge/icon_badge.dart';
import 'models/assistido_models.dart';
import 'modelsview/home_build_tag_page.dart';
import 'home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Modular.get<HomeController>();
  late Future<bool> initedState;
  List<Assistido> assistidoList = [];

  @override
  void initState() {
    initedState = controller.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: initedState,
      builder: (BuildContext context, AsyncSnapshot<bool> isInited) =>
          ValueListenableBuilder(
        valueListenable: controller.activeTagButtom,
        builder: (BuildContext context, String activeTag, Widget? child) =>
            isInited.hasData
                ? FutureBuilder<List<dynamic>?>(
                    initialData: const <Assistido>[],
                    future: controller.assistidosStoreList
                        .getDatas(table: "BDados" /*activeTag*/),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<dynamic>?> response) {
                      if (response.data != null) {
                        if (response.data!.isNotEmpty) {
                          assistidoList = response.data!
                              .map((e) => Assistido.fromList(e))
                              .toList();
                        }
                      }
                      return Scaffold(
                        appBar: AppBar(
                          title: Text('Cestas Natalinas do Posto $activeTag'),
                          actions: <Widget>[
                            IconBadge(
                              icon: const Icon(Icons.sync),
                              itemCount: assistidoList.length,
                              badgeColor: Colors.red,
                              itemColor: Colors.white,
                              maxCount: 999,
                              hideZero: true,
                              onTap: () async {
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                        drawer: HomeBuildTagPage(
                          activeTagButtom: controller.activeTagButtom,
                        ),
                        body: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: ValueListenableBuilder(
                              valueListenable: controller.isExpanded,
                              builder: (BuildContext context, bool activeTag,
                                      Widget? child) =>
                                  ExpansionPanelList.radio(
                                expansionCallback:
                                    (int index, bool isExpanded) {
                                  controller.isExpanded.value =
                                      !controller.isExpanded.value;
                                },
                                children: assistidoList
                                    .map<ExpansionPanel>((Assistido product) {
                                  return ExpansionPanelRadio(
                                    backgroundColor: Colors.white,
                                    // isExpanded: product.isExpanded,
                                    value: product.ident,
                                    canTapOnHeader: true,
                                    headerBuilder: (BuildContext context,
                                        bool isExpanded) {
                                      return ListTile(
                                        leading: CircleAvatar(
                                            child:
                                                Text(product.ident.toString())),
                                        title: Text(
                                            'Família com ${product.nomesMoradores.split(';').length} moradores sendo:\n0 - Adultos\n0 - Adolescente(s) e\n0 - Crianças\nResponsável: ${product.nomeM1}'),
                                      );
                                    },
                                    body: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            '${product.logradouro}: ${product.endereco} nº ${product.numero}\nBairro: ${product.bairro}\nTelefone: ${product.fone}'),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
      ),
    );
  }
}
