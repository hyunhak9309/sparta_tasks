import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tasks/data/repository_impl/to_do_repository_impl.dart';
import 'package:tasks/domain/repository/to_do_repository.dart';

part 'dependency.g.dart';

@riverpod
FirebaseFirestore database(ref) => FirebaseFirestore.instance;

@riverpod
ToDoRepository toDoRepository(ref) => ToDoRepositoryImpl(firebaseFirestore: ref.read(databaseProvider));


