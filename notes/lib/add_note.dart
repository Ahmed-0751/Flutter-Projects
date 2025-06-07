import 'package:flutter/material.dart';
import 'package:notes/data/local/db_helper.dart';
import 'package:notes/data/local/db_provider.dart';
import 'package:provider/provider.dart';
import 'homepage.dart';

class AddNote extends StatelessWidget {
  String title;
  String desc;
  int Sno;

  //DBHelper? dbRef = DBHelper.getInstance;
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  bool isUpdate;

  AddNote({
    super.key,
    this.isUpdate = false,
    this.Sno = 0,
    this.title = "",
    this.desc = "",
  });

  @override
  Widget build(BuildContext context) {
    if (isUpdate) {
      titleController.text = title;
      descController.text = desc;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isUpdate ? 'Edit Note' : 'Add Note',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14),
        child: Column(
          children: [
            //Text(isUpdate ? 'Edit Note' : 'Add Note', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
            SizedBox(height: 21),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Enter title here',
                label: Text('Title'),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              maxLines: 6,
              controller: descController,
              decoration: InputDecoration(
                hintText: 'Enter description here',
                label: Text('Description'),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                        side: BorderSide(width: 4, color: Colors.black),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                        side: BorderSide(width: 4, color: Colors.black),
                      ),
                    ),
                    onPressed: () async {
                      //add notes from here
                      if (titleController.text.isNotEmpty &&
                          descController.text.isNotEmpty) {
                        if (isUpdate) {
                          context.read<DBProvider>().updateNote(
                            titleController.text,
                            descController.text,
                            Sno,
                          );
                        } else {
                          context.read<DBProvider>().addNote(
                            titleController.text,
                            descController.text,
                          );
                        }
                        Navigator.pop(context);
                        /*bool check = isUpdate ?
                    await dbRef!.updateNote(mTitle: titleController.text, mDesc: descController.text, mSno: Sno) :
                    await dbRef!.addNote(mTitle: titleController.text, mDesc: descController.text,);
                    if (check) {
                      Navigator.pop(context);
                    }*/
                      } else {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill all the fields')),
                        );
                      }
                      titleController.clear();
                      descController.clear();
                    },
                    child: Text(isUpdate ? 'Update Note' : 'Add Note'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
