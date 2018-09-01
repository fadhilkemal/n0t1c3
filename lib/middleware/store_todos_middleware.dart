// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';
import 'package:notice/actions/actions.dart';
import 'package:notice/models/models.dart';
import 'package:notice/selectors/selectors.dart';
import 'package:notice/database/transaction/main.dart';
import 'package:notice/database/category/main.dart';
import 'package:notice/database/category/file_storage.dart';
import 'package:notice/tr_copy/todos_repository.dart';
import 'package:notice/trf_copy/todos_repository_flutter.dart';

List<Middleware<AppState>> createStoreTodosMiddleware([
  TodosRepository repository = const TodosRepositoryFlutter(
    fileStorage: const FileStorage(
      '__redux_app__',
      getApplicationDocumentsDirectory,
    ),
  ),
  categRepository = const CategRepositoryFlutter(
    fileStorage: const CategFileStorage(
      '__redux_app__categ',
      getApplicationDocumentsDirectory,
    ),
  ),
  transactionRepo = const TransactionRepositoryFlutter(),
]) {
  final saveTodos = _createSaveTodos(repository);
  final loadTodos = _createLoadTodos(repository);
  final saveCateg = _createSaveCateg(categRepository);
  final loadCateg = _createLoadCateg(categRepository);
  final saveTransaction = _createSaveTransaction(transactionRepo);

  return [
    TypedMiddleware<AppState, LoadTodosAction>(loadTodos),
    TypedMiddleware<AppState, AddTodoAction>(saveTodos),
    TypedMiddleware<AppState, ClearCompletedAction>(saveTodos),
    TypedMiddleware<AppState, ToggleAllAction>(saveTodos),
    TypedMiddleware<AppState, UpdateTodoAction>(saveTodos),
    TypedMiddleware<AppState, TodosLoadedAction>(saveTodos),
    TypedMiddleware<AppState, DeleteTodoAction>(saveTodos),
    TypedMiddleware<AppState, LoadCategAction>(loadCateg),
    TypedMiddleware<AppState, CategoriesLoadedAction>(saveCateg),
    TypedMiddleware<AppState, SaveTransaction>(saveTransaction),
  ];
}

Middleware<AppState> _createSaveTodos(TodosRepository repository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    next(action);

    repository.saveTodos(
      todosSelector(store.state).map((todo) => todo.toEntity()).toList(),
    );
  };
}

Middleware<AppState> _createLoadTodos(TodosRepository repository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    repository.loadTodos().then(
      (todos) {
        store.dispatch(
          TodosLoadedAction(
            todos.map(Todo.fromEntity).toList(),
          ),
        );
      },
    ).catchError((_) => store.dispatch(TodosNotLoadedAction()));

    next(action);
  };
}

Middleware<AppState> _createLoadCateg(CategRepositoryFlutter categRepository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    categRepository.loadCateg().then(
      (categ) {
        var eja = categ.map(Category.fromEntity).toList();
        store.dispatch(
          CategoriesLoadedAction(eja),
        );
        return eja;
      },
    ).then((categ) {
      if (categ.isNotEmpty) {
        store.dispatch(UpdateCategoryAction(categ.first.name));
      }
    });

    next(action);
  };
}

Middleware<AppState> _createSaveCateg(CategRepositoryFlutter categRepository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    next(action);
    categRepository.saveCateg(
      action.category.map((categ) => categ.name).toList(),
    );
  };
}

Middleware<AppState> _createSaveTransaction(
    TransactionRepositoryFlutter transactionRepo) {
  return (Store<AppState> store, action, NextDispatcher next) {
    transactionRepo.saveTransaction(action.payload).then(
      (result) {
        store.dispatch(ClearCompletedAction());
      },
    );
    ;
    next(action);
  };
}
