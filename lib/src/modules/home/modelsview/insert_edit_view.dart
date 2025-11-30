import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:intl/intl.dart';
import '../../../models/parameters.dart';        // <-- IMPORTANTE
import '../home_controller.dart';
import '../models/doador_assistido_model.dart';
import 'template_page.dart';

class InsertEditViewPage extends StatefulWidget {
  final DoadorAssistido? assistido;
  const InsertEditViewPage({super.key, this.assistido});

  @override
  State<InsertEditViewPage> createState() => _InsertEditViewPageState();
}

class _InsertEditViewPageState extends State<InsertEditViewPage> {
  final _assistido = DoadorAssistido.vazio();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _assistido.copy(widget.assistido);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final aux = _assistido.nomeM1.split(" ");
    final nome = '${aux[0]} ${(aux.length > 1 ? aux[1] : "")}';

    return TemplatePage(
      hasProx: null,
      isLeading: true,
      answerLenght: 1,
      header: const Text(
        'Descritivo Geral',
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
        const SizedBox(height: 20),
        Row(
          children: [
            Text(
              'Dados da Família assistida com ${_assistido.nomesMoradores.length + 1} pessoas:',
              textAlign: TextAlign.left,
            ),
            const Spacer(),
            IconButton(
              tooltip: "Copia todas as informações desta tela",
              onPressed: () async {
                await Clipboard.setData(
                  ClipboardData(
                    text: """
OSGEPT - Obras Sociais do Grupo Espírita Paulo de Tarso

Dados da Família assistida com ${_assistido.nomesMoradores.length + 1} pessoas:

Nome\t-\tIdade
${_assistido.nomeM1.split(" ")[0]}\t-\t${(DateTime.now().year - DateFormat('dd/MM/yyyy').parse(_assistido.dataNascM1).year).toString()}
${montaString()}

${_assistido.logradouro}: ${_assistido.endereco} nº ${_assistido.numero}, ${_assistido.bairro}\n${_assistido.complemento} CEP.: ${_assistido.cep}

Telefone: ${_assistido.fone}

Dados do posto:
         
Posto de Assistência Espírita ${controller.activeTagButtom.value} 
${Parameters.postos[controller.activeTagButtom.value]![0]}
${Parameters.postos[controller.activeTagButtom.value]![1]}
${Parameters.postos[controller.activeTagButtom.value]![2]}, e
${Parameters.postos[controller.activeTagButtom.value]![3]}

""",
                  ),
                );
              },
              icon: const Icon(Icons.copy_all_outlined),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Table(
          border: TableBorder.all(),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: <TableRow>[
                TableRow(
                  children: <Widget>[
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.top,
                      child: Container(
                        width: 32,
                        color: Colors.green,
                        child: const Text(
                          "Nome",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.top,
                      child: Container(
                        width: 32,
                        color: Colors.green,
                        child: const Text(
                          "Idade",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.top,
                      child: Container(
                        width: 32,
                        color: Colors.white,
                        child: Text(
                          nome,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.top,
                      child: Container(
                        width: 32,
                        color: Colors.white,
                        child: Text(
                          (DateTime.now().year -
                                  DateFormat('dd/MM/yyyy')
                                      .parse(_assistido.dataNascM1)
                                      .year)
                              .toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ] +
              montaTabela(),
        ),
        const SizedBox(height: 20),
        Text(
          '${_assistido.logradouro}: ${_assistido.endereco} nº ${_assistido.numero}, ${_assistido.bairro}\n${_assistido.complemento} CEP.: ${_assistido.cep}\nTelefone: ${_assistido.fone}',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        const Text(
          'Dados do posto:',
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 20),
        Text(
          textAlign: TextAlign.center,
          controller.activeTagButtom.value == ""
              ? ""
              : """
Posto de Assistência Espírita ${controller.activeTagButtom.value} 
${Parameters.postos[controller.activeTagButtom.value]![0]}
${Parameters.postos[controller.activeTagButtom.value]![1]}
${Parameters.postos[controller.activeTagButtom.value]![2]}, e
${Parameters.postos[controller.activeTagButtom.value]![3]}
""",
          style: const TextStyle(color: Colors.indigo, fontSize: 15.0),
        ),
        Text(
          textAlign: TextAlign.center,
          controller.activeTagButtom.value == ""
              ? ""
              : """
${Parameters.postos[controller.activeTagButtom.value]![4]}
""",
          style: const TextStyle(color: Colors.red, fontSize: 15.0),
        ),
        const SizedBox(height: 20),
        const Text(
          'Dados do Doador:',
          textAlign: TextAlign.left,
        ),

        // … (RESTO DO ARQUIVO NÃO MEXE EM NADA)
        Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always, //.onUserInteraction,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: _assistido.nomeDoador,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    icon: Icon(Icons.person),
                    labelText: 'Informe o nome do Doador',
                  ),
                  keyboardType: TextInputType.name,
                  autovalidateMode: AutovalidateMode.always,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor entre com um nome';
                    } else if (value.length < 4) {
                      return 'Nome muito pequeno';
                    }
                    return null;
                  },
                  onChanged: (v) => setState(() => _assistido.nomeDoador = v),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  initialValue: _assistido.telDoador,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      icon: Icon(Icons.phone),
                      labelText: 'Telefone do Doador'),
                  autovalidateMode: AutovalidateMode.always,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    TelefoneInputFormatter(),
                  ],
                  validator: (value) {
                    String pattern =
                        r'(^\([0-9]{2}\) (?:9)?[0-9]{4}\-[0-9]{4}$)';
                    RegExp regExp = RegExp(pattern);
                    if (value == null ||
                        value.isEmpty ||
                        !regExp.hasMatch(value)) {
                      return 'Please enter valid mobile number';
                    }
                    return null;
                  },
                  onChanged: (v) => setState(
                    () => _assistido.telDoador = v,
                  ),
                ),
                TextFormField(
                    initialValue: _assistido.endDoador,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        icon: Icon(Icons.place),
                        labelText: "Endereço do Doador"),
                    autovalidateMode: AutovalidateMode.always,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor entre com um enderço válido';
                      } else if (value.length < 4) {
                        return 'Endereço muito pequeno';
                      }
                      return null;
                    },
                    onChanged: (v) => setState(() => _assistido.endDoador = v)),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: _assistido.nomeDoador.isNotEmpty
                            ? () async {
                                await _confirmaClear(context, controller);
                                Modular.to.pop();
                              }
                            : null,
                        child: const Text("Excluir Doador")),
                    const SizedBox(width: 10), // give it width
                    ElevatedButton(
                        onPressed: _formKey.currentState?.validate() ?? false
                            ? () async {
                                _formKey.currentState!.save();
                                await save(controller);
                                controller.doadorCount.value++;
                                Modular.to.pop();
                              }
                            : null,
                        child: const Text("Salvar Aterações")),
                    const SizedBox(width: 10), // give it width
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmaClear(
      BuildContext context, HomeController controller) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text("Atenção !!!"),
          titleTextStyle: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
          actionsOverflowButtonSpacing: 20,
          actions: [
            ElevatedButton(
                onPressed: () {
                  Modular.to.pop();
                },
                child: const Text("Cancelar")),
            ElevatedButton(
                onPressed: () async {
                  _assistido.nomeDoador = "";
                  _assistido.telDoador = "";
                  _assistido.endDoador = "";
                  _formKey.currentState!.save();
                  await save(controller);
                  controller.doadorCount.value--;
                  Modular.to.pop();
                },
                child: const Text("Confirmar")),
          ],
          content: const Text(
              "Você realmente deseja excluir o Doador para esta família ?"),
        );
      },
    );
  }

  Future<void> save(HomeController controller) async {
    controller.assistidosStoreList.setItens(
        _assistido.nomeM1.toString(),
        'Nome do Doador',
        [
          _assistido.nomeDoador,
          _assistido.telDoador,
          _assistido.endDoador,
        ],
        planilha: controller.activeTagButtom.value,
        table: "Doador");
    widget.assistido?.copy(_assistido);
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<TableRow> montaTabela() {
    List<TableRow> resp = <TableRow>[];
    if (_assistido.nomesMoradores.isNotEmpty) {
      final list1 = _assistido.nomesMoradores;    
      final list2 = _assistido.datasNasc;
      for (int i = 0; i < list1.length; i++) {
        var aux  = list1[i].split(" ");
        var nome = '${aux[0]} ${(aux.length > 1 ? aux[1]: "")}';           
        resp.add(
          TableRow(
            children: <Widget>[
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.top,
                child: Container(
                  width: 32,
                  color: Colors.white,
                  child: Text(
                    nome,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.top,
                child: Container(
                  width: 32,
                  color: Colors.white,
                  child: Text(
                    (DateTime.now().year -
                            DateFormat('dd/MM/yyyy').parse(list2[i]).year)
                        .toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }
    return resp;
  }

  String montaString() {
    String resp = "";
    if (_assistido.nomesMoradores.isNotEmpty) {
      final list1 = _assistido.nomesMoradores;
      final list2 = _assistido.datasNasc;
      for (int i = 0; i < list1.length; i++) {
        resp =
            '$resp${list1[i].split(" ")[0]}\t-\t${(DateTime.now().year - DateFormat('dd/MM/yyyy').parse(list2[i]).year).toString()}\n';
      }
    }
    return resp;
  }

  bool isCpf(String? cpf) {
    if (cpf == null) {
      return false;
    }

    // get only the numbers
    final numbers = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    // Test if the CPF has 11 digits
    if (numbers.length != 11) {
      return false;
    }
    // Test if all CPF digits are the same
    if (RegExp(r'^(\d)\1*$').hasMatch(numbers)) {
      return false;
    }

    // split the digits
    final digits = numbers.split('').map(int.parse).toList();

    // Calculate the first verifier digit
    var calcDv1 = 0;
    for (var i in Iterable<int>.generate(9, (i) => 10 - i)) {
      calcDv1 += digits[10 - i] * i;
    }
    calcDv1 %= 11;

    final dv1 = calcDv1 < 2 ? 0 : 11 - calcDv1;

    // Tests the first verifier digit
    if (digits[9] != dv1) {
      return false;
    }

    // Calculate the second verifier digit
    var calcDv2 = 0;
    for (var i in Iterable<int>.generate(10, (i) => 11 - i)) {
      calcDv2 += digits[11 - i] * i;
    }
    calcDv2 %= 11;

    final dv2 = calcDv2 < 2 ? 0 : 11 - calcDv2;

    // Test the second verifier digit
    if (digits[10] != dv2) {
      return false;
    }

    return true;
  }
}
