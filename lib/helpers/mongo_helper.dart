// ignore_for_file: public_member_api_docs, prefer_final_locals, avoid_print, prefer_single_quotes, void_checks, omit_local_variable_types, prefer_final_in_for_each, always_use_package_imports, lines_longer_than_80_chars

import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:srm_conn_server/model/faculty.dart';
import 'package:srm_conn_server/model/srm_mail.dart';
import 'package:srm_conn_server/model/thread.dart';

import '../model/course.dart';
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
      'mongodb+srv://kartikey321:kartikey321@cluster0.ykqbrjy.mongodb.net/',
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
        body: {'message': 'Internal Server Error'},
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

  static Future addParent(Parent parent) async {
    var parentsColl = db!.collection(parentPath);
    await parentsColl.createIndex(
      keys: {'email': 1},
      unique: true,
    );
    try {
      await parentsColl.insertOne(parent.toMap());
      print('Parent added!');
      return 'Success: Parent added';
    } catch (e) {
      // Handle other errors, if any
      print('Error: $e');
      return 'Error: $e';
    }
  }

  static Future<List<Parent?>?> getAllParents() async {
    var parentsColl = db!.collection(parentPath);

    var data = await parentsColl.find().toList();
    print(data);
    List<Parent> parentList = [];
    if (data != null) {
      for (var d in data as List) {
        var student = Parent.fromMap(d as Map<String, dynamic>);
        parentList.add(student);
      }
    }
    return parentList;
  }

  static Future addFaculty(Faculty faculty) async {
    var facultyColl = db!.collection(facultyPath);
    await facultyColl.createIndex(
      keys: {'email': 1},
      unique: true,
    );
    try {
      await facultyColl.insertOne(faculty.toMap());
      print('Faculty added!');
      return 'Success: Faculty added';
    } catch (e) {
      // Handle other errors, if any
      print('Error: $e');
      return 'Error: $e';
    }
  }

  static Future<List<Faculty?>?> getAllFaculties() async {
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
    return facultyList;
  }

  static Future updateFacultyBatchYear(Map<String, dynamic> update) async {
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

  static Future<Faculty?> getFacultybyId(String id) async {
    print(db);
    var facultyColl = db!.collection(facultyPath);
    print(id);

    var data = await facultyColl.findOne(mongo.where.eq('regNum', id));
    print(data);
    if (data != null) {
      Faculty model = Faculty.fromMap(data);
      var res = await getStudentsByFacultyId(id);
      model.studentId = res;
      return model;
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

  static Future updateFaculty(Map<String, dynamic> faculty) async {
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
      return ({"status": "success"});
    } catch (e) {
      print(e);
      return e;
    }
  }

  static Future addStudent(Student student) async {
    var studentsColl = db!.collection(studentPath);
    await studentsColl.createIndex(
      keys: {'email': 1},
      unique: true,
    );
    try {
      await studentsColl.insertOne(student.toMap());
      print('Student added!');
      return 'Success: Student added';
    } catch (e) {
      // Handle other errors, if any
      print('Error: $e');
      return 'Error: $e';
    }
  }

  static Future updateStudent(Map<String, dynamic> student) async {
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
      print(result["nModified"]);
      return ({"status": "success"});
    } catch (e) {
      print(e);
      return e;
    }
  }

  static Future<List<Student?>?> getAllStudents() async {
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
    return studList;
  }

  static Future<Student?> getStudentbyId(String id) async {
    print(db);
    var studentsColl = db!.collection(studentPath);
    print(id);

    var data = await studentsColl.findOne(mongo.where.eq('regNum', id));
    print(data);
    if (data != null) {
      Student model = Student.fromMap(data);
      return model;
    }
  }

  static Future<Parent?> getParentbyId(String email) async {
    var parentsColl = db!.collection(parentPath);
    print(email);
    var data = await parentsColl.findOne(mongo.where.eq('email', email));
    print(data);
    if (data != null) {
      Parent model = Parent.fromMap(data);
      return model;
    }
  }

  static Future verifyParent(String email) async {
    var parentsColl = db!.collection(parentPath);

    var filter = mongo.where.eq('email', email);
    var update = mongo.modify.set('verified', true);
    try {
      await parentsColl.updateOne(filter, update);
      return "done";
    } catch (e) {
      return e;
    }
  }

  static Future deleteParent(String email) async {
    var parentsColl = db!.collection(parentPath);
    return parentsColl
        .deleteOne(mongo.where.eq('email', email))
        .whenComplete(() {
      return 'deleted parent $email';
    });
  }

  static Future deleteStudent(String email) async {
    var studentsColl = db!.collection(studentPath);
    return studentsColl
        .deleteOne(mongo.where.eq('email', email))
        .whenComplete(() {
      return 'deleted student $email';
    });
  }

  static Future<Thread?> getThread(String id) async {
    var threadColl = db!.collection(threadPath);
    print(id);
    var objId = mongo.ObjectId.fromHexString('$id');
    print(objId);
    try {
      var data = await threadColl.findOne(mongo.where.id(objId));
      print(data);
      if (data != null) {
        Thread model = Thread.fromMap(data);
        return model;
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<SRMMail?> getMail(String id) async {
    var mailColl = db!.collection(mailPath);
    print(id);
    var objId = mongo.ObjectId.fromHexString(id);
    print(objId);
    var data = await mailColl.findOne(mongo.where.id(objId));
    print(data);
    if (data != null) {
      SRMMail model = SRMMail.fromMap(data);
      return model;
    }
  }

  static Future addMailToThread(String threadId, SRMMail mail) async {
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
      return jsonEncode(
          {"Status": "Success, MailSent", "mailId": addedMail.id});
    } catch (e) {
      print(e);
      return e;
    }
  }

  static Future createThread(
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
      return jsonEncode(
        {'Status': 'Success, Thread created', 'threadId': id.toHexString()},
      );
    } catch (e) {
      print(e);
      return e;
    }
  }
}
