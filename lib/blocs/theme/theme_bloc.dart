import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../services/services.dart';

class ThemeBloc extends Bloc<ThemeMode, ThemeMode> {
  ThemeBloc({
    required LocalStorageService localStorageService,
  })  :
        _localStorageService = localStorageService,
        _preferredTheme = localStorageService.getPreferredTheme(),
        super(localStorageService.getPreferredTheme());

  final LocalStorageService _localStorageService;
  ThemeMode _preferredTheme;

  @override
  Stream<ThemeMode> mapEventToState(ThemeMode theme) async* {
    _preferredTheme = theme;
    _localStorageService.setPreferredTheme(_preferredTheme);
    yield _preferredTheme;
  }
}