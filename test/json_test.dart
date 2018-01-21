// Basic smoke tests for the GeneratedMessage JSON API.
//
// There are more JSON tests in the dart-protoc-plugin package.
library json_test;

import 'dart:convert';
import 'package:fixnum/fixnum.dart' show Int64;
import 'package:protobuf/protobuf.dart' as protobuf;
import 'package:test/test.dart';

import 'mock_util.dart' show MockMessage, mockInfo;

class T extends MockMessage {
  get info_ => _info;
  static final _info = mockInfo("T", () => new T());
}

main() {
  T example = new T()
    ..val = 123
    ..str = "hello";

  test('testWriteToJson', () {
    String json = example.writeToJson();
    checkJsonMap(jsonDecode(json));
  });

  test('writeToJsonMap', () {
    Map m = example.writeToJsonMap();
    checkJsonMap(m);
  });

  test('testMergeFromJson', () {
    var t = new T();
    t.mergeFromJson('''{"1": 123, "2": "hello"}''');
    checkMessage(t);
  });

  test('testMergeFromJsonMap', () {
    var t = new T();
    t.mergeFromJsonMap({"1": 123, "2": "hello"});
    checkMessage(t);
  });

  test('testInt64JsonEncoding', () {
    final value = new Int64(1234567890123456789);
    final t = new T()..int64 = value;
    final encoded = t.writeToJsonMap();
    expect(encoded["5"], "$value");
    final decoded = new T()..mergeFromJsonMap(encoded);
    expect(decoded.int64, value);
  });

  test('testWriteToJsonProto3', () {
    protobuf.jsonFieldKeyType = protobuf.JSONFieldKeyType.proto3;
    String json = example.writeToJson();
    checkJsonMapProto3(JSON.decode(json));
  });

  test('writeToJsonMapProto3', () {
    protobuf.jsonFieldKeyType = protobuf.JSONFieldKeyType.proto3;
    Map m = example.writeToJsonMap();
    checkJsonMapProto3(m);
  });

  test('testMergeFromJsonProto3', () {
    protobuf.jsonFieldKeyType = protobuf.JSONFieldKeyType.proto3;
    var t = new T();
    t.mergeFromJson('''{"val": 123, "str": "hello"}''');
    checkMessage(t);
  });

  test('testMergeFromJsonMapProto3', () {
    protobuf.jsonFieldKeyType = protobuf.JSONFieldKeyType.proto3;
    var t = new T();
    t.mergeFromJsonMap({"val": 123, "str": "hello"});
    checkMessage(t);
  });
}

checkJsonMap(Map m) {
  expect(m.length, 2);
  expect(m["1"], 123);
  expect(m["2"], "hello");
}

checkMessage(T t) {
  expect(t.val, 123);
  expect(t.str, "hello");
}

checkJsonMapProto3(Map m) {
  expect(m.length, 2);
  expect(m["val"], 123);
  expect(m["str"], "hello");
}
