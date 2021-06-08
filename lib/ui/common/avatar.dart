import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final List<Color> _backgroundColors = <Color>[
  const Color(0xFF004D40),
  const Color(0xFF689F38),
  const Color(0xFF455A64),
  const Color(0xFF5C6BC0),
  const Color(0xFFC2185B),
  const Color(0xFF34691E),
  const Color(0xFF00579B),
  const Color(0xFFF5501B),
  const Color(0xFFB046BC),
  const Color(0xFF0388D2),
  const Color(0xFFEF6C00),
  const Color(0xFFF3511D),
  const Color(0xFFEC417A),
  const Color(0xFF5D4138),
  const Color(0xFF5D6AC0),
  const Color(0xFFBE360B),
  const Color(0xFF679F38),
  const Color(0xFF7B1FA2),
  const Color(0xFF435B63),
  const Color(0xFF00897B),
  const Color(0xFF77919D),
];

Color _userAvatarBackgroundColor(User user) {
  final int idx = (user.displayName ?? user.email).hashCode % _backgroundColors.length;
  return _backgroundColors[idx];
}

class UserCircleAvatar extends StatelessWidget {
  const UserCircleAvatar({
    Key? key,
    required User user,
    this.elevation = 0.0,
    this.radius = 35.0,
    this.displayActivityIndicator = false,
    //this.onTap,
  })  : 
        _user = user,
        super(key: key);
        

  final User _user;
  final double elevation;
  final double radius;
  final bool displayActivityIndicator;
 // final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: radius * 2,
        width: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _userAvatarBackgroundColor(_user),
          boxShadow: <BoxShadow>[
            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 5.0),
          ],
        ),
        child: Center(
          child: _user.photoURL != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: Image(image: NetworkImage(_user.photoURL!)),
                )
              : _AnonymousUserCircleAvatar(user: _user, radius: radius),
        ),
      ),
    );
  }
}

class _AnonymousUserCircleAvatar extends StatelessWidget {
  const _AnonymousUserCircleAvatar({
    Key? key,
    required this.user,
    required this.radius,
  }) : super(key: key);

  final User user;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final String firstLetter =
        (user.displayName ?? user.email)!.trimLeft().substring(0, 1).toUpperCase();

    return Center(
      child: Text(
        firstLetter,
        style: TextStyle(
          color: Colors.white,
          fontSize: radius,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}