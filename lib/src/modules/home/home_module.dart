import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'home_controller.dart';
import 'home_page.dart';
import 'repositories/assistido_gsheet_repository.dart';

class HomeModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance<HomeController>(HomeController(
        assistidosStoreList:
            AssistidoRemoteStorageRepository(provider: Dio())));
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => const HomePage());
  }
}
