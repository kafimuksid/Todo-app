import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:async/async.dart';
import 'dart:convert';

import 'package:to_do_app/new_item_view.dart';
import 'package:to_do_app/todo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Todo',
      theme: ThemeData(
          primarySwatch: Colors.amber, fontFamily: 'ArchitectsDaughter'),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ToDo> list = List<ToDo>();
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    initSharedPreferences();
    super.initState();
  }

  initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black12,
      appBar: AppBar(
        title: Text('To-Do-List'),
        centerTitle: true,
      ),
      body: list.isNotEmpty ? buildBody() : buildEmptyBody(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => goToNewItemView(),
      ),
    );
  }

  Widget buildBody() {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return buildItem(list[index]);
        });
  }

  Widget buildEmptyBody() {
    return Center(child: Text('Hurray! You have nothing to do!'));
  }

  Widget buildItem(ToDo item) {
    return Dismissible(
      key: Key(item.hashCode.toString()),
      onDismissed: (direction) => removeItem(item),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red[800],
        child: Icon(Icons.delete, color: Colors.white),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 12.0),
      ),
      child: buildListTile(item),
    );
  }

  Widget buildListTile(ToDo item) {
    return ListTile(
      title: Text(item.title),
      trailing: Checkbox(value: item.complete, onChanged: null),
      onTap: () => setCompleteness(item),
      onLongPress: () => goToEditItemView(item),
    );
  }

  void goToNewItemView() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return NewItemView();
    })).then((title) {
      if (title != null) addTodo(ToDo(title: title));
    });
  }

  void goToEditItemView(ToDo item) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return NewItemView(title: item.title);
    })).then((title) {
      if (title != null) editTodo(item, title);
    });
  }

  void setCompleteness(ToDo item) {
    setState(() {
      item.complete = !item.complete;
    });
    saveData();
  }

  void removeItem(ToDo item) {
    list.remove(item);
    if (list.isEmpty) setState(() {});
    saveData();
  }

  void addTodo(ToDo item) {
    list.add(item);
    saveData();
  }

  void editTodo(ToDo item, String title) {
    item.title = title;
    saveData();
  }

  void saveData() {
    List<String> spList =
        list.map((item) => json.encode(item.toMap())).toList();
    sharedPreferences.setStringList('list', spList);
  }

  void loadData() {
    List<String> spList = sharedPreferences.getStringList('list');
    list = spList.map((item) => ToDo.fromMap(json.decode(item))).toList();
    setState(() {});
  }
}
