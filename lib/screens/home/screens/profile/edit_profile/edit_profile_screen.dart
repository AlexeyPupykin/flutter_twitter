import 'dart:io';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitter/common/app_colors.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_twitter/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_twitter/cubit/cubits.dart';
import 'package:flutter_twitter/helpers/helpers.dart';
import 'package:flutter_twitter/models/models.dart';
import 'package:flutter_twitter/repositories/repositories.dart';
import 'package:flutter_twitter/screens/home/screens/profile/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:flutter_twitter/screens/home/screens/profile/profile_bloc/profile_bloc.dart';
import 'package:flutter_twitter/widgets/widgets.dart';

class EditProfileScreenArgs {
  final BuildContext context;

  EditProfileScreenArgs({required this.context});
}

class EditProfileScreen extends StatelessWidget {
  static const String routeName = "/edit_profile";

  static Route route({required EditProfileScreenArgs args}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: EditProfileScreen.routeName),
      builder: (_) => BlocProvider<EditProfileCubit>(
        create: (context) => EditProfileCubit(
          userRepo: context.read<UserRepo>(),
          storageRepo: context.read<StorageRepo>(),
          profileBloc: args.context.read<ProfileBloc>(),
        ),
        child: EditProfileScreen(
          user: args.context.read<ProfileBloc>().state.user,
        ),
      ),
    );
  }

  final User user;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  EditProfileScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(),
        body: BlocConsumer<EditProfileCubit, EditProfileState>(
          listener: (context, editProfileState) {
            if (editProfileState.status == EditProfileStatus.success) {
              BotToast.showText(text: 'Профиль успешно изменен');
              Navigator.of(context).pop();
              BotToast.closeAllLoading();
            } else if (editProfileState.status == EditProfileStatus.error) {
              BotToast.showText(text: editProfileState.failure.message);
              showDialog(
                context: context,
                builder: (context) => ErrorDialog(
                  message: editProfileState.failure.message,
                ),
              );
            } else if (editProfileState.status ==
                EditProfileStatus.submitting) {
              BotToast.showLoading();
            }
          },
          builder: (context, editProfileState) {
            return Container(
              color: AppColors.mainBackground,
              padding: EdgeInsets.fromLTRB(8, 16, 8, 8),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (editProfileState.status ==
                              EditProfileStatus.submitting)
                            const LinearProgressIndicator(),
                          GestureDetector(
                            onTap: () => _selectProfileImage(context),
                            child: UserProfileImage(
                              radius: 56.0,
                              profileImage: editProfileState.profileImage,
                              profileImageURL: user.photo,
                            ),
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(top: 8, bottom: 8),
                                      child: Text(
                                        'Полное имя',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    _buildInput(
                                        TextInputType.name, user.displayName!,
                                        (value) {
                                      context
                                          .read<EditProfileCubit>()
                                          .nameChanged(value);
                                    },
                                        (value) => value!.trim().isEmpty
                                            ? 'Поле не может быть пустым'
                                            : null),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(top: 8, bottom: 8),
                                      child: Text(
                                        'Описание',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    _buildInput(TextInputType.multiline,
                                        user.description!, (value) {
                                      context
                                          .read<EditProfileCubit>()
                                          .descriptionChanged(value);
                                    }, null),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(top: 8, bottom: 8),
                                      child: Text(
                                        'Дата рождения',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    DateTimePicker(
                                        initialValue:
                                            user.dateOfBirth.toString(),
                                        firstDate: DateTime(1980),
                                        lastDate: DateTime(2100),
                                        dateMask: "dd.MM.yyyy",
                                        style: const TextStyle(
                                            fontSize: 22.0,
                                            color: Colors.black),
                                        onChanged: (val) => context
                                            .read<EditProfileCubit>()
                                            .dateOfBirthChanged(
                                                DateTime.parse(val)),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 10.0),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            borderSide: BorderSide(width: 2.0),
                                          ),
                                        )),
                                  ],
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      child:
                          Text("Сохранить", style: TextStyle(fontSize: 18.0)),
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            AppColors.textMainColor),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppColors.liteGreenColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        elevation: MaterialStateProperty.all<double>(4.0),
                      ),
                      onPressed: () => _submitForm(
                        context,
                        editProfileState.status == EditProfileStatus.submitting,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      child: Text("Удалить профиль",
                          style: TextStyle(fontSize: 18.0)),
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            AppColors.textMainColor),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppColors.darkRedColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        elevation: MaterialStateProperty.all<double>(4.0),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return ConfirmationDialog(
                                  message: "Аккаунт будет удален!",
                                  cancelOnPressed: () =>
                                      Navigator.of(context).pop(),
                                  continueOnPressed: () {
                                    context
                                        .read<UserRepo>()
                                        .disableUser(user: user);
                                    context
                                        .read<AuthBloc>()
                                        .add(AuthDeleteRequestedEvent());
                                    context
                                        .read<LikePostCubit>()
                                        .clearAllLikedPost();
                                  });
                            });
                      },
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInput(TextInputType inputType, String? initialValue,
      Function(String) onChanged, String? Function(String?)? validator) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      validator: validator,
      keyboardType: inputType,
      maxLines: inputType == TextInputType.multiline ? 2 : 1,
      style: const TextStyle(fontSize: 22.0, color: Colors.black),
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
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(width: 2.0),
        ),
      ),
      cursorColor: Colors.black,
    );
  }

  void _selectProfileImage(BuildContext context) async {
    final pickedFile = await ImageHelper.pickImageFromGallery(
      context: context,
      cropStyle: CropStyle.circle,
      title: "Фотография",
    );
    if (pickedFile != null) {
      context
          .read<EditProfileCubit>()
          .profileImageChanged(File(pickedFile.path));
    }
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState!.validate() && !isSubmitting) {
      context.read<EditProfileCubit>().submit();
    }
  }
}
