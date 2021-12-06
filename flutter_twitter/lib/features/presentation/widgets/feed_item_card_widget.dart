import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_twitter/common/app_colors.dart';
import 'package:flutter_twitter/features/domain/entities/person_entity.dart';
import 'package:flutter_twitter/features/presentation/pages/feed_item_screen.dart';
import 'package:flutter_twitter/features/presentation/pages/profile_screen.dart';
import 'package:flutter_twitter/features/presentation/widgets/action_row_widget.dart';
import 'package:flutter_twitter/features/presentation/widgets/comments_widget.dart';
import 'package:flutter_twitter/features/presentation/widgets/feed_item_cache_image_widget.dart';

class FeedItemCard extends StatelessWidget {
  final PersonEntity person;

  const FeedItemCard({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Comment> testComments = [
      Comment('mark_bulah', 'cool photo, dude!'),
      Comment('edward_bill', 'Whooa!!')
    ];
    return Container(
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
                GestureDetector(
                  child: Container(
                    height: 60,
                    width: 60,
                    child: Image.asset('assets/images/user_img.png'),
                    margin: const EdgeInsets.only(
                        left: 10.0, top: 10.0, bottom: 10.0),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  },
                ),
                GestureDetector(
                  child: Container(
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  },
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
          GestureDetector(
            child: FeedItemCacheImage(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              imageUrl: person.image,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FeedItemPage(feedItem: person),
                ),
              );
            },
          ),

          // likes, comments, share
          // _actionsRow(context, 25, 13),
          const ActionRow(numLikes: 25, numComments: 13),

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
          // _comments(testComments),
          CommentsList(comments: testComments)
        ],
      ),
    );
  }
}
