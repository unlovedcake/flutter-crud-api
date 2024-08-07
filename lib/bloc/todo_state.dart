// ignore_for_file: constant_identifier_names

part of 'todo_bloc.dart';


enum Status {
  INITIAL,
  LOADING,
  LOADED,
  SUCESS,
  ERROR
}

class TodoState extends Equatable {
  final Status status;
  final String? error;

  final List<TodoModel>? todoData;

  const TodoState({ this.status = Status.INITIAL, this.error, this.todoData = const <TodoModel>[]});

  factory TodoState.initial() {
    return const TodoState(status: Status.INITIAL);
  }

  TodoState copyWith(
      {required Status status, String? error, List<TodoModel>? todoData, TodoModel? data}) {
    return TodoState(status: status , error: error ?? this.error, todoData: todoData ?? this.todoData );
  }

  @override
    factory TodoState.fromJson(Map<String, dynamic> json) {
    return TodoState(
     status: json['status'],
      error: json['error'],
      todoData: json['todoData'],
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status.name,
        'error': error ?? '',
        'todoData;': todoData ?? [],
       
      };

  @override
  List<Object?> get props => [status, error, todoData];
}
