import 'package:dartz/dartz.dart';
import 'package:flutter_twitter/core/error/failure.dart';
import 'package:flutter_twitter/features/domain/entities/person_entity.dart';

abstract class PersonRepository {
  Future<Either<Failure, List<PersonEntity>>> getAllPersons(int page);
  Future<Either<Failure, List<PersonEntity>>> searchPerson(String query);
}
