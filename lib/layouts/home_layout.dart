import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';
import '../shared/styles/colors.dart';
class HomeLayOut extends StatelessWidget {
  const HomeLayOut({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit()..createDatabase(),
      child: BlocConsumer<TodoCubit, TodoStates>(
        listener: (BuildContext context, TodoStates state) {
          if(state is DatabaseInsertionSuccessState){
            Navigator.pop(context);
          }

        },
        builder: (context, state) {
          return Scaffold(
            key: TodoCubit.get(context).scaffoldKey,
            appBar: AppBar(
              title: Text(TodoCubit
                  .get(context)
                  .titles[TodoCubit
                  .get(context)
                  .currentIndex]),
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.orange,
                shape: const CircleBorder(),
                onPressed: () {
                  if (TodoCubit.get(context).isBottomSheetShawn) {
                    if (TodoCubit.get(context).formKey.currentState!.validate()) {
                      TodoCubit.get(context).insertToDatabase(
                          title:TodoCubit.get(context).taskTitleController.text,
                          time: TodoCubit.get(context).timeController.text,
                          date: TodoCubit.get(context).dateController.text);
                    }
                  } else {
                    TodoCubit.get(context).scaffoldKey.currentState!.showBottomSheet(
                        backgroundColor: Colors.blue,
                            (context) =>
                            Container(
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                padding: const EdgeInsets.all(20),
                                width: double.infinity,
                                child: Form(
                                  key:TodoCubit.get(context).formKey,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        textFormFieldCustom(
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please put your task!';
                                              }
                                              return null;
                                            },
                                            onTap: () {},
                                            controller:TodoCubit.get(context).taskTitleController,
                                            hint: 'Task',
                                            prefix: Icons.task),
                                        const SizedBox(height: 15,),
                                        textFormFieldCustom(
                                          controller:TodoCubit.get(context).timeController,
                                          hint: 'Time',
                                          prefix: Icons.watch_later,
                                          onTap: () {
                                            showTimePicker(context: context,
                                                initialTime: TimeOfDay.now())
                                                .then((value) {
                                              TodoCubit.get(context).timeController.text =
                                                  value!.format(context)
                                                      .toString();
                                            });
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please pick time!';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 15,),
                                        textFormFieldCustom(
                                          controller:TodoCubit.get(context).dateController,
                                          hint: 'Date',
                                          prefix: Icons.calendar_month,
                                          onTap: () {
                                            showDatePicker(context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.parse(
                                                    '2024-12-21')).then((
                                                value) {
                                              TodoCubit.get(context).dateController.text =
                                                  DateFormat.yMMMd().format(
                                                      value!).toString();
                                            });
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please pick Date!';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                            )
                    ).closed.then((value) {
                     TodoCubit.get(context).changeBottomSheetState(isShow: false, icon:Icons.edit);
                    });
                  TodoCubit.get(context).changeBottomSheetState(isShow: true, icon:Icons.add);
                  }
                },
                child: Icon(TodoCubit.get(context).fabIcons)
            ),
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: Colors.white,
              selectedIconTheme: const IconThemeData(
                  size: 30
              ),
              selectedLabelStyle: const TextStyle(
                  color: Colors.white
              ),
              unselectedLabelStyle: const TextStyle(
                  color: Colors.white
              ),
              unselectedIconTheme: const IconThemeData(
                  size: 15,
                  color: Colors.grey
              ),
              backgroundColor: AppColors.backgroundColor,
              currentIndex: TodoCubit
                  .get(context)
                  .currentIndex,
              onTap: (index) {
                TodoCubit.get(context).changeNavigationBarScreens(index);
              },
              elevation: 40,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_box), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive), label: 'Archived'),
              ],
            ),
            body: TodoCubit
                .get(context)
                .navigationBarScreens[TodoCubit
                .get(context).currentIndex],);
        },
      ),
    );
  }
}

