import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_twitter/blocs/blocs.dart';
import 'package:flutter_twitter/common/app_colors.dart';
import 'package:flutter_twitter/cubit/comment_post_cubit/comment_post_cubit.dart';
import 'package:flutter_twitter/cubit/like_post_cubit/like_post_cubit.dart';
import 'package:flutter_twitter/repositories/repositories.dart';
import 'package:flutter_twitter/widgets/widgets.dart';

import 'profile_bloc/profile_bloc.dart';
import 'widgets/widgets.dart';

class ProfileScreenArgs {
  final String userId;

  ProfileScreenArgs({required this.userId});
}

class ProfileScreen extends StatefulWidget {
  static const String routeName = "/profile";

  static Route route({
    required ProfileScreenArgs args,
  }) {
    return MaterialPageRoute(
      settings: RouteSettings(name: ProfileScreen.routeName),
      builder: (context) => BlocProvider<ProfileBloc>(
        create: (_) => ProfileBloc(
          userRepo: context.read<UserRepo>(),
          authBloc: context.read<AuthBloc>(),
          postRepo: context.read<PostRepo>(),
          commentPostCubit: context.read<CommentPostCubit>(),
          likePostCubit: context.read<LikePostCubit>(),
        )..add(ProfileLoadEvent(userId: args.userId)),
        child: ProfileScreen(),
      ),
    );
  }

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        var status = context.read<ProfileBloc>().state.status;
        if (_scrollController.offset >=
                _scrollController.position.maxScrollExtent * 0.75 &&
            !_scrollController.position.outOfRange &&
            status != ProfileStatus.paginating &&
            status != ProfileStatus.failure) {
          context.read<ProfileBloc>().add(ProfilePaginateEvent(
              userId: context.read<ProfileBloc>().state.user.uid));
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
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, profileState) {
        if (profileState.status == ProfileStatus.failure) {
          //closing the existing dialog if exits during loading
          Navigator.of(context, rootNavigator: true).pop();
          BotToast.closeAllLoading();
          BotToast.showText(text: profileState.failure.message);
          //showing the error dialog if error exists

          showDialog(
            context: context,
            builder: (context) {
              return ErrorDialog(
                title: "Error signing in",
                message: profileState.failure.message,
              );
            },
          );
        }
      },
      builder: (context, profileState) {
        return Container(
            color: AppColors.mainBackground, child: _buildBody(profileState));
      },
    );
  }

  Widget _buildBody(ProfileState profileState) {
    switch (profileState.status) {
      case ProfileStatus.loading:
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      default:
        return Scaffold(
          appBar: AppBar(
            title: Text(profileState.user.username ?? "no username"),
            centerTitle: true,
            actions: [
              if (profileState.isCurrentUser != null &&
                  profileState.isCurrentUser!)
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        context: context,
                        builder: (context) =>
                            _buildProfileModal(context, profileState));
                  },
                  icon: Icon(FontAwesomeIcons.bars),
                )
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              context
                  .read<ProfileBloc>()
                  .add(ProfileLoadEvent(userId: profileState.user.uid));
              await Future.delayed(
                Duration(milliseconds: 500),
              );
              return; //true return will remove refresh indicator go away
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                _buildProfileHeader(profileState),
                _buildProfilePosts(profileState),
              ],
            ),
          ),
        );
    }
  }

  Widget _buildProfileModal(BuildContext context, ProfileState state) {
    return Container(
      color: AppColors.darkGreenColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Скопировать ссылку",
                      style: TextStyle(
                        color: AppColors.textMainColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (!state.isCurrentUser!)
              TextButton(
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
            if (state.isCurrentUser!)
              Divider(
                thickness: 1,
              ),
            if (state.isCurrentUser!)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<AuthBloc>().add(AuthLogoutRequestedEvent());
                  context.read<LikePostCubit>().clearAllLikedPost();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Выйти",
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

  Widget _buildProfileHeader(ProfileState state) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      UserProfileImage(
                        radius: MediaQuery.of(context).size.width / 8,
                        profileImageURL: state.user.photo,
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        state.user.username!,
                        style: TextStyle(fontSize: 24.0),
                      )
                    ],
                  ),
                  SizedBox(width: 16.0),
                  Container(
                    width: MediaQuery.of(context).size.width * 2 / 3 - 36,
                    child: ProfileInfo(
                      fullName: state.user.displayName ?? "",
                      gender: state.user.gender ?? "",
                      dateOfBirth: state.user.dateOfBirth,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ProfileButton(
                isCurrentUser: state.isCurrentUser,
                isFollowing: state.isFollowing,
              ),
            ),
            ProfileStats(
              isCurrentUser: state.isCurrentUser,
              isFollowing: state.isFollowing,
              posts: state.user.posts ?? 0,
              followers: state.user.followers ?? 0,
              following: state.user.following ?? 0,
            ),
            Divider(
              height: 0,
              thickness: 2,
              indent: 0,
              endIndent: 0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePosts(ProfileState state) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final post = state.posts[index];
          if (post == null) {
            return null;
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
                  builder: (dialogContext) {
                    return ConfirmationDialog(
                        message: "Вы уверены, что хотите удалить свой пост?",
                        cancelText: "Отмена",
                        continueText: "Удалить",
                        cancelOnPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        continueOnPressed: () {
                          Navigator.of(dialogContext).pop();
                          context
                              .read<ProfileBloc>()
                              .add(ProfileDeletePostEvent(post: post));
                        });
                  });
            },
          );
        },
        childCount: state.posts.length,
      ),
    );
  }
}
