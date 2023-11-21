import 'dart:async';
import 'assistido_models.dart';

class DoadorAssistido extends Assistido {
  String nomeDoador;
  String telDoador;
  String endDoador;

  final StreamController<DoadorAssistido> _doadorController =
      StreamController<DoadorAssistido>.broadcast();

  DoadorAssistido(super.assistido,
      {this.nomeDoador = "", this.telDoador = "", this.endDoador = ""})
      : super.assistido();

  DoadorAssistido.vazio(
      {this.nomeDoador = "", this.telDoador = "", this.endDoador = ""})
      : super(nomeM1: "Nome", logradouro: "Rua", endereco: "", numero: "0");

  Stream<DoadorAssistido> get doadorStream => _doadorController.stream;

  Assistido get assistido => this;

  bool insertDoadorFunc() {
    _doadorController.sink.add(this);
    return true;
  }

  @override
  void changeItens(String? itens, dynamic datas) {
    if (itens != null && datas != null) {
      switch (itens) {
        case 'nomeDoador':
          nomeDoador = datas;
          break;
        case 'telDoador':
          telDoador = datas;
          break;
        case 'endDoador':
          endDoador = datas;
          break;
        default:
          super.changeItens(itens, datas);
          break;
      }
    }
  }

  void copy(DoadorAssistido? assistido) {
    if (assistido != null) {
      ident = assistido.ident;
      updatedApps = assistido.updatedApps;
      nomeM1 = assistido.nomeM1;
      photoName = assistido.photoName;
      condicao = assistido.condicao;
      dataNascM1 = assistido.dataNascM1;
      estadoCivil = assistido.estadoCivil;
      fone = assistido.fone;
      rg = assistido.rg;
      cpf = assistido.cpf;
      logradouro = assistido.logradouro;
      endereco = assistido.endereco;
      numero = assistido.numero;
      bairro = assistido.bairro;
      complemento = assistido.complemento;
      cep = assistido.cep;
      obs = assistido.obs;
      chamada = assistido.chamada;
      parentescos = assistido.parentescos;
      nomesMoradores = assistido.nomesMoradores;
      datasNasc = assistido.datasNasc;
      nomeDoador = assistido.nomeDoador;
      telDoador = assistido.telDoador;
      endDoador = assistido.endDoador;
      _doadorController.sink.add(this);
    }
  }

  factory DoadorAssistido.fromList(List<dynamic> value1,
      {List<dynamic>? value2}) {
    return DoadorAssistido(Assistido.fromList(value1),
        nomeDoador: value2?[1], telDoador: value2?[2], endDoador: value2?[3]);
  }
}
