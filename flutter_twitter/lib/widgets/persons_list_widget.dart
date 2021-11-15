import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitter/features/domain/entities/person_entity.dart';
import 'package:flutter_twitter/features/presentation/bloc/person_list_cubit/person_list_cubit.dart';
import 'package:flutter_twitter/features/presentation/bloc/person_list_cubit/person_list_state.dart';
import 'package:flutter_twitter/widgets/person_card_widget.dart';

class PersonsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonListCubit, PersonState>(
      builder: (context, state) {
        List<PersonEntity> persons = [];
        // if (state is PersonLoading && state.isFirstFetch) {
        //   return _loadingIndicator();
        // } else if (state is PersonLoaded) {
        //   persons = state.personsList;
        // }
        return Container();
        // return ListView.separated(
        //     itemBuilder: (context, index) {
        //       return Text('${persons[index]}');
        //       // return PersonCard(person: persons[index]);
        //     },
        //     separatorBuilder: (context, index) {
        //       return Divider(
        //         color: Colors.grey[400],
        //       );
        //     },
        //     itemCount: persons.length);
      },
    );
  }

  Widget _loadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
