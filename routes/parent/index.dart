import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:srm_conn_server/helpers/mongo_helper.dart';
import 'package:srm_conn_server/model/parent.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.post:
      return MongoHelper.startConnection(context, addPar(context));
    case HttpMethod.delete:
    case HttpMethod.get:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> addPar(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;

  Parent parent = Parent.fromMap(body);
  var res = await MongoHelper.addParent(parent);
  return Response(body: res.toString());
}
