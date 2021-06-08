import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_pinterest/repositories/authentication_repository.dart';

import 'application.dart';
import 'blocs/authentication/authentication_bloc.dart';
import 'blocs/authentication/authentication_event.dart';
import 'blocs/simple_bloc_observer.dart';
import 'blocs/theme/theme_bloc.dart';
import 'configuration.dart';
import 'services/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final LocalStorageService? localStorageService = await LocalStorageService.getInstance();
  final AuthenticationRepository authRepository = AuthenticationRepository();
  final AnalyticsService analyticsService = AnalyticsService(
    useGoogleAnalytics: kIsWeb == false && kUseFirebaseAnalytics,
  );

  if (kUseFlutterBlocObserver) {
    Bloc.observer = SimpleBlocObserver();
  }

  runApp(
    MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<AuthenticationBloc>(
          create: (BuildContext _) {
            return AuthenticationBloc(
              localStorageService: localStorageService!,
              authenticationRepository: authRepository,
            )..add(AppStarted());
          },
        ),
        BlocProvider<ThemeBloc>(
          create: (BuildContext _) => ThemeBloc(localStorageService: localStorageService!),
        ),
      ],
      child: App(authRepository: authRepository, localStorageService: localStorageService!, analyticsService: analyticsService,),
    ),
  );
}

