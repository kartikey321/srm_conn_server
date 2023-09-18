import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:srm_conn_server/helpers/mongo_helper.dart';
import 'package:srm_conn_server/model/srm_mail.dart';
import 'package:srm_conn_server/model/thread.dart';

Future<Response> onRequest(RequestContext context) async {
  // TODO: implement route handler

  switch (context.request.method) {
    case HttpMethod.post:
      return MongoHelper.startConnection(context, newMail(context));
    case HttpMethod.delete:
    case HttpMethod.get:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> newMail(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;
  var threadId;
  if (body.containsKey('threadId') && body.isNotEmpty) {
    threadId = body['parentId'];
    body.remove('threadId');
  } else {
    return Response(body: jsonEncode({"Status": "Provide all fields"}));
  }
  SRMMail mail = SRMMail.fromMap(body);
  var res = await MongoHelper.addMailToThread(threadId.toString(), mail);
  return Response(body: res.toString());
}
