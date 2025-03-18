class Todo {
  Todo({
    this.id,
    this.title = '',
    this.description = '',
    this.completed = false,
  });

  final int? id;
  final String title;
  final String description;
  final bool completed;

  factory Todo.fromMap(Map<String, dynamic> json) {
    return Todo(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      completed: json["completed"] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "completed": completed ? 1 : 0,
    };
  }
}
