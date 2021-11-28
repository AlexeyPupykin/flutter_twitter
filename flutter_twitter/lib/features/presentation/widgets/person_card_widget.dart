import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_twitter/common/app_colors.dart';
import 'package:flutter_twitter/features/domain/entities/person_entity.dart';
import 'package:flutter_twitter/features/presentation/pages/person_detail_screen.dart';
import 'package:flutter_twitter/features/presentation/widgets/person_cache_image_widget.dart';

class Comment {
  String author;
  String text;

  Comment(this.author, this.text);
}

class PersonCard extends StatelessWidget {
  final PersonEntity person;

  const PersonCard({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Comment> testComments = [
      new Comment('mark_bulah', 'cool photo, dude!'),
      new Comment('edward_bill', 'Whooa!!')
    ];
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PersonDetailPage(person: person),
          ),
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          // borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // author, nickname, 3 dots
            SizedBox(
              height: 80,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    child: Image.asset('assets/images/user_img.png'),
                    margin: const EdgeInsets.only(
                        left: 10.0, top: 10.0, bottom: 10.0),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width - 140.0,
                    child: Text(
                      person.name,
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
                    width: 60,
                    child: const Icon(
                      Icons.more_vert_outlined,
                      size: 35,
                    ),
                    margin: const EdgeInsets.only(
                        right: 10.0, top: 10.0, bottom: 10.0),
                  ),
                ],
              ),
            ),

            // image
            PersonCacheImage(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              imageUrl: person.image,
            ),

            // likes, comments, share
            _actionsRow(context, 25, 13),

            // post`s comment
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Its comment for post Its comment for post Its comment for post Its comment for post Its comment for post Its comment for post Its comment for post",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0),
              ),
            ),

            // datetime of create
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                '7 часов назад',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.greyColor),
              ),
            ),

            // comments
            _comments(testComments),
          ],
        ),
      ),
      // child: Row(
      //   children: [
      //     Container(
      //       child: PersonCacheImage(
      //         width: 166,
      //         height: 166,
      //         imageUrl: person.image,
      //       ),
      //     ),
      //     const SizedBox(
      //       width: 16,
      //     ),
      //     Expanded(
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           const SizedBox(
      //             height: 12,
      //           ),
      //           Text(
      //             person.name,
      //             style: const TextStyle(
      //               fontSize: 20,
      //               color: Colors.white,
      //               fontWeight: FontWeight.w700,
      //             ),
      //           ),
      //           const SizedBox(
      //             height: 4,
      //           ),
      //           Row(
      //             children: [
      //               Container(
      //                 height: 8,
      //                 width: 8,
      //                 decoration: BoxDecoration(
      //                   color: person.status == 'Alive'
      //                       ? Colors.green
      //                       : Colors.red,
      //                   borderRadius: BorderRadius.circular(8),
      //                 ),
      //               ),
      //               const SizedBox(
      //                 width: 8,
      //               ),
      //               Expanded(
      //                 child: Text(
      //                   '${person.status} - ${person.species}',
      //                   style: const TextStyle(color: Colors.white),
      //                   maxLines: 1,
      //                   overflow: TextOverflow.ellipsis,
      //                 ),
      //               ),
      //             ],
      //           ),
      //           const SizedBox(
      //             height: 12,
      //           ),
      //           const Text(
      //             'Last known location:',
      //             style: TextStyle(color: AppColors.greyColor),
      //           ),
      //           const SizedBox(
      //             height: 4,
      //           ),
      //           Text(
      //             person.location.name,
      //             style: const TextStyle(color: Colors.white),
      //             maxLines: 1,
      //             overflow: TextOverflow.ellipsis,
      //           ),
      //           const SizedBox(
      //             height: 12,
      //           ),
      //           const Text(
      //             'Origin:',
      //             style: TextStyle(
      //               color: AppColors.greyColor,
      //             ),
      //           ),
      //           const SizedBox(
      //             height: 4,
      //           ),
      //           Text(
      //             person.origin.name,
      //             style: const TextStyle(color: Colors.white),
      //             maxLines: 1,
      //             overflow: TextOverflow.ellipsis,
      //           ),
      //           const SizedBox(
      //             height: 16,
      //           ),
      //         ],
      //       ),
      //     ),
      //     const SizedBox(
      //       width: 12,
      //     ),
      //   ],
      // ),
    );
  }

  Widget _actionsRow(context, int numLikes, int numComments) {
    return SizedBox(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // likes
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
            child: SizedBox(
              height: 60,
              width: MediaQuery.of(context).size.width / 3 - 8,
              child: Row(
                children: [
                  const Icon(
                    Icons.favorite_outline_outlined,
                    size: 35,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    numLikes.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // comments
          SizedBox(
            height: 60,
            width: MediaQuery.of(context).size.width / 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.comment_outlined,
                  size: 35,
                ),
                const SizedBox(width: 10),
                Text(
                  numComments.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          // share
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
            child: SizedBox(
              height: 60,
              width: MediaQuery.of(context).size.width / 3 - 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(
                    Icons.share_outlined,
                    size: 35,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _comments(comments) {
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return RichText(
          text: TextSpan(children: <TextSpan>[
            TextSpan(
                text: comments[index].author + '  ',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600)),
            TextSpan(
              text: comments[index].text,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
            ),
          ]),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemCount: comments.length,
    );
  }
}
