import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitter/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_twitter/cubit/cubits.dart';
import 'package:flutter_twitter/models/models.dart';
import 'package:flutter_twitter/repositories/repositories.dart';
import 'package:flutter_twitter/screens/home/screens/navbar/cubit/NavBarCubit.dart';
import 'package:flutter_twitter/widgets/widgets.dart';

import 'bloc/feed_bloc.dart';

class FeedScreen extends StatefulWidget {
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        var status = context.read<FeedBloc>().state.status;
        if (_scrollController.offset >=
                _scrollController.position.maxScrollExtent * 0.75 &&
            !_scrollController.position.outOfRange &&
            status != FeedStatus.paginating &&
            status != FeedStatus.failure) {
          context.read<FeedBloc>().add(FeedPaginateEvent());
        }
      });
  }

  @override
  void dispose() {
    _scrollController..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeedBloc, FeedState>(
      listener: (context, feedState) {
        if (feedState.status == FeedStatus.failure) {
          showDialog(
            context: context,
            builder: (context) =>
                ErrorDialog(message: feedState.failure.message),
          );
        } else if (feedState.status == FeedStatus.paginating) {}
      },
      builder: (context, feedState) {
        return Scaffold(
          appBar: AppBar(
            title: Text("flutter_twitter"),
            actions: [
              if (feedState.posts.isEmpty &&
                  feedState.status == FeedStatus.loaded)
                IconButton(
                  onPressed: () =>
                      context.read<FeedBloc>().add(FeedFetchEvent()),
                  icon: Icon(
                    Icons.refresh,
                  ),
                ),
            ],
          ),
          body: _buildBody(feedState),
        );
      },
    );
  }

  Widget _buildBody(FeedState feedState) {
    switch (feedState.status) {
      case FeedStatus.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );

      default:
        return RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(
              Duration(milliseconds: 300),
            );
            context.read<FeedBloc>().add(FeedFetchEvent());
          },
          child: ListView.builder(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            itemCount: feedState.posts.length,
            itemBuilder: (context, index) {
              final post = feedState.posts[index];
              if (post == null) {
                return SizedBox();
              }
              final commentPostState = context.watch<CommentPostCubit>().state;
              final likedPostState = context.watch<LikePostCubit>().state;
              final isLiked = likedPostState.likedPostIds.contains(post.id);
              return PostView(
                postAuthor:
                    post.author.uid == context.read<AuthBloc>().state.user.uid,
                post: post,
                lastComment: commentPostState.comments.containsKey(post.id)
                    ? commentPostState.comments[post.id]
                    : null,
                isLiked: isLiked,
                likes: likedPostState.postsLikes.containsKey(post.id)
                    ? likedPostState.postsLikes[post.id]
                    : null,
                comments: commentPostState.commentsCount.containsKey(post.id)
                    ? commentPostState.commentsCount[post.id]
                    : null,
                onLike: () {
                  if (context.read<AuthBloc>().state.user.uid.isEmpty) {
                    BotToast.showText(text: "login to like");
                  } else {
                    if (isLiked) {
                      context.read<LikePostCubit>().unLikePost(post: post);
                    } else {
                      context.read<LikePostCubit>().likePost(post: post);
                    }
                  }
                },
                onPostDelete: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ConfirmationDialog(
                            message:
                                "Вы уверены, что хотите удалить свой пост?",
                            cancelText: "Отмена",
                            continueText: "Удалить",
                            cancelOnPressed: () => Navigator.of(context).pop,
                            continueOnPressed: () => context
                                .read<FeedBloc>()
                                .add(FeedDeletePostEvent(post: post)));
                      });
                },
              );
            },
          ),
        );
    }
  }

  // Widget _buildShowFirebaseUsers() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Expanded(
  //               child: Text(
  //                 'Suggestions for You',
  //                 style: const TextStyle(
  //                     fontWeight: FontWeight.w600, fontSize: 15),
  //               ),
  //             ),
  //             TextButton(
  //               onPressed: () {},
  //               child: Text(
  //                 'See All',
  //                 style: const TextStyle(fontSize: 15, color: Colors.blue),
  //               ),
  //             )
  //           ],
  //         ),
  //         StreamBuilder<List<User>>(
  //             stream: UserRepo().getAllFirebaseUsers(),
  //             builder: (context, snapshot) {
  //               if (snapshot.hasData) {
  //                 final userList = snapshot.data;
  //                 if (userList == null) {
  //                   return Container(
  //                     height: 160,
  //                     child: Align(child: Text("Unable to fetch users")),
  //                   );
  //                 }
  //                 return Container(
  //                   height: 160,
  //                   child: ListView.builder(
  //                     padding: EdgeInsets.only(right: 10),
  //                     scrollDirection: Axis.horizontal,
  //                     itemCount: userList.length,
  //                     itemBuilder: (BuildContext context, int index) {
  //                       final user = userList[index];
  //                       return SuggestionTile(user: user);
  //                     },
  //                   ),
  //                 );
  //               } else if (snapshot.hasError) {
  //                 return Icon(Icons.error_outline);
  //               } else {
  //                 return CircularProgressIndicator();
  //               }
  //             })
  //       ],
  //     ),
  //   );
  // }
}