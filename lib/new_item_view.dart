import 'package:flutter/material.dart';

class NewItemView extends StatefulWidget {
  final String title;

  NewItemView({this.title});

  @override
  _NewItemViewState createState() => _NewItemViewState();
}

class _NewItemViewState extends State<NewItemView> {
  TextEditingController textFieldController;

  @override
  void initState() {
    textFieldController = TextEditingController(text: widget.title);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: textFieldController,
              onEditingComplete: () => save(),
            ),
            FlatButton(
              onPressed: () => save(),
              child: Text(
                'Save',
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            )
          ],
        ),
      ),
    );
  }

  void save() {
    if (textFieldController.text.isNotEmpty)
      Navigator.of(context).pop(textFieldController.text);
  }
}
