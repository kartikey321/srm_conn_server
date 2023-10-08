import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:srm_conn_server/helpers/mongo_helper.dart';

Future<Response> onRequest(RequestContext context) async {
  // TODO: implement route handler

  switch (context.request.method) {
    case HttpMethod.patch:
      return await MongoHelper.startConnection(
          context, updateFacultyClass(context));
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
    print(res);
    return res;
  } else {
    return Response(
        body: MongoHelper.getReturnMap(
          success: false,
          message: 'Provide all the fields',
        ),
        statusCode: 500);
  }
}
