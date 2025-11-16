import 'package:flutter/material.dart';

import 'data/models/user_model.dart';
import 'features/user_detail/ui/screens/user_detail_screen.dart';
import 'features/user_list/ui/screens/user_list_screen.dart';

class AppRoutes {
  static const String userList = '/';
  static const String userDetail = '/detail';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.userDetail:
        final args = settings.arguments;
        if (args is! User) {
          return _errorRoute('User details unavailable', settings);
        }
        return MaterialPageRoute(
          builder: (_) => UserDetailScreen(user: args),
          settings: settings,
        );
      case AppRoutes.userList:
      default:
        return MaterialPageRoute(
          builder: (_) => const UserListScreen(),
          settings: settings,
        );
    }
  }

  static Route<dynamic> _errorRoute(String message, RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Navigation Error')),
        body: Center(child: Text(message)),
      ),
      settings: settings,
    );
  }
}
