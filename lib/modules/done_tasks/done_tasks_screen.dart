import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/components/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
class DoneTasksScreen extends StatelessWidget {
  const DoneTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit,TodoStates>(
        listener: (context,state){},
        builder:(context,state){
          return ListView.separated(itemBuilder: (context,index)=>buildTaskItem(tasksData:TodoCubit.get(context).doneTasks[index],context: context), separatorBuilder:(context,index)=>Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(width: double.infinity,height: 1,color: Colors.grey,),
          ), itemCount:TodoCubit.get(context).doneTasks.length);
        }
    );
  }
}