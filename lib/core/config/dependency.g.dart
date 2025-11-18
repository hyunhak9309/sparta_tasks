// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dependency.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(database)
const databaseProvider = DatabaseProvider._();

final class DatabaseProvider
    extends
        $FunctionalProvider<
          FirebaseFirestore,
          FirebaseFirestore,
          FirebaseFirestore
        >
    with $Provider<FirebaseFirestore> {
  const DatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'databaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$databaseHash();

  @$internal
  @override
  $ProviderElement<FirebaseFirestore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirebaseFirestore create(Ref ref) {
    return database(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseFirestore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseFirestore>(value),
    );
  }
}

String _$databaseHash() => r'56c03d984da0b36197036b43d584798a0131a2f7';

@ProviderFor(toDoRepository)
const toDoRepositoryProvider = ToDoRepositoryProvider._();

final class ToDoRepositoryProvider
    extends $FunctionalProvider<ToDoRepository, ToDoRepository, ToDoRepository>
    with $Provider<ToDoRepository> {
  const ToDoRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'toDoRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$toDoRepositoryHash();

  @$internal
  @override
  $ProviderElement<ToDoRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ToDoRepository create(Ref ref) {
    return toDoRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ToDoRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ToDoRepository>(value),
    );
  }
}

String _$toDoRepositoryHash() => r'bc72fc4f112191548e4bbaf97e6e22db7c05241f';
