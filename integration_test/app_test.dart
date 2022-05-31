import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_users/main.dart';
import 'package:github_users/model/repository/base_repository.dart';
import 'package:github_users/model/repository/repo/users_repository.dart';
import 'package:github_users/model/user_model.dart';
import 'package:github_users/view_model/users_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockUsersRepositoryImpl extends Mock implements UsersRepository {}

void main() {
  late MockUsersRepositoryImpl mockUsersRepositoryImpl;

  setUp(() {
    mockUsersRepositoryImpl = MockUsersRepositoryImpl();
  });

  var users = [
    UserModel(
        login: 'Test 1',
        id: 1,
        avatarUrl: 'https://avatars.githubusercontent.com/u/1?v=4'),
    UserModel(
        login: 'Test 2',
        id: 2,
        avatarUrl: 'https://avatars.githubusercontent.com/u/1?v=4')
  ];

  void checkAndReturnData() {
    when(() => mockUsersRepositoryImpl.fetchUsers(1)).thenAnswer(
        (_) async => RepositoryResult(users, RepositoryResultSource.server));
  }

  void checkLocalData() {
    when(() => mockUsersRepositoryImpl.fetchLocalUsers()).thenAnswer(
        (_) async => RepositoryResult([], RepositoryResultSource.cached));
  }

  Widget createWidgetUnderTest() {
    return MaterialApp(
      title: 'News App',
      home: MultiBlocProvider(
        providers: [
          BlocProvider<UsersCubit>(
            create: (BuildContext context) =>
                UsersCubit(usersRepository: mockUsersRepositoryImpl),
          ),
        ],
        child: const MyApp(),
      ),
    );
  }

  testWidgets("""Tapping on tab bar selected user tab 
  should open second tab""", (WidgetTester tester) async {
    checkAndReturnData();
    checkLocalData();
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    await tester.tap(find.text('Selected Users'));

    await tester.pumpAndSettle();

    // fab button on second tab should be visible
    expect(find.byKey(const Key('remove_all_button')), findsOneWidget);
  });
}
