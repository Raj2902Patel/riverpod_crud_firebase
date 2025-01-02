import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_mang/database/dataModel.dart';
import 'package:riverpod_mang/providers/funcProviders.dart';

class AddPage extends ConsumerStatefulWidget {
  const AddPage({super.key});

  @override
  ConsumerState<AddPage> createState() => _AddPageState();
}

class _AddPageState extends ConsumerState<AddPage> {
  final TextEditingController empNameController = TextEditingController();
  final TextEditingController empNumberController = TextEditingController();

  void submitData() {
    final empName = empNameController.text;
    final empNumber = empNumberController.text;

    if (empName.isNotEmpty && empNumber.isNotEmpty) {
      final newData = DataBase(id: '', empName: empName, empNumber: empNumber);
      final addData = ref.watch(addDataProvider);
      addData(newData);
      Navigator.pop(context);

      const snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Success!',
          message: 'Employee Added!',
          messageTextStyle: TextStyle(
            fontSize: 18.0,
          ),
          contentType: ContentType.success,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    } else {
      const snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error!',
          message: 'All Fields Are Required!',
          messageTextStyle: TextStyle(
            fontSize: 18.0,
          ),
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.withOpacity(0.6),
        title: const Text("Add Data"),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
              child: TextFormField(
                maxLength: 15,
                controller: empNameController,
                decoration: InputDecoration(
                    labelText: "Employee Name",
                    prefixIcon: const Icon(CupertinoIcons.person_alt),
                    hintText: "eg. John",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13.0),
                    )),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
              child: TextFormField(
                maxLength: 10,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: empNumberController,
                decoration: InputDecoration(
                  labelText: "Employee Number",
                  prefixIcon: const Icon(CupertinoIcons.phone_fill),
                  prefix: const Text("+91 "),
                  hintText: "Contact Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13.0),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13.0),
              )),
              onPressed: submitData,
              child: const Text(
                "SAVE DATA",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
