/// Definiciones de tipos globales para la aplicación
library;

import 'dart:async';

import 'package:dartz/dartz.dart';

import '../errors/failures.dart';

/// Resultado asíncrono que puede ser un Failure o un valor de tipo T
typedef FutureResult<T> = Future<Either<Failure, T>>;

/// Resultado síncrono que puede ser un Failure o un valor de tipo T
typedef Result<T> = Either<Failure, T>;
