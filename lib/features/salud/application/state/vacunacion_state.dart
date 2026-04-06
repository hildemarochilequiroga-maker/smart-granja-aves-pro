import 'package:equatable/equatable.dart';
import '../../domain/entities/vacunacion.dart';

class VacunacionState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final Vacunacion? vacunacion;

  const VacunacionState({
    this.isLoading = false,
    this.errorMessage,
    this.vacunacion,
  });

  const VacunacionState.initial()
    : isLoading = false,
      errorMessage = null,
      vacunacion = null;

  const VacunacionState.loading()
    : isLoading = true,
      errorMessage = null,
      vacunacion = null;

  const VacunacionState.success(this.vacunacion)
    : isLoading = false,
      errorMessage = null;

  const VacunacionState.failure(this.errorMessage)
    : isLoading = false,
      vacunacion = null;

  @override
  List<Object?> get props => [isLoading, errorMessage, vacunacion];
}
