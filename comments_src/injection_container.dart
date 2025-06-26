import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:your_app/core/network/network_info.dart';
import 'package:your_app/features/comments/data/datasources/comment_remote_data_source.dart';
import 'package:your_app/features/comments/data/repositories/comment_repository_impl.dart';
import 'package:your_app/features/comments/domain/repositories/comment_repository.dart';
import 'package:your_app/features/comments/domain/usecases/add_comment.dart';
import 'package:your_app/features/comments/domain/usecases/delete_comment.dart';
import 'package:your_app/features/comments/domain/usecases/get_comments.dart';
import 'package:your_app/features/comments/domain/usecases/like_comment.dart';
import 'package:your_app/features/comments/domain/usecases/unlike_comment.dart';
import 'package:your_app/features/comments/domain/usecases/update_comment.dart';
import 'package:your_app/features/comments/presentation/bloc/comment_bloc.dart';

final sl = GetIt.instance;

Future<void> initCommentsDependencies() async {
  // BLoC
  sl.registerFactory(
    () => CommentBloc(
      getComments: sl(),
      addComment: sl(),
      updateComment: sl(),
      deleteComment: sl(),
      likeComment: sl(),
      unlikeComment: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetComments(sl()));
  sl.registerLazySingleton(() => AddComment(sl()));
  sl.registerLazySingleton(() => UpdateComment(sl()));
  sl.registerLazySingleton(() => DeleteComment(sl()));
  sl.registerLazySingleton(() => LikeComment(sl()));
  sl.registerLazySingleton(() => UnlikeComment(sl()));

  // Repository
  sl.registerLazySingleton<CommentRepository>(
    () => CommentRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Data sources
  sl.registerLazySingleton<CommentRemoteDataSource>(
    () => CommentRemoteDataSourceImpl(firestore: sl()),
  );
}

Future<void> initCoreDependencies() async {
  // Network info
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
}

Future<void> initExternalDependencies() async {
  // Firebase
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  // Internet connection checker
  sl.registerLazySingleton(() => InternetConnectionChecker());
}

Future<void> init() async {
  // Initialize external dependencies first
  await initExternalDependencies();

  // Then core dependencies
  await initCoreDependencies();

  // Finally feature-specific dependencies
  await initCommentsDependencies();
}
