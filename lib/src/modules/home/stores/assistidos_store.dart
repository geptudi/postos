import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../interfaces/assistido_local_storage_interface.dart';
import '../interfaces/asssistido_remote_storage_interface.dart';
import '../interfaces/assistido_config_local_storage_interface.dart';
import '../interfaces/sync_local_storage_interface.dart';
import '../models/assistido_models.dart';
import '../models/stream_assistido_model.dart';

Map<String, String> _caracterMap = {
  "â": "a",
  "à": "a",
  "á": "a",
  "ã": "a",
  "ê": "e",
  "è": "e",
  "é": "e",
  "î": "i",
  "ì": "i",
  "í": "i",
  "õ": "o",
  "ô": "o",
  "ò": "o",
  "ó": "o",
  "ü": "u",
  "û": "u",
  "ú": "u",
  "ù": "u",
  "ç": "c"
};

class AssistidosStoreList {
  late final AssistidoLocalStorageInterface _localStore;
  late final AssistidoRemoteStorageInterface _remoteStore;
  late final AssistidoConfigLocalStorageInterface _configStore;
  late final SyncLocalStorageInterface _syncStore;
  AssistidosStoreList(
      {SyncLocalStorageInterface? syncStore,
      AssistidoLocalStorageInterface? localStore,
      AssistidoConfigLocalStorageInterface? configStore,
      AssistidoRemoteStorageInterface? remoteStore}) {
    _syncStore = syncStore ?? Modular.get<SyncLocalStorageInterface>();
    _localStore = localStore ?? Modular.get<AssistidoLocalStorageInterface>();
    _configStore =
        configStore ?? Modular.get<AssistidoConfigLocalStorageInterface>();
    _remoteStore =
        remoteStore ?? Modular.get<AssistidoRemoteStorageInterface>();
  }

  void Function()? atualiza;
  void Function()? desatualiza;
  final countSync = RxNotifier<int>(0);
  bool isRunningSync = false;

  static int _countConnection = 0;

  final _assistidoList = [].cast<StreamAssistido>();
  final StreamController<List<StreamAssistido>> _assistidoListStream =
      StreamController<List<StreamAssistido>>.broadcast();
  Stream<List<StreamAssistido>> get stream => _assistidoListStream.stream;

  late final Stream<BoxEvent> dateSelectedController;
  late final Stream<BoxEvent> itensListController;

  Future<void> init() async {
    await _localStore.init();
    await _configStore.init();
    dateSelectedController = _configStore
        .watch("dateSelected")
        .asBroadcastStream() as Stream<BoxEvent>;
    itensListController =
        _configStore.watch("itensList").asBroadcastStream() as Stream<BoxEvent>;
    await _remoteStore.init();
    await _syncStore.init();
    _assistidoList.addAll(
      (await _localStore.getAll()).map(
        (element) => StreamAssistido(element)
          ..saveJustLocalExt = addSaveJustLocal
          ..saveJustRemoteExt = addSaveJustRemote
          ..deleteExt = delete,
      ),
    );
    sync();
    _assistidoListStream.sink.add(_assistidoList);
  }

  Future<void> sync() async {
    if (isRunningSync == false) {
      isRunningSync = true;
      countSync.value = await _syncStore.length();
      while ((await _syncStore.length()) > 0) {
        while (_countConnection >= 10) {
          await Future.delayed(const Duration(
              milliseconds: 500)); //so faz 10 requisições por vez.
        }
        _countConnection++;
        dynamic status;
        var sync = await _syncStore.getSync(0);
        await _syncStore.delSync(0);
        if (sync != null) {
          if (sync.synckey == 'add') {
            status = await _remoteStore
                .addData((sync.syncValue as StreamAssistido).toList());
          }
          if (sync.synckey == 'set') {
            status = await _remoteStore.setData(
                (sync.syncValue as StreamAssistido).ident.toString(),
                (sync.syncValue as StreamAssistido).toList());
          }
          if (sync.synckey == 'del') {
            status = await _remoteStore.deleteData((sync.syncValue as String));
          }
          if (sync.synckey == 'addImage') {
            status = await _remoteStore.addFile(
                'BDados_Images',
                (sync.syncValue[0] as String),
                (sync.syncValue[1] as Uint8List));
          }
          if (sync.synckey == 'setImage') {
            status = await _remoteStore.setFile(
                'BDados_Images',
                (sync.syncValue[0] as String),
                (sync.syncValue[1] as Uint8List));
          }
          if (sync.synckey == 'delImage') {
            status =
                await _remoteStore.deleteFile('BDados_Images', sync.syncValue);
          }
          if (status != null) {
            countSync.value = await _syncStore.length();
            _countConnection--;
          } else {
            await _syncStore.addSync(sync.synckey, sync.syncValue);
            break;
          }
        }
      }
      var remoteConfigChanges = await _remoteStore.getChanges(table: "Config");
      if (remoteConfigChanges != null && remoteConfigChanges.isNotEmpty) {
        for (List e in remoteConfigChanges) {
          e.removeWhere((element) => element == "");
          _configStore.addConfig(e[0], e.sublist(1).cast<String>());
        }
      }
      var remoteDataChanges = await _remoteStore.getChanges();
      if (remoteDataChanges != null) {
        final keys = await _localStore.getKeys();
        for (var e in remoteDataChanges) {
          addSaveJustLocal(StreamAssistido(Assistido.fromList(e)),
              isAdd: (keys.contains(e[0])) ? false : true);
        }
      }
      isRunningSync = false;
    }
    if (desatualiza != null) desatualiza!();
    if (atualiza != null) atualiza!();
  }

  List<StreamAssistido> search(
      List<StreamAssistido> assistidoList, termosDeBusca, String condicao) {
    return assistidoList
        .where((assistido) =>
            // ignore: prefer_interpolation_to_compose_strings
            assistido.condicao.contains(RegExp(r"^(" + condicao + ")")))
        .where((assistido) => assistido.nomeM1
            .toLowerCase()
            .replaceAllMapped(
                RegExp(r'[\W\[\] ]'),
                (Match a) => _caracterMap.containsKey(a[0])
                    ? _caracterMap[a[0]]!
                    : a[0]!)
            .contains(termosDeBusca.toLowerCase()))
        .toList();
  }

  Future<StreamAssistido?> getRow(int rowId) async {
    var resp = await _localStore.getRow(rowId);
    return resp != null ? StreamAssistido(resp) : null;
  }

  Future<String?> add(StreamAssistido stAssist) async {
    addSaveJustRemote(stAssist, isAdd: true);
    return addSaveJustLocal(stAssist, isAdd: true);
  }

  Future<bool> addSaveJustRemote(StreamAssistido stAssist,
      {bool isAdd = false}) async {
    _syncStore.addSync(isAdd ? 'add' : 'set', stAssist).then((_) => sync());
    return true;
  }

  Future<String?> addSaveJustLocal(StreamAssistido stAssist,
      {bool isAdd = false}) async {
    if (isAdd) {
      stAssist
        ..saveJustLocalExt = addSaveJustLocal
        ..saveJustRemoteExt = addSaveJustRemote
        ..deleteExt = delete;
    }
    return _localStore.setRow(stAssist)
      ..then(
        (value) async {
          if (isAdd) {
            _assistidoListStream.sink.add(_assistidoList..add(stAssist));
          }
        },
      );
  }

  Future<bool> deleteAll() async {
    if (await _localStore.delAll()) {
      return true;
    }
    return false;
  }

  Future<bool> delete(StreamAssistido stAssist) async {
    final rowId = stAssist.ident.toString();
    _syncStore.addSync('del', rowId).then((_) => sync());
    if (await _localStore.delRow(rowId)) {
      return true;
    }
    return false;
  }
}