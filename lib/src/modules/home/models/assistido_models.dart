class Assistido {
  int ident;
  String updatedApps;
  String photoName;
  String nomeM1;
  String condicao;
  String dataNascM1;
  String estadoCivil;
  dynamic fone;
  dynamic rg;
  dynamic cpf;
  String logradouro;
  String endereco;
  dynamic numero;
  String bairro;
  String complemento;
  dynamic cep;
  String obs;
  String chamada;
  String parentescos;
  String nomesMoradores;
  String datasNasc;
  bool isExpanded;

  Assistido({
    this.ident = -1,
    this.updatedApps = "",
    required this.nomeM1,
    this.photoName = "",
    this.condicao = "ATIVO",
    this.dataNascM1 = "",
    this.estadoCivil = "Não declarado(a)",
    this.fone = "",
    this.rg = "",
    this.cpf = "",
    required this.logradouro,
    required this.endereco,
    required this.numero,
    this.bairro = "Morada Nova",
    this.complemento = "",
    this.cep = "",
    this.obs = "",
    this.chamada = "",
    this.parentescos = "",
    this.nomesMoradores = "",
    this.datasNasc = "",
    this.isExpanded = false,
  });

  Assistido.assistido(Assistido assistido)
      : ident = assistido.ident,
        updatedApps = assistido.updatedApps,
        nomeM1 = assistido.nomeM1,
        photoName = assistido.photoName,
        condicao = assistido.condicao,
        dataNascM1 = assistido.dataNascM1,
        estadoCivil = assistido.estadoCivil,
        fone = assistido.fone,
        rg = assistido.rg,
        cpf = assistido.cpf,
        logradouro = assistido.logradouro,
        endereco = assistido.endereco,
        numero = assistido.numero,
        bairro = assistido.bairro,
        complemento = assistido.complemento,
        cep = assistido.cep,
        obs = assistido.obs,
        chamada = assistido.chamada,
        parentescos = assistido.parentescos,
        nomesMoradores = assistido.nomesMoradores,
        datasNasc = assistido.datasNasc,
        isExpanded = assistido.isExpanded;

  factory Assistido.fromList(List<dynamic> value) {
    return Assistido(
      ident: value[0] as int,
      updatedApps: value[1],
      photoName: value[2].toString(),
      nomeM1: value[3].toString(),
      condicao: value[4].toString(),
      dataNascM1: value[5].toString(),
      estadoCivil: value[6].toString(),
      fone: value[7].toString(),
      rg: value[8].toString(),
      cpf: value[9].toString(),
      logradouro: value[10],
      endereco: value[11].toString(),
      numero: value[12].toString(),
      bairro: value[13].toString(),
      complemento: value[14],
      cep: value[15].toString(),
      obs: value[16].toString(),
      chamada: value[17].toString(),
      parentescos: value[18].toString(),
      nomesMoradores: value[19].toString(),
      datasNasc: value[20].toString(),
      isExpanded: false,
    );
  }

  void changeItens(String? itens, dynamic datas) {
    if (itens != null && datas != null) {
      switch (itens) {
        case 'key':
          ident = datas;
          break;
        case 'Updated Apps':
          updatedApps = datas;
          break;
        case 'Morador01':
          nomeM1 = datas;
          break;
        case 'Foto':
          photoName = datas;
          break;
        case 'Condição':
          condicao = datas;
          break;
        case 'Data de Nasc':
          dataNascM1 = datas;
          break;
        case 'Estado Civil':
          estadoCivil = datas;
          break;
        case 'Telefone':
          fone = datas;
          break;
        case 'RG':
          rg = datas;
          break;
        case 'CPF':
          cpf = datas;
          break;
        case 'Logradouro':
          logradouro = datas;
          break;
        case 'Endereço':
          endereco = datas;
          break;
        case 'Nº':
          numero = datas;
          break;
        case 'Bairro':
          bairro = datas;
          break;
        case 'Complemento':
          complemento = datas;
          break;
        case 'CEP':
          cep = datas;
          break;
        case 'Obs.:':
          obs = datas;
          break;
        case 'Chamada':
          chamada = datas;
          break;
        case 'Parentescos':
          parentescos = datas;
          break;
        case 'Nomes do Moradores':
          nomesMoradores = datas;
          break;
        case 'Datas Nasc':
          datasNasc = datas;
          break;
      }
    }
  }

  List<dynamic> toList() {
    return [
      photoName,
      nomeM1,
      condicao,
      dataNascM1,
      estadoCivil,
      fone,
      rg,
      cpf,
      logradouro,
      endereco,
      numero,
      bairro,
      complemento,
      cep,
      obs,
      chamada,
      parentescos,
      nomesMoradores,
      datasNasc
    ];
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Assistido &&
        other.ident == ident &&
        other.updatedApps == updatedApps &&
        other.photoName == photoName &&
        other.nomeM1 == nomeM1 &&
        other.dataNascM1 == dataNascM1 &&
        other.estadoCivil == estadoCivil &&
        other.fone == fone &&
        other.rg == rg &&
        other.cpf == cpf &&
        other.logradouro == logradouro &&
        other.endereco == endereco &&
        other.numero == numero &&
        other.bairro == bairro &&
        other.complemento == complemento &&
        other.cep == cep &&
        other.obs == obs &&
        other.chamada == chamada &&
        other.parentescos == parentescos &&
        other.nomesMoradores == nomesMoradores &&
        other.datasNasc == datasNasc;
  }

  @override
  int get hashCode {
    return ident.hashCode ^
        updatedApps.hashCode ^
        photoName.hashCode ^
        nomeM1.hashCode ^
        dataNascM1.hashCode ^
        estadoCivil.hashCode ^
        fone.hashCode ^
        rg.hashCode ^
        cpf.hashCode ^
        logradouro.hashCode ^
        endereco.hashCode ^
        numero.hashCode ^
        bairro.hashCode ^
        complemento.hashCode ^
        cep.hashCode ^
        obs.hashCode ^
        chamada.hashCode ^
        parentescos.hashCode ^
        nomesMoradores.hashCode ^
        datasNasc.hashCode;
  }
}
