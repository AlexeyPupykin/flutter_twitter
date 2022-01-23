import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_twitter/common/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ConfirmationDialog extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String cancelText;
  final Color cancelBackgroundColor;
  final Color cancelForegroundColor;
  final VoidCallback cancelOnPressed;
  final String continueText;
  final Color continueBackgroundColor;
  final Color continueForegroundColor;
  final VoidCallback continueOnPressed;

  const ConfirmationDialog({
    required this.cancelOnPressed,
    required this.continueOnPressed,
    this.icon = Icons.dangerous_rounded,
    this.iconColor = AppColors.darkRedColor,
    this.title = "Вы уверены?",
    this.message = "",
    this.cancelText = "Отмена",
    this.cancelBackgroundColor = AppColors.darkRedColor,
    this.cancelForegroundColor = AppColors.textMainColor,
    this.continueText = "Подтвердить",
    this.continueBackgroundColor = AppColors.liteGreenColor,
    this.continueForegroundColor = AppColors.textMainColor,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? _showIOSDialog(context)
        : _showAndroidDialog(context);
  }

  CupertinoAlertDialog _showIOSDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.pop(context),
          child: const Text("Ok"),
        ),
      ],
    );
  }

  AlertDialog _showAndroidDialog(BuildContext context) {
    Widget cancelButton = ElevatedButton(
      child: Text(cancelText, style: TextStyle(fontSize: 14)),
      style: ButtonStyle(
        foregroundColor:
            MaterialStateProperty.all<Color>(cancelForegroundColor),
        backgroundColor:
            MaterialStateProperty.all<Color>(cancelBackgroundColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        elevation: MaterialStateProperty.all<double>(4.0),
      ),
      onPressed: cancelOnPressed,
    );

    Widget continueButton = ElevatedButton(
      child: Text(continueText, style: TextStyle(fontSize: 14)),
      style: ButtonStyle(
        foregroundColor:
            MaterialStateProperty.all<Color>(continueForegroundColor),
        backgroundColor:
            MaterialStateProperty.all<Color>(continueBackgroundColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        elevation: MaterialStateProperty.all<double>(4.0),
      ),
      onPressed: continueOnPressed,
    );

    return AlertDialog(
      backgroundColor: AppColors.darkGreenColor,
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actionsPadding: EdgeInsets.symmetric(horizontal: 16),
      title: Row(children: [
        Icon(
          icon,
          color: iconColor,
        ),
        SizedBox(
          width: 36,
        ),
        Text(title)
      ]),
      content: Text(message),
      actions: [cancelButton, continueButton],
    );
  }
}
