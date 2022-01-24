import 'package:flutter/material.dart';
import 'package:flutter_twitter/common/app_colors.dart';

class LoadingDialog extends StatelessWidget {
  final String loadingMessage;

  const LoadingDialog({this.loadingMessage = "Loading, please wait ...."});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.mainBackground,
      content: Row(
        children: [
          CircularProgressIndicator(),
          const SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Text(loadingMessage),
          ),
        ],
      ),
    );
  }
}
