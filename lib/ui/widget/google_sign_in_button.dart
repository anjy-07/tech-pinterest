import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_pinterest/blocs/login/login_bloc.dart';
import 'package:tech_pinterest/blocs/login/login_event.dart';
import 'package:tech_pinterest/blocs/login/login_state.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({
    Key? key,
  }) : super(key: key);

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  late SnackBar _signingInSnackBar;

  @override
  Widget build(BuildContext context) {
    final _loginBloc = BlocProvider.of<LoginBloc>(context);
    return BlocConsumer<LoginBloc, LoginState>(
        listener: (BuildContext context, LoginState state) async {
      if (state is LoginFailure) {
        ScaffoldMessenger.of(context).showSnackBar(_signingInSnackBar);
      }
    }, builder: (BuildContext context, LoginState state) {
      return Center(
        child: state is LoginLoading
            ? CircularProgressIndicator()
            : OutlinedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
                onPressed: () {
                  _loginBloc.add(LoginInWithGoogleButtonPressed());
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage("assets/google_logo.png"),
                        height: 35.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Sign in with Google',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
      );
    });
    // show splash scree
  }
}
