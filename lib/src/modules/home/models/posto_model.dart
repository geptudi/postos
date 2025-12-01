class PostoModel {
  final String endereco;
  final String bairro;
  final String coordenador1;
  final String coordenador2;
  final String entrega;

  const PostoModel({
    required this.endereco,
    required this.bairro,
    required this.coordenador1,
    required this.coordenador2,
    required this.entrega,
  });

  factory PostoModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return const PostoModel(
        endereco: "",
        bairro: "",
        coordenador1: "",
        coordenador2: "",
        entrega: "",
      );
    }

    return PostoModel(
      endereco: map["endereco"] ?? "",
      bairro: map["bairro"] ?? "",
      coordenador1: map["coordenador1"] ?? "",
      coordenador2: map["coordenador2"] ?? "",
      entrega: map["entrega"] ?? "",
    );
  }
}
