import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitter/bloc/user_bloc.dart';
import 'package:flutter_twitter/services/user_repository.dart';
import 'package:flutter_twitter/widgets/action_buttons.dart';
import 'package:flutter_twitter/widgets/user_list.dart';

class HomePage extends StatelessWidget {
  final usersRepository = UsersRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
        create: (context) => UserBloc(usersRepository: usersRepository),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Users list'),
            centerTitle: true,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[ActionButtons(), Expanded(child: UserList())],
          ),
        ));
  }
}
