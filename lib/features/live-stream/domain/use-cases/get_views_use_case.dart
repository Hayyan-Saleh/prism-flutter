import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/live-stream/domain/repository/chat_repository.dart';

class GetViewsUseCase {
  final ChatRepository repository;

  GetViewsUseCase(this.repository);

  Either<AppFailure, Stream<int>> call() {
    return repository.getViews();
  }
}
