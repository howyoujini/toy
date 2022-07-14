import 'package:flutter_app/core/exception.dart';

// FlutterException 을 import 해서
// 이를 물려받는 IOException class 를 생성한다.

// IOException 란,
// 스트림, 파일 및 디렉터리를 사용하여 정보에 액세스하는 동안 throw 된 예외에 대한 기본 클래스
class IOException extends FlutterException{
  IOException([final String message = "", final dynamic cause, final StackTrace? trace])
      : super(message: message, cause: cause, trace: trace);
}

// IOException 를 물려받는 JsonParseException class 를 생성한다.
class JsonParseException extends IOException{
  JsonParseException(final String message, [final dynamic cause, final StackTrace? trace])
      : super(message, cause, trace);
}

// IOException 를 물려받는 PersistedValueParseException class 를 생성한다.
class PersistedValueParseException extends IOException{
  PersistedValueParseException(final String message, [final dynamic cause, final StackTrace? trace])
      : super(message, cause, trace);
}
