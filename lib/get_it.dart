import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:invite_system_poc/src/services/notification_service.dart';

final GetIt getIt = GetIt.instance;

setupDependencies() {
  getIt.registerSingleton(NotificationService());
  getIt.registerSingleton(
    Dio(
      BaseOptions(
        baseUrl: "https://fcm.googleapis.com/",
        contentType: "application/json",
      ),
    ),
  );
}
