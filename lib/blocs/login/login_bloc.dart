import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tech_pinterest/blocs/authentication/authentication_event.dart';
import 'package:tech_pinterest/repositories/authentication_repository.dart';
import 'package:tech_pinterest/services/local_storage_service.dart';
import 'login_event.dart';
import 'login_state.dart';
import '../authentication/authentication_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationBloc _authenticationBloc;
  final AuthenticationRepositoryInterface _authRepository;
  final LocalStorageService _localStorageService;

  LoginBloc({
    required AuthenticationBloc authenticationBloc,
    required AuthenticationRepositoryInterface authRepository,
    required LocalStorageService localStorageService,
  })   : _authenticationBloc = authenticationBloc,
        _authRepository = authRepository,
        _localStorageService = localStorageService,
        super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginInWithGoogleButtonPressed) {
      yield* _mapLoginWithGoogleSignInToState(event);
    }
  }

  Stream<LoginState> _mapLoginWithGoogleSignInToState(
    LoginInWithGoogleButtonPressed event) async* {
    yield LoginLoading();
    try {
      User? user = await _authRepository.signInWithGoogle();
      if (user != null) {
        _localStorageService.setAuthenticatedUserID(user.email);
        _authenticationBloc.add(UserLoggedIn(user: user));
      
      } else {
        yield LoginFailure(error: 'Something very weird just happened');
      }
    } catch (err) {
      yield LoginFailure(error: err.toString());
    }
  }
}
