import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:srm_conn_server/helpers/mongo_helper.dart';
import 'package:srm_conn_server/model/faculty.dart';
import 'package:srm_conn_server/model/srm_mail.dart';
import 'package:srm_conn_server/model/thread.dart';

Future<Response> onRequest(RequestContext context) async {
  // TODO: implement route handler

  switch (context.request.method) {
    case HttpMethod.get:
      return MongoHelper.startConnection(context, getAllFaculties(context));
    case HttpMethod.delete:
    case HttpMethod.patch:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.post:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> getAllFaculties(RequestContext context) async {
  var res = await MongoHelper.getAllFaculties();
  List<Map<String, dynamic>> facultyJsonList =
      res!.map((stud) => stud!.toMap()).toList();

  return Response(body: jsonEncode(facultyJsonList));
}
