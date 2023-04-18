import 'package:fpdart/fpdart.dart';
import 'package:sensei/core/failure.dart';
import 'package:sensei/models/user_model.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;
