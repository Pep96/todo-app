import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/todo.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  late Box<Todo> _todoBox;
  final _uuid = const Uuid();

  TodoBloc() : super(TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<UpdateTodo>(_onUpdateTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<ToggleTodo>(_onToggleTodo);
    on<FilterTodos>(_onFilterTodos);
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      _todoBox = Hive.box<Todo>('todos');
      final todos = _todoBox.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(TodoLoaded(todos: todos));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      final current = state as TodoLoaded;
      await _todoBox.put(event.todo.id, event.todo);
      final todos = _todoBox.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(TodoLoaded(todos: todos, filter: current.filter));
    }
  }

  Future<void> _onUpdateTodo(UpdateTodo event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      final current = state as TodoLoaded;
      await _todoBox.put(event.todo.id, event.todo);
      final todos = _todoBox.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(TodoLoaded(todos: todos, filter: current.filter));
    }
  }

  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      final current = state as TodoLoaded;
      await _todoBox.delete(event.id);
      final todos = _todoBox.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(TodoLoaded(todos: todos, filter: current.filter));
    }
  }

  Future<void> _onToggleTodo(ToggleTodo event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      final current = state as TodoLoaded;
      final todo = _todoBox.get(event.id);
      if (todo != null) {
        final updated = todo.copyWith(isCompleted: !todo.isCompleted);
        await _todoBox.put(event.id, updated);
        final todos = _todoBox.values.toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        emit(TodoLoaded(todos: todos, filter: current.filter));
      }
    }
  }

  void _onFilterTodos(FilterTodos event, Emitter<TodoState> emit) {
    if (state is TodoLoaded) {
      final current = state as TodoLoaded;
      emit(TodoLoaded(todos: current.todos, filter: event.filter));
    }
  }

  String generateId() => _uuid.v4();
}
