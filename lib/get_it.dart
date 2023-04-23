import 'package:get_it/get_it.dart';
import 'package:invite_system_poc/src/services/notification_service.dart';

final GetIt getIt = GetIt.instance;

setupDependencies() {
  getIt.registerSingleton(NotificationService());
}
