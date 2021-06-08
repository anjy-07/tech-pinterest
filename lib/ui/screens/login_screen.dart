import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_pinterest/blocs/authentication/authentication_bloc.dart';
import 'package:tech_pinterest/blocs/login/login_bloc.dart';
import 'package:tech_pinterest/repositories/repositories.dart';
import 'package:tech_pinterest/services/local_storage_service.dart';
import 'package:tech_pinterest/ui/widget/google_sign_in_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({
    Key? key,
    required AuthenticationRepository authRepository,
    required LocalStorageService localStorageService,
  })  : _localStorageService = localStorageService,
        _authenticationRepository = authRepository,
        super(key: key);

  final LocalStorageService _localStorageService;
  final AuthenticationRepository _authenticationRepository;

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);
    return SafeArea(
      child: Scaffold(
        body: BlocProvider<LoginBloc>(
          create: (BuildContext context) => LoginBloc(
              authRepository: _authenticationRepository,
              localStorageService: _localStorageService,
              authenticationBloc: authBloc),
          child: GoogleSignInButton(),
        ),
      ),
    );
  }
}
