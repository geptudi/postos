abstract class AssistidoConfigLocalStorageInterface {
  Future<void> init();
  Future<bool> addConfig(
      String ident, List<String>? values); //Adiciona varias linhas
  Future<List<String>?> getConfig(String ident); //Retorna o valor das linhas
  Future<void> delConfig(String ident); //Deleta um Linha
  Stream watch(String key);
}
