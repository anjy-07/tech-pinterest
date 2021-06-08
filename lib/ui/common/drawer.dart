import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_pinterest/blocs/authentication/authentication_bloc.dart';
import 'package:tech_pinterest/blocs/authentication/authentication_state.dart';
import 'package:tech_pinterest/blocs/authentication/authentication_event.dart';
import 'package:tech_pinterest/blocs/theme/theme_bloc.dart';
import 'package:tech_pinterest/ui/common/avatar.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<ThemeMode, String> _themeToString = <ThemeMode, String>{
      ThemeMode.dark: 'Dark',
      ThemeMode.light: 'Light',
      ThemeMode.system: 'System',
    };

    return Drawer(
      child: SafeArea(
        child: ListView(
          children: <Widget>[
            BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (BuildContext context, AuthenticationState state) {
                User _user;
                if (state is AuthenticationAuthenticated) {
                  _user = state.user;

                  return UserAccountsDrawerHeader(
                      accountName: Text(_user.displayName ?? 'Jon Doe'),
                      accountEmail: Text(_user.email ?? 'jon.doe@gmail.com'),
                      currentAccountPicture: CircleAvatar(
                        radius: 50.0,
                        backgroundColor: const Color(0xFF778899),
                        child: UserCircleAvatar(user: _user),
                      ));
                } else {
                  return Text(
                    'hi'
                  );
                }
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.lightbulb_outline),
              title: const Text('Theme'
                  // textScaleFactor: textScaleFactor,
                  ),
              trailing: BlocBuilder<ThemeBloc, ThemeMode>(
                builder: (BuildContext context, ThemeMode mode) {
                  return DropdownButton<ThemeMode>(
                    value: mode,
                    elevation: 16,
                    onChanged: (ThemeMode ? newValue) {
                      BlocProvider.of<ThemeBloc>(context).add(newValue!);
                    },
                    items: ThemeMode.values.map<DropdownMenuItem<ThemeMode>>(
                      (ThemeMode value) {
                        return DropdownMenuItem<ThemeMode>(
                          value: value,
                          child: Text(_themeToString[value]!),
                        );
                      },
                    ).toList(),
                  );
                },
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text(
                'Logout',
              ),
              onTap: () {
                BlocProvider.of<AuthenticationBloc>(context)
                    .add(UserLoggedOut());
              },
            ),
          ],
        ),
      ),
    );
  }
}
