// ignore_for_file: public_member_api_docs, prefer_final_locals, avoid_print, prefer_single_quotes, void_checks, omit_local_variable_types, prefer_final_in_for_each, always_use_package_imports, lines_longer_than_80_chars

import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:srm_conn_server/model/srm_mail.dart';
import 'package:srm_conn_server/model/thread.dart';

import '../model/course.dart';
import '../model/parent.dart';
import '../model/student.dart';

class MongoHelper {
  static mongo.Db? db;

  static Future<mongo.Db> initiaize() async {
    db = await mongo.Db.create(
      'mongodb+srv://kartikey321:kartikey321@cluster0.ykqbrjy.mongodb.net/',
    );
    await db!.open().whenComplete(() {
      print(db);
    });
    print(db);
    return db!;
  }

  static Future<Response> startConnection(
    RequestContext context,
    Future<Response> callBack,
  ) async {
    try {
      await initiaize();
      return await callBack;
    } catch (e) {
      return Response.json(
        statusCode: 500,
        body: {'message': 'Internal server error'},
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
    var parentsColl = db!.collection('parents');
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

  static Future addStudent(Student student) async {
    var studentsColl = db!.collection('students');
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

  static Future<Student?> getStudentbyId(String id) async {
    print(db);
    var studentsColl = db!.collection('students');
    print(id);

    var data = await studentsColl.findOne(mongo.where.eq('regNum', id));
    print(data);
    if (data != null) {
      Student model = Student.fromMap(data);
      return model;
    }
  }

  static Future<Parent?> getParentbyId(String email) async {
    var parentsColl = db!.collection('parents');
    print(email);
    var data = await parentsColl.findOne(mongo.where.eq('email', email));
    print(data);
    if (data != null) {
      Parent model = Parent.fromMap(data);
      return model;
    }
  }

  static Future verifyParent(String email) async {
    var parentsColl = db!.collection('parents');

    var filter = mongo.where.eq('email', email);
    var update = mongo.modify.set('verified', true);
    return parentsColl.updateOne(filter, update).whenComplete(() {
      return 'done';
    });
  }

  static Future deleteParent(String email) async {
    var parentsColl = db!.collection('parents');
    return parentsColl
        .deleteOne(mongo.where.eq('email', email))
        .whenComplete(() {
      return 'deleted parent $email';
    });
  }

  static Future deleteStudent(String email) async {
    var studentsColl = db!.collection('students');
    return studentsColl
        .deleteOne(mongo.where.eq('email', email))
        .whenComplete(() {
      return 'deleted student $email';
    });
  }

  static Future<Thread?> getThread(String id) async {
    var threadColl = db!.collection('threads');
    print(id);
    var data = await threadColl
        .findOne(mongo.where.id(mongo.ObjectId.fromHexString(id)));
    print(data);
    if (data != null) {
      Thread model = Thread.fromMap(data);
      return model;
    }
  }

  static Future<SRMMail?> getMail(String id) async {
    var mailColl = db!.collection('mails');
    print(id);
    var data = await mailColl
        .findOne(mongo.where.id(mongo.ObjectId.fromHexString(id)));
    print(data);
    if (data != null) {
      SRMMail model = SRMMail.fromMap(data);
      return model;
    }
  }

  static Future addMailToThread(String threadId, SRMMail mail) async {
    var threadsColl = db!.collection('threads');
    var mailsColl = db!.collection('mails');

    try {
      //adding mail
      var addedMail = await mailsColl.insertOne(mail.toMap());

      //adding mail to threads collection
      final threadUpdateResult = await threadsColl.update(
        mongo.where.id(mongo.ObjectId.fromHexString(threadId)),
        mongo.modify.addToSet('messageIds', addedMail.id),
      );
      print("Success: Mail Sent");
      return jsonEncode({"Status": "Success, MailSent"});
    } catch (e) {
      print(e);
      return e;
    }
  }

  static Future createThread(String parentId, Thread thread) async {
    var threadsColl = db!.collection('threads');
    var parentsColl = db!.collection('parents');
    try {
      //creating thread
      var map = thread.toMap();
      map['id'] = mongo.ObjectId();
      map['_id'] = map['id'];
      var addedThred = await threadsColl.insertOne(map);
      //adding thread to parents collection
      var filter = mongo.where.eq('email', parentId);
      await parentsColl.update(
        filter,
        mongo.modify.addToSet('threadIds', addedThred.id),
      );
      print('Success: Mail Sent');
      return jsonEncode(
          {'Status': 'Success, Thread created', 'threadId': addedThred.id});
    } catch (e) {
      print(e);
      return e;
    }
  }
}
