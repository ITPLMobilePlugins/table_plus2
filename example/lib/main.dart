import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:table_plus/table_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var searchNameList = <dynamic>[];
  final bool isSearchEnabled = false;
  List<Widget> searchCtrl = <Widget>[];
  List<String> tableHeading = <String>[];

  List<DataColumn> dataColumnValues() {
    List<DataColumn> values = <DataColumn>[];
    for (var i = 0; i < tableHeading.length; i++) {
      values.add(DataColumn(
        label: Container(
          margin: isSearchEnabled
              ? const EdgeInsets.only(top: 25.0, bottom: 20.0)
              : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                tableHeading[i],
                style: const TextStyle(color: Colors.black),
              ),
              isSearchEnabled ? searchCtrl[i] : Container(),
            ],
          ),
        ),
        numeric: false,
      ));
    }
    return values;
  }

  List<DataRow> dataRowsValues() {
    return searchNameList
        .map(
          (objData) => DataRow(
            cells: [
              DataCell(
                Text(objData.firstName),
                showEditIcon: false,
                placeholder: false,
              ),
              DataCell(
                Text(objData.lastName),
                showEditIcon: false,
                placeholder: false,
              )
            ],
          ),
        )
        .toList();
  }

  @override
  void initState() {
    super.initState();
    searchNameList = names;
    tableHeading.clear();
    tableHeading.add("First Name");
    tableHeading.add("Second Name");

    for (var index = 0; index < tableHeading.length; index++) {
      searchCtrl.add(CustomSearchTextFieldWidget(
        onChangedFunctions: (String value, TextEditingController controller) {
          if (kDebugMode) {
            print(value);
          }
          List<dynamic> searchList = <dynamic>[];

          if (value.isNotEmpty) {
            searchList.clear();
            for (int i = 0; i < names.length; i++) {
              String data = index == 0 ? names[i].firstName : names[i].lastName;
              Name nameData = names[i];
              if (data.toLowerCase().contains(value.toLowerCase())) {
                searchList.add(nameData);
              }
            }
            setState(() {
              searchNameList = searchList;
            });
          } else {
            setState(() {
              searchNameList = names;
            });
          }
        },
        index: index,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Table Plus Plugin'),
        ),
        body: TablePlus(
          exportFileName: "MyTableFile",
          tabelHeadingList: tableHeading,
          isExportCSVEnabled: true,
          columnSpacing: 60,
          sortColumnIndex: 1,
          isSearchEnabled: isSearchEnabled,
          rows: dataRowsValues(),
          columns: dataColumnValues(),
          dataValues: names,
          shareWidget: Container(
              color: Colors.blue,
              padding: const EdgeInsets.all(10.0),
              child: const Text(
                'Export',
                style: TextStyle(color: Colors.white),
              )),
        ),
      ),
    );
  }

  var names = <Name>[
    Name(firstName: "Aakav", lastName: "Kumar"),
    Name(firstName: "Aakash", lastName: "Tewari"),
    Name(firstName: "Rohan", lastName: "Singh"),
    Name(firstName: "rajesh", lastName: "babu"),
    Name(firstName: "ajeeth", lastName: "balaji"),
    Name(firstName: "raj", lastName: "kumar"),
    Name(firstName: "mohan", lastName: "raj"),
    Name(firstName: "sundar", lastName: "jo"),
    Name(firstName: "veera", lastName: "sundar"),
  ];
}

class Name {
  String firstName;
  String lastName;

  Name({required this.firstName, required this.lastName});
}
