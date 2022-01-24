import 'package:authentication_repository/authentication_repository.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitter/common/app_colors.dart';
import 'package:flutter_twitter/cubit/comment_post_cubit/comment_post_cubit.dart';
import 'package:flutter_twitter/cubit/like_post_cubit/like_post_cubit.dart';
import 'package:flutter_twitter/repositories/repositories.dart';
import 'package:flutter_twitter/screens/home/screens/comment/bloc/comment_bloc.dart';
import 'package:flutter_twitter/screens/home/screens/create_post/cubit/create_post_cubit.dart';
import 'package:flutter_twitter/screens/home/screens/profile/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:flutter_twitter/screens/home/screens/profile/profile_bloc/profile_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeAgo;

import 'blocs/blocs.dart';
import 'config/custom_router.dart';
import 'screens/auth/login/cubit/login_cubit.dart';
import 'screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final authRepo = AuthRepo();
  await authRepo.user.first;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? onboardingFinished = prefs.getBool("onboardingFinished");
  timeAgo.setLocaleMessages('ru', timeAgo.RuMessages());

  BlocOverrides.runZoned(
    () => runApp(MyApp(
      authenticationRepository: authRepo,
      onboardingFinished: onboardingFinished ?? false,
    )),
  );
}

class MyApp extends StatelessWidget {
  const MyApp(
      {Key? key,
      required AuthRepo authenticationRepository,
      required bool onboardingFinished})
      : authRepo = authenticationRepository,
        onboardingFinished = onboardingFinished,
        super(key: key);

  final bool onboardingFinished;
  final AuthRepo authRepo;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepo>(
          create: (_) => UserRepo(),
        ),
        RepositoryProvider<AuthRepo>(
          create: (_) => AuthRepo(),
        ),
        RepositoryProvider<StorageRepo>(
          create: (_) => StorageRepo(),
        ),
        RepositoryProvider<PostRepo>(
          create: (_) => PostRepo(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepo: authRepo,
              onboardingFinished: onboardingFinished,
            ),
          ),
          BlocProvider<LoginCubit>(
            create: (context) => LoginCubit(
              authRepo,
              context.read<UserRepo>(),
            ),
          ),
          BlocProvider<CommentPostCubit>(
            create: (context) => CommentPostCubit(
              postRepo: context.read<PostRepo>(),
              authBloc: context.read<AuthBloc>(),
            ),
          ),
          BlocProvider<LikePostCubit>(
            create: (context) => LikePostCubit(
              postRepo: context.read<PostRepo>(),
              authBloc: context.read<AuthBloc>(),
            ),
          ),
          BlocProvider<ProfileBloc>(
            create: (context) => ProfileBloc(
              authBloc: context.read<AuthBloc>(),
              postRepo: context.read<PostRepo>(),
              userRepo: context.read<UserRepo>(),
              likePostCubit: context.read<LikePostCubit>(),
              commentPostCubit: context.read<CommentPostCubit>(),
            ),
          ),
          BlocProvider<CommentBloc>(
            create: (context) => CommentBloc(
              authBloc: context.read<AuthBloc>(),
              postRepo: context.read<PostRepo>(),
              commentPostCubit: context.read<CommentPostCubit>(),
              likePostCubit: context.read<LikePostCubit>(),
            ),
          ),
          BlocProvider<CreatePostCubit>(
            create: (context) => CreatePostCubit(
              authBloc: context.read<AuthBloc>(),
              postRepo: context.read<PostRepo>(),
              storageRepo: context.read<StorageRepo>(),
            ),
          ),
          BlocProvider<EditProfileCubit>(
            create: (context) => EditProfileCubit(
              userRepo: context.read<UserRepo>(),
              storageRepo: context.read<StorageRepo>(),
              profileBloc: context.read<ProfileBloc>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: "flutter_twitter",
          themeMode: ThemeMode.dark,
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.mainBackground,
            // shadowColor: AppColors.liteGreenColor,
            dialogBackgroundColor: AppColors.liteGreenColor,
            selectedRowColor: AppColors.liteGreenColor,
            backgroundColor: AppColors.mainBackground,
            colorScheme: ColorScheme.highContrastDark(),
            appBarTheme: AppBarTheme(
              toolbarHeight: 72.0,
              elevation: 2.0,
              color: AppColors.darkGreenColor,
              centerTitle: true,
              titleTextStyle: TextStyle(
                color: AppColors.textMainColor,
                fontFamily: 'Lato',
                fontSize: 24,
                fontWeight: FontWeight.w400,
              ),
              iconTheme: IconThemeData(
                color: AppColors.textMainColor,
              ),
            ),
          ),
          debugShowCheckedModeBanner: false,
          builder: BotToastInit(),
          navigatorObservers: [
            BotToastNavigatorObserver(),
          ],
          onGenerateRoute: CustomRoute.onGenerateRoute,
          initialRoute: SplashScreen.routeName,
        ),
      ),
    );
  }
}
