import 'package:card_organizer/folders.dart';
import 'package:card_organizer/database_helper.dart';
import 'package:flutter/material.dart';

class Cards extends StatefulWidget {
  const Cards({super.key});

  @override
  State<Cards> createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  final dbhelper = DatabaseHelper();
  List<Map<String, dynamic>> _cards = [];

  String? _selectedCard;
  List<Map<String,String>> cardddd = [
    {'Name': 'Jack', 'suit' : 'Clubs','image_url':'assets/jack_of_clubs.png'},
    {'Name': 'king', 'suit' : 'Hearts','image_url':'assets/king_of_hearts.png'}
  ];
  
  @override
  void initState(){
    super.initState();
    _insertcard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cards'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<String>(
              hint: Text('Insert card'),
              value: _selectedCard,
              items: cardddd.map((card) {
                return DropdownMenuItem<String>(
                  value: card['Name'],
                  child: Text(card['Name']!),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCard = newValue;
                }); 
                _addSelectedCardToDatabase(newValue!);
             }),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 2,mainAxisSpacing: 2),
                itemCount: _cards.length,
                itemBuilder: (context, index){
                  final card = _cards[index];
                  return Card(
                    child:Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                                card['image_url']
                              ),
                        ),
                        Text('Card ID: ${card['id'].toString()}'),
                        SizedBox(height: 5),
                        Text('FolderID: ${card['folder_id'].toString()}'),
                        ElevatedButton(
                          onPressed: (){
                            showDialog(
                              context: context, 
                              builder: (_) => AlertDialog(
                                title: Text('Remove/update folder'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ElevatedButton(
                                      onPressed: (){
                                        _updateFolderidForcards(card['id'], null);
                                      },
                                      child: Text('Remove')
                                    ),
                                    Row(
                                      children: [
                                        FloatingActionButton(
                                        onPressed: (){
                                            _updateFolderidForcards(card['id'],3);
                                        },
                                        child: Icon(Icons.diamond)
                                        ),
                                        FloatingActionButton(
                                          onPressed: (){
                                              _updateFolderidForcards(card['id'],2);
                                          },
                                          child: Icon(Icons.heart_broken)
                                        ),
                                        FloatingActionButton(
                                          onPressed: (){
                                              _updateFolderidForcards(card['id'],1);
                                          },
                                          child: Icon(Icons.change_history) //spades
                                        ),
                                        FloatingActionButton(
                                          onPressed: () {
                                            _updateFolderidForcards(card['id'],4);
                                          },
                                          child: Icon(Icons.spa) //clubs
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ));
                          }, 
                          child: Text('Folder')
                        ),
                        ElevatedButton(
                          onPressed: (){
                            _deleteCard(card['id']);
                          }, 
                          child: Text('Delete'))
                      ],
                    )
                  );
                }))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Folders()));
        },
        child: Text('>>')),
    );
  }

  void _insertcard() async{
    List<Map<String, dynamic>> cards = await dbhelper.getCards();

    if(cards.length < 5){
      await dbhelper.insertCard('Jack', 'Hearts', 'assets/jack_of_hearts.png');
      await dbhelper.insertCard('Queen', 'Hearts', 'assets/queen_of_hearts.png');
      await dbhelper.insertCard('Ace', 'Hearts', 'assets/ace_of_hearts.png');
      await dbhelper.insertCard('Ace', 'Spades', 'assets/ace_of_spades.png');
      await dbhelper.insertCard('Ace', 'Diamonds', 'assets/ace_of_diamonds.png');
    }
    _viewCards();
  }

  void _viewCards () async{
    List<Map<String, dynamic>> cards = await dbhelper.getCards();
    setState(() {
      _cards = cards;
    });
  }

  void _updateFolderidForcards(int cardid,int? folderid) async{
    await dbhelper.updateFolderID(cardid, folderid);
    _viewCards();
    Navigator.pop(context);
  }

  void _addSelectedCardToDatabase(String cardName) async {
    Map<String, String>? selectedCard = cardddd.firstWhere(
      (card) => card['Name'] == cardName,
      orElse: () => {},
    );

      await dbhelper.insertCard(selectedCard['Name']!, selectedCard['suit']!, selectedCard['image_url']!);
      _viewCards(); 
    
  }

  void _deleteCard(int id) async{
    await dbhelper.deleteCard(id);
    _viewCards();
  }
}