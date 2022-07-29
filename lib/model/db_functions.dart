import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


  Database _db ;
  String _dbName = "my_db" ;
  //String _dbPath ;



//----------------------Database creation functions
  Future openDB() async{
    _db = await openDatabase('$_dbName.db');
    //_dbPath = _dbName+ ".db";
    
  }

  void deleteDB() async{
      // Get a location using getDatabasesPath
      String databasesPath = await getDatabasesPath();
      String path = join(databasesPath, '$_dbName.db');
      // Delete the database
      await deleteDatabase(path);
  }
  //---------------DDL functions

  //return true if success
  Future<bool> createTable(String tableName, String attributesDefentions) async{
    try{
      _db.execute("create table $tableName  ($attributesDefentions)");
      return true ;
    }catch(e){
      log("error   \n " + e.toString());
      return false ;
    }
  }
  Future deleteTable(String tableName) async{
      _db.execute("drop table $tableName");
  }

  //------------DML functions

  //insertion should be in form TABLE(ATTR1 , ATTR2) -- ("val1" , "val2")
  Future<bool> insertToDB(String tableName, String values) async{
    try{
         // Insert some records in a transaction
        await _db.transaction((txn) async {
        int id1 = await txn.rawInsert(
          'INSERT INTO $tableName VALUES(' + values +')');
        print('inserted1: $id1');
       });
      return true;
    }catch(e){
      log("Error in insertion " + e.toString());
      return false;
    }
  }

  Future updateDB(String tableName, String values , String conditions) async{
      // Update some record
      int count = await _db.rawUpdate(
        'UPDATE $tableName SET $values WHERE $conditions' , );
      return count ;
  }


  Future<List<Map>> readFromDB(String tableName , [String condition = ""]) async{
    if (condition != ""){
      condition = " where " + condition;
    }
    List<Map> list;
    try{
       list = await _db.rawQuery('SELECT * FROM $tableName ' + condition);
    }catch(e){
      log("error in read no table " + e.toString());
      throw e ;
    }
    return list ;
  }

  Future<int> getCounts(String tableName , [String condition = ""]) async{
    if (condition != ""){
      condition = " where " + condition;
    }
    int count = Sqflite .firstIntValue(await _db.rawQuery('SELECT COUNT(*) FROM $tableName'+ condition )); 
    return count ;
  }

  Future<String> deleteFromDB(String tableName , String condition) async{
    if (condition != ""){
      condition = " where " + condition;
    }
    try{
      log('DELETE FROM $tableName ' + condition );
       await _db.rawDelete('DELETE FROM $tableName ' + condition );
       
       return "done";
    }catch(error){
      log("error in deletion is "+ error.toString());
      return "error";
    }
  }


  Future clearTable(String tableName) async{
      _db.execute("delete from  $tableName");
  }
  
