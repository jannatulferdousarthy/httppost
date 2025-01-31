import 'dart:convert';
import 'package:chopper/chopper.dart';

part 'chopper_service.chopper.dart'; // This part is generated by Chopper

@ChopperApi(baseUrl: 'https://jsonplaceholder.typicode.com')
abstract class PostService extends ChopperService {
  @Get(path: '/posts')
  Future<Response> getPosts();

  static PostService create([ChopperClient? client]) =>
      _$PostService(client);
}
import 'package:flutter/material.dart';
import 'package:chopper/chopper.dart';
import 'chopper_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChopperPostsScreen(),
    );
  }
}

class ChopperPostsScreen extends StatefulWidget {
  @override
  _ChopperPostsScreenState createState() => _ChopperPostsScreenState();
}

class _ChopperPostsScreenState extends State<ChopperPostsScreen> {
  late Future<List<Post>> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = fetchPostsWithChopper();
  }

  Future<List<Post>> fetchPostsWithChopper() async {
    final client = ChopperClient(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      services: [
        PostService.create(),
      ],
      converter: JsonConverter(),
      interceptors: [
        HeadersInterceptor(),
        LogInterceptor(),
      ],
    );

    final postService = PostService.create(client);
    final response = await postService.getPosts();

    if (response.isSuccessful) {
      List<dynamic> data = json.decode(response.bodyString!);
      return data.map((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chopper Posts'),
      ),
      body: FutureBuilder<List<Post>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return ListTile(
                  title: Text(post.title),
                  subtitle: Text(post.body),
                );
              },
            );
          }
          return Center(child: Text('No data available'));
        },
      ),
    );
  }
}
class HeadersInterceptor implements RequestInterceptor {
  @override
  Future<Request> onRequest(Request request) async {
    final modifiedRequest = request.copyWith(
      headers: {'Authorization': 'Bearer YOUR_ACCESS_TOKEN'},
    );
    return modifiedRequest;
  }
}
class LogInterceptor implements ResponseInterceptor {
  @override
  Future<Response> onResponse(Response response) async {
    print('Response: ${response.body}');
    return response;
  }

  @override
  Future<Request> onRequest(Request request) async {
    print('Request: ${request.url}');
    return request;
  }
}
class LogInterceptor implements ResponseInterceptor {
  @override
  Future<Response> onResponse(Response response) async {
    print('Response: ${response.body}');
    return response;
  }

  @override
  Future<Request> onRequest(Request request) async {
    print('Request: ${request.url}');
    return request;
  }
}
