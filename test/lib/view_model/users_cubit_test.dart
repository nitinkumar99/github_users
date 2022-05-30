import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_users/model/repository/base_repository.dart';
import 'package:github_users/model/repository/repo/users_repository.dart';
import 'package:github_users/model/user_model.dart';
import 'package:github_users/view_model/users_cubit.dart';
import 'package:github_users/view_model/users_state.dart';
import 'package:mocktail/mocktail.dart';

class MockUsersRepositoryImpl extends Mock implements UsersRepository {}

void main() {
  late MockUsersRepositoryImpl mockUsersRepositoryImpl;

  UsersCubit? usersCubit;

  final usersFromRepository = [
    UserModel(login: 'Test 1', avatarUrl: 'Test 1 content', id: 1),
    UserModel(login: 'Test 2', avatarUrl: 'Test 2 content', id: 2),
    UserModel(login: 'Test 3', avatarUrl: 'Test 3 content', id: 3),
  ];

  setUp(() async {
    mockUsersRepositoryImpl = MockUsersRepositoryImpl();

    usersCubit = UsersCubit(usersRepository: mockUsersRepositoryImpl);
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
        act: (UsersCubit? cubit) async {
          cubit?.page = 2;
          when(() => mockUsersRepositoryImpl.fetchUsers(2)).thenAnswer(
              (_) async => RepositoryResult([], RepositoryResultSource.server));
          await cubit?.getUsers();
        },
        expect: () => [
              LoadingState(const [], const [], isFirstFetch: false),
              LoadedState(const [], const []),
            ]);
  });

  group('Local data or no api is used', () {
    blocTest<UsersCubit, UsersState>(
        'Should emit [LoadingState, LoadedState] when local users are fetched',
        build: () => usersCubit!,
        act: (UsersCubit? cubit) {
          when(() => mockUsersRepositoryImpl.fetchLocalUsers()).thenAnswer(
              (_) async => RepositoryResult([], RepositoryResultSource.cached));
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
          when(() => mockUsersRepositoryImpl.setLocalUsers([
                    UserModel(
                        login: "test",
                        id: 1,
                        avatarUrl: 'https://test_image.png')
                  ]))
              .thenAnswer((_) async =>
                  RepositoryResult(true, RepositoryResultSource.cached));
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
          when(() => mockUsersRepositoryImpl.clearLocalData()).thenAnswer(
              (_) async =>
                  RepositoryResult(true, RepositoryResultSource.cached));
          cubit?.deleteAll();
        },
        expect: () => [
              LoadingState(const [], const [], isAddingRemovingUser: true),
              LoadedState(const [], const []),
            ]);
  });
}
