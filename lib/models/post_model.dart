class Post {
  final int code;
  final bool success;
  final int timestamp;
  final String message;
  final List<Item> items;
  final Meta meta;

  Post({
    required this.code,
    required this.success,
    required this.timestamp,
    required this.message,
    required this.items,
    required this.meta,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      code: json['code'],
      success: json['success'],
      timestamp: json['timestamp'],
      message: json['message'],
      items: List<Item>.from(json['items'].map((item) => Item.fromJson(item))),
      meta: Meta.fromJson(json['meta']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'success': success,
      'timestamp': timestamp,
      'message': message,
      'items': List<dynamic>.from(items.map((item) => item.toJson())),
      'meta': meta.toJson(),
    };
  }
}

class Item {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String title;
  final String description;
  final bool isCompleted;

  Item({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.description,
    required this.isCompleted,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      title: json['title'],
      description: json['description'],
      isCompleted: json['is_completed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'title': title,
      'description': description,
      'is_completed': isCompleted,
    };
  }
}

class Meta {
  final int totalItems;
  final int totalPages;
  final int perPageItem;
  final int currentPage;
  final int pageSize;
  final bool hasMorePage;

  Meta({
    required this.totalItems,
    required this.totalPages,
    required this.perPageItem,
    required this.currentPage,
    required this.pageSize,
    required this.hasMorePage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      totalItems: json['total_items'],
      totalPages: json['total_pages'],
      perPageItem: json['per_page_item'],
      currentPage: json['current_page'],
      pageSize: json['page_size'],
      hasMorePage: json['has_more_page'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_items': totalItems,
      'total_pages': totalPages,
      'per_page_item': perPageItem,
      'current_page': currentPage,
      'page_size': pageSize,
      'has_more_page': hasMorePage,
    };
  }
}


// class Post {
//   final String? id;
//   final String? description;
//   final String? title;
//   final bool? completed;
//   final String? created_at;
//   final String? updated_at;

//   Post({
//     this.id,
//     this.description,
//     this.title,
//     this.completed,
//     this.created_at,
//     this.updated_at,
//   });

//   factory Post.fromJson(Map<String, dynamic> json) {
//     return Post(
//       id: json['_id'] ?? '',
//       description: json['description'] ?? '',
//       title: json['title'] ?? '',
//       completed: json['is_completed'] ?? false,
//       created_at: json['created_at'] ?? '',
//       updated_at: json['updated_at'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         '_id': id ?? '',
//         'description': description ?? '',
//         'title': title ?? '',
//         'is_completed': completed ?? '',
//         'created_at': created_at ?? '',
//         'updated_at': updated_at ?? '',
//       };
// }
