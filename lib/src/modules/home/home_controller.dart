import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'models/assistido_models.dart';
import 'repositories/assistido_gsheet_repository.dart';

class HomeController {
  final ValueNotifier<String> activeTagButtom =
      ValueNotifier<String>('Bezerra de Menezes');
  late final AssistidoRemoteStorageRepository assistidosStoreList;
  final StreamController<List<Assistido>> _assistidoListStream =
      StreamController<List<Assistido>>.broadcast();

  Stream<List<Assistido>> get stream => _assistidoListStream.stream;  

  HomeController({AssistidoRemoteStorageRepository? assistidosStoreList}) {
    this.assistidosStoreList =
        assistidosStoreList ?? Modular.get<AssistidoRemoteStorageRepository>();
  }

  Future<bool> sync() async {
    await assistidosStoreList.init();
    List<dynamic>? response = await assistidosStoreList.getChanges(table: activeTagButtom.value);
        if (response != null) {
        if (response.isNotEmpty) {
        _assistidoListStream.sink.add(response.map((e) => Assistido.fromList(e)).toList());
      }
    }
    return true;
  }
}
