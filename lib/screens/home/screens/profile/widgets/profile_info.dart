import 'package:flutter/material.dart';
import 'package:flutter_twitter/extensions/datetime_extensions.dart';

class ProfileInfo extends StatelessWidget {
  final String fullName;
  final String description;
  final DateTime? dateOfBirth;

  const ProfileInfo({
    required this.fullName,
    required this.description,
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
          height: 8,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 3 / 4 - 60,
          child: Text(
            description,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        const SizedBox(
          height: 8,
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
