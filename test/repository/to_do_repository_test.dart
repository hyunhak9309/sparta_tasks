import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasks/data/repository_impl/to_do_repository_impl.dart';
import 'package:tasks/data/model/to_do_model.dart';

/// 테스트 로그 유틸 함수
void log(String m) {
  final ts = DateTime.now().toIso8601String();
  print('[$ts][ToDoRepoTest] $m');
}

void main() {
  late FakeFirebaseFirestore fakeDb;
  late ToDoRepositoryImpl repository;

  setUp(() {
    log('------------------------------');
    log('setUp: FakeFirebaseFirestore 초기화');
    fakeDb = FakeFirebaseFirestore();
    repository = ToDoRepositoryImpl(firebaseFirestore: fakeDb);
  });

  tearDown(() async {
    // 각 테스트 끝나고 현재 todos 상태를 출력
    final snapshot = await fakeDb.collection('todos').get();
    log('tearDown: 현재 todos 문서 수 = ${snapshot.docs.length}');
    for (final doc in snapshot.docs) {
      log('  - docId=${doc.id}, data=${doc.data()}');
    }
  });

  test('addToDo should create a document', () async {
    log('=== [TEST] addToDo should create a document 시작 ===');

    final todo = ToDoModel(
      id: '1',
      title: 'Test',
      createdAt: DateTime.now(),
      description: '',
      isFavorite: false,
      isDone: false,
    );

    log('1) addToDo 호출 전, todos 컬렉션 상태 확인');
    final before = await fakeDb.collection('todos').get();
    log('   - 기존 문서 수: ${before.docs.length}');

    log('2) repository.addToDo(todo) 호출');
    await repository.addToDo(todo);

    log('3) repository.getToDos() 호출로 저장 결과 확인');
    final todos = await repository.getToDos();
    log('   - getToDos 결과 length: ${todos.length}');
    if (todos.isNotEmpty) {
      log('   - 첫 번째 todo: id=${todos.first.id}, title=${todos.first.title}');
    }

    expect(
      todos.length,
      1,
      reason: 'addToDo 이후 todos 컬렉션에는 정확히 1개의 문서가 있어야 합니다.',
    );
    expect(
      todos.first.title,
      'Test',
      reason: '저장된 todo의 title은 "Test" 여야 합니다.',
    );

    log('=== [TEST] addToDo should create a document 종료 ===');
  });

  test('getToDos should return list of todos ordered by created_at desc', () async {
    log('=== [TEST] getToDos should return list of todos ordered by created_at desc 시작 ===');

    final now = DateTime.now();

    log('1) Fake Firestore에 두 개의 todo 문서를 직접 삽입 (created_at 오름차순)');
    await fakeDb.collection('todos').doc('1').set({
      'id': '1',
      'title': 'A',
      'created_at': now.toIso8601String(),
      'is_favorite': false,
      'is_done': false,
      'description': '',
    });
    log('   - doc 1 삽입: title=A, created_at=${now.toIso8601String()}');

    await fakeDb.collection('todos').doc('2').set({
      'id': '2',
      'title': 'B',
      'created_at': now.add(const Duration(seconds: 1)).toIso8601String(),
      'is_favorite': false,
      'is_done': false,
      'description': '',
    });
    log('   - doc 2 삽입: title=B, created_at=${now.add(const Duration(seconds: 1)).toIso8601String()}');

    log('2) repository.getToDos() 호출');
    final result = await repository.getToDos();
    log('   - getToDos 결과 length: ${result.length}');
    for (final todo in result) {
      log('   - todo: id=${todo.id}, title=${todo.title}, createdAt=${todo.createdAt.toIso8601String()}');
    }

    expect(
      result.length,
      2,
      reason: '테스트 데이터로 2개의 todo를 넣었으므로, 결과는 2개여야 합니다.',
    );
    expect(
      result.first.title,
      'B',
      reason: 'created_at 기준 내림차순 정렬이므로 가장 나중에 생성된 B가 첫 번째여야 합니다.',
    );

    log('=== [TEST] getToDos should return list of todos ordered by created_at desc 종료 ===');
  });

  test('deleteToDo removes the document', () async {
    log('=== [TEST] deleteToDo removes the document 시작 ===');

    log('1) Fake Firestore에 doc 1 삽입');
    await fakeDb.collection('todos').doc('1').set({
      'id': '1',
      'title': 'A',
      'created_at': DateTime.now().toIso8601String(),
      'is_favorite': false,
      'is_done': false,
      'description': '',
    });

    final before = await fakeDb.collection('todos').get();
    log('   - 삭제 전 문서 수: ${before.docs.length}');

    log('2) repository.deleteToDo("1") 호출');
    await repository.deleteToDo('1');

    log('3) Firestore에서 doc 1 조회해 존재 여부 확인');
    final doc = await fakeDb.collection('todos').doc('1').get();
    log('   - 삭제 후 doc.exists: ${doc.exists}');

    expect(
      doc.exists,
      false,
      reason: 'deleteToDo 호출 후 해당 문서는 존재하면 안 됩니다.',
    );

    log('=== [TEST] deleteToDo removes the document 종료 ===');
  });
}