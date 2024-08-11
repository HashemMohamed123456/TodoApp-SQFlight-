import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/shared/cubit/states.dart';
import '../../modules/archived_tasks/archived_tasks_screen.dart';
import '../../modules/done_tasks/done_tasks_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';


class TodoCubit extends Cubit<TodoStates>{
  TodoCubit():super(TodoInitialState());
  static TodoCubit get(context)=>BlocProvider.of<TodoCubit>(context);
  int currentIndex=0;
  List<Widget> navigationBarScreens=const [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];
  List<String>titles=[
    'New Tasks','Done Tasks','Archived Tasks'
  ];
  late Database database;
  List<Map>newTasks=[];
  List<Map>doneTasks=[];
  List<Map>archivedTasks=[];
   IconData fabIcons=Icons.edit;
    bool isBottomSheetShawn=false;
  TextEditingController taskTitleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  void changeNavigationBarScreens(int index){
    currentIndex=index;
    emit(ChangedNavigationBarScreenState());
  }
  Future<void> createDatabase()async {
     openDatabase('todo.db',
        version: 1,
        onCreate: (database,version){
          database.execute('CREATE TABLE tasks(id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)').then((value){
          }).catchError((error){
          });
        },
        onOpen: (database){
          getDataFromDatabase(database);
        }
    ).then((value){
       database=value;
      emit(DatabaseCreatedState());
    });
  }
   insertToDatabase({required String title,required String time,required String date})async{
     await database.transaction((txn)async{
      txn.rawInsert('INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","New")').then((value){
        emit(DatabaseInsertionSuccessState());
      }).catchError((error){
        emit(DatabaseInsertionErrorState());
      });
      getDataFromDatabase(database);
    });
  }
  void getDataFromDatabase(database){
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];
     database.rawQuery('SELECT * FROM tasks').then((value){
      value.forEach((element){
        if(element['status']=='New'){
          newTasks.add(element);
        }else if(element['status']=='done'){
          doneTasks.add(element);
        }else {archivedTasks.add(element);}
      });
      emit(GetDataSuccessState());
    });
  }
  void changeBottomSheetState({required bool isShow,required IconData icon}){
       isBottomSheetShawn=isShow;
       fabIcons=icon;
       emit(TodoChangeBottomSheetState());
  }
  void updateDataInDatabase({required String status, required int id})async{
    database.rawUpdate('UPDATE tasks SET status=? WHERE id=?',[status,id]).then((value){
      getDataFromDatabase(database);
      emit(DatabaseUpdateState());

    });
  }
  void deleteDataFromDatabase({required int id})async{
    database.rawDelete('DELETE FROM tasks WHERE id=?',[id]).then((value){
      getDataFromDatabase(database);
      emit(DeletedDataFromDatabaseState());

    });
  }
}


