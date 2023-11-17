import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';

import 'assistido_models.dart';

class StreamAssistido extends Assistido {
  Function(StreamAssistido value)? saveJustLocalExt;
  Function(StreamAssistido value)? saveJustRemoteExt;
  Function(StreamAssistido value)? deleteExt;
  final StreamController<StreamAssistido> _chamadaController =
      StreamController<StreamAssistido>.broadcast();
  final StreamController<Uint8List> _photoController =
      StreamController<Uint8List>.broadcast();
  bool isExpanded = false;
  StreamAssistido(Assistido assistido) : super.assistido(assistido);
  StreamAssistido.vazio()
      : super(nomeM1: "Nome", logradouro: "Rua", endereco: "", numero: "0");
  Stream<StreamAssistido> get chamadaStream => _chamadaController.stream;
  Stream<Uint8List> get photoStream => _photoController.stream;
  Assistido get assistido => this;

  bool insertChamadaFunc(dateSelected) {
    if (!(chamada.toLowerCase().contains(dateSelected))) {
      changeItens("Chamada", "$chamada$dateSelected,");
      save();
      return true;
    }
    return false;
  }

  int chamadaToogleFunc(dateSelected) {
    if (chamada.toLowerCase().contains(dateSelected)) {
      changeItens("Chamada", chamada.replaceAll("$dateSelected,", ""));
      save();
      return -1;
    } else {
      changeItens("Chamada", "$chamada$dateSelected,");
      save();
      return 1;
    }
  }

  @override
  Future<void> save() async {
    await saveJustLocal();
    await saveJustRemote();
  }

  Future<void> saveJustLocal() async {
    if (saveJustLocalExt != null) {
      saveJustLocalExt!(this); //Save no modo remoto
    } else {
      debugPrint("save Local Func - NULL");
    }
  }

  Future<void> saveJustRemote() async {
    if (saveJustRemoteExt != null) {
      saveJustRemoteExt!(this); //Save no modo remoto
    } else {
      debugPrint("save Remote Func - NULL");
    }
  }

  @override
  Future<void> delete() async {
    if (deleteExt != null) deleteExt!(this);
    super.delete();
  }

  @override
  void changeItens(String? itens, dynamic datas) {
    if (itens != null && datas != null) {
      switch (itens) {
        case 'Foto':
          photo = datas;
          break;
        case 'Chamada':
          chamada = datas;
          break;
        default:
          super.changeItens(itens, datas);
          break;
      }
    }
  }

  void copy(StreamAssistido? assistido) {
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
      photoIntList = assistido.photoIntList;
      fotoPoints = assistido.fotoPoints;
    }
    _chamadaController.sink.add(this);
    _photoController.sink.add(photoUint8List);
  }

  Uint8List get photoUint8List => Uint8List.fromList(super.photoIntList);
  set photoUint8List(Uint8List data) {
    super.photoIntList = data;
  }

  List<dynamic> get photo =>
      [super.photoName, photoUint8List, super.fotoPoints];
  set photo(List<dynamic> datas) {
    super.photoName = datas[0];
    photoUint8List = datas[1];
    super.fotoPoints = datas[2].cast<double>();
    _photoController.sink.add(datas[1]);
  }

  @override
  set chamada(String data) {
    super.chamada = data;
    _chamadaController.sink.add(this);
  }
}
