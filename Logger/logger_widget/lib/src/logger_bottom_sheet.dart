import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'app_logger.dart';
import 'log.dart';

class LoggerBottomSheet extends StatefulWidget {
  const LoggerBottomSheet({Key? key}) : super(key: key);

  @override
  State<LoggerBottomSheet> createState() => _LoggerBottomSheetState();
}

class _LoggerBottomSheetState extends State<LoggerBottomSheet> {
  List<LogItem> logs = [];

  @override
  void initState() {
    for (var log in AppLogger().logs.buffer.toList().reversed) {
      logs.add(LogItem(log.lines));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.93,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 50),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(Icons.clear)),
                  const Text(
                    kDebugMode ? "App Debug" : "App Release",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Color.fromRGBO(38, 70, 83, 1)),
                  ),
                  const SizedBox(
                    width: 32,
                  )
                ],
              ),
            ),
            Expanded(
              child: AppLogger().filter != null
                  ? SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      logs[index].isExpanded = !logs[index].isExpanded;
                    });
                  },
                  animationDuration: const Duration(milliseconds: 300),
                  children: [
                    for (var log in logs)
                      ExpansionPanel(
                        canTapOnHeader: true,
                        isExpanded: log.isExpanded,
                        headerBuilder: (BuildContext context, bool isOpen) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Center(
                                child: Text(
                                  log.logs.first,
                                  maxLines: 1,
                                )),
                          );
                        },
                        body: InkWell(
                          onTap: () {
                            setState(() {
                              log.isExpanded = !log.isExpanded;
                            });
                          },
                          child: Text("${log.logs}\n"),
                        ),
                      )
                  ],
                ),
              )
                  : const Center(
                child: Text(
                  "Method AppLogger().init must be called",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
