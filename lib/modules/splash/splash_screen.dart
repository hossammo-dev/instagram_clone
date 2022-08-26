import 'dart:async';

import 'package:flutter/material.dart';
import 'package:instagram_clone/layouts/home_layout.dart';
import 'package:instagram_clone/modules/auth/auth_screen.dart';
import 'package:instagram_clone/shared/constants.dart';
import 'package:instagram_clone/shared/network/local/cache_helper.dart';
import 'package:instagram_clone/shared/widgets/components.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    final Widget _widget = _validateUser();
    Timer(const Duration(seconds: 5),
        () => navigateRemove(context, page: _widget));
    super.initState();
  }

  Widget _validateUser() {
    final String _uid = CacheHelper.get('uid') ?? 'null';
    // ignore: unnecessary_null_comparison
    if (_uid == 'null') {
      debugPrint('--$_uid');
      return AuthScreen();
    } else {
      Constants.userId = _uid;
      debugPrint('--${Constants.userId}');
      return const HomeLayout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          Constants.appLogo,
          width: 200,
          height: 200,
          repeat: false,
        ),
      ),
    );
  }
}
