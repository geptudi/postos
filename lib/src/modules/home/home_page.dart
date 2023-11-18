import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:icon_badge/icon_badge.dart';
import '../../models/parameters.dart';
import 'models/assistido_models.dart';
import 'modelsview/home_build_tag_page.dart';
import 'home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Modular.get<HomeController>();
  late Future<bool> initedState;
  List<Assistido> assistidoList = [];
  List<int> aux = [];

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
        builder: (BuildContext context, int activeTag, Widget? child) =>
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
                          title: Text(
                            'Cestas Natalinas do\nPosto ${postos[activeTag]![0]}',
                            style: const TextStyle(
                              fontSize: 18,
                              height: 1.1,
                            ),
                          ),
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
                            child: ExpansionPanelList.radio(
                              expansionCallback: (int index, bool isExpanded) {
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
                                  headerBuilder:
                                      (BuildContext context, bool isExpanded) {
                                    var st = product.datasNasc.substring(
                                        0,
                                        product.datasNasc.isEmpty
                                            ? 0
                                            : product.datasNasc.length - 1);
                                    aux = ([product.dataNascM1] + st.split(';'))
                                        .map(
                                      (e) {
                                        return e == ""
                                            ? calculateAge(
                                                DateFormat('dd/MM/yyyy')
                                                    .parse("1/1/1900"))
                                            : calculateAge(
                                                DateFormat('dd/MM/yyyy')
                                                    .parse(e));
                                      },
                                    ).toList();
                                    return ListTile(
                                      leading: CircleAvatar(
                                          child:
                                              Text(product.ident.toString())),
                                      title: Text(
                                          'Família com ${aux.length} moradores sendo:\n${aux.map((e) => e >= 18).length} - Adultos\n${aux.map((e) => e >= 12 && e > 18).length} - Adolescente(s) e\n${aux.map((e) => e < 12).length} - Crianças\nResponsável: ${product.nomeM1}'),
                                    );
                                  },
                                  body: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                      );
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(),
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
