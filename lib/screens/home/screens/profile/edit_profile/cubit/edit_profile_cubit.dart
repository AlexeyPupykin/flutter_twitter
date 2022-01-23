import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitter/models/models.dart';
import 'package:flutter_twitter/repositories/repositories.dart';
import 'package:flutter_twitter/screens/home/screens/profile/profile_bloc/profile_bloc.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final UserRepo _userRepo;
  final StorageRepo _storageRepo;
  final ProfileBloc _profileBloc;

  EditProfileCubit({
    required UserRepo userRepo,
    required StorageRepo storageRepo,
    required ProfileBloc profileBloc,
  })  : _userRepo = userRepo,
        _storageRepo = storageRepo,
        _profileBloc = profileBloc,
        super(EditProfileState.initial()) {
    final user = _profileBloc.state.user;
    emit(
      state.copyWith(
        name: user.displayName,
        description: user.description,
        dateOfBirth: user.dateOfBirth,
      ),
    );
  }

  void profileImageChanged(File image) {
    emit(
      state.copyWith(profileImage: image, status: EditProfileStatus.initial),
    );
  }

  void nameChanged(String name) {
    emit(
      state.copyWith(name: name, status: EditProfileStatus.initial),
    );
  }

  void descriptionChanged(String description) {
    emit(
      state.copyWith(
          description: description, status: EditProfileStatus.initial),
    );
  }

  void dateOfBirthChanged(DateTime dateOfBirth) {
    emit(
      state.copyWith(
          dateOfBirth: dateOfBirth, status: EditProfileStatus.initial),
    );
  }

  void disableUser(User user) {
    _userRepo.updateUser(user: user.copyWith(disabled: true));
  }

  void submit() async {
    emit(state.copyWith(status: EditProfileStatus.submitting));
    try {
      final user = _profileBloc.state.user;
      var profileImageUrl = user.photo;

      if (state.profileImage != null) {
        profileImageUrl = await _storageRepo.uploadProfileImageAndGiveUrl(
            url: profileImageUrl, image: state.profileImage!);
      }

      final updatedUser = user.copyWith(
        name: state.name,
        description: state.description,
        dateOfBirth: state.dateOfBirth,
        photo: profileImageUrl,
      );

      await _userRepo.updateUser(user: updatedUser);

      _profileBloc.add(ProfileLoadEvent(userId: user.uid));

      emit(state.copyWith(status: EditProfileStatus.success));
    } catch (err) {
      emit(
        state.copyWith(
          status: EditProfileStatus.error,
          failure:
              Failure(message: "unable to update profile: " + err.toString()),
        ),
      );
    }
  }
}
