class TodoModel {
  final String? id;
  final String? description;
  final String? title;
  final bool? completed;
  final String? created_at;
  final String? updated_at;

  TodoModel({
    this.id,
    this.description,
    this.title,
    this.completed,
    this.created_at,
    this.updated_at,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['_id'] ?? '',
      description: json['description'] ?? '',
      title: json['title'] ?? '',
      completed: json['is_completed'] ?? false,
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id ?? '',
        'description': description ?? '',
        'title': title ?? '',
        'is_completed': completed ?? '',
        'created_at': created_at ?? '',
        'updated_at': updated_at ?? '',
      };
}
