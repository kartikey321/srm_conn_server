import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:srm_conn_server/helpers/mongo_helper.dart';
import 'package:srm_conn_server/model/student.dart';

Future<Response> onRequest(RequestContext context) async {
  // TODO: implement route handler

  switch (context.request.method) {
    case HttpMethod.post:
      return MongoHelper.startConnection(context, addStud(context));

    case HttpMethod.put:
      return MongoHelper.startConnection(context, updateStud(context));
    case HttpMethod.get:
      return MongoHelper.startConnection(context, getAllStud(context));
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> addStud(RequestContext context) async {
  try {
    final body = await context.request.json() as Map<String, dynamic>;
    Student student = Student.fromMap(body);
    var res = await MongoHelper.addStudent(student);
    return res;
  } catch (e) {
    return Response(body: e.toString());
  }
}

Future<Response> updateStud(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;
  if (body.isNotEmpty && body.containsKey('regNum')) {
    var res = await MongoHelper.updateStudent(body);
    return res;
  }
  return Response(
      body: MongoHelper.getReturnMap(
          success: false,
          message:
              'Provide student id along with the details you want to update'),
      statusCode: 500);
}

Future<Response> getAllStud(RequestContext context) async {
  var res = await MongoHelper.getAllStudents();

  return res;
}
