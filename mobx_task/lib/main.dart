import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'store/post_store.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PostStore>(create: (_) => PostStore()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MobX Dio Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final postStore = Provider.of<PostStore>(context, listen: false);
    postStore.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    final postStore = Provider.of<PostStore>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MobX Dio Task'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              postStore.fetchPosts();
            },
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (postStore.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (postStore.posts.isEmpty) {
            return const Center(child: Text('No posts available'));
          }

          return ListView.builder(
            itemCount: postStore.posts.length,
            itemBuilder: (context, index) {
              final post = postStore.posts[index];
              return ListTile(
                title: Text(post.title),
                subtitle: Text(post.body),
              );
            },
          );
        },
      ),
    );
  }
}
