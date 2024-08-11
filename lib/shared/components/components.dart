import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/shared/cubit/cubit.dart';
import '../styles/colors.dart';
Widget textFormFieldCustom({
  TextEditingController? controller,
    String? hint,
    IconData? prefix,
    IconData? suffix,
    String? Function(String?)? validator,
  TextInputType? keyboardType,
  void Function(String)? onChanged,
  void Function()? onTap
}
    )
=>TextFormField(
  onTap: onTap,
  onChanged:onChanged ,
  keyboardType:keyboardType ,
  validator: validator,
  controller: controller,
  decoration: InputDecoration(hintStyle:GoogleFonts.habibi(
      fontSize: 15,
      color:AppColors.backgroundColor,
      fontWeight: FontWeight.w900
  ),
      suffixIcon: Icon(suffix),
      suffixIconColor: AppColors.backgroundColor,
      prefixIconColor: AppColors.backgroundColor,
      fillColor: Colors.white,
      filled: true,
      hintText:hint??'',
      prefixIcon: Icon(prefix),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
            width: 3,
            color: Colors.blue
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
            width: 2,
            color: Colors.blue
        ),
      ),
      errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
              width: 3,
              color: Colors.red
          )
      )
  ),
);

Widget buildTaskItem({required Map tasksData,required context})=>
    Dismissible(
    onDismissed: (direction){
     TodoCubit.get(context).deleteDataFromDatabase(id:tasksData['id']);
    }
    ,key: Key(tasksData['id'].toString()), child:Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Expanded(
            child: CircleAvatar(
              radius: 40,
              child: Text('${tasksData['time']}'),
            ),
          ),
          const SizedBox(width: 15,),
          Expanded(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children:[
                  Text('${tasksData['title']}',style:GoogleFonts.habibi(color: Colors.white,fontSize: 20)),
                  Text('${tasksData['date']}',style:GoogleFonts.habibi(color: Colors.orange,fontSize: 10))
                ]
            ),
          ),
          IconButton(onPressed:(){
            TodoCubit.get(context).updateDataInDatabase(status: 'done', id:tasksData['id']);
          }, icon:const Icon(Icons.check_box,color: Colors.green,)),
          IconButton(onPressed:(){
            TodoCubit.get(context).updateDataInDatabase(status: 'archived', id:tasksData['id']);
          }, icon:const Icon(Icons.archive,color: Colors.orange,)),
        ],
      ),
    ) );
