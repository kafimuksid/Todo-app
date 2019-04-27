class ToDo {
  String title;
  bool complete;

  ToDo({
    this.title,
    this.complete = false,
  });

  ToDo.fromMap(Map map)
      : this.title = map['title'],
        this.complete = map['complete'];

  Map toMap() {
    return {
      'title': this.title,
      'complete': this.complete,
    };
  }
}
