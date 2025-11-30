import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:intl/intl.dart';
import '../../../models/parameters.dart';
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
    super.initState();
    _assistido.copy(widget.assistido);
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
          shadows: [
            Shadow(
              offset: Offset(2.0, 2.0),
              blurRadius: 1.0,
              color: Colors.black,
            ),
          ],
        ),
      ),
      itens: (HomeController controller,
              GlobalKey<FormFieldState<List<ValueNotifier<String>>>> state) =>
          [
        const SizedBox(height: 20),

        /// **Título da Tabela + Botão de Copiar**
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
                final posto = Parameters.postos[controller.activeTagButtom.value];
                await Clipboard.setData(
                  ClipboardData(
                    text: """
OSGEPT - Obras Sociais do Grupo Espírita Paulo de Tarso

Dados da Família assistida com ${_assistido.nomesMoradores.length + 1} pessoas:

Nome - Idade
${aux[0]} - ${(DateTime.now().year - DateFormat('dd/MM/yyyy').parse(_assistido.dataNascM1).year)}
${montaString()}

${_assistido.logradouro}: ${_assistido.endereco} nº ${_assistido.numero}, ${_assistido.bairro}
${_assistido.complemento} CEP: ${_assistido.cep}

Telefone: ${_assistido.fone}

Dados do posto:

Posto de Assistência Espírita ${controller.activeTagButtom.value}
${posto?[0] ?? ""}
${posto?[1] ?? ""}
${posto?[2] ?? ""}, e
${posto?[3] ?? ""}

${posto?[4] ?? ""}
""",
                  ),
                );
              },
              icon: const Icon(Icons.copy_all_outlined),
            ),
          ],
        ),

        const SizedBox(height: 20),

        /// **Tabela de Moradores**
        Table(
          border: TableBorder.all(),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                Container(
                  color: Colors.green,
                  child: const Center(child: Text("Nome")),
                ),
                Container(
                  color: Colors.green,
                  child: const Center(child: Text("Idade")),
                ),
              ],
            ),
            TableRow(
              children: [
                Container(
                  color: Colors.white,
                  child: Center(child: Text(nome)),
                ),
                Container(
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      (DateTime.now().year -
                              DateFormat('dd/MM/yyyy')
                                  .parse(_assistido.dataNascM1)
                                  .year)
                          .toString(),
                    ),
                  ),
                ),
              ],
            ),
            ...montaTabela(),
          ],
        ),

        const SizedBox(height: 20),

        Text(
          '${_assistido.logradouro}: ${_assistido.endereco} nº ${_assistido.numero}, ${_assistido.bairro}\n'
          '${_assistido.complemento} CEP: ${_assistido.cep}\nTelefone: ${_assistido.fone}',
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 20),

        /// **Dados do Posto**
        const Text(
          'Dados do posto:',
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 20),

        Builder(builder: (context) {
          final posto = Parameters.postos[controller.activeTagButtom.value];

          if (controller.activeTagButtom.value.isEmpty || posto == null) {
            return const SizedBox.shrink();
          }

          return Column(
            children: [
              Text(
                """
Posto de Assistência Espírita ${controller.activeTagButtom.value}
${posto[0]}
${posto[1]}
${posto[2]}, e
${posto[3]}
""",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.indigo, fontSize: 15),
              ),
              Text(
                posto[4],
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 15),
              ),
            ],
          );
        }),

        const SizedBox(height: 20),

        const Text(
          'Dados do Doador:',
          textAlign: TextAlign.left,
        ),

        /// **FORMULÁRIO DO DOADOR**
        Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),

                /// Nome do Doador
                TextFormField(
                  initialValue: _assistido.nomeDoador,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    icon: Icon(Icons.person),
                    labelText: 'Informe o nome do Doador',
                  ),
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

                /// Telefone
                TextFormField(
                  initialValue: _assistido.telDoador,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    icon: Icon(Icons.phone),
                    labelText: 'Telefone do Doador',
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    TelefoneInputFormatter(),
                  ],
                  validator: (value) {
                    const pattern =
                        r'(^\([0-9]{2}\) (?:9)?[0-9]{4}\-[0-9]{4}$)';
                    if (value == null || !RegExp(pattern).hasMatch(value)) {
                      return 'Digite um telefone válido';
                    }
                    return null;
                  },
                  onChanged: (v) =>
                      setState(() => _assistido.telDoador = v),
                ),

                /// Endereço
                TextFormField(
                  initialValue: _assistido.endDoador,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    icon: Icon(Icons.place),
                    labelText: "Endereço do Doador",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor entre com um endereço válido';
                    } else if (value.length < 4) {
                      return 'Endereço muito pequeno';
                    }
                    return null;
                  },
                  onChanged: (v) => setState(() => _assistido.endDoador = v),
                ),

                const SizedBox(height: 24),

                /// Botões
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
                      child: const Text("Excluir Doador"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed:
                          _formKey.currentState?.validate() ?? false
                              ? () async {
                                  _formKey.currentState!.save();
                                  await save(controller);
                                  controller.doadorCount.value++;
                                  Modular.to.pop();
                                }
                              : null,
                      child: const Text("Salvar Alterações"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Confirmação de exclusão
  Future<void> _confirmaClear(
      BuildContext context, HomeController controller) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Atenção !!!"),
          content: const Text(
              "Você realmente deseja excluir o Doador para esta família ?"),
          actions: [
            ElevatedButton(
              onPressed: () => Modular.to.pop(),
              child: const Text("Cancelar"),
            ),
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
              child: const Text("Confirmar"),
            ),
          ],
        );
      },
    );
  }

  /// Salvar no banco
  Future<void> save(HomeController controller) async {
    controller.assistidosStoreList.setItens(
      _assistido.nomeM1,
      'Nome do Doador',
      [
        _assistido.nomeDoador,
        _assistido.telDoador,
        _assistido.endDoador,
      ],
      planilha: controller.activeTagButtom.value,
      table: "Doador",
    );
    widget.assistido?.copy(_assistido);
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Cria as linhas da tabela de moradores
  List<TableRow> montaTabela() {
    List<TableRow> resp = [];

    for (int i = 0; i < _assistido.nomesMoradores.length; i++) {
      final aux = _assistido.nomesMoradores[i].split(" ");
      final nome = '${aux[0]} ${(aux.length > 1 ? aux[1] : "")}';

      resp.add(
        TableRow(
          children: [
            Container(
              color: Colors.white,
              child: Center(child: Text(nome)),
            ),
            Container(
              color: Colors.white,
              child: Center(
                child: Text(
                  (DateTime.now().year -
                          DateFormat('dd/MM/yyyy')
                              .parse(_assistido.datasNasc[i])
                              .year)
                      .toString(),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return resp;
  }

  /// Monta string "Nome - Idade"
  String montaString() {
    String resp = "";

    for (int i = 0; i < _assistido.nomesMoradores.length; i++) {
      resp +=
          "${_assistido.nomesMoradores[i].split(" ")[0]} - ${(DateTime.now().year - DateFormat('dd/MM/yyyy').parse(_assistido.datasNasc[i]).year)}\n";
    }

    return resp;
  }
}