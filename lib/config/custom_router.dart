import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_twitter/screens/auth/login/login_screen.dart';
import 'package:flutter_twitter/screens/auth/sign_up/sign_up_screen.dart';
import 'package:flutter_twitter/screens/home/home_screen.dart';
import 'package:flutter_twitter/screens/home/screens/navbar/navbar.dart';
import 'package:flutter_twitter/screens/home/screens/screens.dart';
import 'package:flutter_twitter/screens/onboarding/onboarding_screen.dart';
import 'package:flutter_twitter/screens/splash/splash_screen.dart';

class CustomRoute {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          settings: RouteSettings(name: '/'),
          builder: (_) => InitialRoutePage(),
        );

      case SplashScreen.routeName:
        return SplashScreen.route();

      case OnboardingScreen.routeName:
        return OnboardingScreen.route();

      case NavBar.routeName:
        return NavBar.route();

      case HomeScreen.routeName:
        return HomeScreen.route();

      default:
        return _errorRoute();
    }
  }

  static Route onGenerateNestedRoute(RouteSettings settings) {
    switch (settings.name) {
      case LoginScreen.routeName:
        return LoginScreen.route();

      case SignUpScreen.routeName:
        return SignUpScreen.route();

      case EditProfileScreen.routeName:
        return EditProfileScreen.route(
            args: settings.arguments as EditProfileScreenArgs);

      case ProfileScreen.routeName:
        return ProfileScreen.route(
            args: settings.arguments as ProfileScreenArgs);

      case CommentScreen.routeName:
        return CommentScreen.route(
            args: settings.arguments as CommentScreenArgs);

      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: RouteSettings(name: '/error'),
      builder: (_) => ErrorRoutePage(),
    );
  }
}

class InitialRoutePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            'Initial Route',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class ErrorRoutePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            'Error Route',
            style: TextStyle(
              color: Colors.red,
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
