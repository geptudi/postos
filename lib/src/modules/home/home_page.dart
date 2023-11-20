import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import '../../models/styles.dart';
import 'home_controller.dart';
import 'models/assistido_models.dart';
import 'package:badges/badges.dart' as bg;
import 'template_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = Modular.get<HomeController>();
  List<Assistido> assistidoList = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>?>(
      future: _controller.assistidosStoreList.getDatas(table: "BDados"),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>?> response) {
        if (response.data != null) {
          if (response.data!.isNotEmpty) {
            assistidoList =
                response.data!.map((e) => Assistido.fromList(e)).toList();
          }
        }
        return TemplatePage(
          hasProx: null,
          isLeading: true,
          answerLenght: 1,
          header: bg.Badge(
            badgeStyle: const bg.BadgeStyle(badgeColor: Colors.red),
            position: bg.BadgePosition.topStart(top: 0),
            badgeContent: const Text(
              '53',
              style: TextStyle(color: Colors.white, fontSize: 10.0),
            ),
            child: Text(
              'Cestas Natalinas do\nPosto ${_controller.activeTagButtom.value}',
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
          ),
          itens: (HomeController controller,
                  GlobalKey<FormFieldState<List<ValueNotifier<String>>>>
                      state) =>
              assistidoList
                  .map<Widget>(
                    (pessoa) => Column(
                      children: <Widget>[
                        row(pessoa),
                        Container(
                          height: 1,
                          color: Styles.linhaProdutoDivisor,
                        ),
                      ],
                    ),
                  )
                  .toList(),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget row(Assistido pessoa) {
    var st = pessoa.datasNasc.substring(
        0, pessoa.datasNasc.isEmpty ? 0 : pessoa.datasNasc.length - 1);
    var aux = ([pessoa.dataNascM1] + st.split(';')).map(
      (e) {
        return e == ""
            ? calculateAge(DateFormat('dd/MM/yyyy').parse("01/01/1900"))
            : calculateAge(DateFormat('dd/MM/yyyy').parse(e));
      },
    ).toList();
    return SafeArea(
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
                children: <Widget>[
                  Text(
                    'Família com ${aux.length} moradores',
                    style: Styles.linhaProdutoNomeDoItem,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 8)),
                  Text(
                    '${aux.where((e) => e < 12).length} - Crianças\n${aux.where((e) => (e >= 12 && e <= 18)).length} - Adolescente(s) e\n${aux.where((e) => e > 18).length} - Adultos',
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
