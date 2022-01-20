import 'package:flutter/material.dart';

class CustomSearchTextFieldWidget extends StatefulWidget {
  final int index;
  final Function onChangedFunctions;

  const CustomSearchTextFieldWidget(
      {required this.index, required this.onChangedFunctions, Key? key})
      : super(key: key);

  @override
  _CustomSearchTextFieldWidgetState createState() =>
      _CustomSearchTextFieldWidgetState();
}

class _CustomSearchTextFieldWidgetState
    extends State<CustomSearchTextFieldWidget> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25.0,
      width: 100.0,
      margin: const EdgeInsets.only(top: 30.0, bottom: 10.0),
      child: TextFormField(
        controller: _nameController,
        onChanged: (value) => widget.onChangedFunctions(value, _nameController),
        decoration: const InputDecoration(hintText: "Search..."),
        validator: (v) {
          if (v!.trim().isEmpty) return 'Please enter something';
          return null;
        },
      ),
    );
  }
}
