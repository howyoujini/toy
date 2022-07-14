// http response(응답) 받아오기 + exception_io.dart 를 import 해서 처리하기

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data'; // Uint8List 선언하려고 import

import 'package:flutter/material.dart'; // immutable 어노테이션 쓰려고 import
import 'package:flutter_app/util/io/exception_io.dart';


@immutable
// curl CLI 로 response headers 에 어떤 형태로 받는지 확인해보기
// curl -vH "Content-Type:application/json" <url>
class FlutterHttpResponse {
  // int , String, Map, Uint8List -> 이것들은 데이터 자료형

  final int statusCode; // 200, 304, 404 같은 코드
  final String? reasonPhrase; // 상태 텍스트
  final Map<String, String> headers; // headers 에 담아오는 map 형태의 데이터
  final Uint8List? bodyBytes; // row level 인 bytes 로 변환 : 서버에서 '.jpeg, .obj' 파일이 올 때도 다 바이트로 변환

  // 상수 constructor : 생성자를 상수처럼 만들어주기
  const FlutterHttpResponse(this.statusCode, {this.reasonPhrase, this.headers = const{}, this.bodyBytes});

  @override
  String toString() {
    // ! : not-null assertion
    // null 은 변수 선언만 되고 값이 할당되지 않은 경우
    // kotlin 에서는 dart 에서의 ! 가 !! 이다.

    // Uint8List 바이트 형태의 bodyBytes 에 담긴 데이터가 없을 경우 즉, 받아오는 데이터가 전혀 없을 경우
    // if (!(bodyBytes?.isEmpty == true)) <- 이렇게도 가능하다.
    // if (bodyBytes == null || bodyBytes!.isEmpty) <- 이렇게도 가능하다.
    if (bodyBytes.isEmpty()) {
      throw IOException("Trying to parse an empty response");
    }

    return const Utf8Codec().decode(bodyBytes!);
  }


}

// ---------------------------------------------------
// 31줄의 .isEmpty()를 사용하기 위한 extension function 이다.
// 이는 Uint8List 자료형일 때만 사용된다.
extension Uint8ListExtension on Uint8List? {
  bool isEmpty() {
    // 원래 dart 에서 제공하는 isEmpty 는 nullable 인지 체크하려면 ! 가 필요하고
    // 가독성이 떨어지므로 따로 extension function 을 만들어서 활용한다.
    return this == null || this!.isEmpty;
    // 즉, this 가 값이 할당되지 않았거나, 값이 텅 비어있을 경우 true 를 반환한다.
  }
}
