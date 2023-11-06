import 'package:kids_care_demo/app/core/domain/objects/files.dart';

class Post {
  String id;
  String active;
  String title;
  String date;
  List<PostFile> files;

  Post({
    required this.id,
    required this.active,
    required this.title,
    required this.date,
    required this.files,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    List<dynamic> filesList = json['files'];
    List<PostFile> parsedFiles = filesList.map((fileJson) => PostFile.fromJson(fileJson)).toList();

    return Post(
      id: json['id'],
      active: json['active'],
      title: json['title'],
      date: json['date'],
      files: parsedFiles,
    );
  }
}
