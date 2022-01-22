import 'package:flutter/material.dart';
import 'package:table_plus2/table_plus.dart';

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
  final bool isSearchEnabled = true;
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
              ),
              DataCell(
                Text(objData.age.toString()),
                showEditIcon: false,
                placeholder: false,
              ),
              DataCell(
                Text(objData.mobileNumber.toString()),
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
    tableHeading.add("Age");
    tableHeading.add("Mobile Number");

    for (var index = 0; index < tableHeading.length; index++) {
      searchCtrl.add(CustomSearchTextFieldWidget(
        onChangedFunctions: (String value, TextEditingController controller) {
          List<dynamic> searchList = <dynamic>[];

          if (value.isNotEmpty) {
            searchList.clear();
            for (int i = 0; i < names.length; i++) {
              if (index == 0 || index == 1) {
                String data =
                    index == 0 ? names[i].firstName : names[i].lastName;
                Name nameData = names[i];
                if (data.toLowerCase().contains(value.toLowerCase())) {
                  searchList.add(nameData);
                }
              } else if (index == 2) {
                int age = names[i].age;
                Name nameData = names[i];
                if (age.toString().contains(value)) {
                  searchList.add(nameData);
                }
              } else if (index == 3) {
                int mobileNumber = names[i].mobileNumber;
                Name nameData = names[i];
                if (mobileNumber.toString().contains(value)) {
                  searchList.add(nameData);
                }
              }
              // String data = index == 0 ? names[i].firstName : names[i].lastName;
              // Name nameData = names[i];
              // if (data.toLowerCase().contains(value.toLowerCase())) {
              //   searchList.add(nameData);
              // }
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
    Name(
        firstName: "Aakav",
        lastName: "Kumar",
        age: 22,
        mobileNumber: 9087694590),
    Name(
        firstName: "Aakash",
        lastName: "Tewari",
        age: 23,
        mobileNumber: 9994628319),
    Name(
        firstName: "Rohan",
        lastName: "Singh",
        age: 24,
        mobileNumber: 99524018412),
  ];
}

class Name {
  String firstName;
  String lastName;
  int age;
  int mobileNumber;

  Name(
      {required this.firstName,
      required this.lastName,
      required this.age,
      required this.mobileNumber});
}
