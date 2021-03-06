import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitter/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_twitter/common/app_colors.dart';
import 'package:flutter_twitter/screens/home/screens/navbar/navbar.dart';
import 'package:flutter_twitter/screens/onboarding/onboarding_screen.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = '/splash';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: SplashScreen.routeName),
      builder: (_) => SplashScreen(),
    );
  }

  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.unknown) {
            Navigator.pushNamed(context, OnboardingScreen.routeName);
          } else {
            Navigator.of(context).pushNamed(NavBar.routeName);
          }
        },
        child: Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              color: AppColors.liteGreenColor,
              valueColor:
                  new AlwaysStoppedAnimation<Color>(AppColors.liteGreenColor),
              backgroundColor: AppColors.darkGreenColor,
            ),
          ),
        ),
      ),
    );
  }
}
