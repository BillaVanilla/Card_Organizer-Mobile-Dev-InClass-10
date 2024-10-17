import 'package:card_organizer/database_helper.dart';
import 'package:flutter/material.dart';

class Folders extends StatefulWidget {
  const Folders({super.key});

  @override
  State<Folders> createState() => _FoldersState();
}

class _FoldersState extends State<Folders> {
  final dbhelper = DatabaseHelper();
  List<Map<String, dynamic>> _folders = [];
  
  @override
  void initState(){
    super.initState();
    _insertfolder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Folders'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: _folders.length,
                itemBuilder: (context, index){
                  final folder = _folders[index];
                  return ListTile(
                    title: Text(folder['folder_name']),
                    subtitle: Text('ID: ${folder['id']} - created at : ${folder['created_at']}'),
                  );
                }),
            ),
          ],
        ),
      ),
    );
  }

  void _insertfolder() async{
  List<Map<String, dynamic>> folders = await dbhelper.getAllFolders();
  if(folders.length < 4){
   await dbhelper.insertFolder('Spades');
   await dbhelper.insertFolder('Hearts');
   await dbhelper.insertFolder('Diamonds');
   await dbhelper.insertFolder('Clubs');
  }
   _viewFolder();
  }

  void _viewFolder () async{
    List<Map<String, dynamic>> folders = await dbhelper.getAllFolders();
    setState(() {
      _folders = folders;
    });
  }

}