import 'package:dartz/dartz.dart';
import 'package:flutter_twitter/core/error/failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
