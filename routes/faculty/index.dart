import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:srm_conn_server/helpers/mongo_helper.dart';
import 'package:srm_conn_server/model/faculty.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.post:
      return MongoHelper.startConnection(context, newFaculty(context));
    case HttpMethod.delete:
    case HttpMethod.get:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> newFaculty(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;

  if (body.isNotEmpty) {
    Faculty faculty = Faculty.fromMap(body);
    var res = await MongoHelper.addFaculty(faculty);
    return res;
  } else {
    return Response(
        body: MongoHelper.getReturnMap(
            success: false, message: 'Provide all fields'),
        statusCode: 500);
  }
}
