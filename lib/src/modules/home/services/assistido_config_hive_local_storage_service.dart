import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import '../interfaces/assistido_config_local_storage_interface.dart';

//implements == interface
class AssistidoConfigLocalStorageService
    implements AssistidoConfigLocalStorageInterface {
  Completer<Box<List<String>>> configCompleter = Completer<Box<List<String>>>();

  @override
  Future<void> init() async {
    if (!configCompleter.isCompleted) {
      configCompleter.complete(await Hive.openBox<List<String>>('configDatas'));
    }
  }

  @override
  Stream<BoxEvent> watch(String key) async* {
    final box = await configCompleter.future;
    yield* box.watch(key: key);
  }

  @override
  Future<bool> addConfig(String ident, List<String>? values) async {
    final box = await configCompleter.future;
    if (values != null) {
      await box.put(ident, values);
      return true;
    }
    return false;
  }

  @override
  Future<void> delConfig(String ident) async {
    final box = await configCompleter.future;
    await box.delete(ident);
  }

  @override
  Future<List<String>?> getConfig(String ident) async {
    final box = await configCompleter.future;
    return box.get(ident);
  }
}
