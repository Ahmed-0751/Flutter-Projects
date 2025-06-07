import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todoist/data/db_provider.dart';
import 'package:todoist/view/add_task_page.dart';
import 'package:todoist/data/db_helper.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{


  DBHelper? dbRef;
  DateTime selectedDate = DateTime.now();
  bool showAllTasks = true;
  String getFormattedDate(DateTime date) {
    return DateFormat('d MMM, yyyy').format(date);
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<DBProvider>().getInitialTasks();
  }


  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> allNotes = Provider.of<DBProvider>(context).getNotes();
    int total = allNotes.length;
    int completed = allNotes.where((task) => task[DBHelper.COLUMN_TODO_COMPLETE] == 1).length;
    double progress = total == 0 ? 0 : completed / total;
    double per = progress*100;
    int result = per.toInt();


    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Color(0xFF0D47A1),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text('Todoist', style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),

      ),
      body: Container(
        color: Color(0xFF0D47A1),
        child: Column(
          children: [
            Expanded(child: Container(
              child: Stack(
                children: [
                  Positioned(left: 50, child: Text('Today', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),)),
                  Positioned(right: 50, top: 18, child: GestureDetector(
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null && picked != selectedDate) {
                        setState(() {
                          selectedDate = picked;
                          showAllTasks = false; // Automatically uncheck
                        });

                        String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
                        await context.read<DBProvider>().getTasksForDate(formattedDate);
                      }

                    },
                    child: Text(
                      getFormattedDate(selectedDate),
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                  ),
                  Positioned(
                    left: 35,
                    top: 30,
                    child: Row(
                      children: [
                        Checkbox(
                          value: showAllTasks,
                          onChanged: (value) async {
                            setState(() {
                              showAllTasks = value!;
                            });

                            if (showAllTasks) {
                              await context.read<DBProvider>().getInitialTasks();
                            } else {
                              String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
                              await context.read<DBProvider>().getTasksForDate(formattedDate);
                            }
                          },
                          activeColor: Colors.white,
                          checkColor: Color(0xFF0D47A1),
                        ),
                        Text("Show all tasks: ${allNotes.length}", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),

                  Positioned(right: 50, top: 75, child: Text('$result%', style: TextStyle(color: Colors.white,),)),
                  Positioned(left: 50, top: 100, child: SizedBox(
                    height: 10,
                    width: MediaQuery.of(context).size.width - 100,
                    child: LinearProgressIndicator(
                      borderRadius: BorderRadius.circular(5),
                      value: progress, // From 0.0 to 1.0 (60% progress)
                      backgroundColor: Colors.grey[600],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),),
                ],
              ),
              decoration: BoxDecoration(
                color: Color(0xFF0D47A1),
              ),
            )),
            Consumer<DBProvider>(
              builder: (ctx, provider, __){
                List<Map<String, dynamic>> allNotes = showAllTasks
                    ? provider.getNotes()
                    : provider.getFilteredNotes();
                return Container(
                  height: MediaQuery.of(context).size.height*0.725,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Expanded(
                          child: allNotes.isEmpty? Center(
                            child: Text("No tasks added yet!"),
                          ) : ListView.builder(
                            itemCount: allNotes.length,
                            itemBuilder: (context, index){
                              return ListTile(
                                leading: Checkbox(
                                  value: (allNotes[index][DBHelper.COLUMN_TODO_COMPLETE] ?? 0) == 1,

                                  onChanged: (value) async {
                                    await context.read<DBProvider>().updateTaskCompletion(
                                      Sno: allNotes[index][DBHelper.COLUMN_TODO_SNO],
                                      completed: value! ? 1 : 0,
                                    );
                                    if (showAllTasks) {
                                      await context.read<DBProvider>().getInitialTasks();
                                    } else {
                                      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
                                      await context.read<DBProvider>().getTasksForDate(formattedDate);
                                    }
                                  },
                                ),
                                title: Text(allNotes[index][DBHelper.COLUMN_TODO_TITLE]),
                                subtitle: Text(allNotes[index][DBHelper.COLUMN_TODO_DESC],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,),
                                trailing: SizedBox(
                                  width: 180, // adjust as needed
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(allNotes[index][DBHelper.COLUMN_TODO_DATE]),
                                          Text(allNotes[index][DBHelper.COLUMN_TODO_TIME])
                                        ],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddTaskPage(title: allNotes[index][DBHelper.COLUMN_TODO_TITLE], desc: allNotes[index][DBHelper.COLUMN_TODO_DESC], date: allNotes[index][DBHelper.COLUMN_TODO_DATE], time: allNotes[index][DBHelper.COLUMN_TODO_TIME], Sno: allNotes[index][DBHelper.COLUMN_TODO_SNO], isUpdate: true,)));
                                        },
                                        child: Icon(Icons.edit),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          context.read<DBProvider>().deleteTask(
                                              Sno: allNotes[index][DBHelper.COLUMN_TODO_SNO]); // fix: use actual SNO
                                        },
                                        child: Icon(Icons.delete, color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),

                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25)
                      )
                  ),
                );
              },
            )
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddTaskPage()));
      }, child: Icon(Icons.add), backgroundColor: Color(0xFF0D47A1),),
    );
  }
}
