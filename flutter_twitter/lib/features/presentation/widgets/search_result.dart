import 'package:flutter/material.dart';
import 'package:flutter_twitter/common/app_colors.dart';
import 'package:flutter_twitter/features/domain/entities/person_entity.dart';
import 'package:flutter_twitter/features/presentation/pages/person_detail_screen.dart';
import 'package:flutter_twitter/features/presentation/widgets/person_cache_image_widget.dart';

class SearchResult extends StatelessWidget {
  final PersonEntity personResult;

  const SearchResult({Key? key, required this.personResult}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          child: Container(
            height: 60,
            width: 60,
            child: Image.asset('assets/images/user_img.png'),
            margin: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PersonDetailPage(person: personResult),
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 200.0,
            child: GestureDetector(
              child: Text(
                personResult.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PersonDetailPage(person: personResult),
                  ),
                );
              },
            ),
          ),
        ),
        Container(
          width: 120,
          child: TextButton(
              child: Text('Subscribe'.toUpperCase(),
                  style: TextStyle(fontSize: 18)),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      AppColors.liteGreenColor),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.fromLTRB(8, 4, 8, 4)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: BorderSide(color: AppColors.liteGreenColor)))),
              onPressed: () => null),
        ),
      ],
    );
  }
}
