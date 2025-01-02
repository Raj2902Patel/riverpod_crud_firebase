import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_mang/pages/addPage.dart';
import 'package:riverpod_mang/pages/editPage.dart';
import 'package:riverpod_mang/providers/funcProviders.dart';

class DisplayPage extends ConsumerWidget {
  const DisplayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final delayAsync = ref.watch(delayedStreamProvider);
    final employeesAsync = ref.watch(fetchProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.withOpacity(0.6),
        title: const Padding(
          padding: EdgeInsets.only(left: 30.0),
          child: Text("Display Data"),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const AddPage()));
                },
                icon: const Icon(
                  CupertinoIcons.add_circled,
                  size: 30,
                )),
          )
        ],
      ),
      body: delayAsync.when(
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
        error: (error, stackTrace) {
          return Center(child: Text('Error: $error'));
        },
        data: (_) {
          return employeesAsync.when(
            data: (employees) {
              return employees.isNotEmpty
                  ? ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: employees.length,
                      itemBuilder: (context, index) {
                        final result = employees[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 8.0, bottom: 2.0),
                          child: Card(
                            color: Colors.yellow.withOpacity(0.1),
                            child: ListTile(
                              title: Text(
                                "Name: ${result.empName}",
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              subtitle: Text(
                                "Number: +91 ${result.empNumber}",
                                style: const TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditPage(data: result),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      showCustomDialog(context, ref, result.id);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        "No Data Found!",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20.0,
                        ),
                      ),
                    );
            },
            loading: () {
              return const Center(child: CircularProgressIndicator());
            },
            error: (err, stack) {
              return Center(child: Text('Error: $err'));
            },
          );
        },
      ),
    );
  }

  void showCustomDialog(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Icon(
                CupertinoIcons.question_circle,
                size: 100,
              ),
              const SizedBox(
                height: 12,
              ),
              // Main container for dialog content
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Are You Sure?",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 25.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text("Do you really want to delete this record?"),
              const SizedBox(
                height: 2,
              ),
              const Text("This procress can't be undone."),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    )),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        )),
                    onPressed: () {
                      final deleteData = ref.watch(deleteDataProvider);
                      deleteData(id);
                      Navigator.pop(context);
                      const snackBar = SnackBar(
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: 'Warning!',
                          message: 'Employee Removed!',
                          messageTextStyle: TextStyle(
                            fontSize: 18.0,
                          ),
                          contentType: ContentType.failure,
                        ),
                      );

                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    },
                    child: const Text(
                      "Remove",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        );
      },
    );
  }
}
