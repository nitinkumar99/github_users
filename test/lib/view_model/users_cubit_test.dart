import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:github_users/model/network/api_client.dart';
import 'package:github_users/model/preference/app_preferences.dart';
import 'package:github_users/model/repository/repo/users_repository.dart';
import 'package:github_users/model/repository/repo/users_repository_impl.dart';
import 'package:github_users/model/user_model.dart';
import 'package:github_users/view_model/users_cubit.dart';
import 'package:github_users/view_model/users_state.dart';
import 'package:mockito/mockito.dart';

import '../../../lib/model/repository/repo/mock_users_repository_impl.dart';

class UsersRepositoryImplMock extends Mock implements UsersRepositoryImpl {}

class ApiClientMock extends Mock implements ApiClient {}

class AppPreferencesMock extends Mock implements AppPreferences {}

void main() {
  late MockUsersRepositoryImpl mockUsersRepositoryImpl;

  UsersCubit? usersCubit;

  setUp(() async {
    await GetIt.I.reset();
    final dependencyInjection = GetIt.instance;
    mockUsersRepositoryImpl = MockUsersRepositoryImpl();

    dependencyInjection.registerFactory<ApiClient>(() => ApiClientMock());
    dependencyInjection
        .registerFactory<AppPreferences>(() => AppPreferencesMock());
    dependencyInjection
        .registerFactory<UsersRepository>(() => mockUsersRepositoryImpl);

    usersCubit = UsersCubit();
  });

  tearDown(() {
    usersCubit?.close();
  });

  test('Cubit have initial state as [InitialState]', () {
    expect(usersCubit?.state.runtimeType, InitialState);
  });

  group('Server data or Api is used', () {
    blocTest<UsersCubit, UsersState>(
        'Should emit [LoadingState, LoadedState] when users are fetched',
        build: () => usersCubit!,
        act: (UsersCubit? cubit) {
          cubit?.getUsers();
        },
        expect: () => [
              LoadingState(const [], const [], isFirstFetch: true),
              LoadedState(const [], const []),
            ]);
  });

  group('Local data or no api is used', () {
    blocTest<UsersCubit, UsersState>(
        'Should emit [LoadingState, LoadedState] when local users are fetched',
        build: () => usersCubit!,
        act: (UsersCubit? cubit) {
          cubit?.getSelectedUsers();
        },
        expect: () => [
              LoadingState(
                const [],
                const [],
              ),
              LoadedState(const [], const []),
            ]);

    blocTest<UsersCubit, UsersState>(
        'Should emit [LoadingState, LoadedState] when users are added and removed',
        build: () => usersCubit!,
        act: (UsersCubit? cubit) {
          cubit?.addRemoveUser(UserModel(
              login: "test", id: 1, avatarUrl: 'https://test_image.png'));
        },
        expect: () => [
              LoadingState(const [], [
                UserModel(
                    login: "test", id: 1, avatarUrl: 'https://test_image.png')
              ], isAddingRemovingUser: true),
              LoadedState(const [], [
                UserModel(
                    login: "test", id: 1, avatarUrl: 'https://test_image.png')
              ]),
            ]);

    blocTest<UsersCubit, UsersState>(
        'Should emit [LoadingState, LoadedState] when all users are removed',
        build: () => usersCubit!,
        act: (UsersCubit? cubit) {
          cubit?.deleteAll();
        },
        expect: () => [
              LoadingState(const [], const [], isAddingRemovingUser: true),
              LoadedState(const [], const []),
            ]);
  });
}
