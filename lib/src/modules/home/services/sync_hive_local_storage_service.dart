import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import '../interfaces/sync_local_storage_interface.dart';
import '../models/sync_models.dart';

//implements == interface
class SyncLocalStorageService implements SyncLocalStorageInterface {
  Completer<Box<SyncType>> completerSync = Completer<Box<SyncType>>();

  @override
  Future<void> init() async {
    if (!Hive.isBoxOpen('syncDatas')) {
      Hive.registerAdapter(SyncTypeAdapter());
    }
    if (!completerSync.isCompleted) {
      completerSync.complete(await Hive.openBox<SyncType>('syncDatas'));
    }
  }

  @override
  Future<int> length() async {
    final box = await completerSync.future;
    return (box.length);
  }

  @override
  Future<bool> addSync(String synckey, dynamic syncValue) async {
    try {
      final box = await completerSync.future;
      box.add(SyncType(synckey: synckey, syncValue: syncValue));
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<SyncType?> getSync(int index) async {
    final box = await completerSync.future;
    return (box.getAt(index));
  }

  @override
  Future<bool> delSync(int index) async {
    try {
      final box = await completerSync.future;
      box.deleteAt(index);
      return true;
    } catch (e) {
      return false;
    }
  }
}
