import 'package:bloc/bloc.dart';
import 'package:crud_api/repositories/todo_repositories.dart';

import 'package:equatable/equatable.dart';


import 'package:crud_api/models/todo_model.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part './todo_event.dart';
part './todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {

   
  TodoBloc() : super(TodoState.initial()) {
    on<GetTodoEvent>((event, emit) async {
      emit(state.copyWith(status: Status.LOADING));
      try {
        final data = await TodoRepositories.get('?page=7&limit=10');
        final todaoData = List<TodoModel>.from(data.map((x) => TodoModel.fromJson(x)));
        emit(state.copyWith(
            todoData: todaoData, status: Status.LOADED));
      } catch (e) {
        emit(state.copyWith(error: e.toString(), status: Status.ERROR));
      }
    });

    //  on<AddTodoEvent>((event, emit) async {

    //   emit(state.copyWith(status:  Status.LOADING));
    //   try {
    //         List<TodoModel>? listTodoData;
    //     final response = await TodoRepositories.post(event.todoData);

    //    // final todoData = TodoModel.fromJson(response);

 


    //       listTodoData!.add(TodoModel.fromJson(response));

    //     print('Success');

    //     emit(state.copyWith(todoData: listTodoData, status: Status.SUCESS));
    //   } catch (e) {
    //     emit(state.copyWith(status: Status.ERROR));
        
    //   }
    // });
     on<AddTodoEvent>(_addTodo);
  }
 
  void _addTodo(AddTodoEvent event, Emitter<TodoState> emit)async{

    emit(state.copyWith(status:  Status.LOADING));
    List<TodoModel> listTodoData= [];
 
    listTodoData.addAll(state.todoData!);
    
    await TodoRepositories.post(event.todoData);
    listTodoData.insert(0,event.todoData!);
    
    
        print('Success');
     emit(state.copyWith(todoData: listTodoData, status: Status.SUCESS));
  }
  
  // @override
  // TodoState? fromJson(Map<String, dynamic> json) {
  //  return TodoState.fromJson(json);
  // }
  
  // @override
  // Map<String, dynamic>? toJson(TodoState state) {
  //   // TODO: implement toJson
  //   return state.toJson();
  // }
}
