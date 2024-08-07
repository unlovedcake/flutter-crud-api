import 'package:crud_api/bloc/todo_bloc.dart';
import 'package:crud_api/models/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {

    @override
  void initState() {
    BlocProvider.of<TodoBloc>(context).add(GetTodoEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TodoBloc _todoBloc = BlocProvider.of<TodoBloc>(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('Todo'),
          ),
//           body:BlocConsumer<TodoBloc, TodoState>(
//   listenWhen: (context, state) {
//     return state.status == Status.LOADED || state.status == Status.SUCESS;
//   },
//   listener: (context, state) {
//     if (state.status == Status.LOADED) {
//       // Navigate to next screen
//       print('OKEY');
//      // Navigator.of(context).pushNamed('OrderCompletedScreen');
//     } else if (state.status == Status.LOADED) {
//        print('OKEYS');
//      // Analytics.reportRefunded(state.orderId);
//     }
//   },
//   buildWhen: (context, state) {
//     return state.status == Status.LOADED || state.status == Status.SUCESS;
//   },
//   builder: (context, state) {
//     if (state.status == Status.LOADED || state.status == Status.SUCESS) {
//  return Column(
//                   children: [
//                     Container(
//                       height: 500,
//                       child: ListView.builder(
//                         itemCount: state.todoData!.length,
//                         itemBuilder: (context, index) {
//                           final todo = state.todoData![index];
//                           return ListTile(
//                             title: Text(todo.title.toString()),
//                             // leading: Checkbox(
//                             //   value: todo.completed,
//                             //   onChanged: (value) {
//                             //     final updatedTodo = todo.copyWith(completed: value);
//                             //     _todoBloc.add(UpdateTodo(updatedTodo));
//                             //   },
//                             // ),
//                             trailing: IconButton(
//                               icon: const Icon(Icons.delete),
//                               onPressed: () {
//                                 //_todoBloc.add(DeleteTodo(todo.id));
//                               },
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 );
//     } else if (state.status == Status.LOADING) {
//       return Container(child: Text('In Progress'));
//     } else {
//       return Container(child: Text('No State'));
//     }
//   },
// ),
          body: BlocListener<TodoBloc, TodoState>(
        listenWhen: (context, state) {
          return state.status == Status.LOADED || state.status == Status.SUCESS;
        },
        listener: (context, state) {
           if (state.status == Status.LOADING) {
           Center(child: Text('Loading'));
          }
          else if (state.status == Status.ERROR) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.error.toString()),
              duration: const Duration(seconds: 3),
            ));
          }
        },
        child: BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              if (state.status == Status.LOADING) {
                return const Center(child: Text('Loading,,,'));
              } else if (state.status == Status.LOADED || state.status == Status.SUCESS) {
         
                return Column(
                  children: [
                    Container(
                      height: 500,
                      child: ListView.builder(
                        itemCount: state.todoData!.length,
                        itemBuilder: (context, index) {
                          final todo = state.todoData![index];
                          return ListTile(
                            title: Text(todo.title.toString()),
                            // leading: Checkbox(
                            //   value: todo.completed,
                            //   onChanged: (value) {
                            //     final updatedTodo = todo.copyWith(completed: value);
                            //     _todoBloc.add(UpdateTodo(updatedTodo));
                            //   },
                            // ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                //_todoBloc.add(DeleteTodo(todo.id));
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return Container(child: Text('Empty'),);
              }
            },
          )),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showAddTodoDialog(context);
            },
            child: const Icon(Icons.add),
          ),
        );
  }
    void _showAddTodoDialog(BuildContext context) {
      final _titleController = TextEditingController();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const  Text('Add Todo'),
            content: TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'Todo title'),
            ),
            actions: [
              ElevatedButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: const Text('Add'),
                onPressed: () {
                  
                  final todo = TodoModel(
                    id: DateTime.now().toString(),
                    title: _titleController.text,
                         description: "Description",
                    completed: false,
                  );
                  //  context
                  //   .read<TodoBloc>()
                  //   .add(AddTodoEvent(todo));

           
                   BlocProvider.of<TodoBloc>(context).add(AddTodoEvent(todo));
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
}