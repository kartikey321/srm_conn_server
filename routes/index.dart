import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:srm_conn_server/helpers/mongo_helper.dart';
import 'package:srm_conn_server/model/thread.dart';

Future<Response> onRequest(RequestContext context) async {
  // TODO: implement route handler

  switch (context.request.method) {
    case HttpMethod.post:
      return MongoHelper.startConnection(context, newThread(context));
    case HttpMethod.delete:
    case HttpMethod.get:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> newThread(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;
  var parentId;
  if (body.containsKey('parentId') && body.isNotEmpty) {
    parentId = body['parentId'];
    body.remove('parentId');
  } else {
    return Response(body: jsonEncode({"Status": "Provide all fields"}));
  }
  Thread thread = Thread.fromMap(body);
  var res = await MongoHelper.createThread(parentId.toString(), thread);
  return Response(body: res.toString());
}
