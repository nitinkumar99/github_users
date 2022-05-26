import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:github_users/model/repository/repo/users_repository.dart';
import 'package:github_users/model/user_model.dart';
import 'package:github_users/view_model/users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  List<UserModel> users = [];
  List<UserModel> selectedUsers = [];
  int page = 1;

  late UsersRepository repository;

  UsersCubit({UsersRepository? usersRepository}) : super(InitialState()) {
    repository = usersRepository ?? GetIt.I.get<UsersRepository>();
  }

  // fetch from cloud
  void getUsers() async {
    try {
      if (state is LoadingState) return;

      emit(LoadingState(this.users, selectedUsers, isFirstFetch: page == 1));
      final users = await repository.fetchUsers(page);
      this.users.addAll(users.data);
      if (page == 1) {
        // only need to get this first time, rest it will be updated when user changes it.
        await getUsersFromStorage();
      }
      // for setting selected user in all user list
      if (selectedUsers.isNotEmpty) {
        for (var element in this.users) {
          if (selectedUsers.contains(element)) {
            element.isSelected = true;
          }
        }
      }
      page++;
      emit(LoadedState(this.users, selectedUsers));
    } catch (e) {
      emit(ErrorState());
    }
  }

  // fetch locally using shared preference
  void getSelectedUsers() async {
    try {
      if (selectedUsers.isNotEmpty) {
        emit(LoadedState(users, selectedUsers));
      } else {
        emit(LoadingState(users, selectedUsers));
        await getUsersFromStorage();
        emit(LoadedState(users, selectedUsers));
      }
    } catch (e) {
      emit(ErrorState());
    }
  }

  // add user locally
  void addRemoveUser(UserModel user) async {
    try {
      emit(LoadingState(users, selectedUsers, isAddingRemovingUser: true));
      if (selectedUsers.contains(user)) {
        selectedUsers.remove(user);
        var data = users.firstWhereOrNull((element) => element.id == user.id);
        if (data != null) {
          data.isSelected = false;
        }
      } else {
        selectedUsers.add(user);
        var data = users.firstWhereOrNull((element) => element.id == user.id);
        if (data != null) {
          data.isSelected = true;
        }
      }
      // is updated can be used to show if entry is successfully inserted.
      final isUpdated = await repository.setLocalUsers(selectedUsers);
      emit(LoadedState(users, selectedUsers));
    } catch (e) {
      emit(ErrorState());
    }
  }

  void deleteAll() async {
    try {
      emit(LoadingState(users, selectedUsers, isAddingRemovingUser: true));
      selectedUsers.clear();
      for (var element in users) {
        element.isSelected = false;
      }
      // is updated can be used to show if all entries are deleted.
      final isUpdated = await repository.clearLocalData();
      emit(LoadedState(users, selectedUsers));
    } catch (e) {
      emit(ErrorState());
    }
  }

  Future getUsersFromStorage() async {
    final selectedUsers = await repository.fetchLocalUsers();
    this.selectedUsers.addAll(selectedUsers.data);
  }

  /// This method used when all user screen is opened and to avoid hitting api when tab is switching, [users.isEmpty] check is added.
  void checkAndGetUsers() {
    if (users.isEmpty) {
      getUsers();
    }
  }
}
