import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_users/view/screens/selected_users_screen.dart';
import 'package:github_users/view_model/users_cubit.dart';

void main() {
  testWidgets('Users are displayed with avatar and name',
      (WidgetTester tester) async {
    await tester.pumpWidget(MultiBlocProvider(providers: [
      BlocProvider<UsersCubit>(
        create: (BuildContext context) => UsersCubit(),
      ),
    ], child: const ListPageWrapper()));
    await tester.pump(const Duration(seconds: 2));

    final carListKey = find.byKey(const Key('user_list'));
    expect(carListKey, findsOneWidget);
  });
}

class ListPageWrapper extends StatelessWidget {
  const ListPageWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SelectedUsersScreen(),
    );
  }
}
