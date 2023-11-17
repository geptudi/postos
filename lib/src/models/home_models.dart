Map<String, dynamic> map00 = {
  'id': 1,
  'title': 'Ativos',
  'img': 'assets/images/tela1.jpg',
  'active': 1
};

Map<String, dynamic> map01 = {
  'id': 2,
  'title': 'Inativos',
  'img': 'assets/images/tela4.jpg',
  'active': 0
};

Map<String, dynamic> map02 = {
  'id': 3,
  'title': 'Todos',
  'img': 'assets/images/tela3.jpg',
  'active': 0
};

List<Map<String, dynamic>> telaAssistidos = [map00, map01, map02];

Map<String, dynamic> map10 = {
  'id': 1,
  'title': 'Chamada',
  'img': 'assets/images/tela2.jpg',
  'active': 1
};
Map<String, dynamic> map11 = {
  'id': 2,
  'title': 'Cadastros',
  'img': 'assets/images/tela2.jpg',
  'active': 0
};

List<Map<String, dynamic>> telaColaboradores = [map10, map11];

Map<String, List<Map<String, dynamic>>> mapTelas = {
  'Assistidos': telaAssistidos,
  'Colaboradores': telaColaboradores
};
