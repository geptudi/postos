import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:rx_notifier/rx_notifier.dart';
import '../../models/product.dart';
import 'models/stream_assistido_model.dart';
import 'modelsview/home_build_tag_page.dart';
import 'home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Modular.get<HomeController>();
  final List<Product> _products = Product.generateItems(18);
  List<StreamAssistido> list = [];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller.isInitedController,
      builder: (BuildContext context, bool isInited, _) =>
          ValueListenableBuilder(
        valueListenable: controller.activeTagButtom,
        builder: (BuildContext context, String activeTag, Widget? child) =>
            StreamBuilder<List<StreamAssistido>>(
          initialData: const [],
          stream: controller.assistidosStoreList.stream,
          builder: (BuildContext context,
              AsyncSnapshot<List<StreamAssistido>> assistidoList) {
              list = controller.assistidosStoreList.search(
                  assistidoList.data!,
                  "",
                  'ATIVO',
                );
            return Scaffold(
              appBar: AppBar(
                title: Text('Cestas Natalinas do Posto $activeTag'),
                actions: <Widget>[
                  RxBuilder(
                    builder: (BuildContext context) => IconBadge(
                      icon: const Icon(Icons.sync),
                      itemCount: controller.assistidosStoreList.countSync.value,
                      badgeColor: Colors.red,
                      itemColor: Colors.white,
                      maxCount: 99,
                      hideZero: true,
                      onTap: () async {
                        controller.assistidosStoreList.sync();
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
                      setState(() => list[index].isExpanded = !isExpanded);
                    },
                    children: list.map<ExpansionPanel>((StreamAssistido product) {
                      return ExpansionPanelRadio(
                        // isExpanded: product.isExpanded,
                        value: product.assistido.ident,
                        canTapOnHeader: true,
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            leading: CircleAvatar(
                                child: Text(product.assistido.ident.toString())),
                            title: Text(product.nomeM1),
                          );
                        },
                        body: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Text(product.nomesMoradores),
                            ),
                            Image.network(
                                'https://picsum.photos/id/${product.assistido.ident}/500/300'),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
