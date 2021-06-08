import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tech_pinterest/repositories/repositories.dart';
import 'package:tech_pinterest/services/local_storage_service.dart';
import './authentication_event.dart';
import './authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final LocalStorageService _localStorageService;
  final AuthenticationRepository _authenticationRepository;

  AuthenticationBloc(
      {required AuthenticationRepository authenticationRepository,
      required LocalStorageService localStorageService})
      : _localStorageService = localStorageService,
        _authenticationRepository = authenticationRepository,
        super(AuthenticationUninitialized());

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AppStarted) {
      yield* _mapAppLoadedToState(event);
    }
    if (event is UserLoggedIn) {
      yield* _mapUserLoggedInToState(event);
    }
    if (event is UserLoggedOut) {
      yield* _mapUserLoggedOutToState(event);
    }
  }

  Stream<AuthenticationState> _mapAppLoadedToState(AppStarted event) async* {
    // yield AuthenticationLoading();
    try {
      final User? user =
          await _authenticationRepository.signInWithCurrentUser();
      if (user != null) {
        await _localStorageService.setAuthenticatedUserID(user.uid);
        yield AuthenticationAuthenticated(user: user);
        // await _analyticsService.logSignIn('signInWithCurrentUser');
      } else {
        await _localStorageService.deleteAuthenticatedUserID();
        yield AuthenticationUnauthenticated();
      }
    } catch (_) {
      await _localStorageService.deleteAuthenticatedUserID();
      yield AuthenticationUnauthenticated();
    }
  }

  Stream<AuthenticationState> _mapUserLoggedInToState(
      UserLoggedIn event) async* {
    try {
      yield AuthenticationLoading();
      yield AuthenticationAuthenticated(user: event.user);
    } catch (_) {
      yield AuthenticationUnauthenticated();
    }
  }

  Stream<AuthenticationState> _mapUserLoggedOutToState(
      UserLoggedOut event) async* {
    yield AuthenticationLoading();
    await _localStorageService.deleteAuthenticatedUserID();
    yield AuthenticationUnauthenticated();
    await _authenticationRepository.signOut();
     //await _analyticsService.logSignOut();
  }
}
