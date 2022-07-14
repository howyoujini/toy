// Exception 라이브러리를 활용해서 예외 처리

class FlutterException implements Exception {
  late final String message;
  late final FlutterException? cause;
  late final dynamic details;
  late final StackTrace trace; // 예외를 트리거한 호출 순서에 대한 정보를 사용자에게 전달하기 위한 것

  // constructor : instance 생성 가능
  // const 인스턴스1 = new FlutterException({message, cause, details, trace})
  // message, cause(경우), details, trace를 받아서 실행한다.
  FlutterException({this.message = "", final dynamic cause, this.details, final StackTrace? trace}){
    if(cause is FlutterException){
      this.cause = cause;
    }else{
      if(cause == null){
        this.cause = null;
      }else{
        this.cause = FlutterException(message: "FlutterException($cause)");
      }
    }

    if(trace == null){
      this.trace = StackTrace.current;
    }else{
      this.trace = trace;
    }
  }

  // implements 로 메세지를 전달했으니 override(재정의) 가 필수 !
  @override
  String toString(){
    final String detailsStr;
    if(details == null){
      detailsStr = "";
    }else{
      detailsStr = "(details: ${details.toString()})";
    }

    return "${runtimeType.toString()}: $message$detailsStr";
  }

}