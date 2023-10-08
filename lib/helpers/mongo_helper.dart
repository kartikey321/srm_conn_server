// ignore_for_file: public_member_api_docs, prefer_final_locals, avoid_print, prefer_single_quotes, void_checks, omit_local_variable_types, prefer_final_in_for_each, always_use_package_imports, lines_longer_than_80_chars

import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:srm_conn_server/model/faculty.dart';
import 'package:srm_conn_server/model/srm_mail.dart';
import 'package:srm_conn_server/model/thread.dart';

import '../model/parent.dart';
import '../model/student.dart';

class MongoHelper {
  static String studentPath = 'students';
  static String facultyPath = 'faculties';
  static String parentPath = 'parents';
  static String threadPath = 'threads';
  static String mailPath = 'mails';
  static mongo.Db? db;

  static Future<mongo.Db> initiaize() async {
    db = await mongo.Db.create(
      'mongodb+srv://kartikey321:kartikey321@cluster0.ykqbrjy.mongodb.net/srm_connect',
    );
    var res = await db!.open();
    print(res);
    return db!;
  }

  static Future<Response> startConnection(
    RequestContext context,
    Future<Response> callBack,
  ) async {
    try {
      while (db == null) {
        var res = await initiaize();
      }

      return await callBack;
    } catch (e) {
      return Response.json(
        statusCode: 500,
        body: {'message': e.toString()},
      );
    }
  }

  static Future<void> clearAllCollections() async {
    // Open the database connection if not already opened

    var collections = await db!.getCollectionNames();
    for (var collectionName in collections) {
      var collection = db!.collection(collectionName!);
      await collection.drop();
      print('Collection $collectionName cleared.');
    }
  }

  static Future<Response> addParent(Parent parent) async {
    var parentsColl = db!.collection(parentPath);
    var res = await parentsColl.findOne({'email': parent.email});

    if (res != null) {
      return Response(
        body: getReturnMap(
            success: false, message: 'Parent with same email already exists'),
        statusCode: 500,
      );
    }
    await parentsColl.createIndex(
      keys: {'email': 1},
      unique: true,
    );
    try {
      await parentsColl.insertOne(parent.toMap());
      print('Parent added!');
      return Response(
        body: getReturnMap(success: true, message: 'Parent added'),
      );
    } catch (e) {
      // Handle other errors, if any
      print('Error: $e');
      return Response(
        body: getReturnMap(success: false, message: 'Error $e'),
        statusCode: 500,
      );
    }
  }

  static Future<Response> getAllParents() async {
    try {
      var parentsColl = db!.collection(parentPath);

      var data = await parentsColl.find().toList();
      print(data);
      List<Parent> parentList = [];
      if (data != null) {
        for (var d in data as List) {
          var parent = Parent.fromMap(d as Map<String, dynamic>);
          parentList.add(parent);
        }
      }
      List<Map<String, dynamic>> parentJsonList =
          parentList.map((parent) => parent.toMap()).toList();
      var resp =
          getReturnMap(success: true, message: 'Success', data: parentJsonList);
      print(resp);
      return Response(body: resp);
    } catch (e) {
      return Response(
          body: getReturnMap(
            success: false,
            message: 'Error $e',
          ),
          statusCode: 500);
    }
  }

  static Future<Response> addFaculty(Faculty faculty) async {
    var facultyColl = db!.collection(facultyPath);

    var res = await facultyColl.findOne({'email': faculty.email});

    if (res != null) {
      return Response(
        body: getReturnMap(
            success: false, message: 'Faculty with same email already exists'),
        statusCode: 500,
      );
    }
    res = await facultyColl.findOne({'regNum': faculty.regNum});
    if (res != null) {
      return Response(
        body: getReturnMap(
            success: false,
            message: 'Faculty with same register number already exists'),
        statusCode: 500,
      );
    }
    await facultyColl.createIndex(
      keys: {'email': 1},
      unique: true,
    );
    try {
      await facultyColl.insertOne(faculty.toMap());
      print('Faculty added!');
      return Response(
        body: getReturnMap(success: true, message: 'Faculty added'),
      );
    } catch (e) {
      // Handle other errors, if any
      print('Error: $e');
      return Response(
        body: getReturnMap(success: false, message: 'Error $e'),
        statusCode: 500,
      );
    }
  }

  static Future<Response> getAllFaculties() async {
    var facultiesColl = db!.collection(facultyPath);

    var data = await facultiesColl.find().toList();
    print(data);
    List<Faculty> facultyList = [];
    if (data != null) {
      for (var d in data as List) {
        var faculty = Faculty.fromMap(d as Map<String, dynamic>);
        var res = await getStudentsByFacultyId(faculty.regNum);
        faculty.studentId = res;
        facultyList.add(faculty);
      }
    }
    List<Map<String, dynamic>> facultyJsonList =
        facultyList.map((faculty) => faculty.toMap()).toList();
    var resp =
        getReturnMap(success: true, message: 'Success', data: facultyJsonList);
    return Response(body: resp);
  }

  static Future<Response> updateFacultyBatchYear(
      Map<String, dynamic> update) async {
    print('update1: $update');
    Map<String, dynamic> update1 = {
      "regNum": update['regNum'],
      "batch": update['batch'],
      "semester": update['semester']
    };
    print('update1: $update1');
    var res = await updateFaculty(update1);
    return res;
  }

  static Future<Response> getFacultybyId(String id) async {
    print(db);
    var facultyColl = db!.collection(facultyPath);
    var threadsColl = db!.collection(threadPath);
    print(id);

    var data = await facultyColl.findOne(mongo.where.eq('regNum', id));
    print(data);
    if (data != null) {
      Faculty model = Faculty.fromMap(data);
      var res = await getStudentsByFacultyId(id);
      model.studentId = res;
      if (model.threads != null) {
        List<Thread> sortedThreads = [];
        for (final threadId in model.threads!) {
          final threadDoc = await threadsColl.findOne(
              mongo.where.id(mongo.ObjectId.fromHexString(threadId as String)));
          if (threadDoc != null) {
            Thread thread = Thread.fromMap(threadDoc);
            sortedThreads.add(thread);
          }
        }

        sortedThreads.sort(
            (a, b) => a.updatedAt.compareTo(b.updatedAt)); // Sort by timestamp
        model.threads = sortedThreads.map((e) => e.id).toList();
      }
      return Response(
        body: getReturnMap(
            success: true, message: 'Found faculty', data: model.toMap()),
      );
    } else {
      return Response(
          body: getReturnMap(
            success: false,
            message: 'No faculty with this register number exists',
          ),
          statusCode: 500);
    }
  }

  static Future<List<String>> getStudentsByFacultyId(String facultyId) async {
    var studentsColl = db!.collection(studentPath);

    final studentsStream =
        studentsColl.find(mongo.where.eq('courses.facultyId', facultyId));

    final studentRegNums = await studentsStream
        .map((student) => student['regNum'] as String)
        .toList();

    return studentRegNums;
  }

  static Future<Response> updateFaculty(Map<String, dynamic> faculty) async {
    var studentsColl = db!.collection(facultyPath);
    try {
      final update = mongo.ModifierBuilder();

      faculty.forEach((key, value) {
        update.set(key, value);
      });

      // Perform the update
      final result = await studentsColl.update(
          mongo.where.eq('regNum', faculty['regNum']), update);

      // if (result["nModified"] != null && result["nModified"] > 0) {
      //   print("Document updated successfully.");
      // } else {
      //   print("Document not updated. No changes made.");
      // }
      print('result: ${result["nModified"]}');
      return Response(
          body: getReturnMap(success: true, message: 'Faculty Updated'));
    } catch (e) {
      print(e);
      return Response(
        body: getReturnMap(success: false, message: 'Error $e'),
        statusCode: 500,
      );
    }
  }

  static String getReturnMap(
      {required bool success, required String message, dynamic data}) {
    Map<String, dynamic> returnMap = {"success": success, 'message': message};
    Map<String, dynamic> returnMapData = {
      "success": success,
      'message': message,
      'data': data
    };
    return jsonEncode(data == null ? returnMap : returnMapData);
  }

  static Future<Response> addStudent(Student student) async {
    var studentsColl = db!.collection(studentPath);

    var res = await studentsColl.findOne({'email': student.email});

    if (res != null) {
      return Response(
        body: getReturnMap(
            success: false, message: 'Student with same email already exists'),
        statusCode: 500,
      );
    }
    res = await studentsColl.findOne({'regNum': student.regNum});
    if (res != null) {
      return Response(
        body: getReturnMap(
            success: false,
            message: 'Student with same register number already exists'),
        statusCode: 500,
      );
    }
    await studentsColl.createIndex(
      keys: {'email': 1, 'regNum': 1},
      unique: true,
    );

    try {
      var res = await studentsColl.insertOne(student.toMap());
      print(res.success);
      if (res.success) {
        print('Student added!');
        return Response(
          body: getReturnMap(
            success: true,
            message: 'Student added',
          ),
          statusCode: 500,
        );
      } else {
        print('Error: Email already exists');
        return Response(
          body: getReturnMap(
              success: false,
              message: 'Student with same email already exists'),
          statusCode: 500,
        );
      }
    } catch (e) {
      // Handle other errors, if any
      print('Error: $e');
      return Response(
        body: getReturnMap(success: false, message: 'Error $e'),
        statusCode: 500,
      );
    }
  }

  static Future<Response> updateStudent(Map<String, dynamic> student) async {
    var studentsColl = db!.collection(studentPath);
    try {
      final update = mongo.ModifierBuilder();

      student.forEach((key, value) {
        update.set(key, value);
      });

      // Perform the update
      final result = await studentsColl.update(
          mongo.where.eq('regNum', student['regNum']), update);

      // if (result["nModified"] != null && result["nModified"] > 0) {
      //   print("Document updated successfully.");
      // } else {
      //   print("Document not updated. No changes made.");
      // }
      print(result);
      return Response(
          body: getReturnMap(success: true, message: 'Student Updated'));
    } catch (e) {
      print(e);
      return Response(
        body: getReturnMap(success: false, message: 'Error $e'),
        statusCode: 500,
      );
    }
  }

  static Future<Response> getAllStudents() async {
    var studentsColl = db!.collection(studentPath);

    var data = await studentsColl.find().toList();
    print(data);
    List<Student> studList = [];
    if (data != null) {
      for (var d in data as List) {
        var student = Student.fromMap(d);
        studList.add(student);
      }
    }
    List<Map<String, dynamic>> studJsonList =
        studList.map((stud) => stud.toMap()).toList();
    var resp =
        getReturnMap(success: true, message: 'Success', data: studJsonList);
    return Response(body: resp);
  }

  static Future<Response> getStudentbyId(String id) async {
    print(db);
    var studentsColl = db!.collection(studentPath);
    print(id);

    var data = await studentsColl.findOne(mongo.where.eq('regNum', id));
    print(data);
    if (data != null) {
      Student model = Student.fromMap(data);
      return Response(
        body: getReturnMap(
            success: true, message: 'Found student', data: model.toMap()),
      );
    } else {
      return Response(
          body: getReturnMap(
            success: false,
            message: 'No student with this register number exists',
          ),
          statusCode: 500);
    }
  }

  static Future<Response> getParentbyId(String email) async {
    var parentsColl = db!.collection(parentPath);
    var threadsColl = db!.collection(threadPath);
    print(email);
    try {
      var data = await parentsColl.findOne(mongo.where.eq('email', email));
      print(data);
      if (data != null) {
        Parent model = Parent.fromMap(data);
        if (model.threads != null) {
          List<Thread> sortedThreads = [];
          for (final threadId in model.threads!) {
            final threadDoc = await threadsColl.findOne(mongo.where
                .id(mongo.ObjectId.fromHexString(threadId as String)));
            if (threadDoc != null) {
              Thread thread = Thread.fromMap(threadDoc);
              sortedThreads.add(thread);
            }
          }

          sortedThreads.sort((a, b) =>
              a.updatedAt.compareTo(b.updatedAt)); // Sort by timestamp
          model.threads = sortedThreads.map((e) => e.id).toList();
        }

        return Response(
          body: getReturnMap(
              success: true, message: 'Found student', data: model.toMap()),
        );
      } else {
        return Response(
            body: getReturnMap(
              success: false,
              message: 'No student with this register number exists',
            ),
            statusCode: 500);
      }
    } catch (e) {
      return Response(
          body: getReturnMap(
            success: false,
            message: 'Error $e',
          ),
          statusCode: 500);
    }
  }

  static Future<Response> verifyParent(String email) async {
    var parentsColl = db!.collection(parentPath);

    var filter = mongo.where.eq('email', email);
    var update = mongo.modify.set('verified', true);
    try {
      var resp = await parentsColl.updateOne(filter, update);
      if (resp.success) {
        return Response(
            body:
                getReturnMap(success: true, message: 'Verified parent $email'));
      } else {
        return Response(
            body: getReturnMap(
                success: false, message: "Couldnt't verify parent $email"));
      }
    } catch (e) {
      return Response(
          body: getReturnMap(
            success: false,
            message: 'Error $e',
          ),
          statusCode: 500);
    }
  }

  static Future<Response> deleteParent(String email) async {
    try {
      var parentsColl = db!.collection(parentPath);
      var resp = await parentsColl.deleteOne(mongo.where.eq('email', email));
      if (resp.success) {
        return Response(
            body:
                getReturnMap(success: true, message: 'Deleted parent $email'));
      } else {
        return Response(
            body: getReturnMap(
                success: false, message: "Couldn't parent $email"));
      }
    } catch (e) {
      return Response(
          body: getReturnMap(
            success: false,
            message: 'Error $e',
          ),
          statusCode: 500);
    }
  }

  static Future<Response> deleteStudent(String email) async {
    try {
      var studentsColl = db!.collection(studentPath);
      var resp = await studentsColl.deleteOne(mongo.where.eq('email', email));
      if (resp.success) {
        return Response(
            body:
                getReturnMap(success: true, message: 'Deleted studeny $email'));
      } else {
        return Response(
            body: getReturnMap(
                success: false, message: 'Couldn\'t student $email'));
      }
    } catch (e) {
      return Response(
          body: getReturnMap(
            success: false,
            message: 'Error $e',
          ),
          statusCode: 500);
    }
  }

  static Future<Response> getThread(String id) async {
    var threadColl = db!.collection(threadPath);
    print(id);
    var objId = mongo.ObjectId.fromHexString('$id');
    print(objId);
    try {
      var data = await threadColl.findOne(mongo.where.id(objId));
      print(data);
      if (data != null) {
        Thread model = Thread.fromMap(data);
        return Response(
          body: getReturnMap(
              success: true, message: 'Found thread', data: model.toMap()),
        );
      } else {
        return Response(
            body: getReturnMap(
              success: false,
              message: 'No such thread is found',
            ),
            statusCode: 500);
      }
    } catch (e) {
      return Response(
          body: getReturnMap(success: false, message: 'Error $e'),
          statusCode: 500);
    }
  }

  static Future<Response> getMail(String id) async {
    var mailColl = db!.collection(mailPath);
    print(id);
    var objId = mongo.ObjectId.fromHexString(id);
    print(objId);
    var data = await mailColl.findOne(mongo.where.id(objId));
    print(data);
    if (data != null) {
      SRMMail model = SRMMail.fromMap(data);
      return Response(
        body: getReturnMap(
            success: true, message: 'Found mail', data: model.toMap()),
      );
    } else {
      return Response(
          body: getReturnMap(
            success: false,
            message: 'No such mail is found',
          ),
          statusCode: 500);
    }
  }

  static Future<Response> addMailToThread(String threadId, SRMMail mail) async {
    var threadsColl = db!.collection(threadPath);
    var mailsColl = db!.collection(mailPath);
    print(threadId);
    print(mail.toJson());
    try {
      //adding mail
      var addedMail = await mailsColl.insertOne(mail.toMap());

      //adding mail to threads collection
      final threadUpdateResult = await threadsColl.update(
        mongo.where.id(mongo.ObjectId.fromHexString(threadId)),
        mongo.modify.addToSet('messageIds', addedMail.id),
      );
      await threadsColl.update(
        mongo.where.id(mongo.ObjectId.fromHexString(threadId)),
        mongo.modify.set('updatedAt', mail.time.toIso8601String()),
      );

      print("Success: Mail Sent  ${threadUpdateResult}");
      return Response(
          body: getReturnMap(
              success: true,
              message: 'Mail Sent',
              data: {'mailId': addedMail.id}));
    } catch (e) {
      print(e);
      return Response(
          body: getReturnMap(success: false, message: 'Error $e'),
          statusCode: 500);
    }
  }

  static Future<Response> createThread(
      {required String senderType,
      required String senderId,
      required String recieverId,
      required String recieverType}) async {
    var threadsColl = db!.collection(threadPath);
    var senderColl = db!.collection(senderType);
    var recieverColl = db!.collection(recieverType);
    try {
      //creating thread
      Thread thread = Thread(
          createdAt: DateTime.now(), updatedAt: DateTime.now(), messageIds: []);
      var map = thread.toMap();
      var id = mongo.ObjectId();
      map['id'] = id.toHexString();
      map['_id'] = id;
      var addedThred = await threadsColl.insertOne(map);
      //adding thread to senders collection
      var filter = mongo.where.eq('email', senderId);
      await senderColl.update(
        filter,
        mongo.modify.addToSet('threads', id.toHexString()),
      );
      await recieverColl.update(
        mongo.where.eq('email', recieverId),
        mongo.modify.addToSet('threads', id.toHexString()),
      );
      print('Success: Mail Sent');
      return Response(
          body: getReturnMap(
              success: true,
              message: 'Thread created',
              data: {'threadId': id.toHexString()}));
    } catch (e) {
      print(e);
      return Response(
          body: getReturnMap(success: false, message: 'Error $e'),
          statusCode: 500);
    }
  }
}
