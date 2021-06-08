
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginInWithGoogleButtonPressed extends LoginEvent {

  LoginInWithGoogleButtonPressed();

  @override
  List<Object> get props => [];
}

