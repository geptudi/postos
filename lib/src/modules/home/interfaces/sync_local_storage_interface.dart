import '../models/sync_models.dart';

abstract class SyncLocalStorageInterface {
  Future<void> init();
  Future<int> length();
  Future<bool> addSync(String key, dynamic syncValue); //Adiciona varias linhas
  Future<SyncType?> getSync(int index); //Adiciona varias linhas
  Future<bool> delSync(int index);
}
