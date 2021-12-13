import 'package:flutter/material.dart';
import 'package:flutter_twitter/common/app_colors.dart';
import 'package:flutter_twitter/features/presentation/pages/feed_screen.dart';
import 'package:flutter_twitter/features/presentation/pages/my_profile_screen.dart';
import 'package:flutter_twitter/features/presentation/widgets/custom_search_delegate.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
  final Widget _feed = const FeedPage();
  final Widget _myEmails = const MyEmails();
  final Widget _myProfile = const MyProfilePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        backgroundColor: AppColors.darkGreenColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            iconSize: 35,
            color: Colors.white,
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            iconSize: 35,
            color: Colors.white,
            onPressed: () {},
          )
        ],
      ),
      body: getBody(),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: AppColors.darkGreenColor,
        unselectedItemColor: AppColors.cellBackground,
        selectedItemColor: Colors.white,
        iconSize: 28,
        selectedIconTheme: const IconThemeData(size: 35),
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Лента',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_rounded),
            label: 'Новый пост',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Профиль',
          ),
        ],
        onTap: (int index) {
          onTapHandler(index);
        },
      ),
    );
  }

  Widget getBody() {
    if (selectedIndex == 0) {
      return _feed;
    } else if (selectedIndex == 1) {
      return _myEmails;
    } else {
      return _myProfile;
    }
  }

  void onTapHandler(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}

class MyEmails extends StatelessWidget {
  const MyEmails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("New post"));
  }
}

class MyProfile extends StatelessWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Profile"));
  }
}
