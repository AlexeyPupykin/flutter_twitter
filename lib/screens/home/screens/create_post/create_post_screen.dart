import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitter/common/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_twitter/helpers/helpers.dart';
import 'package:flutter_twitter/screens/home/screens/create_post/cubit/create_post_cubit.dart';
import 'package:flutter_twitter/screens/home/screens/navbar/cubit/navbar_cubit.dart';
import 'package:flutter_twitter/screens/home/screens/profile/profile_bloc/profile_bloc.dart';
import 'package:flutter_twitter/widgets/widgets.dart';

class CreatePostScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Создать пост"),
      ),
      body: BlocConsumer<CreatePostCubit, CreatePostState>(
        listener: (context, state) {
          if (state.status == CreatePostStatus.success) {
            context.read<NavBarCubit>().updateSelectedItem(NavBarItem.profile);
            context.read<ProfileBloc>()
              ..add(ProfileLoadEvent(
                  userId: context.read<ProfileBloc>().state.user.uid));
            Navigator.of(context, rootNavigator: true).pop();
            _formKey.currentState!.reset();
            context.read<CreatePostCubit>().reset();

            BotToast.showText(text: "Пост успешно создан");
          } else if (state.status == CreatePostStatus.submitting) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => LoadingDialog(
                loadingMessage: 'Создание поста',
              ),
            );
          } else if (state.status == CreatePostStatus.failure) {
            Navigator.of(context, rootNavigator: true).pop();
            BotToast.showText(text: state.failure.message);

            showDialog(
              context: context,
              builder: (context) => ErrorDialog(
                message: state.failure.message,
              ),
            );
          }
        },
        builder: (context, state) {
          return GestureDetector(
            onTap: () => showDialog(
                context: context,
                builder: (buildContext) =>
                    _buildSelectImageDialog(buildContext, context)),
            child: Container(
              color: AppColors.mainBackground,
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (state.status == CreatePostStatus.submitting)
                              LinearProgressIndicator(),
                            Container(
                              height: MediaQuery.of(context).size.height / 2,
                              width: double.infinity,
                              color: Colors.grey[200],
                              child: state.postImage != null
                                  ? Container(
                                      child: Image.file(
                                        state.postImage!,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.image_outlined,
                                      color: Colors.grey,
                                      size: 120,
                                    ),
                            ),
                            SizedBox(height: 12.0),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 4.0, 0, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildCaptionInput(context),
                                ],
                              ),
                            ),
                            SizedBox(height: 12.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 4.0),
                    child: _buildPostButton(context, state),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCaptionInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 0, bottom: 8),
          child: Text(
            'Описание к посту',
            style: TextStyle(fontSize: 16),
          ),
        ),
        TextFormField(
          keyboardType: TextInputType.text,
          style: TextStyle(
              fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.w400),
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
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(width: 2.0),
            ),
          ),
          cursorColor: AppColors.mainBackground,
          onChanged: (value) {
            context.read<CreatePostCubit>().captionChanged(value);
          },
          validator: (value) {
            return value!.trim().isEmpty
                ? 'Описание к посту обязательно'
                : null;
          },
        ),
      ],
    );
  }

  Widget _buildPostButton(BuildContext context, CreatePostState state) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        child: Text("Опубликовать", style: TextStyle(fontSize: 18.0)),
        style: ButtonStyle(
          foregroundColor:
              MaterialStateProperty.all<Color>(AppColors.textMainColor),
          backgroundColor:
              MaterialStateProperty.all<Color>(AppColors.liteGreenColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          elevation: MaterialStateProperty.all<double>(4.0),
        ),
        onPressed: () {
          _submitForm(
            context,
            state.postImage!,
            state.status == CreatePostStatus.submitting,
          );
        },
      ),
    );
  }

  Widget _buildSelectImageDialog(
      BuildContext buildContext, BuildContext mainContext) {
    return AlertDialog(
      content: Container(
        height: 150,
        width: MediaQuery.of(buildContext).size.width - 32,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              child: TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(AppColors.textMainColor),
                  overlayColor:
                      MaterialStateProperty.all<Color>(AppColors.greyColor),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.camera,
                      size: 90,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Камера",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                onPressed: () {
                  _selectPostImageFromCamera(mainContext);
                  Navigator.pop(buildContext);
                },
              ),
            ),
            VerticalDivider(
              color: AppColors.textMainColor,
              thickness: 1,
              indent: 0,
              endIndent: 0,
              width: 50,
            ),
            SizedBox(
              child: TextButton(
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        AppColors.textMainColor),
                    overlayColor:
                        MaterialStateProperty.all<Color>(AppColors.greyColor)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.image,
                      size: 90,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Галлерея",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                onPressed: () {
                  _selectPostImageFromGallery(mainContext);
                  Navigator.pop(buildContext);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _selectPostImageFromCamera(BuildContext context) async {
    final pickedFile = await ImageHelper.pickImageFromCamera(
      context: context,
      cropStyle: CropStyle.rectangle,
      title: 'Добавить изображение',
    );
    if (pickedFile != null) {
      context.read<CreatePostCubit>().postImageChanged(pickedFile);
    }
  }

  void _selectPostImageFromGallery(BuildContext context) async {
    final pickedFile = await ImageHelper.pickImageFromGallery(
      context: context,
      cropStyle: CropStyle.rectangle,
      title: 'Добавить изображение',
    );
    if (pickedFile != null) {
      context.read<CreatePostCubit>().postImageChanged(pickedFile);
    }
  }

  void _submitForm(
      BuildContext context, File postImage, bool isSubmitting) async {
    if (_formKey.currentState!.validate() &&
        postImage != null &&
        !isSubmitting) {
      context.read<CreatePostCubit>().submit();
    }
  }
}
