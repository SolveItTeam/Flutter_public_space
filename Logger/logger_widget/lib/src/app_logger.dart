import 'package:logger/logger.dart';

enum AppLoggerFilter { prod, dev, qa }

class AppLogger {
  static MemoryOutput memoryOutput = MemoryOutput(bufferSize: 100, secondOutput: ConsoleOutput());

  static AppLoggerFilter? _initialFilter;

  Logger? _save;

  static final AppLogger _singleton = AppLogger._internal();

  AppLogger._internal();

  factory AppLogger() => _singleton;

  MemoryOutput get logs => memoryOutput;

  AppLoggerFilter? get filter => _initialFilter;

  void init(AppLoggerFilter filter) {
    _initialFilter = filter;
    switch (filter) {
      case (AppLoggerFilter.dev):
        _save = Logger(
          filter: DevelopmentFilter(),
          printer: SimplePrinter(),
          output: memoryOutput,
        );
        break;
      case (AppLoggerFilter.prod):
        _save = Logger(
          filter: DevelopmentFilter(),
          printer: SimplePrinter(),
          output: memoryOutput,
        );
        break;
      case (AppLoggerFilter.qa):
        _save = Logger(
          filter: ProductionFilter(),
          printer: SimplePrinter(),
          output: memoryOutput,
        );
        break;
    }
  }

  /// Log a message at level [Level.verbose].
  void verbose(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (_save != null) {
      _save!.v(message, error, stackTrace);
    }
  }

  /// Log a message at level [Level.debug].
  void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (_save != null) {
      _save!.d(message, error, stackTrace);
    }
  }

  /// Log a message at level [Level.info].
  void info(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (_save != null) {
      _save!.i(message, error, stackTrace);
    }
  }

  /// Log a message at level [Level.warning].
  void warning(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (_save != null) {
      _save!.w(message, error, stackTrace);
    }
  }

  /// Log a message at level [Level.error].
  void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (_save != null) {
      _save!.e(message, error, stackTrace);
    }
  }

  /// Log a message at level [Level.wtf].
  void wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (_save != null) {
      _save!.wtf(message, error, stackTrace);
    }
  }
}
