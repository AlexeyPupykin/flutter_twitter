import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_twitter/core/error/failure.dart';
import 'package:flutter_twitter/core/usecases/usecase.dart';
import 'package:flutter_twitter/features/domain/entities/person_entity.dart';
import 'package:flutter_twitter/features/domain/repositories/person_repository.dart';

class SearchPerson extends UseCase<List<PersonEntity>, SearchPersonParams> {
  final PersonRepository personRepository;

  SearchPerson(this.personRepository);

  @override
  Future<Either<Failure, List<PersonEntity>>> call(
      SearchPersonParams params) async {
    return await personRepository.searchPerson(params.query);
  }
}

class SearchPersonParams extends Equatable {
  final String query;

  const SearchPersonParams({required this.query});

  @override
  List<Object?> get props => [query];
}
