import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  final bool? isCurrentUser;
  final bool isFollowing;
  final int posts;
  final int following;
  final int followers;

  const ProfileStats({
    required this.isCurrentUser,
    required this.isFollowing,
    required this.posts,
    required this.following,
    required this.followers,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Stats(
            label: 'Посты',
            count: posts,
          ),
          _Stats(
            label: 'Подписчики',
            count: followers,
          ),
          _Stats(
            label: 'Подписки',
            count: following,
          ),
        ],
      ),
    );
  }
}

class _Stats extends StatelessWidget {
  final String label;
  final int count;

  const _Stats({
    Key? key,
    required this.label,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      child: Column(
        children: [
          Text(count.toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
          Text(label,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400))
        ],
      ),
    );
  }
}
