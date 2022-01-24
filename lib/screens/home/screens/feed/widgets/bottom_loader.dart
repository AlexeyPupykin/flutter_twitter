import 'package:flutter/material.dart';
import 'package:flutter_twitter/common/app_colors.dart';

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          color: AppColors.liteGreenColor,
          valueColor:
              new AlwaysStoppedAnimation<Color>(AppColors.liteGreenColor),
          backgroundColor: AppColors.darkGreenColor,
        ),
      ),
    );
  }
}
