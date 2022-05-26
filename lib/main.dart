import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:github_users/model/network/api_client.dart';
import 'package:github_users/model/preference/app_preferences.dart';
import 'package:github_users/model/repository/repo/users_repository.dart';
import 'package:github_users/model/repository/repo/users_repository_impl.dart';
import 'package:github_users/route/route_generator.dart';
import 'package:github_users/values/colors.dart';
import 'package:github_users/view/screens/home_screen.dart';
import 'package:github_users/view_model/users_cubit.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  GetIt.I.registerSingletonAsync<AppPreferences>(
      () => AppPreferences.getInstance());
  GetIt.I.registerSingleton<ApiClient>(ApiClient());

  GetIt.I.registerSingletonWithDependencies<UsersRepository>(
      () => UsersRepositoryImpl(),
      dependsOn: [AppPreferences]);

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) async {
    await GetIt.I.allReady();
    runApp(MultiBlocProvider(
      providers: [
        BlocProvider<UsersCubit>(
          create: (BuildContext context) => UsersCubit(),
        ),
      ],
      child: const MyApp(),
    ));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.latoTextTheme(
      Theme.of(context).textTheme,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) => RouteGenerator.generateRoute(settings),
      initialRoute: HomeScreen.routeName,
      theme: ThemeData(
        primarySwatch: AppColor.PRIMARY_SWATCH,
        hintColor: AppColor.TEXT_HINT_COLOR,
        splashColor: AppColor.SPLASH_RIPPLE_COLOR.withOpacity(0.2),
        highlightColor: AppColor.SPLASH_RIPPLE_COLOR.withOpacity(0.2),
        brightness: Brightness.light,
        iconTheme: const IconThemeData(color: AppColor.ICON),
        textTheme: textTheme,
        appBarTheme: AppBarTheme(
          textTheme: textTheme,
        ),
        tabBarTheme: TabBarTheme(
          labelStyle: textTheme.subtitle2,
          unselectedLabelStyle: textTheme.subtitle2,
        ),
      ),
      builder: (context, child) => FutureBuilder(
        future: GetIt.I.allReady(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return child ?? Container();
        },
      ),
    );
  }
}
