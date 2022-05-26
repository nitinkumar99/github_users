import 'package:github_users/model/repository/base_repository.dart';
import 'package:github_users/model/user_model.dart';

abstract class UsersRepository extends BaseRepository {
  Future<RepositoryResult<List<UserModel>>> fetchUsers(int page);

  Future<RepositoryResult<List<UserModel>>> fetchLocalUsers();

  Future<RepositoryResult<bool>> setLocalUsers(List<UserModel> users);

  Future<RepositoryResult<bool>> clearLocalData();
}
