import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tasks/core/config/dependency.dart';
import 'package:tasks/core/utils/logger.dart';
import 'package:tasks/data/model/to_do_model.dart';
import 'package:tasks/data/repository_impl/to_do_repository_impl.dart';
import 'package:uuid/uuid.dart';

part 'home_page_view_model.g.dart';

@riverpod
class HomePageViewModel extends _$HomePageViewModel {

  @override
  Future<List<ToDoModel>> build() async {
    return await ref.read(toDoRepositoryProvider).getToDos();
  }

  Future<void> addTodo({required ToDoModel toDo}) async {
    state = AsyncValue.loading();
    state = AsyncData([...state.value!, toDo]);
    await ref.read(toDoRepositoryProvider).addToDo(toDo);
  }

  // Future<void> addTodo2() async {
  //   final newTodo = ToDoModel(
  //     id: const Uuid().v4(),
  //     title: 'New Todo ${state.value!.length + 1}',
  //     description: 'New Todo Description ${state.value!.length + 1}',
  //     isFavorite: false,
  //     isDone: false, createdAt: DateTime.now(),
  //   );
  //   state = AsyncData([...state.value!, newTodo]);
  //   await toDoRepository.addToDo(newTodo);
  // }

  Future<void> refresh() async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref.read(toDoRepositoryProvider).getToDos();
    });
  }

  Future<void> loadMore() async {
    if (!state.isLoading) {
      state = AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        final moreTodos = await ref.read(toDoRepositoryProvider).getMoreToDos(state.value!.last);
        logger.d(moreTodos);
        return [...state.value!, ...moreTodos];
      });
    }
  }

  Future<void> toggleFavorite({
    required String id,
    required bool isFavorite,
  }) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final todo = state.value!.firstWhere((element) => element.id == id);
      final updatedTodo = todo.copyWith(isFavorite: isFavorite);
      await ref.read(toDoRepositoryProvider).updateToDo(updatedTodo);
      return [
        for (final t in state.value!)
          if (t.id == id) updatedTodo else t,
      ];
    });
  }

  Future<void> toggleDone({required String id, required bool isDone}) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final todo = state.value!.firstWhere((element) => element.id == id);
      final updatedTodo = todo.copyWith(isDone: isDone);
      await ref.read(toDoRepositoryProvider).updateToDo(updatedTodo);
      return [
        for (final t in state.value!)
          if (t.id == id) updatedTodo else t,
      ];
    });
  }

  Future<void> deleteTodo({required String id}) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(toDoRepositoryProvider).deleteToDo(id);
      return state.value!.where((element) => element.id != id).toList();
    });
  }
}
