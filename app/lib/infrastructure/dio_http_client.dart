// dio : http 처럼 서버와 통신을 하기 위해 필요한 패키지

// 주요 기능 3가지
// 1. Request & Response
// 2. Options
// 3. Interceptor

import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_app/util/io/exception_io.dart';
import 'package:flutter_app/util/io/http/flutter_http_client.dart';
import 'package:flutter_app/util/io/http/flutter_http_response.dart';
import 'package:flutter_app/util/io/json_serializable.dart';
import 'package:flutter_app/util/logger.dart';

class FlutterHttpClientDioImpl implements FlutterHttpClient{
// 변수명 앞에 언더바(_)를 붙이면 private 변수라는 뜻
// POINT : 왜 dio 를 private 로 선언했을까?
// 캡슐화 !!

  Dio? _dio;
  late final  Logger _logger;
  late final BaseOptions options;

  // constructor : instance 생성가능
  FlutterHttpClientDioImpl({
    required final String baseUrl,
    required final int connectTimeoutMs,
    required final int receiveTimeoutMs,
    final Map<String, dynamic> defaultHeaders = const {}
}){
    // dio 객체를 생성하면서 공통적으로 사용하고 싶은 것들을 BaseOptions 을 통해 지정가능
    options = BaseOptions(
      baseUrl: baseUrl, // 요청할 기본 주소를 설정
      connectTimeout: connectTimeoutMs, // 서버로부터 응답받는 시간을 설정
      receiveTimeout: receiveTimeoutMs, // 파일 다운로드 등과 같이 연결 '지속' 시간을 설정
      headers: defaultHeaders, // 요청의 header 데이터를 설정 ex) 인증토큰 등
      responseType: ResponseType.bytes, //
      setRequestContentTypeWhenNoPayload: true, // request-header 안에 content-type 을 추가하는 것을 허락함
    );

    _logger = LogFactory.getLogger(FlutterHttpClient);
  }

  // Dio client 생성
  Dio client(){
   return  _dio ??= Dio(options);
  }

  // FlutterHttpClient 를 override 하기
  @override
  void setHeader(final String key, final String value){
    client().options.headers[key] = value;
  }
  // Dio close override 하기
  @override
  void close(){
    _dio?.close(force: true);
    _dio = null;
  }

  // "GET" method (서버에서 데이터 조회) 일 때, _logRequest 함수를 실행하고
  // _toFlutterHttpResponse 객체에 'get' 메소드 클라이언트를 담아서 리턴하라.
  @override
  Future<FlutterHttpResponse> get(final String url){
    _logRequest("GET", url);
    return _toFlutterHttpResponse(client().get(url));
  }

  // "POST" method (서버로 리소스 '생성') 일 때, _logRequest 함수를 실행하고
  // response 변수를 선언하고
  // _toFlutterHttpResponse 객체에 'post' 메소드 클라이언트를 담아서 리턴하라.
  @override
  Future<FlutterHttpResponse> post(final String url, [final JsonSerializable? payload]){
    _logRequest("POST", url);
    final Future<Response<List<int>>> response;
    if(payload == null){
      response = client().post(url);
    }else{
      response = client().post(url, data: payload.toJson());
    }

    return _toFlutterHttpResponse(response);
  }

  // "PATCH" method (서버로 리소스 '수정') 일 때, _logRequest 함수를 실행하고
  // response 변수를 선언하고
  // _toFlutterHttpResponse 객체에 'patch' 메소드 클라이언트를 담아서 리턴하라.
  @override
  Future<FlutterHttpResponse> patch(final String url, [final JsonSerializable? payload]){
    _logRequest("PATCH", url);
    final Future<Response<List<int>>> response;
    if(payload == null){
      response = client().patch(url);
    }else{
      response = client().patch(url, data: payload.toJson());
    }

    return _toFlutterHttpResponse(response);
  }

  // "DELETE" method (서버에서 데이터 '삭제') 일 때, _logRequest 함수를 실행하고
  // _toFlutterHttpResponse 객체에 'delete' 메소드 클라이언트를 담아서 리턴하라.
  @override
  Future<FlutterHttpResponse> delete(final String url){
    _logRequest("DELETE", url);
    return _toFlutterHttpResponse(client().delete(url));
  }

  // _toFlutterHttpResponse : Future 비동기 객체 생성
  // Dart 의 Future<T>는 지금은 없지만 미래에 요청한 데이터<T> 혹은 에러가 담길 그릇 -> 비동기
  // 이 Future 를 받은 변수는 Future 로부터 데이터<T>가 나올 때를 대비해 then 메소드를, Error 가 나올 경우를 대비해 CatchError 메소드를 준비해야 한다.
  Future<FlutterHttpResponse> _toFlutterHttpResponse(final Future<Response<List<int>>> dioResponse) async{

    FlutterHttpResponse parseResponse(final Response<dynamic> it){
      final statusCode = it.statusCode;
      if(statusCode == null){
        throw IOException("No http status code from peer");
      }

      _logger.v("HTTP %s/%s %s", [it.statusCode, it.requestOptions.method, it.requestOptions.uri]);
      _logger.v("Response headers: ");
      // k -> key, v -> value
      it.headers.forEach((k, v) => _logger.v(" $k : $v"));

      return FlutterHttpResponse(
          statusCode,
          reasonPhrase: it.statusMessage,
          headers: _toPlainMap(it.headers),
          // as : 상위타입 호환
          bodyBytes: it.data as Uint8List,
      );
    }

      // try{
      // 예외 발생할 수 도 있는 코드
      // code that might throw an exception
      // }on 예외클래스{
      // 예외처리를 위한 코드
      // code for handling exception
      // }

    try{
      final it = await dioResponse;

      return parseResponse(it);
    } on DioError catch(e, s){
      final response = e.response;

      if(response == null){
        throw IOException("Empty response body from host", e, s);
      }else{
        // Dio 가 200 아니면 제멋대로 오류를 내기 때문에 정상응답인 것 처럼 처리해야함
        return parseResponse(response);
      }

    } catch(e, s){
      throw IOException("Connection refused", e, s);
    }

  }

  Map<String, String> _toPlainMap(final Headers headers){
    // map 객체 직렬화하기
    final map = <String, String>{};

    headers.map.forEach((key, value) {
      if(value.isEmpty){
        // value 값이 empty 라면, 빈 스트링값으로 넣어주기
        map[key] = "";
      } else if(value.length == 1){
        // value 의 길이가 1이라면, 그 한 값을 넣어주기
        map[key] = value.first;
      }else{
        // 다 아니면 ,로 다 붙여서 넣어주기
        map[key] = "[${value.join(",")}]";
      }
    });

    return map;
  }

  void _logRequest(final String method, final String url, [final JsonSerializable? payload]){
    // log 실행을 하지 않을시 그냥 return
    if(!_logger.isLoggable(LoggerLevel.verbose)){
      return;
    }

    _logger.v("%s ${options.baseUrl}%s", [method, url]);
    _logger.v("Request headers: ");
    client().options.headers.entries.forEach((it) => _logger.v("  ${it.key} : ${it.value}"));
    if(payload != null){
      _logger.v("Request body: %s", [jsonEncode(payload)]);
    }
  }

}

