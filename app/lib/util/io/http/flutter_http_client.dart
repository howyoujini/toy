// response 받아온 응답을 FlutterHttpResponse 타입을 가진 promise 비동기 객체로 만들기
import 'package:flutter_app/util/io/http/flutter_http_response.dart';
import 'package:flutter_app/util/io/json_serializable.dart';

abstract class FlutterHttpClient {
  void setHeader(final String key, final String value);

  void close();

  // Future 에서 작업 후에 나오는 결과값이 FlutterHttpResponse <타입>이라는 의미이다.
  Future<FlutterHttpResponse> get(final String url);

  // 데이터를 전송할 때, 헤더와 메타데이터, 에러 체크 비트 등과 같은 다양한 요소들을 함께 보내어, 데이터 전송의 효율과 안정성을 높히게 된다.
  // 이 때, 보내고자 하는 "데이터 자체"를 의미하는 것 => 페이로드
  Future<FlutterHttpResponse> post(final String url, [final JsonSerializable payload]);

  // patch : 부분 수정하기
  Future<FlutterHttpResponse> patch(final String url, [final JsonSerializable payload]);

  Future<FlutterHttpResponse> delete(final String url);
}
