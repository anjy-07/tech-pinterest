import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {
  @override
  String toString() => 'AppStarted';
}

class AppLoading extends AuthenticationEvent {
  @override
  String toString() => 'AppStarted';
}

class UserLoggedIn extends AuthenticationEvent {
  final User user;

  UserLoggedIn({required this.user});

  @override
  List<Object> get props => [user];

}

class UserLoggedOut extends AuthenticationEvent {
  @override
  String toString() => 'LoggedOut';
}