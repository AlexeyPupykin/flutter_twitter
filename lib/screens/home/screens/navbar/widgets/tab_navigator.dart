import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitter/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_twitter/blocs/blocs.dart';
import 'package:flutter_twitter/config/custom_router.dart';
import 'package:flutter_twitter/cubit/comment_post_cubit/comment_post_cubit.dart';
import 'package:flutter_twitter/cubit/like_post_cubit/like_post_cubit.dart';
import 'package:flutter_twitter/repositories/post/post_repository.dart';
import 'package:flutter_twitter/repositories/repositories.dart';
import 'package:flutter_twitter/screens/auth/login/login_screen.dart';
import 'package:flutter_twitter/screens/home/screens/create_post/cubit/create_post_cubit.dart';
import 'package:flutter_twitter/screens/home/screens/feed/bloc/feed_bloc.dart';
import 'package:flutter_twitter/screens/home/screens/navbar/cubit/navbar_cubit.dart';
import 'package:flutter_twitter/screens/home/screens/profile/profile_bloc/profile_bloc.dart';

import '../../screens.dart';

class TabNavigator extends StatelessWidget {
  static const String tabNavigatorRoot = "/";

  final GlobalKey<NavigatorState> navigatorKey;
  final NavBarItem item;

  const TabNavigator({Key? key, required this.navigatorKey, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Navigator(
        key: navigatorKey,
        initialRoute: tabNavigatorRoot,
        onGenerateInitialRoutes: (_, initialRoute) {
          return [
            MaterialPageRoute(
              settings: RouteSettings(name: tabNavigatorRoot),
              builder: (context) => _getScreen(context, item),
            ),
          ];
        },
        onGenerateRoute: CustomRoute.onGenerateNestedRoute,
      ),
      onWillPop: () async => false,
    );
  }

  Widget _getScreen(BuildContext context, NavBarItem item) {
    switch (item) {
      case NavBarItem.feed:
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return BlocProvider(
              create: (context) => FeedBloc(
                postRepo: context.read<PostRepo>(),
                authBloc: context.read<AuthBloc>(),
                likePostCubit: context.read<LikePostCubit>(),
                commentPostCubit: context.read<CommentPostCubit>(),
              )..add(FeedFetchEvent()),
              child: FeedScreen(),
            );
          },
        );

      case NavBarItem.create:
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state.status == AuthStatus.unauthenticated ||
                state.status == AuthStatus.unknown) {
              return LoginScreen();
            } else if (state.status == AuthStatus.authenticated) {
              return BlocProvider<CreatePostCubit>(
                create: (context) => CreatePostCubit(
                  authBloc: context.read<AuthBloc>(),
                  postRepo: context.read<PostRepo>(),
                  storageRepo: context.read<StorageRepo>(),
                ),
                child: CreatePostScreen(),
              );
            }
            return Scaffold();
          },
        );

      case NavBarItem.profile:
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state.status == AuthStatus.unauthenticated ||
                state.status == AuthStatus.unknown) {
              return LoginScreen();
            } else if (state.status == AuthStatus.authenticated) {
              return BlocProvider<ProfileBloc>(
                create: (_) => ProfileBloc(
                  userRepo: context.read<UserRepo>(),
                  authBloc: context.read<AuthBloc>(),
                  postRepo: context.read<PostRepo>(),
                  likePostCubit: context.read<LikePostCubit>(),
                  commentPostCubit: context.read<CommentPostCubit>(),
                )..add(
                    ProfileLoadEvent(
                      userId: context.read<AuthBloc>().state.user.uid,
                    ),
                  ),
                child: ProfileScreen(),
              );
            }
            return Scaffold();
          },
        );

      default:
        return Scaffold();
    }
  }
}
