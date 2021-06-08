import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_pinterest/blocs/authentication/authentication_bloc.dart';
import 'package:tech_pinterest/ui/screens/home_screen.dart';
import 'package:tech_pinterest/ui/screens/login_screen.dart';
import 'package:tech_pinterest/ui/screens/splash_screen.dart';
import 'package:tech_pinterest/utils/theme.dart';
import 'blocs/authentication/authentication_state.dart';
import 'blocs/authentication/authentication_bloc.dart';
import 'blocs/blocs.dart';
import 'blocs/theme/theme_bloc.dart';
import 'configuration.dart';
import 'repositories/repositories.dart';
import 'services/services.dart';

class App extends StatefulWidget {
  const App(
      {Key? key,
      required AuthenticationRepository authRepository,
      required AnalyticsService analyticsService,
      required LocalStorageService localStorageService})
      : _authRepository = authRepository,
        _localStorageService = localStorageService,
        _analyticsService = analyticsService,
        super(key: key);

  final AuthenticationRepository _authRepository;
  final AnalyticsService _analyticsService;
  final LocalStorageService _localStorageService;

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeMode>(
        builder: (BuildContext context, ThemeMode mode) {
      return MaterialApp(
        onGenerateTitle: (BuildContext context) => kAppName,
        debugShowCheckedModeBanner: false,
        // localisation delegate missing
        supportedLocales: kSupportedLanguages,
        theme: AppTheme.theme(Brightness.light),
        darkTheme: AppTheme.theme(Brightness.dark),
        themeMode: mode,
        navigatorObservers: kIsWeb == false && kUseFirebaseAnalytics
            ? <NavigatorObserver>[
                widget._analyticsService.getAnalyticsObserver()!
              ]
            : <NavigatorObserver>[],
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
          //final authBloc = BlocProvider.of<AuthenticationBloc>(context);
          if (state is AuthenticationUninitialized) {
            return SplashScreen();
          }
          if (state is AuthenticationAuthenticated) {
            print("home screen");
            return HomeScreen();
          } else {
            return LoginScreen(
              authRepository: widget._authRepository,
              localStorageService: widget._localStorageService,
            );
          }
        }),
      );
    });
  }
}
