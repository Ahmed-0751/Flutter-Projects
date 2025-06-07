import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todoist/data/add_task_provider.dart';
import 'package:todoist/data/db_helper.dart';
import 'package:todoist/data/db_provider.dart';
class AddTaskPage extends StatelessWidget {
  int Sno;
  String title;
  String desc;
  String date;
  String time;
  bool isUpdate;
  AddTaskPage({super.key,
    this.Sno = 0,
    this.title = '',
    this.desc = '',
    this.date = '',
    this.time = '',
    this.isUpdate = false,
  });

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  DBHelper? dbRef = DBHelper.getInstance;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  //Function to pick date
  Future<void> _selectDate(BuildContext context) async {
    final taskProvider = Provider.of<AddTaskProvider>(context, listen: false);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      dateController.text = DateFormat('yyyy-MM-dd').format(picked);

    }
  }

  //Function to pick time
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      selectedTime = pickedTime;
      timeController.text = pickedTime.format(context); // Use format for human-readable string
    }
  }





  @override
  Widget build(BuildContext context) {
    if(isUpdate){
      titleController.text = title;
      descController.text = desc;
      dateController.text = date;
      timeController.text = time;
    }
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF0D47A1),
          title: Text(isUpdate ? 'Edit Task' : 'Add Task', style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(height: 20,),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Enter title',
                label: Text('Title'),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(11))
              ),
            ),
            SizedBox(height: 21,),
            TextField(
              controller: descController,
              maxLines: 5,
              decoration: InputDecoration(
                  hintText: 'Enter description',
                  label: Text('Description'),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(11))
              ),
            ),
            SizedBox(height: 21,),
            TextField(
              controller: dateController,
              readOnly: true,
              decoration: InputDecoration(
                label: Text('Select Date'),
                hintText: 'Date has not been set yet!',
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
                suffixIcon: IconButton(onPressed: ()=> _selectDate(context), icon: Icon(Icons.calendar_month_sharp))
              ),
            ),
            SizedBox(height: 21,),
            TextField(
              readOnly: true,
              controller: timeController,
              decoration: InputDecoration(
                  label: Text('Select Time'),
                  hintText: 'Time has not been set yet!',
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
                  suffixIcon: IconButton(onPressed: ()=> _selectTime(context), icon: Icon(Icons.watch_later))
              ),
            ),

          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(onPressed: () async{
        if(titleController.text.isNotEmpty) {
          if(isUpdate){
            context.read<DBProvider>().updateTask(Sno, titleController.text, descController.text, dateController.text, timeController.text);
          } else {
            context.read<DBProvider>().addTask( titleController.text,
                descController.text,
                dateController.text,
                timeController.text);
          }
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please, fill the title!')));
        }

      }, child: Icon(Icons.done), backgroundColor: Color(0xFF0D47A1),),

    );
  }
}
