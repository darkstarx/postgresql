import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:postgresql2/postgresql.dart' as pg;

void main() {
  var uri = 'postgres://testdb:password@localhost:5432/testdb';
  pg.connect(uri).then((conn) {
    run(sql) => conn.query(sql).toList();
    readline(run);
  });
}

void readline(Future run(String sql)) {
  
  print("Type some SQL and press enter twice to run a command.");

  var buffer = new StringBuffer();
  
  stdin
    .transform(UTF8.decoder)
    .transform(new LineSplitter())
    .listen((line) {
      if (line != '') {
        buffer.writeln(line);
        return;
      }
      
      var sql = buffer.toString();
      buffer = new StringBuffer();
      
      print('Running query...');
      run(sql)
        .then((result) => print('Result: $result\n'))
        .catchError((err) => print('Error: $err\n'));
    });
}

