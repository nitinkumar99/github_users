import 'package:flutter/material.dart';
import 'package:github_users/view/screens/all_users_screen.dart';
import 'package:github_users/view/screens/selected_users_screen.dart';
import 'package:github_users/view_model/users_cubit.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  UsersCubit? usersCubit;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Github users'),
          bottom: const TabBar(
            tabs: [Tab(text: "All Users"), Tab(text: "Selected Users")],
          ),
        ),
        body: const TabBarView(
          children: [
            AllUsersScreen(),
            SelectedUsersScreen(),
          ],
        ),
      ),
    );
  }
}
