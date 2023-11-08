import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:srm_conn_server/helpers/mongo_helper.dart';

Future<Response> onRequest(RequestContext context) async {
  // TODO: implement route handler

  switch (context.request.method) {
    case HttpMethod.post:
      return MongoHelper.startConnection(context, newNotif(context));
    case HttpMethod.delete:
    case HttpMethod.put:
      return MongoHelper.startConnection(context, addNotifToken(context));
    case HttpMethod.get:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> addNotifToken(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;
  final email = body['email'] as String;
  final token = body['token'] as String;

  final res = await MongoHelper.updateParenToken(email, token);
  return res;
}

Future<Response> newNotif(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;
  print(body);
  final email = body['email'] as String;
  print('email: $email');
  final notifTitle = body['title'] as String;
  print('title: $notifTitle');
  final notifBody = body['body'] as String;
  print('body: $notifBody');
  final res = await MongoHelper.sendNotifsToUsers(email, notifTitle, notifBody);
  return res;
}
