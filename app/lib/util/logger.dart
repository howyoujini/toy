// Logger 패키지가 있는데 따로 log 를 만든 이유는 ..
// log.debug("message: $message") 를 log.debug("message: %s", [message]) 이렇게 바꾸면서 바로 메모리참조를 통해 코드 줄(실행속도 감소)이 엄청 짧아진다.

import 'dart:math';

import 'package:flutter_app/core/exception.dart';
import 'package:flutter_app/main.dart';
import 'package:sprintf/sprintf.dart'; // print(sprintf("%s %s", ["Hello", "World"])); => "Hello World" 로 변환해준다.

// verbose 란 사전적 의미로 “말 수가 많다” 라는 뜻
// 상세한 로깅 logging 을 출력할지 말지를 조정하는 parameter
enum LoggerLevel {verbose, debug, info, warn, error}

abstract class Logger{
  LoggerLevel get level;

  bool isLoggable(final LoggerLevel level);

  void v(final String messageOrFormat, [List<dynamic> args = const []]);
  void d(final String messageOrFormat, [List<dynamic> args = const []]);
  void i(final String messageOrFormat, [List<dynamic> args = const []]);
  void w(final String messageOrFormat, [List<dynamic> args = const []]);
  void e(final String messageOrFormat, [List<dynamic> args = const []]);
}

typedef InstanceProvider = Logger Function(String?, LoggerLevel);

abstract class LogFactory {
  static Logger getLogger([final dynamic context]){
    if(context == null){
      return _LoggerImpl("LOG", _minLogLevel);
    }

    final contextStr = context.toString();
    return _loggers.putIfAbsent(contextStr, ()=> _LoggerImpl(contextStr, _minLogLevel));
  }

  static void clear() {
    _loggers.clear();
    _minLogLevel = LoggerLevel.debug;
  }

// region 내부 상태 logic
// 메모리 최적화 필요하면 나중에 제대로 구현해야 한다.
  static final _loggers = <String, Logger>{};
  static LoggerLevel _minLogLevel = LoggerLevel.debug;

  static void setMinLogLevel(final LoggerLevel level){
    LogFactory._minLogLevel = level;
  }
// end - region
}

class _LoggerImpl implements Logger{
  final String context;

  @override
  final LoggerLevel level;

  // constructor : instance 생성가능
  _LoggerImpl(this.context, this.level);

  @override
  bool isLoggable(final LoggerLevel level) => level.grade <= this.level.grade;

  @override
  void v(final String messageOrFormat, [final List<dynamic> args = const []]){
    _redirectLog(LoggerLevel.verbose, messageOrFormat, args);
  }

  @override
  void d(final String messageOrFormat, [final List<dynamic> args = const []]){
    _redirectLog(LoggerLevel.debug, messageOrFormat, args);
  }

  @override
  void i(final String messageOrFormat, [final List<dynamic> args = const []]){
    _redirectLog(LoggerLevel.info, messageOrFormat, args);
  }

  @override
  void w(final String messageOrFormat, [final List<dynamic> args = const []]){
    _redirectLog(LoggerLevel.warn, messageOrFormat, args);
  }

  @override
  void e(final String messageOrFormat, [final List<dynamic> args = const []]){
    _redirectLog(LoggerLevel.error, messageOrFormat, args);
  }

  void _redirectLog(final LoggerLevel level, final String messageOrFormat, final List<dynamic> args){
    if(level.grade > this.level.grade){
      return;
    }


    String exceptionOrError = "";
    List<String> stackTrace = [];
    List<dynamic> printArgs = [];

    for(var it in args){
      if(exceptionOrError.isEmpty && (it is Exception || it is Error)){
        if(it is Exception){
          exceptionOrError = it.toString();

            if(it is FlutterException){
              stackTrace = _formatStackTrace(it.trace);
            }

        }else{
          exceptionOrError = (it as Error).toString();
          stackTrace = _formatStackTrace(it.stackTrace);

        }
      }else if(stackTrace.isEmpty && it is StackTrace){
          stackTrace = _formatStackTrace(it);

      }else{
          printArgs.add(it);
      }
    }

    String _threeDigits(int n){
      if(n >= 100) return '$n';
      if(n >= 10) return '0$n';
      return '00$n';
    }

    String _twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    final now = DateTime.now();
    final yyyy = now.year;
    final MM = _twoDigits(now.month);
    final dd = _twoDigits(now.day);
    final hh = _twoDigits(now.hour);
    final mm = _twoDigits(now.minute);
    final ss = _twoDigits(now.second);
    final SSS = _threeDigits(now.millisecond);
    final dateTime = "$yyyy-$MM-$dd $hh:$mm:$ss.$SSS";

    final prefix = sprintf("$dateTime ${level.prefix}/%-24s|", [context]);

    final List<String> messages = [];
    if(printArgs.isEmpty){
      messages.add(messageOrFormat);
    }else{
      messages.add(sprintf(messageOrFormat, printArgs));
    }

    if(exceptionOrError.isNotEmpty){
      messages.add(exceptionOrError);
    }
    messages.addAll(stackTrace);

    _printLog(prefix, messages);
  }

  void _printLog(final String prefix, final List<String> messages){
    for(var element in messages){
      print("$prefix $element");
    }
  }

  List<String> _formatStackTrace(final StackTrace? trace){
    if(trace == null){
      return [];
    }

    final allTraces = trace.toString().split("\n").map((it) => " at $it").toList();
    int rootCauseIndex = 10;

    for(int i = allTraces.length - 1; i >= 0; --i){
      if(allTraces[i].contains("packages/${MyApp.appPackageName}")){
        rootCauseIndex = i + 1;
        break;
      }
    }
    final maybeTruncated = allTraces.take(min(rootCauseIndex, allTraces.length)).toList();
    if(maybeTruncated.length < allTraces.length){
      maybeTruncated.add("  (${allTraces.length - maybeTruncated.length} of total ${allTraces.length} traces were omitted)");
    }
    return maybeTruncated;
  }
}

extension _LoggerLevelGrader on LoggerLevel{
  int get grade{
    final int grade;

    switch(this){
      case LoggerLevel.verbose:
        grade = 5;
        break;
      case LoggerLevel.debug:
        grade = 4;
        break;
      case LoggerLevel.info:
        grade = 3;
        break;
      case LoggerLevel.warn:
        grade = 2;
        break;
      case LoggerLevel.error:
        grade = 1;
        break;
    }
    return grade;
  }

  String get prefix{
    final String prefix;
    switch(this){
      case LoggerLevel.verbose:
        prefix = "V";
        break;
      case LoggerLevel.debug:
        prefix = "D";
        break;
      case LoggerLevel.info:
        prefix = "I";
        break;
      case LoggerLevel.warn:
        prefix = "W";
        break;
      case LoggerLevel.error:
        prefix = "E";
        break;
    }

    return prefix;
  }
}