import 'package:flutter/material.dart';
import 'package:notes/add_note.dart';
import 'package:notes/data/local/db_helper.dart';
import 'package:notes/data/local/db_provider.dart';
import 'package:notes/setting_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  //List<Map<String, dynamic>> allNotes = [];
  //DBHelper? dbRef;

  @override
  void initState() {
    super.initState();
    context.read<DBProvider>().getInitialNotes();

    /*dbRef = DBHelper.getInstance;
    getNotes();*/
  }

  /*void getNotes() async{
    allNotes = await dbRef!.getAllNotes();
    setState(() {

    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notes'),
      actions: [
        PopupMenuButton(itemBuilder: (_) {
          return [
            PopupMenuItem(child: Row(
              children: [
                Icon(Icons.settings),
                SizedBox(width: 11,),
                Text('Settings')
              ],
            ),onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage()));
            },)
          ];
        }),
        ],
      ),

      body: Consumer<DBProvider>(
        builder: (ctx, provider, __) {
          List<Map<String, dynamic>> allNotes = provider.getNotes();
          return allNotes.isNotEmpty
              ? ListView.builder(
                itemCount: allNotes.length,
                itemBuilder: (_, index) {
                  /// all notes viewed here

                  return ListTile(
                    leading: Text('${index + 1}'),
                    title: Text(allNotes[index][DBHelper.COLUMN_NOTE_TITLE]),
                    subtitle: Text(allNotes[index][DBHelper.COLUMN_NOTE_DESC]),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => AddNote(
                                        isUpdate: true,
                                        Sno:
                                            allNotes[index][DBHelper
                                                .COLUMN_NOTE_SNO],
                                        title:
                                            allNotes[index][DBHelper
                                                .COLUMN_NOTE_TITLE],
                                        desc:
                                            allNotes[index][DBHelper
                                                .COLUMN_NOTE_DESC],
                                      ),
                                ),
                              );
                              /*showModalBottomSheet(context: context, builder: (context) {
                                titleController.text = allNotes[index][DBHelper.COLUMN_NOTE_TITLE];
                                descController.text = allNotes[index][DBHelper.COLUMN_NOTE_DESC];
                                return getBottomSheetWidget(isUpdate: true, Sno: allNotes[index][DBHelper.COLUMN_NOTE_SNO]);
                                });*/
                            },
                            child: Icon(Icons.edit),
                          ),
                          InkWell(
                            onTap: () async {

                              context.read<DBProvider>().deleteNote(allNotes[index][DBHelper.COLUMN_NOTE_SNO]);

                              /*bool check = await dbRef!.deleteNotes(mSno: allNotes[index][DBHelper.COLUMN_NOTE_SNO]);
                                if(check) {
                                getNotes();
                                }*/
                            },
                            child: Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
              : Center(child: Text('No Notes yet!!'));
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNote()),
          );
          /*return showModalBottomSheet(context: context, builder: (context) {
          return getBottomSheetWidget();
        });*/
        },
        child: Icon(Icons.add),
      ),
    );
  }

  /*Widget getBottomSheetWidget({bool isUpdate= false, int Sno = 0}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14),
      child: Column(
        children: [
          Text(isUpdate ? 'Edit Note' : 'Add Note', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
          SizedBox(height: 21,),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
                hintText: 'Enter title here',
                label: Text('Title'),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11)
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11)
                )
            ),
          ),
          SizedBox(height: 20,),
          TextField(
            maxLines: 4,
            controller: descController,
            decoration: InputDecoration(
                hintText: 'Enter description here',
                label: Text('Description'),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11)
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11)
                )
            ),
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              Expanded(child: OutlinedButton(style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                      side: BorderSide(
                          width: 4,
                          color: Colors.black
                      )
                  )
              ),onPressed: (){
                Navigator.pop(context);
              }, child: Text('Cancel'))),
              SizedBox(width: 10,),
              Expanded(child: OutlinedButton(style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                      side: BorderSide(
                          width: 4,
                          color: Colors.black
                      )
                  )
              ),onPressed: () async{
                //add notes from here
                if(titleController.text.isNotEmpty && descController.text.isNotEmpty){
                  bool check = isUpdate ?
                  await dbRef!.updateNote(mTitle: titleController.text, mDesc: descController.text, mSno: Sno) :
                  await dbRef!.addNote(mTitle: titleController.text, mDesc: descController.text,);
                  if (check) {
                    getNotes();
                    Navigator.pop(context);
                  }
                } else {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill all the fields'))
                  );
                }
                titleController.clear();
                descController.clear();
              }, child: Text(isUpdate ? 'Update Note' : 'Add Note')))
            ],
          )
        ],
      ),
    );
  }*/
}
