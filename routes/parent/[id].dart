import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:srm_conn_server/helpers/mongo_helper.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return MongoHelper.startConnection(context, fetchParent(context, id));
    case HttpMethod.patch:
      return MongoHelper.startConnection(context, verifyParent(context, id));
    case HttpMethod.delete:
      return MongoHelper.startConnection(context, deleteParent(context, id));
    case HttpMethod.post:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> deleteParent(RequestContext context, String id) async {
  var res = await MongoHelper.deleteParent(id);
  return Response.json(body: res.toString());
}

Future<Response> verifyParent(RequestContext context, String id) async {
  var res = await MongoHelper.verifyParent(id);
  return Response.json(body: res.toString());
}

Future<Response> fetchParent(RequestContext context, String id) async {
  var data = await MongoHelper.getParentbyId(id);
  print(data);
  return Response.json(body: data!.toMap());
}
