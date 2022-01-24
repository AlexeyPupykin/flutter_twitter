import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_twitter/blocs/blocs.dart';
import 'package:flutter_twitter/common/app_colors.dart';
import 'package:flutter_twitter/cubit/comment_post_cubit/comment_post_cubit.dart';
import 'package:flutter_twitter/cubit/cubits.dart';
import 'package:flutter_twitter/extensions/datetime_extensions.dart';
import 'package:flutter_twitter/models/models.dart';
import 'package:flutter_twitter/repositories/repositories.dart';
import 'package:flutter_twitter/screens/home/screens/navbar/cubit/navbar_cubit.dart';
import 'package:flutter_twitter/widgets/widgets.dart';

import '../screens.dart';
import 'bloc/comment_bloc.dart';

class CommentScreenArgs {
  final PostModel post;
  final bool isLiked;
  final VoidCallback onLike;
  final bool postAuthor;
  final VoidCallback onPostDelete;
  final int likes;
  final int comments;

  CommentScreenArgs({
    required this.post,
    required this.isLiked,
    required this.onLike,
    required this.postAuthor,
    required this.onPostDelete,
    required this.likes,
    required this.comments,
  });
}

class CommentScreen extends StatefulWidget {
  static const String routeName = "/comments";

  static Route route({required CommentScreenArgs args}) {
    return MaterialPageRoute(
      settings:
          RouteSettings(name: CommentScreen.routeName, arguments: args.post),
      builder: (_) => BlocProvider<CommentBloc>(
        create: (context) => CommentBloc(
            postRepo: context.read<PostRepo>(),
            authBloc: context.read<AuthBloc>(),
            commentPostCubit: context.read<CommentPostCubit>(),
            likePostCubit: context.read<LikePostCubit>())
          ..add(
            FetchCommentEvent(
              post: args.post,
              isLiked: args.isLiked,
              onLike: args.onLike,
              postAuthor: args.postAuthor,
              onPostDelete: args.onPostDelete,
              likes: args.likes,
              comments: args.comments,
            ),
          ),
        child: CommentScreen(),
      ),
    );
  }

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommentBloc, CommentState>(
        listener: (context, commentState) {
      if (commentState.status == CommentStatus.error) {
        showDialog(
          context: context,
          builder: (_) => ErrorDialog(message: commentState.failure.message),
        );
      }
    }, builder: (context, commentState) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.textMainColor),
            onPressed: () {
              context.read<NavBarCubit>().showNavBar();
              Navigator.of(context).pop();
            },
          ),
        ),
        bottomSheet: Container(
          color: AppColors.mainBackground,
          child: _buildCommentBottomSheet(commentState),
        ),
        body: Container(
          padding: context.read<AuthBloc>().state.status ==
                  AuthStatus.unauthenticated
              ? EdgeInsets.only(bottom: 0)
              : EdgeInsets.only(bottom: 80),
          color: Colors.black,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                  child: commentState.post == null
                      ? CircularProgressIndicator(
                          color: AppColors.liteGreenColor,
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              AppColors.liteGreenColor),
                          backgroundColor: AppColors.darkGreenColor,
                        )
                      : PostView(
                          isLiked: commentState.isLiked,
                          post: commentState.post!,
                          lastComment: null,
                          onLike: () {
                            if (context
                                .read<AuthBloc>()
                                .state
                                .user
                                .uid
                                .isEmpty) {
                              BotToast.showText(
                                  text: "Авторизуйтесь, чтобы оставить лайк");
                            } else {
                              context.read<CommentBloc>()..add(OnLikeEvent());
                            }
                          },
                          postAuthor: commentState.postAuthor,
                          onPostDelete: commentState.onPostDelete,
                          likes: commentState.likes,
                          comments: commentState.comments,
                        )),
              _buildComments(commentState)
            ],
          ),
        ),
      );
    });
  }

  Widget _buildComments(CommentState state) {
    return state.commentList.length == 0
        ? Container(
            child: SliverPadding(
            padding: EdgeInsets.zero,
          ))
        : state.status == CommentStatus.loading
            ? Center(
                child: CircularProgressIndicator(
                color: AppColors.liteGreenColor,
                valueColor:
                    new AlwaysStoppedAnimation<Color>(AppColors.liteGreenColor),
                backgroundColor: AppColors.darkGreenColor,
              ))
            : Container(
                child: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final comment = state.commentList[index];
                    return ListTile(
                      leading: GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          ProfileScreen.routeName,
                          arguments:
                              ProfileScreenArgs(userId: comment!.author.uid),
                        ),
                        child: UserProfileImage(
                          radius: 15,
                          profileImageURL: comment!.author.photo!,
                        ),
                      ),
                      title: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: comment.author.username,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 18.0),
                            ),
                            const TextSpan(text: " "),
                            TextSpan(
                                text: comment.content,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18.0)),
                          ],
                        ),
                      ),
                      subtitle: Text(
                        '${comment.dateTime.timeAgoExt()}',
                        style: TextStyle(
                          color: AppColors.greyColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      trailing: context.read<AuthBloc>().state.user.uid ==
                                  comment.author.uid ||
                              state.post!.author.uid ==
                                  context.read<AuthBloc>().state.user.uid
                          ? IconButton(
                              constraints: BoxConstraints(maxHeight: 18),
                              padding: new EdgeInsets.all(0),
                              iconSize: 18,
                              icon: Icon(
                                FontAwesomeIcons.trashAlt,
                                color: state.status == CommentStatus.submitting
                                    ? Colors.white38
                                    : Colors.white,
                              ),
                              onPressed: () {
                                context.read<CommentBloc>().add(
                                      DeleteCommentEvent(
                                          post: state.post!,
                                          comment: comment,
                                          previousComment: index == 0
                                              ? null
                                              : state.commentList.last),
                                    );
                              },
                            )
                          : null,
                    );
                  }, childCount: state.comments),
                ),
              );
  }

  Widget _buildCommentBottomSheet(CommentState state) {
    return context.read<AuthBloc>().state.status == AuthStatus.unauthenticated
        ? SizedBox()
        : Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state.status == CommentStatus.submitting)
                const LinearProgressIndicator(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: TextField(
                        enabled: state.status != CommentStatus.submitting,
                        controller: _commentController,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            filled: true,
                            fillColor: AppColors.darkGreenColor,
                            hintText: 'Написать комментарий...',
                            hintStyle: TextStyle(fontSize: 18.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(
                                  width: 5.0, color: AppColors.darkGreenColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(
                                    width: 1.0,
                                    color: AppColors.liteGreenColor))),
                        cursorColor: AppColors.textMainColor,
                        style: TextStyle(
                            fontSize: 18.0, color: AppColors.textMainColor),
                      ),
                    ),
                  ),
                  IconButton(
                    constraints: BoxConstraints(maxHeight: 36),
                    padding: new EdgeInsets.all(2.0),
                    iconSize: 36,
                    icon: Icon(
                      FontAwesomeIcons.comment,
                      color: state.status == CommentStatus.submitting
                          ? Colors.blueAccent
                          : AppColors.textMainColor,
                    ),
                    onPressed: state.status == CommentStatus.submitting ||
                            context.read<AuthBloc>().state.status ==
                                AuthStatus.unauthenticated
                        ? null
                        : () {
                            final commentText = _commentController.text.trim();
                            if (commentText.isNotEmpty) {
                              context.read<CommentBloc>().add(
                                    AddCommentEvent(content: commentText),
                                  );
                            }
                            _commentController.clear();
                          },
                  ),
                ],
              ),
            ],
          );
  }
}
