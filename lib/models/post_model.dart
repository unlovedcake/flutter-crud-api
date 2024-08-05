// class Post {
//   final int? userdescription;
//   final int? description;
//   final String? title;
//   final bool? completed;

//   Post({
//     this.userdescription,
//     this.description,
//     this.title,
//     this.completed,
//   });

//   factory Post.fromJson(Map<String, dynamic> json) {
//     return Post(
//       userdescription: json['userdescription'],
//       description: json['description'],
//       title: json['title'],
//       completed: json['completed'] ?? false,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'userdescription': userdescription,
//         'description': description,
//         'title': title,
//         'completed': completed,
//       };
// }

class Post {
  final String? id;
  final String? description;
  final String? title;
  final bool? completed;
  final String? created_at;
  final String? updated_at;

  Post({
    this.id,
    this.description,
    this.title,
    this.completed,
    this.created_at,
    this.updated_at,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
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
