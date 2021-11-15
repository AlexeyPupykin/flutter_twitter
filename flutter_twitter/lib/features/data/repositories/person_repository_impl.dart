import 'package:flutter_twitter/core/platform/network_info.dart';
import 'package:flutter_twitter/features/data/datascources/person_local_data_source.dart';
import 'package:flutter_twitter/features/data/datascources/person_remote_data_source.dart';
import 'package:flutter_twitter/features/data/models/person_model.dart';
import 'package:flutter_twitter/features/domain/entities/person_entity.dart';
import 'package:flutter_twitter/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_twitter/features/domain/repositories/person_repository.dart';
import 'package:meta/meta.dart';

class PersonRepositoryImpl implements PersonRepository {
  final PersonRemoteDataSource? remoteDataSource;
  final PersonLocalDataSource? localDataSource;
  final NetworkInfo? networkInfo;

  PersonRepositoryImpl(
      {@required this.remoteDataSource,
      @required this.localDataSource,
      @required this.networkInfo});

  @override
  Future<Either<Failure, List<PersonEntity>>> getAllPersons(int page) async {
    return await _getPersons(() {
      return remoteDataSource!.getAllPersons(page);
    });
  }

  @override
  Future<Either<Failure, List<PersonEntity>>> searchPerson(String query) async {
    return await _getPersons(() {
      return remoteDataSource!.searchPerson(query);
    });
  }

  Future<Either<Failure, List<PersonModel>>> _getPersons(
      Future<List<PersonModel>> Function() getPersons) async {
    if (await networkInfo!.isConnected) {
      try {
        final persons = await getPersons();
        localDataSource!.personsToCache(persons);
        return Right(persons);
      } on ServerFailure {
        return Left(ServerFailure());
      }
    } else {
      try {
        final locationPerson = await localDataSource!.getLastPersonsFromCache();
        return Right(locationPerson);
      } on CacheFailure {
        return Left(CacheFailure());
      }
    }
  }
}
