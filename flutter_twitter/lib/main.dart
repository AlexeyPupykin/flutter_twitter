import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitter/common/app_colors.dart';
import 'package:flutter_twitter/features/presentation/bloc/person_list_cubit/person_list_cubit.dart';
import 'package:flutter_twitter/features/presentation/bloc/search_bloc/search_bloc.dart';
import 'package:flutter_twitter/locator_service.dart' as di;

import 'locator_service.dart';
// import 'pages/home_page.dart';
import 'pages/persons_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PersonListCubit>(
            create: (context) => sl<PersonListCubit>()),
        BlocProvider<PersonSearchBloc>(
            create: (context) => sl<PersonSearchBloc>()),
      ],
      child: MaterialApp(
        theme: ThemeData.dark().copyWith(
          backgroundColor: AppColors.mainBackground,
          scaffoldBackgroundColor: AppColors.mainBackground,
        ),
        home: HomePage(),
      ),
    );
  }
}
