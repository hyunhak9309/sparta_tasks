import 'package:tasks/data/model/to_do_model.dart';

abstract class ToDoRepository {
  Future<void> addToDo(ToDoModel toDo);
  Future<void> updateToDo(ToDoModel toDo);
  Future<void> deleteToDo(String id);
  Future<List<ToDoModel>> getToDos();
  Future<List<ToDoModel>> getMoreToDos(ToDoModel lastDoc);
}
