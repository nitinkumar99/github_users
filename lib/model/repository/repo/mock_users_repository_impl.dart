import 'package:github_users/model/user_model.dart';

import '../base_repository.dart';
import 'users_repository.dart';

/// This class is used for unit testing, for mocking data
class MockUsersRepositoryImpl extends UsersRepository {
  final limit = 15;

  @override
  Future<RepositoryResult<List<UserModel>>> fetchUsers(int page) async {
    return RepositoryResult([], RepositoryResultSource.server);
  }

  @override
  Future<RepositoryResult<List<UserModel>>> fetchLocalUsers() async {
    return RepositoryResult([], RepositoryResultSource.cached);
  }

  @override
  Future<RepositoryResult<bool>> setLocalUsers(List<UserModel> users) async {
    return RepositoryResult(true, RepositoryResultSource.cached);
  }

  @override
  Future<RepositoryResult<bool>> clearLocalData() async {
    return RepositoryResult(true, RepositoryResultSource.cached);
  }
}
