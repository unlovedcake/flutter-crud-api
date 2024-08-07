part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetTodoEvent extends TodoEvent {
   
  GetTodoEvent();
}

class AddTodoEvent extends TodoEvent {
  final TodoModel? todoData;


  AddTodoEvent(this.todoData);
}

class UpdateTodoEvent extends TodoEvent {
    final String? id;
  UpdateTodoEvent(this.id);
}


class GetProductsJolliBeeEvent extends TodoEvent {
  final String? category;

  GetProductsJolliBeeEvent(this.category);
}
