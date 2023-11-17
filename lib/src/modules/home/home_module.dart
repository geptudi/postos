import 'package:flutter_modular/flutter_modular.dart';
import 'home_controller.dart';
import 'home_page.dart';
import 'interfaces/assistido_config_local_storage_interface.dart';
import 'interfaces/assistido_local_storage_interface.dart';
import 'interfaces/asssistido_remote_storage_interface.dart';
import 'interfaces/provider_interface.dart';
import 'interfaces/sync_local_storage_interface.dart';
import 'repositories/assistido_gsheet_repository.dart';
import 'services/assistido_config_hive_local_storage_service.dart';
import 'services/assistido_hive_local_storage_service.dart';
import 'services/sync_hive_local_storage_service.dart';
import 'stores/assistidos_store.dart';

class HomeModule extends Module {
  @override
  void binds(i) {
    i.addSingleton<ProviderInterface>(ProviderInterface.new);
    i.addSingleton<AssistidoConfigLocalStorageInterface>(
        AssistidoConfigLocalStorageService.new);
    i.addSingleton<AssistidoLocalStorageInterface>(
        AssistidoLocalStorageService.new);
    i.addSingleton<AssistidoRemoteStorageInterface>(
        AssistidoRemoteStorageRepository.new);
    i.addSingleton<SyncLocalStorageInterface>(SyncLocalStorageService.new);
    i.addSingleton<AssistidosStoreList>((i) => AssistidosStoreList.new);
    i.addSingleton<HomeController>(HomeController.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => const HomePage());
  }
}
