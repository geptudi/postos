import 'dart:typed_data';

abstract class AssistidoRemoteStorageInterface {
  Future<void> init();

  Future<int?> addData(List<dynamic>? value,
      {String table}); //Adiciona varias linhas no final da Base de Dados
  Future<String?> addFile(String targetDir, String fileName,
      Uint8List data); //Salva uma imagem na base de Dados

  Future<List<dynamic>?> getChanges(
      {String table}); //Lê todas as linhas apartir da primeira linha
  Future<List<dynamic>?> getRow(String rowId,
      {String table}); //Retorna o valor das linhas solicitadas
  Future<String?> getFile(String targetDir,
      String fileName); //Retorna as imagens da Base de Dados solicitadas

  Future<String?> setData(String rowsId, List<dynamic> data,
      {String table}); //Reescreve todas as linhas apartir da primeira linha
  Future<String?> setFile(String targetDir, String fileName,
      Uint8List data); //Retorna as imagens da Base de Dados solicitadas

  Future<dynamic> deleteData(String row, {String table}); //Deleta um Linha
  Future<dynamic> deleteFile(
      String targetDir, String fileName); //Deleta um item
}
