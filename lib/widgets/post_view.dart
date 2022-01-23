import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_twitter/common/app_colors.dart';
import 'package:flutter_twitter/extensions/datetime_extensions.dart';
import 'package:flutter_twitter/models/models.dart';
import 'package:flutter_twitter/screens/home/screens/navbar/cubit/navbar_cubit.dart';
import 'package:flutter_twitter/screens/home/screens/profile/profile_screen.dart';
import 'package:flutter_twitter/screens/home/screens/screens.dart';
import 'package:flutter_twitter/widgets/user_profile_image.dart';
import 'package:provider/src/provider.dart';

class PostView extends StatelessWidget {
  final PostModel post;
  final CommentModel? lastComment;
  final bool isLiked;
  final int? likes;
  final int? comments;
  final VoidCallback onLike;
  final VoidCallback onPostDelete;

  final bool postAuthor;
  final bool isPostScreen;

  const PostView(
      {Key? key,
      required this.isLiked,
      this.likes = 0,
      this.comments = 0,
      required this.post,
      required this.lastComment,
      required this.onLike,
      required this.postAuthor,
      required this.onPostDelete,
      this.isPostScreen = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.mainBackground,
      child: Column(
        children: <Widget>[
          _buildHeader(context),
          _buildContent(context),
          _buildFooter(context),
          _buildCaption(context),
          _buildComment(context),
          Divider(
            height: 0,
            thickness: 2,
            indent: 0,
            endIndent: 0,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final author = post.author;
    return Padding(
      padding: EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, ProfileScreen.routeName,
            arguments: ProfileScreenArgs(userId: author.uid)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            UserProfileImage(radius: 30, profileImageURL: author.photo),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width - 128.0,
              child: Text(
                author.username ?? "unknown",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    context: context,
                    builder: (context) => _buildPostModal(context));
              },
              icon: Icon(Icons.more_vert_outlined),
              iconSize: 36.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostModal(BuildContext context) {
    return Container(
      color: AppColors.darkGreenColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            postAuthor
                ? TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onPostDelete();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Удалить",
                          style: TextStyle(
                            color: AppColors.textMainColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  )
                : TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Пожаловаться",
                          style: TextStyle(
                            color: AppColors.textMainColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onLike,
      child: CachedNetworkImage(
        width: double.infinity,
        height: MediaQuery.of(context).size.width,
        imageUrl: post.imageUrl,
        fit: BoxFit.fill,
        placeholder: (context, url) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              IconButton(
                onPressed: onLike,
                icon: isLiked
                    ? const Icon(Icons.favorite, color: Colors.red)
                    : const Icon(Icons.favorite_outline),
                iconSize: 40.0,
              ),
              Text(
                '${likes == null ? 0 : likes}',
                style: TextStyle(
                    color: AppColors.textMainColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 20.0),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (!isPostScreen) {
                    context.read<NavBarCubit>().hideNavBar();
                    Navigator.pushNamed(
                      context,
                      CommentScreen.routeName,
                      arguments: CommentScreenArgs(
                          post: post,
                          isLiked: isLiked,
                          onLike: onLike,
                          postAuthor: postAuthor,
                          onPostDelete: onPostDelete,
                          likes: likes!,
                          comments: comments!),
                    );
                  }
                },
                icon: Icon(FontAwesomeIcons.comment),
                iconSize: 35.0,
              ),
              Text(
                '${comments == null ? 0 : comments}',
                style: TextStyle(
                    color: AppColors.textMainColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 20.0),
              ),
            ],
          ),
          Icon(
            Icons.share_outlined,
            size: 35,
          )
        ],
      ),
    );
  }

  Widget _buildCaption(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text.rich(TextSpan(children: [
            TextSpan(
                text: post.author.username ?? "unknown",
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 24.0)),
            TextSpan(text: " "),
            TextSpan(text: post.caption, style: TextStyle(fontSize: 18.0)),
          ])),
          const SizedBox(height: 8.0),
          Text(
            '${post.dateTime.timeAgoExt()}',
            style: TextStyle(
                color: AppColors.greyColor,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w400,
                fontSize: 18.0),
          ),
        ],
      ),
    );
  }

  Widget _buildComment(BuildContext context) {
    if (lastComment == null) {
      return SizedBox();
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    lastComment!.author.username!,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    lastComment!.content,
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 18.0),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
