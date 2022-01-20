import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_html/html.dart' as html;

export 'text_controller.dart';

class TablePlus extends StatefulWidget {
  final List<Widget>? srchCtrl;
  final bool isExportCSVEnabled;
  final bool isSearchEnabled;
  final List<DataColumn> columns;
  final int? sortColumnIndex;
  final bool sortAscending;
  final ValueSetter<bool?>? onSelectAll;
  final Decoration? decoration;
  final MaterialStateProperty<Color?>? dataRowColor;
  final double? dataRowHeight;
  final TextStyle? dataTextStyle;
  final MaterialStateProperty<Color?>? headingRowColor;
  final double? headingRowHeight;
  final TextStyle? headingTextStyle;
  final double? horizontalMargin;
  final double? columnSpacing;
  final bool showCheckboxColumn;
  final List<DataRow> rows;
  final double? dividerThickness;
  final bool showBottomBorder;
  final double? checkboxHorizontalMargin;
  final TableBorder? border;
  final Widget shareWidget;
  final List<dynamic> dataValues;
  final List<String> tabelHeadingList;
  final String? exportFileName;

  const TablePlus(
      {Key? key,
      this.srchCtrl,
      required this.isExportCSVEnabled,
      required this.isSearchEnabled,
      required this.columns,
      this.sortColumnIndex,
      this.sortAscending = true,
      this.onSelectAll,
      this.decoration,
      this.dataRowColor,
      this.dataRowHeight,
      this.dataTextStyle,
      this.headingRowColor,
      this.headingRowHeight,
      this.headingTextStyle,
      this.horizontalMargin,
      this.columnSpacing,
      this.showCheckboxColumn = true,
      this.showBottomBorder = false,
      this.dividerThickness,
      required this.rows,
      this.checkboxHorizontalMargin,
      this.border,
      required this.shareWidget,
      required this.dataValues,
      required this.tabelHeadingList,
      this.exportFileName = "MyTableFile"})
      : super(key: key);

  @override
  _TablePlusState createState() => _TablePlusState();
}

class _TablePlusState extends State<TablePlus> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: SingleChildScrollView(child: bodyData())),
        Visibility(
          visible: widget.isExportCSVEnabled,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                getCsv();
              },
              child: widget.shareWidget,
            ),
          ),
        )
      ],
    );
  }

  Widget bodyData() => DataTable(
      columnSpacing: widget.columnSpacing,
      headingRowHeight: widget.isSearchEnabled ? 130.0 : 56.0,
      onSelectAll: widget.onSelectAll,
      sortColumnIndex: widget.sortColumnIndex,
      sortAscending: widget.sortAscending,
      columns: widget.columns,
      rows: widget.rows);

  Future<bool> externalStoragePermission() async {
    var status1 = await Permission.manageExternalStorage.status;
    if (!status1.isGranted) {
      await Permission.manageExternalStorage.request();
    }
    return status1.isGranted;
  }

  getCsv() async {
    {
      try {
        List<String> nameContexts = <String>[];
        List<List<String>> data = [];
        data.add(widget.tabelHeadingList);
        for (int i = 0; i < widget.dataValues.length; i++) {
          nameContexts = [
            widget.dataValues[i].firstName,
            widget.dataValues[i].lastName
          ];
          data.add(nameContexts);
        }
        saveCSV(data, "${widget.exportFileName}.csv");
      } on Exception catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  Future<void> saveCSV(List<List<String>> dataValue, String fileName) async {
    Directory? directory;
    if (defaultTargetPlatform == TargetPlatform.android) {
      if (await _requestPermission(Permission.storage)) {
        directory = await getExternalStorageDirectory();
        DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
        final androidInfo = await deviceInfoPlugin.androidInfo;
        if (androidInfo.version.sdkInt > 29 &&
            await externalStoragePermission()) {
          String newPath = "";
          if (kDebugMode) {
            print(directory);
          }
          List<String> paths = directory!.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }
          newPath = newPath + "/Table_Plus";
          directory = Directory(newPath);
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }
          String file = directory.path + "/${widget.exportFileName}.csv";
          File f = File(file);
          String csv = const ListToCsvConverter().convert(dataValue);
          f.writeAsString(csv);
          successMsg();
        } else if (androidInfo.version.sdkInt < 30) {
          directory = Directory(directory!.path);
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }
          String file = directory.path + "/${widget.exportFileName}.csv";
          File f = File(file);
          String csv = const ListToCsvConverter().convert(dataValue);
          f.writeAsString(csv);
          successMsg();
        }
      }
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      if (await _requestPermission(Permission.photos)) {
        directory = await getTemporaryDirectory();
        directory = Directory(directory.path);
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        File saveFile = File(directory.path + "/$fileName");
        String csv = const ListToCsvConverter().convert(dataValue);
        saveFile.writeAsString(csv);
        await ImageGallerySaver.saveFile(saveFile.path,
            isReturnPathOfIOS: true);
        successMsg();
      }
    } else if (kIsWeb) {
      //now convert our 2d array into the csvlist using the plugin of csv
      String csv = const ListToCsvConverter().convert(dataValue);
//this csv variable holds entire csv data
//Now Convert or encode this csv string into utf8
      final bytes = utf8.encode(csv);
//NOTE THAT HERE WE USED HTML PACKAGE
      final blob = html.Blob([bytes]);
//It will create downloadable object
      final url = html.Url.createObjectUrlFromBlob(blob);
//It will create anchor to download the file
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = '${widget.exportFileName}.csv';
//finally add the csv anchor to body
      html.document.body?.children.add(anchor);
// Cause download by calling this function
      anchor.click();
//revoke the object
      html.Url.revokeObjectUrl(url);
      successMsg();
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  void successMsg() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          backgroundColor: Colors.green,
          content: Text('CSV exported successfully')),
    );
  }
}
