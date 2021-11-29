import 'package:flutter/material.dart';
import 'package:flutter_twitter/common/app_colors.dart';
import 'package:flutter_twitter/features/domain/entities/person_entity.dart';
import 'package:flutter_twitter/features/presentation/widgets/action_row_widget.dart';
import 'package:flutter_twitter/features/presentation/widgets/comments_widget.dart';
import 'package:flutter_twitter/features/presentation/widgets/custom_search_delegate.dart';
import 'package:flutter_twitter/features/presentation/widgets/person_cache_image_widget.dart';

class FeedItemPage extends StatelessWidget {
  final PersonEntity feedItem;

  const FeedItemPage({Key? key, required this.feedItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Comment> testComments = [
      Comment('mark_bulah', 'cool photo, dude!'),
      Comment('edward_bill', 'Whooa!!'),
      Comment('amiran495', 'hello from USA!!'),
      Comment('zheki444', 'Its better then my RR!!'),
      Comment('bakulin_official', '<3'),
    ];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: AppColors.darkGreenColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            iconSize: 35,
            color: Colors.white,
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            iconSize: 35,
            color: Colors.white,
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        // padding: const EdgeInsets.symmetric(horizontal: 16),
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
                        feedItem.name,
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
                imageUrl: feedItem.image,
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
              CommentsList(comments: testComments)
            ],
          ),
        ),
      ),
    );
  }
}
