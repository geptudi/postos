import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:rx_notifier/rx_notifier.dart';
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
                        .getChanges(table: activeTag),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<dynamic>?> response) {
                      if (response.data != null) {
                        if ((response as List).isNotEmpty) {
                          assistidoList = response.data!
                              .map((e) => Assistido.fromList(e))
                              .toList();
                        }
                      }
                      return Scaffold(
                        appBar: AppBar(
                          title: Text('Cestas Natalinas do Posto $activeTag'),
                          actions: <Widget>[
                            RxBuilder(
                              builder: (BuildContext context) => IconBadge(
                                icon: const Icon(Icons.sync),
                                itemCount: assistidoList.length,
                                badgeColor: Colors.red,
                                itemColor: Colors.white,
                                maxCount: 99,
                                hideZero: true,
                                onTap: () async {
                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        ),
                        drawer: HomeBuildTagPage(
                          activeTagButtom: controller.activeTagButtom,
                        ),
                        body: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: ExpansionPanelList.radio(
                              expansionCallback: (int index, bool isExpanded) {
                                setState(() => assistidoList[index].isExpanded =
                                    !isExpanded);
                              },
                              children: assistidoList
                                  .map<ExpansionPanel>((Assistido product) {
                                return ExpansionPanelRadio(
                                  // isExpanded: product.isExpanded,
                                  value: product.ident,
                                  canTapOnHeader: true,
                                  headerBuilder:
                                      (BuildContext context, bool isExpanded) {
                                    return ListTile(
                                      leading: CircleAvatar(
                                          child:
                                              Text(product.ident.toString())),
                                      title: Text(product.nomeM1),
                                    );
                                  },
                                  body: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 12.0),
                                        child: Text(product.nomesMoradores),
                                      ),
                                      Image.network(
                                          'https://picsum.photos/id/${product.ident}/500/300'),
                                    ],
                                  ),
                                );
                              }).toList(),
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
