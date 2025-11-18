import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasks/data/model/to_do_model.dart';
import 'package:tasks/domain/repository/to_do_repository.dart';

class ToDoRepositoryImpl implements ToDoRepository {
  final FirebaseFirestore _db;
  ToDoRepositoryImpl({required FirebaseFirestore firebaseFirestore}) : _db = firebaseFirestore;

  @override
  Future<void> addToDo(ToDoModel toDo) async {
    await _db.collection('todos').doc(toDo.id).set(toDo.toJson());
  }

  @override
  Future<void> updateToDo(ToDoModel toDo) async {
    await _db.collection('todos').doc(toDo.id).update(toDo.toJson());
  }

  @override
  Future<void> deleteToDo(String id) async {
    await _db.collection('todos').doc(id).delete();
  }

  @override
  Future<List<ToDoModel>> getToDos() async {
    final snapshot = await _db
        .collection('todos')
        .orderBy('created_at', descending: true)
        .limit(15)
        .get();
    return snapshot.docs.map((doc) => ToDoModel.fromJson(doc.data())).toList();
  }

  @override
  Future<List<ToDoModel>> getMoreToDos(ToDoModel lastDoc) async {
    final snapshot = await _db
        .collection('todos')
        .orderBy('created_at', descending: true)
        .startAfter([lastDoc.createdAt.toIso8601String()])
        .limit(15)
        .get();
    return snapshot.docs.map((doc) => ToDoModel.fromJson(doc.data())).toList();
  }
}
