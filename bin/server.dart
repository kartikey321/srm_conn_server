// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, implicit_dynamic_list_literal

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../routes/thread/index.dart' as thread_index;
import '../routes/thread/[id].dart' as thread_$id;
import '../routes/student/index.dart' as student_index;
import '../routes/student/[id].dart' as student_$id;
import '../routes/parent/index.dart' as parent_index;
import '../routes/parent/[id].dart' as parent_$id;
import '../routes/mail/index.dart' as mail_index;
import '../routes/mail/[id].dart' as mail_$id;
import '../routes/faculty/index.dart' as faculty_index;
import '../routes/faculty/updateclass/index.dart' as faculty_updateclass_index;
import '../routes/faculty/details/index.dart' as faculty_details_index;
import '../routes/faculty/details/[id].dart' as faculty_details_$id;

import '../routes/_middleware.dart' as middleware;

void main() async {
  final address = InternetAddress.anyIPv6;
  final port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;
  createServer(address, port);
}

Future<HttpServer> createServer(InternetAddress address, int port) async {
  final handler = Cascade().add(buildRootHandler()).handler;
  final server = await serve(handler, address, port);
  print(
      '\x1B[92m✓\x1B[0m Running on http://${server.address.host}:${server.port}');
  return server;
}

Handler buildRootHandler() {
  final pipeline = const Pipeline().addMiddleware(middleware.middleware);
  final router = Router()
    ..mount('/faculty/details',
        (RequestContext context) => buildFacultyDetailsHandler()(context))
    ..mount('/faculty/updateclass',
        (RequestContext context) => buildFacultyUpdateclassHandler()(context))
    ..mount(
        '/faculty', (RequestContext context) => buildFacultyHandler()(context))
    ..mount('/mail', (RequestContext context) => buildMailHandler()(context))
    ..mount(
        '/parent', (RequestContext context) => buildParentHandler()(context))
    ..mount(
        '/student', (RequestContext context) => buildStudentHandler()(context))
    ..mount(
        '/thread', (RequestContext context) => buildThreadHandler()(context));
  return pipeline.addHandler(router);
}

Handler buildFacultyDetailsHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all(
        '/',
        (RequestContext context) => faculty_details_index.onRequest(
              context,
            ))
    ..all(
        '/<id>',
        (
          RequestContext context,
          String id,
        ) =>
            faculty_details_$id.onRequest(
              context,
              id,
            ));
  return pipeline.addHandler(router);
}

Handler buildFacultyUpdateclassHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all(
        '/',
        (RequestContext context) => faculty_updateclass_index.onRequest(
              context,
            ));
  return pipeline.addHandler(router);
}

Handler buildFacultyHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all(
        '/',
        (RequestContext context) => faculty_index.onRequest(
              context,
            ));
  return pipeline.addHandler(router);
}

Handler buildMailHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all(
        '/',
        (RequestContext context) => mail_index.onRequest(
              context,
            ))
    ..all(
        '/<id>',
        (
          RequestContext context,
          String id,
        ) =>
            mail_$id.onRequest(
              context,
              id,
            ));
  return pipeline.addHandler(router);
}

Handler buildParentHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all(
        '/',
        (RequestContext context) => parent_index.onRequest(
              context,
            ))
    ..all(
        '/<id>',
        (
          RequestContext context,
          String id,
        ) =>
            parent_$id.onRequest(
              context,
              id,
            ));
  return pipeline.addHandler(router);
}

Handler buildStudentHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all(
        '/',
        (RequestContext context) => student_index.onRequest(
              context,
            ))
    ..all(
        '/<id>',
        (
          RequestContext context,
          String id,
        ) =>
            student_$id.onRequest(
              context,
              id,
            ));
  return pipeline.addHandler(router);
}

Handler buildThreadHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all(
        '/',
        (RequestContext context) => thread_index.onRequest(
              context,
            ))
    ..all(
        '/<id>',
        (
          RequestContext context,
          String id,
        ) =>
            thread_$id.onRequest(
              context,
              id,
            ));
  return pipeline.addHandler(router);
}
