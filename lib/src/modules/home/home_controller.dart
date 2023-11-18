import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'repositories/assistido_gsheet_repository.dart';

class HomeController {
  final ValueNotifier<String> activeTagButtom =
      ValueNotifier<String>('Bezerra de Menezes');
  final ValueNotifier<bool> isExpanded = ValueNotifier<bool>(false);      
  late final AssistidoRemoteStorageRepository assistidosStoreList;


  HomeController({AssistidoRemoteStorageRepository? assistidosStoreList}) {
    this.assistidosStoreList =
        assistidosStoreList ?? Modular.get<AssistidoRemoteStorageRepository>();
  }

  Future<bool> init() async {
    await assistidosStoreList.init();
    return true;
  }
}
