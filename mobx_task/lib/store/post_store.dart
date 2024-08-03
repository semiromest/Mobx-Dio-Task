import 'package:mobx/mobx.dart';
import 'package:dio/dio.dart';
import '../../models/post.dart'; // Yeni Post sınıfını içe aktar

// Include generated file
part '../post_store.g.dart';

// This is the class used by rest of your codebase
class PostStore = _PostStore with _$PostStore;

// The store-class
abstract class _PostStore with Store {
  final Dio _dio = Dio();

  @observable
  bool isLoading = false;

  @observable
  ObservableList<Post> posts = ObservableList<Post>();

  @action
  Future<void> fetchPosts() async {
    isLoading = true;
    try {
      final response =
          await _dio.get('https://jsonplaceholder.typicode.com/posts');
      final List<dynamic> data = response.data;
      posts = data.map((post) => Post.fromJson(post)).toList().asObservable();
    } catch (e) {
      print('Failed to fetch posts: $e');
    } finally {
      isLoading = false;
    }
  }
}
