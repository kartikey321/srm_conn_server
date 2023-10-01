import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:srm_conn_server/helpers/mongo_helper.dart';

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
  final keysToCheck = <String>[
    'senderType',
    'recieverType',
    'senderId',
    'recieverId'
  ];
  if (!(keysToCheck.every(body.containsKey) && body.isNotEmpty)) {
    return Response(body: jsonEncode({"Status": "Provide all fields"}));
  }
  var res;
  try {
    res = await MongoHelper.createThread(
      senderId: body['senderId'] as String,
      senderType: body['senderType'] as String,
      recieverId: body['recieverId'] as String,
      recieverType: body['recieverType'] as String,
    );
  } catch (e) {
    print(e);
    res = e;
  }
  return Response(body: res.toString());
}
