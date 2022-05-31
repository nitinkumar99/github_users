import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_users/view/widgets/user_item.dart';
import 'package:github_users/view_model/users_cubit.dart';
import 'package:github_users/view_model/users_state.dart';

class SelectedUsersScreen extends StatefulWidget {
  const SelectedUsersScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SelectedUsersScreenState();
  }
}

class SelectedUsersScreenState extends State<SelectedUsersScreen> {
  UsersCubit? usersCubit;

  get getRemoveAllButton => FloatingActionButton(
        // isExtended: true,
    key: const Key('remove_all_button'),
        child: const Icon(Icons.delete),
        onPressed: () {
          usersCubit?.deleteAll();
        },
      );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      usersCubit = BlocProvider.of<UsersCubit>(context, listen: false);
      usersCubit?.getSelectedUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: getRemoveAllButton,
      body: BlocBuilder<UsersCubit, UsersState>(
        builder: (context, state) {
          if (state is LoadingState && state.isFirstFetch) {
            return loadingIndicator;
          } else if (state is ErrorState) {
            return const Center(
              child: Icon(Icons.close),
            );
          }

          var users = [];
          bool isAddingUserInLocal = false;

          if (state is LoadingState) {
            users = state.oldSelectedUsers;
            if (state.isAddingRemovingUser) {
              isAddingUserInLocal = true;
            }
          } else if (state is LoadedState) {
            users = state.selectedUsers;
          }

          return Stack(
            children: [
              ListView.builder(
                key: const Key('user_list'),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: UserItem(users[index], () {
                    usersCubit?.addRemoveUser(users[index]);
                  }));
                },
              ),
              if (isAddingUserInLocal) loadingIndicator,
            ],
          );
        },
      ),
    );
  }

  Widget get loadingIndicator => const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
}
