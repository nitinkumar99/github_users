import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_users/main.dart';
import 'package:github_users/model/repository/base_repository.dart';
import 'package:github_users/model/repository/repo/users_repository.dart';
import 'package:github_users/model/user_model.dart';
import 'package:github_users/view_model/users_cubit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

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

  void checkAndReturnDataWithDelay() {
    when(() => mockUsersRepositoryImpl.fetchUsers(1)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return RepositoryResult([], RepositoryResultSource.server);
    });
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

  group("Testing static components", () {
    testWidgets("Title is shown", (WidgetTester tester) async {
      checkAndReturnData();
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('Github users'), findsOneWidget);
    });

    testWidgets("Tab bars are shown", (WidgetTester tester) async {
      checkAndReturnData();
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text("All Users"), findsOneWidget);
      expect(find.text("Selected Users"), findsOneWidget);
    });
  });

  group('Testing of dynamic data', () {
    testWidgets('Testing of loading indicator', (WidgetTester tester) async {
      checkAndReturnDataWithDelay();
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byKey(const Key('progress_indicator')), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('Testing of users list in case of error',
        (WidgetTester tester) async {
      checkAndReturnData();
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byKey(const Key('no_data_found')), findsOneWidget);
    });

    testWidgets('Testing of users list', (WidgetTester tester) async {
      await mockNetworkImagesFor(
          () async {
            checkAndReturnData();
            checkLocalData();
            await tester.pumpWidget(createWidgetUnderTest());
            await tester.pump(const Duration(milliseconds: 500));

            for (var item in users) {
              expect(find.text(item.login!), findsOneWidget);
            }
          });
    });
  });
}
