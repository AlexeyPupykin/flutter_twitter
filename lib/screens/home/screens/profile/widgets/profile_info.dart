import 'package:flutter/material.dart';
import 'package:flutter_twitter/extensions/datetime_extensions.dart';

class ProfileInfo extends StatelessWidget {
  final String fullName;
  final String gender;
  final DateTime? dateOfBirth;

  const ProfileInfo({
    required this.fullName,
    required this.gender,
    required this.dateOfBirth,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fullName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        Text(
          gender,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        Text(
          dateOfBirth == null
              ? ""
              : '${dateOfBirth!.calculateAgeExt()} years old',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
