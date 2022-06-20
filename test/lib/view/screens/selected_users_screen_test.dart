
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_users/model/repository/base_repository.dart';
import 'package:github_users/model/repository/repo/users_repository.dart';
import 'package:github_users/model/user_model.dart';
import 'package:github_users/view/screens/selected_users_screen.dart';
import 'package:github_users/view_model/users_cubit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

class MockUsersRepositoryImpl extends Mock implements UsersRepository {}


void main(){

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

  void checkLocalData() {
    when(() => mockUsersRepositoryImpl.fetchLocalUsers()).thenAnswer(
            (_) async => RepositoryResult(users, RepositoryResultSource.cached));
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
        child: const SelectedUsersScreen(),
      ),
    );
  }

  testWidgets("Checking static components, checking FAB button", (widgetTester) async  {
    await widgetTester.pumpWidget(createWidgetUnderTest());
    expect(find.byKey(const Key("remove_all_button")), findsOneWidget);
  });

  testWidgets("Checking static components, checking FAB button", (widgetTester) async  {
    checkLocalData();
    await widgetTester.pumpWidget(createWidgetUnderTest());
    expect(find.byKey(const Key("remove_all_button")), findsOneWidget);
  });

  testWidgets("Checking dynamic components, checking if items inserted in list", (widgetTester) async  {
    mockNetworkImagesFor(() async {
      checkLocalData();
      await widgetTester.pumpWidget(createWidgetUnderTest());

      await widgetTester.pumpAndSettle();

      // checking if data is set from list
      expect(find.text(users[0].login ?? ''), findsOneWidget);
      expect(find.text(users[1].login ?? ''), findsOneWidget);

    });
  });

}