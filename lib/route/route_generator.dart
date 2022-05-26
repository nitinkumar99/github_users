import 'package:flutter/material.dart';
import 'package:github_users/view/screens/home_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeScreen.routeName:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        debugPrint('Navigating to ${settings.name}');
        return buildErrorRoute();
    }
  }

  static Route<dynamic> buildErrorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Arggg!'),
          ),
          body: Center(
            child: Text('Oh No! You should not be here! '),
          ),
        );
      },
    );
  }
}
