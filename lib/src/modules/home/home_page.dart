import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import '../../models/styles.dart';
import 'home_controller.dart';
import 'package:badges/badges.dart' as bg;
import 'models/doador_assistido_model.dart';
import 'modelsview/template_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = Modular.get<HomeController>();
  List<DoadorAssistido> assistidoList = [];
  @override
  void initState() {
    super.initState();
  }

  Future<bool> init() async {
    _controller.doadorCount.value = 0;
    final response1 = await _controller.assistidosStoreList.getDatas(
        planilha: _controller.activeTagButtom.value,
        table: "BDados",
        columnFilter: 'Condição',
        valueFilter: 'ATIVO');
    final response2 = await _controller.assistidosStoreList
        .getDatas(planilha: _controller.activeTagButtom.value, table: "Doador");
    if (response1 != null &&
        response1.isNotEmpty &&
        response2 != null &&
        response2.isNotEmpty) {
      for (int index = 0; index < response1.length; index++) {
        assistidoList.add(
          DoadorAssistido.fromList(
            response1[index],
            value2: response2[response1[index][0]-1],
          ),
        );
        if (((response2[response1[index][0]-1][1] ?? "") as String).isNotEmpty) {
          _controller.doadorCount.value++;
        }
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: init(),
      builder: (BuildContext context, AsyncSnapshot<bool> initValue) =>
          TemplatePage(
        hasProx: null,
        isLeading: true,
        answerLenght: 1,
        header: bg.Badge(
          badgeStyle: const bg.BadgeStyle(badgeColor: Colors.green),
          position: bg.BadgePosition.topStart(top: 0, start: 0),
          badgeContent: ValueListenableBuilder(
            valueListenable: _controller.doadorCount,
            builder: (BuildContext context, int count, _) => Text(
              '$count',
              style: const TextStyle(color: Colors.white, fontSize: 10.0),
            ),
          ),
          child: bg.Badge(
          badgeStyle: const bg.BadgeStyle(badgeColor: Colors.red),
          position: bg.BadgePosition.topStart(top: 25, start: 0),
          badgeContent: ValueListenableBuilder(
            valueListenable: _controller.doadorCount,
            builder: (BuildContext context, int count, _) => Text(
              '${assistidoList.length - count}',
              style: const TextStyle(color: Colors.white, fontSize: 10.0),
            ),
          ),
          child: Text(
            'Cestas Natalinas do Posto ${_controller.activeTagButtom.value}',
            textAlign: TextAlign.center,
            style: const TextStyle(
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
        ),),
        itens: (HomeController controller,
                GlobalKey<FormFieldState<List<ValueNotifier<String>>>> state) =>
            initValue.data == true
                ? assistidoList
                    .map<Widget>(
                      (pessoa) => Column(
                        children: <Widget>[
                          StreamBuilder<bool>(
                              initialData: false,
                              stream: pessoa.doadorStream,
                              builder: (BuildContext context,
                                      AsyncSnapshot<bool> assistidoList) =>
                                  row(pessoa)),
                          Container(
                            height: 1,
                            color: Styles.linhaProdutoDivisor,
                          ),
                        ],
                      ),
                    )
                    .toList()
                : [
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
      ),
    );
  }

  @override
  void dispose() {
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
