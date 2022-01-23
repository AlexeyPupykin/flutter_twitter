import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitter/common/app_colors.dart';
import 'package:flutter_twitter/screens/home/screens/profile/profile_bloc/profile_bloc.dart';
import 'package:flutter_twitter/screens/home/screens/screens.dart';

class ProfileButton extends StatelessWidget {
  final bool? isCurrentUser;
  final bool isFollowing;

  const ProfileButton({
    required this.isCurrentUser,
    required this.isFollowing,
  });

  @override
  Widget build(BuildContext context) {
    if (isCurrentUser == null) {
      return SizedBox();
    }
    return isCurrentUser!
        ? _buildButton('Редактировать', () {
            Navigator.of(context).pushNamed(
              EditProfileScreen.routeName,
              arguments: EditProfileScreenArgs(context: context),
            );
          })
        : _buildButton(isFollowing ? 'Отписаться' : 'Подписаться', () {
            isFollowing
                ? context.read<ProfileBloc>().add(
                      ProfileUnfollowUserEvent(),
                    )
                : context.read<ProfileBloc>().add(
                      ProfileFollowUserEvent(),
                    );
            ;
          });
  }

  Widget _buildButton(String text, VoidCallback onPressedCallback) {
    return SizedBox(
      width: double.infinity,
      height: 52.0,
      child: ElevatedButton(
        child: Text(text, style: TextStyle(fontSize: 18.0)),
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(
              (isCurrentUser != null && isCurrentUser!)
                  ? AppColors.darkGreenColor
                  : isFollowing
                      ? AppColors.darkGreenColor
                      : AppColors.liteGreenColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26.0),
            ),
          ),
          elevation: MaterialStateProperty.all<double>(4.0),
        ),
        onPressed: () => onPressedCallback(),
      ),
    );
  }
}
