import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rx_notifier/rx_notifier.dart';

import 'stores/assistidos_store.dart';

class HomeController {
  final ValueNotifier<String> activeTagButtom = ValueNotifier<String>('Bezerra de Menezes');
  late final AssistidosStoreList assistidosStoreList;  
  final isInitedController = RxNotifier<bool>(false);  
  
  HomeController({AssistidosStoreList? assistidosStoreList}) {
    this.assistidosStoreList =
        assistidosStoreList ?? Modular.get<AssistidosStoreList>();
    assistidosStoreList?.atualiza = () => isInitedController.value = true;
    assistidosStoreList?.desatualiza = () => isInitedController.value = false;
  } 

  Future<bool> init() async {
    await assistidosStoreList.init();
    assistidosStoreList.sync();
    return true;
  }
}
