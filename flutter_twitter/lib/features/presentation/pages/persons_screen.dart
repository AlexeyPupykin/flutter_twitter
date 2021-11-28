// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_twitter/common/app_colors.dart';
import 'package:flutter_twitter/features/presentation/widgets/persons_list_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Characters'),
        centerTitle: true,
        backgroundColor: AppColors.darkGreenColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            iconSize: 35,
            color: Colors.white,
            onPressed: () {},
          ),
          SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            iconSize: 35,
            color: Colors.white,
            onPressed: () {},
          )
        ],
      ),
      body: PersonsList(),
    );
  }
}
