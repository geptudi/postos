import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'models/posto_model.dart';
import 'repositories/assistido_gsheet_repository.dart';

class HomeController {
  final ValueNotifier<bool> isExpanded = ValueNotifier<bool>(false);
  bool showControls = true;
  bool wasPlaying = false;
  bool isFullScreem = false;
  bool isChange = false;

  /// Contador de doadores exibido na UI
  final doadorCount = ValueNotifier<int>(0);

  /// Respostas do questionário (TemplatePage)
  final answer = ValueNotifier<List<String>>([]);

  /// Lista auxiliar usada nos campos de seleção dinâmica
  final answerAux = ValueNotifier<List<ValueNotifier<String>>>([]);

  /// Posto selecionado pelo usuário
  final activeTagButtom = ValueNotifier<String>("");

  /// Lista segura de postos carregada do JSON
  late Map<String, PostoModel> postos = {};

  /// Repositório do Google Sheets
  late final AssistidoRemoteStorageRepository assistidosStoreList;

  HomeController({AssistidoRemoteStorageRepository? assistidosStoreList}) {
    this.assistidosStoreList =
        assistidosStoreList ?? Modular.get<AssistidoRemoteStorageRepository>();
  }

  /// Inicialização geral: carrega JSON e repositório remoto
  Future<bool> init() async {
    await loadPostos();
    await assistidosStoreList.init();
    return true;
  }

  /// Carrega o JSON de postos de forma segura e profissional
  Future<void> loadPostos() async {
    try {
      final jsonString = await rootBundle.loadString('web/postos.json');
      final data = json.decode(jsonString);

      postos = {
        for (final key in data.keys) key: PostoModel.fromMap(data[key]),
      };
    } catch (e) {
      postos = {}; // fallback seguro
    }
  }

  /// Recupera um posto específico de forma segura
  PostoModel getPosto(String key) {
    return postos[key] ??
        const PostoModel(
          endereco: "",
          bairro: "",
          coordenador1: "",
          coordenador2: "",
          entrega: "",
        );
  }

  /// Libera recursos
  void dispose() {
    doadorCount.dispose();
    answer.dispose();
    activeTagButtom.dispose();
    for (final v in answerAux.value) {
      v.dispose();
    }
  }
}
