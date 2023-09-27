import 'dart:convert';
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
  return Response(body: res.toString());
}

Future<Response> verifyPar(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;

  if (body.isNotEmpty && body.containsKey('email')) {
    var res = await MongoHelper.verifyParent(body['email'].toString());
    return Response(body: res.toString());
  }
  return Response(body: 'Send parent email id');
}

Future<Response> getAllPar(RequestContext context) async {
  var res = await MongoHelper.getAllParents();
  List<Map<String, dynamic>> studentJsonList =
      res!.map((stud) => stud!.toMap()).toList();

  return Response(body: jsonEncode(studentJsonList));
}
