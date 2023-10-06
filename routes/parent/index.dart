import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:srm_conn_server/helpers/mongo_helper.dart';
import 'package:srm_conn_server/model/parent.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.post:
      return MongoHelper.startConnection(context, addPar(context));
    case HttpMethod.patch:
      return MongoHelper.startConnection(context, verifyPar(context));
    case HttpMethod.get:
      return MongoHelper.startConnection(context, getAllPar(context));
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> addPar(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;

  Parent parent = Parent.fromMap(body);
  var res = await MongoHelper.addParent(parent);
  return res;
}

Future<Response> verifyPar(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;

  if (body.isNotEmpty && body.containsKey('email')) {
    var res = await MongoHelper.verifyParent(body['email'].toString());
    return res;
  }
  return Response(
      body: MongoHelper.getReturnMap(
        success: false,
        message: 'Send parent email id',
      ),
      statusCode: 500);
}

Future<Response> getAllPar(RequestContext context) async {
  print(context);
  var res = await MongoHelper.getAllParents();
  return res;
}
