class PostFile {
  String file;
  String classIds;
  List<String> classesIds;

  PostFile({
    required this.file,
    required this.classIds,
    required this.classesIds,
  });

  factory PostFile.fromJson(Map<String, dynamic> json) {
    List<dynamic> classesIdsList = json['classesIds'];
    List<String> parsedClassesIds =
        classesIdsList.map((classId) => classId.toString()).toList();

    return PostFile(
      file: replaceSubString(json['file']??""),
      classIds: json['classIds'],
      classesIds: parsedClassesIds,
    );
  }
}

// manage returned image
String replaceSubString(String inputLink) {
  return inputLink.replaceAll("/healthupdates/", "%2Fhealthupdates%2F");
}
