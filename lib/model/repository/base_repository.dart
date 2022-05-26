import 'package:get_it/get_it.dart';
import 'package:github_users/model/network/api_client.dart';
import 'package:github_users/model/preference/app_preferences.dart';

abstract class BaseRepository {
  final ApiClient apiClient = GetIt.I.get<ApiClient>();
  final AppPreferences appPreferences = GetIt.I.get<AppPreferences>();
}

enum RepositoryResultSource { server, cached }

class RepositoryResult<T> {
  final T data;
  final RepositoryResultSource source;

  RepositoryResult(this.data, this.source);
}
