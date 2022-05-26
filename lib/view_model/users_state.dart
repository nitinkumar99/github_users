import 'package:equatable/equatable.dart';
import 'package:github_users/model/user_model.dart';

abstract class UsersState extends Equatable {}

class InitialState extends UsersState {
  @override
  List<Object> get props => [];
}

class LoadingState extends UsersState {
  LoadingState(this.oldUsers, this.oldSelectedUsers,
      {this.isFirstFetch = false, this.isAddingRemovingUser = false});

  final List<UserModel> oldUsers;
  final List<UserModel> oldSelectedUsers;
  final bool isFirstFetch;
  final bool isAddingRemovingUser;

  @override
  List<Object> get props =>
      [oldUsers, oldSelectedUsers, isFirstFetch, isAddingRemovingUser];
}

class LoadedState extends UsersState {
  LoadedState(this.users, this.selectedUsers);

  final List<UserModel> users;
  final List<UserModel> selectedUsers;

  @override
  List<Object> get props => [users, selectedUsers];
}

class ErrorState extends UsersState {
  @override
  List<Object> get props => [];
}
