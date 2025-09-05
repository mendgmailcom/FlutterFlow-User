import 'package:get_it/get_it.dart';
import '../../custom_code/repositories/index.dart';
import '../../custom_code/models/app_state.dart';

final getIt = GetIt.instance;

class ServiceLocator {
  static Future<void> setup() async {
    // Register repositories
    getIt.registerLazySingleton(() => ServiceRepository());
    getIt.registerLazySingleton(() => BookingRepository());
    getIt.registerLazySingleton(() => UserRepository());
    getIt.registerLazySingleton(() => ProviderRepository());
    getIt.registerLazySingleton(() => ChatRepository());
    getIt.registerLazySingleton(() => WalletRepository());

    // Register state managers
    getIt.registerLazySingleton(() => AppState());
  }

  // Repository getters
  static ServiceRepository get serviceRepository => getIt<ServiceRepository>();
  static BookingRepository get bookingRepository => getIt<BookingRepository>();
  static UserRepository get userRepository => getIt<UserRepository>();
  static ProviderRepository get providerRepository =>
      getIt<ProviderRepository>();
  static ChatRepository get chatRepository => getIt<ChatRepository>();
  static WalletRepository get walletRepository => getIt<WalletRepository>();

  // State manager getter
  static AppState get appState => getIt<AppState>();
}
