import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:video_player/video_player.dart';
import 'repositories/assistido_gsheet_repository.dart';

class HomeController {
  final doadorCount = ValueNotifier<int>(0);  
  final answer = ValueNotifier<List<String>>([]);  
  final answerAux = ValueNotifier<List<ValueNotifier<String>>>([]);  
  final ValueNotifier<String> activeTagButtom = ValueNotifier<String>('');
  final ValueNotifier<bool> isExpanded = ValueNotifier<bool>(false);      
  late final AssistidoRemoteStorageRepository assistidosStoreList;
  final videoController = VideoPlayerController.asset('assets/cestasnatal.mp4');
  bool showControls = true;
  bool wasPlaying = false;
  bool isFullScreem = false;
  bool isChange = false;


  HomeController({AssistidoRemoteStorageRepository? assistidosStoreList}) {
    this.assistidosStoreList =
        assistidosStoreList ?? Modular.get<AssistidoRemoteStorageRepository>();
  }

  Future<bool> init() async {
    await assistidosStoreList.init();
    return true;
  }
}
