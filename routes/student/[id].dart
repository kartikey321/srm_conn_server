import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:srm_conn_server/helpers/mongo_helper.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return MongoHelper.startConnection(context, fetchStudent(context, id));
    case HttpMethod.delete:
      return MongoHelper.startConnection(context, deleteParent(context, id));
    case HttpMethod.post:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> deleteParent(RequestContext context, String id) async {
  var res = await MongoHelper.deleteParent(id);
  return Response.json(body: res.toString());
}

Future<Response> fetchStudent(RequestContext context, String id) async {
  var data = await MongoHelper.getStudentbyId(id);
  return Response(body: data!.toJson());
}
