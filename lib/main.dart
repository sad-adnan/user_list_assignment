import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/di/service_locator.dart';
import 'core/theme/app_theme.dart';
import 'data/models/user_model.dart';
import 'routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(UserAdapter());
  }
  await setupLocator();
  runApp(
    const ProviderScope(
      child: UserListAssignmentApp(),
    ),
  );
}

class UserListAssignmentApp extends StatelessWidget {
  const UserListAssignmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User List Assignment',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.userList,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
