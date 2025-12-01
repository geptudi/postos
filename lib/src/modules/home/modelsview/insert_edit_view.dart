import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:intl/intl.dart';
import '../models/posto_model.dart';
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

  late final HomeController controller;

  @override
  void initState() {
    super.initState();
    controller = Modular.get<HomeController>();
    _assistido.copy(widget.assistido);
  }

  @override
  Widget build(BuildContext context) {
    final aux = _assistido.nomeM1.split(" ");
    final nomePrimeiraPessoa = '${aux[0]} ${aux.length > 1 ? aux[1] : ""}';

    /// Obtém o posto selecionado de forma segura
    final posto = controller.getPosto(controller.activeTagButtom.value);

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
            Shadow(offset: Offset(2, 2), blurRadius: 1, color: Colors.black),
          ],
        ),
      ),
      itens:
          (
            HomeController controller,
            GlobalKey<FormFieldState<List<ValueNotifier<String>>>> state,
          ) {
            return [
              const SizedBox(height: 20),

              // Título
              Row(
                children: [
                  Text(
                    'Dados da Família assistida com ${_assistido.nomesMoradores.length + 1} pessoas:',
                    textAlign: TextAlign.left,
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: "Copiar todas as informações desta tela",
                    icon: const Icon(Icons.copy_all_outlined),
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(text: _buildClipboardText(posto)),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Tabela principal
              Table(
                border: TableBorder.all(),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children:
                    <TableRow>[
                      TableRow(
                        children: [_tableHeader("Nome"), _tableHeader("Idade")],
                      ),
                      _tableRow(
                        nomePrimeiraPessoa,
                        _calcIdade(_assistido.dataNascM1),
                      ),
                    ] +
                    _montaTabelaMoradores(),
              ),

              const SizedBox(height: 20),

              /// Endereço da família
              Text(
                '${_assistido.logradouro}: ${_assistido.endereco} nº ${_assistido.numero}, ${_assistido.bairro}\n'
                '${_assistido.complemento} CEP.: ${_assistido.cep}\n'
                'Telefone: ${_assistido.fone}',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              /// Dados do posto
              const Text('Dados do posto:', textAlign: TextAlign.left),
              const SizedBox(height: 20),

              _buildPostoResumo(posto),

              const SizedBox(height: 20),

              /// Dados do Doador
              const Text('Dados do Doador:', textAlign: TextAlign.left),

              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: _buildFormularioDoador(),
              ),
            ];
          },
    );
  }

  // -----------------------------
  //         AUXILIARES
  // -----------------------------

  Widget _tableHeader(String text) {
    return Container(
      color: Colors.green,
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(text, textAlign: TextAlign.center),
    );
  }

  TableRow _tableRow(String nome, int idade) {
    return TableRow(children: [_tableCell(nome), _tableCell(idade.toString())]);
  }

  Widget _tableCell(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(text, textAlign: TextAlign.center),
    );
  }

  int _calcIdade(String data) {
    final nasc = DateFormat('dd/MM/yyyy').parse(data);
    return DateTime.now().year - nasc.year;
  }

  List<TableRow> _montaTabelaMoradores() {
    List<TableRow> resp = [];

    for (int i = 0; i < _assistido.nomesMoradores.length; i++) {
      final partes = _assistido.nomesMoradores[i].split(" ");
      final nome = "${partes[0]} ${partes.length > 1 ? partes[1] : ""}";
      final idade = _calcIdade(_assistido.datasNasc[i]);

      resp.add(_tableRow(nome, idade));
    }

    return resp;
  }

  Widget _buildPostoResumo(PostoModel posto) {
    if (controller.activeTagButtom.value.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Text(
          """
Posto de Assistência Espírita ${controller.activeTagButtom.value}

${posto.endereco}
${posto.bairro}

${posto.coordenador1}, e
${posto.coordenador2}
""",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.indigo, fontSize: 15),
        ),
        Text(
          posto.entrega,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red, fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildFormularioDoador() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Nome do doador
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
              }
              if (value.length < 4) {
                return 'Nome muito pequeno';
              }
              return null;
            },
            onChanged: (v) => setState(() => _assistido.nomeDoador = v),
          ),

          const SizedBox(height: 15),

          // Telefone do doador
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
              final reg = RegExp(r'(^\([0-9]{2}\) (?:9)?[0-9]{4}\-[0-9]{4}$)');
              if (value == null || !reg.hasMatch(value)) {
                return 'Por favor entre com um telefone válido';
              }
              return null;
            },
            onChanged: (v) => setState(() => _assistido.telDoador = v),
          ),

          const SizedBox(height: 15),

          // Endereço do doador
          TextFormField(
            initialValue: _assistido.endDoador,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              icon: Icon(Icons.place),
              labelText: 'Endereço do Doador',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor entre com um endereço válido';
              }
              if (value.length < 4) {
                return 'Endereço muito pequeno';
              }
              return null;
            },
            onChanged: (v) => setState(() => _assistido.endDoador = v),
          ),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: _assistido.nomeDoador.isNotEmpty
                    ? () async {
                        await _confirmaClear();
                        Modular.to.pop();
                      }
                    : null,
                child: const Text("Excluir Doador"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _formKey.currentState?.validate() ?? false
                    ? () async {
                        await save();
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
    );
  }

  Future<void> _confirmaClear() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text("Atenção !!!"),
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 20,
        ),
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

              await save();
              controller.doadorCount.value--;

              Modular.to.pop();
            },
            child: const Text("Confirmar"),
          ),
        ],
        content: const Text(
          "Você realmente deseja excluir o Doador para esta família ?",
        ),
      ),
    );
  }

  Future<void> save() async {
    await controller.assistidosStoreList.setItens(
      _assistido.nomeM1,
      'Nome do Doador',
      [_assistido.nomeDoador, _assistido.telDoador, _assistido.endDoador],
      planilha: controller.activeTagButtom.value,
      table: "Doador",
    );

    widget.assistido?.copy(_assistido);
  }

  /// Texto completo para copiar para área de transferência
  String _buildClipboardText(PostoModel posto) {
    return """
OSGEPT - Obras Sociais do Grupo Espírita Paulo de Tarso

Dados da Família assistida com ${_assistido.nomesMoradores.length + 1} pessoas:

Nome - Idade
${_assistido.nomeM1.split(" ")[0]} - ${_calcIdade(_assistido.dataNascM1)}
${_montaStringMoradores()}

${_assistido.logradouro}: ${_assistido.endereco} nº ${_assistido.numero}, ${_assistido.bairro}
${_assistido.complemento} CEP.: ${_assistido.cep}

Telefone: ${_assistido.fone}

Dados do posto:

Posto de Assistência Espírita ${controller.activeTagButtom.value}

${posto.endereco}
${posto.bairro}
${posto.coordenador1}, e
${posto.coordenador2}

${posto.entrega}
""";
  }

  String _montaStringMoradores() {
    List<String> linhas = [];

    for (int i = 0; i < _assistido.nomesMoradores.length; i++) {
      final partes = _assistido.nomesMoradores[i].split(" ");
      final nome = partes[0];
      final idade = _calcIdade(_assistido.datasNasc[i]);
      linhas.add("$nome - $idade");
    }

    return linhas.join("\n");
  }

  @override
  void dispose() {
    super.dispose();
  }
}
