import 'package:crud_api/repositories/post_repositories.dart';

import '../models/post_model.dart';

class PostService {
  static const String endpoint = 'posts';

  static Future<List<Post>> getPosts() async {
    final data = await PostRepository.get('?page=1&limit=10');
    return List<Post>.from(data.map((x) => Post.fromJson(x)));
  }

  static Future<Post> create(Post post) async {
    final data = await PostRepository.post(post.toJson());

    return Post.fromJson(data);
  }

  static Future<Post> update(Post post) async {
    final data = await PostRepository.put(post.id.toString(), post.toJson());
    return Post.fromJson(data);
  }

  static Future<void> delete(String id) async {
    await PostRepository.delete(id);
  }
}
