import 'package:crud_api/repositories/post_repositories.dart';

import '../models/post_model.dart';

class PostService {
  static const String endpoint = 'posts';

  static Future<List<Item>> getPosts(int page,) async {
    final data = await PostRepository.get('?page=$page&limit=10');
  
    return List<Item>.from(data.map((x) => Item.fromJson(x)));
  }

  static Future<Item> create(Item post) async {
    final data = await PostRepository.post(post.toJson());

    return Item.fromJson(data);
  }

  static Future<Item> update(Item post) async {
    final data = await PostRepository.put(post.id.toString(), post.toJson());
    return Item.fromJson(data);
  }

  static Future<void> delete(String id) async {
    await PostRepository.delete(id);
  }
}
