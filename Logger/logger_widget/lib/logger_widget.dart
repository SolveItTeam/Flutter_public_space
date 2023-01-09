library logger_widget;

import 'package:flutter/material.dart';

import 'src/app_logger.dart';
import 'src/logger_bottom_sheet.dart';

export 'src/app_logger.dart';

class LoggerWidget extends StatefulWidget {
  final Widget child;

  const LoggerWidget({Key? key, required this.child}) : super(key: key);

  @override
  State<LoggerWidget> createState() => _LoggerWidgetState();
}

class _LoggerWidgetState extends State<LoggerWidget> {
  Widget get child => widget.child;

  void openCityBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const LoggerBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if(AppLogger().filter!=AppLoggerFilter.prod){
          openCityBottomSheet(context);
        }
      },
      child: child,
    );
  }
}