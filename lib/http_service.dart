import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Post>> fetchPosts() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    headers: {
      'Authorization': 'Bearer YOUR_ACCESS_TOKEN', // Optional header
    },
  );

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, parse the JSON.
    List<dynamic> data = json.decode(response.body);
    return data.map((e) => Post.fromJson(e)).toList();
  } else {
    // If the server does not return a 200 OK response, throw an error.
    throw Exception('Failed to load posts');
  }
}

class Post {
  final int id;
  final String title;
  final String body;

  Post({required this.id, required this.title, required this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}
