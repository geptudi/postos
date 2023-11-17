import 'package:flutter_modular/flutter_modular.dart';
import 'home_controller.dart';
import 'home_page.dart';
import 'interfaces/asssistido_remote_storage_interface.dart';
import 'interfaces/provider_interface.dart';
import 'repositories/assistido_gsheet_repository.dart';


class HomeModule extends Module {
  @override
  void binds(i) {
    i.addSingleton<ProviderInterface>(ProviderInterface.new);
    i.addSingleton<AssistidoRemoteStorageInterface>(
        AssistidoRemoteStorageRepository.new);
    i.addSingleton<HomeController>(HomeController.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => const HomePage());
  }
}
