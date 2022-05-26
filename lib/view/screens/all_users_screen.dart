import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_users/view/widgets/user_item.dart';
import 'package:github_users/view_model/users_cubit.dart';
import 'package:github_users/view_model/users_state.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AllUsersScreenState();
  }
}

class AllUsersScreenState extends State<AllUsersScreen> {
  UsersCubit? usersCubit;

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      usersCubit = BlocProvider.of<UsersCubit>(context, listen: false);
      usersCubit?.checkAndGetUsers();
    });
    setUpScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersCubit, UsersState>(
      builder: (context, state) {
        if (state is LoadingState && state.isFirstFetch) {
          return loadingIndicator;
        } else if (state is ErrorState) {
          return const Center(
            child: Text("Unable to load data"),
          );
        }

        var users = [];
        bool isLoading = false;
        bool isAddingUserInLocal = false;

        if (state is LoadingState) {
          users = state.oldUsers;
          if (state.isAddingRemovingUser) {
            isAddingUserInLocal = true;
          } else {
            isLoading = true;
          }
        } else if (state is LoadedState) {
          users = state.users;
        }

        return Stack(
          children: [
            ListView.builder(
              controller: scrollController,
              itemCount: users.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < users.length) {
                  return Card(
                      child: UserItem(users[index], () {
                    usersCubit?.addRemoveUser(users[index]);
                  }));
                } else {
                  Timer(const Duration(milliseconds: 30), () {
                    scrollController
                        .jumpTo(scrollController.position.maxScrollExtent);
                  });
                  return loadingIndicator;
                }
              },
            ),
            if (isAddingUserInLocal) loadingIndicator,
          ],
        );
      },
    );
  }

  Widget get loadingIndicator => const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );

  void setUpScrollController() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.maxScrollExtent != 0) {
          usersCubit?.getUsers();
        }
      }
    });
  }
}
