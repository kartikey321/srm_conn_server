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
    case HttpMethod.patch:
      return MongoHelper.startConnection(context, updateFacultyClass(context));
    case HttpMethod.delete:
    case HttpMethod.get:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.post:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> updateFacultyClass(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;
  print(body);
  if (body.isNotEmpty && body.containsKey('regNum')) {
    var res = await MongoHelper.updateFacultyBatchYear(body);

    return Response(body: res.toString());
  } else {
    return Response(body: jsonEncode({"Status": "Provide all fields"}));
  }
}