import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:megaspice/common/app_colors.dart';
import 'package:megaspice/repositories/repositories.dart';
import 'package:megaspice/screens/auth/sign_up/sign_up_screen.dart';

import 'cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = "/login";

  static Route route() {
    return PageRouteBuilder(
      settings: RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (context, __, ___) => BlocProvider<LoginCubit>(
        create: (context) =>
            LoginCubit(context.read<AuthRepo>(), context.read<UserRepo>()),
        child: LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, loginState) {
        if (loginState.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content:
                  Text(loginState.errorMessage ?? 'Authentication Failure'),
            ));
        }
      },
      builder: (context, loginState) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            body: WillPopScope(
              onWillPop: () async => false,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 48.0),
                            _SignInLabel(),
                            const SizedBox(height: 36.0),
                            _EmailInput(),
                            const SizedBox(height: 8.0),
                            _PasswordInput(),
                            const SizedBox(height: 24.0),
                          ],
                        ),
                      ),
                    ),
                    _SignInButton(),
                    const SizedBox(height: 12.0),
                    _SignUpNavLink(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Text(
                'Логин',
                style: TextStyle(fontSize: 16),
              ),
            ),
            TextField(
              onChanged: (email) =>
                  context.read<LoginCubit>().emailChanged(email),
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(fontSize: 22.0, color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(5),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(5),
                ),
                errorText: state.email.invalid ? 'Неверный логин' : null,
                errorStyle: TextStyle(fontSize: 14.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(width: 2.0),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Text(
                'Пароль',
                style: TextStyle(fontSize: 16),
              ),
            ),
            TextField(
              onChanged: (password) =>
                  context.read<LoginCubit>().passwordChanged(password),
              keyboardType: TextInputType.visiblePassword,
              style: const TextStyle(fontSize: 22.0, color: Colors.black),
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(5),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(5),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                errorText: state.email.invalid ? 'Неверный пароль' : null,
                errorStyle: TextStyle(fontSize: 14.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(width: 5.0),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SignInButton extends StatelessWidget {
  const _SignInButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : SizedBox(
                width: double.infinity,
                height: 52.0,
                child: ElevatedButton(
                  child: Text("Войти", style: TextStyle(fontSize: 18.0)),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        AppColors.textMainColor),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        AppColors.darkGreenColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    elevation: MaterialStateProperty.all<double>(4.0),
                  ),
                  onPressed: state.status.isValidated
                      ? () => context.read<LoginCubit>().logInWithCredentials()
                      : null,
                ));
      },
    );
  }
}

class _SignUpNavLink extends StatelessWidget {
  const _SignUpNavLink({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          children: [
            const TextSpan(
                text: 'Нет аккаунта? ', style: TextStyle(color: Colors.black)),
            TextSpan(
              text: 'Создать аккаунт',
              style: const TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.of(context).pushNamed(SignUpScreen.routeName);
                },
            ),
          ],
        ),
      ),
    );
  }
}

class _SignInLabel extends StatelessWidget {
  const _SignInLabel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          width: MediaQuery.of(context).size.width * 0.75,
          child: const Text(
            'Вход в аккаунт',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 36),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          width: MediaQuery.of(context).size.width * 0.75,
          child: const Text(
            'Добро пожаловать!\n Введите свой логин и пароль для входа в аккаунт.',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
