import 'package:equatable/equatable.dart';
import '../../domain/entities/salud_registro.dart';

class SaludState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final SaludRegistro? registro;

  const SaludState({this.isLoading = false, this.errorMessage, this.registro});

  const SaludState.initial()
    : isLoading = false,
      errorMessage = null,
      registro = null;

  const SaludState.loading()
    : isLoading = true,
      errorMessage = null,
      registro = null;

  const SaludState.success(this.registro)
    : isLoading = false,
      errorMessage = null;

  const SaludState.failure(this.errorMessage)
    : isLoading = false,
      registro = null;

  @override
  List<Object?> get props => [isLoading, errorMessage, registro];
}
