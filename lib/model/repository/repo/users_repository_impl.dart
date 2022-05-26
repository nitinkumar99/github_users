import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:github_users/model/user_model.dart';

import '../base_repository.dart';
import 'users_repository.dart';

class UsersRepositoryImpl extends UsersRepository {
  final limit = 15;

  @override
  Future<RepositoryResult<List<UserModel>>> fetchUsers(int page) async {
    final connectivity = await Connectivity().checkConnectivity();

    //Fetch from db
    if (connectivity == ConnectivityResult.none) {
      // fetch in case of offline mode
      //  return RepositoryResult(list, RepositoryResultSource.cached);
    }

    //Fetch from network
    final response =
        await apiClient.getUsers({'page': page, 'per_page': limit});

    final users =
        List<UserModel>.from(response.data.map((x) => UserModel.fromJson(x)));

    return RepositoryResult(users, RepositoryResultSource.server);
  }

  @override
  Future<RepositoryResult<List<UserModel>>> fetchLocalUsers() async {
    //Fetch from network
    final response = await appPreferences.getUsers();
    return RepositoryResult(response, RepositoryResultSource.cached);
  }

  @override
  Future<RepositoryResult<bool>> setLocalUsers(List<UserModel> users) async {
    //Fetch from network
    final response = await appPreferences.setUsers(users);
    return RepositoryResult(response, RepositoryResultSource.cached);
  }

  @override
  Future<RepositoryResult<bool>> clearLocalData() async {
    //Fetch from network
    final response = await appPreferences.clear();
    return RepositoryResult(response, RepositoryResultSource.cached);
  }
}
