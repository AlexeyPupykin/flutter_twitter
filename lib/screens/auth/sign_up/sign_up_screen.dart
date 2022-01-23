import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';
import 'package:megaspice/common/app_colors.dart';
import 'package:megaspice/repositories/repositories.dart';

import 'cubit/sign_up_cubit.dart';

class SignUpScreen extends StatelessWidget {
  static const String routeName = "/sign_up";

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => SignUpScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider<SignUpCubit>(
          create: (_) => SignUpCubit(
            context.read<AuthRepo>(),
            context.read<UserRepo>(),
          ),
          child: const SignUpForm(),
        ),
      ),
    );
  }
}

class SignUpForm extends StatelessWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          Navigator.of(context).pop();
        } else if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text(state.errorMessage ?? 'Sign Up Failure')));
        }
      },
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
                  _SignUpLabel(),
                  const SizedBox(height: 36.0),
                  _EmailInput(),
                  const SizedBox(height: 24.0),
                  _PasswordInput(),
                  const SizedBox(height: 24.0),
                  _ConfirmPasswordInput(),
                ],
              ),
            )),
            _SignUpButton(),
            const SizedBox(height: 12.0),
            _SignInNavLink(),
          ],
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
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
                  context.read<SignUpCubit>().emailChanged(email),
              keyboardType: TextInputType.emailAddress,
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
                errorText: state.email.invalid ? 'Некорректный логин' : null,
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
    return BlocBuilder<SignUpCubit, SignUpState>(
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
                  context.read<SignUpCubit>().passwordChanged(password),
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
                errorText:
                    state.password.invalid ? 'Некорректный пароль' : null,
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

class _ConfirmPasswordInput extends StatelessWidget {
  const _ConfirmPasswordInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.confirmedPassword != current.confirmedPassword,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Text(
                'Повторите пароль',
                style: TextStyle(fontSize: 16),
              ),
            ),
            TextField(
              onChanged: (confirmPassword) => context
                  .read<SignUpCubit>()
                  .confirmedPasswordChanged(confirmPassword),
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
                errorText: state.confirmedPassword.invalid
                    ? 'Пароли не совпадают'
                    : null,
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

class _SignUpButton extends StatelessWidget {
  const _SignUpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : SizedBox(
                width: double.infinity,
                height: 52.0,
                child: ElevatedButton(
                  child: Text("Создать", style: TextStyle(fontSize: 18.0)),
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
                      ? () => context.read<SignUpCubit>().signUpFormSubmitted()
                      : null,
                ));
      },
    );
  }
}

class _SignInNavLink extends StatelessWidget {
  const _SignInNavLink({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          children: [
            const TextSpan(
                text: 'Уже есть аккаунт? ',
                style: TextStyle(color: Colors.black)),
            TextSpan(
              text: 'Войти',
              style: const TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pop(context);
                },
            ),
          ],
        ),
      ),
    );
  }
}

class _SignUpLabel extends StatelessWidget {
  const _SignUpLabel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          width: MediaQuery.of(context).size.width * 0.75,
          child: const Text(
            'Регистрация',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 36),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          width: MediaQuery.of(context).size.width * 0.75,
          child: const Text(
            'Чтобы создать аккаунт\n заполните поля ниже.',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
