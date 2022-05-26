import 'package:github_users/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static AppPreferences? _appPreferences;
  static late SharedPreferences _sharedPreferences;

  final String usersList = "users_list";

  AppPreferences._();

  static Future<AppPreferences> getInstance() async {
    if (_appPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
      _appPreferences = AppPreferences._();
    }
    return _appPreferences!;
  }

  Future reload() => _sharedPreferences.reload();

  Future<bool> clear() {
    return _sharedPreferences.clear();
  }

  Future<bool> setUsers(List<UserModel> users) async {
    // Encode and store data in SharedPreferences
    final String encodedData = UserModel.encode(users);

    return await _sharedPreferences.setString(usersList, encodedData);
  }

  Future<List<UserModel>> getUsers() async {
    // Fetch and decode data
    final String? users = _sharedPreferences.getString(usersList);
    final List<UserModel> userList =
        users != null ? UserModel.decode(users) : [];
    return userList;
  }
}
