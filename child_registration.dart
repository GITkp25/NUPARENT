// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:nu_parent/Components/topbar.dart';
import 'package:nu_parent/main.dart';
import 'package:nu_parent/success.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nu_parent/view_profile.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class RegistrationChild extends StatefulWidget {
  final String docId;
  final String action;
  const RegistrationChild({Key? key, required this.docId, required this.action})
      : super(key: key);

  @override
  State<RegistrationChild> createState() => _RegistrationChildState();
}

class _RegistrationChildState extends State<RegistrationChild> {
  final _formKey = GlobalKey<FormState>();
  late String _receivedDocId;

  late ProgressDialog _progressDialog;

  @override
  void initState() {
    super.initState();
    _receivedDocId = widget.docId;
    _progressDialog = ProgressDialog(context);
  }

  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  XFile? _selectedImage;
  String? _imageUrl;
  DateTime? _selectedDate;
  String selectedGender = '';

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = XFile(pickedFile.path);
      });
    }
  }

  void _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000, 1, 1),
      lastDate: DateTime(2050, 12, 31),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid name';
    }
    return null;
  }

  String? _validateDateOfBirth(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select the date of birth';
    }
    return null;
  }

  Future<void> _registerChild() async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        _progressDialog.show();
        if (selectedGender.isEmpty) {
          Fluttertoast.showToast(
            msg: "Please select a gender",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          return;
        }

        DocumentReference childRef =
            await FirebaseFirestore.instance.collection('child').add({
          'name': _nameController.text,
          'dateOfBirth': _dateController.text,
          'gender': selectedGender,
          'userId': _receivedDocId,
          // Add more fields as needed
        });

        String docId = childRef.id;

        await _uploadImage(docId);

        Fluttertoast.showToast(
          msg: "Registration Successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        if (widget.action == 'ADD') {
          _progressDialog.hide();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ViewProfile()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SuccessScreen()),
          );
        }
      }
    } catch (e) {
      _progressDialog.hide();
      Fluttertoast.showToast(
        msg: "Error registering child: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      print("Error registering child: $e");
      // Handle error, show message, or take appropriate action
    }
  }

  Future<void> _uploadImage(String childId) async {
    try {
      if (_selectedImage != null) {
        Reference ref =
            FirebaseStorage.instance.ref().child('child_images/$childId.jpg');
        UploadTask uploadTask = ref.putFile(File(_selectedImage!.path));
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

        String imageUrl = await taskSnapshot.ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('child')
            .doc(childId)
            .update({
          'imageUrl': imageUrl,
        });
      }
    } catch (e) {
      print("Error uploading image: $e");
      // Handle error, show message or take appropriate action
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Color.fromARGB(255, 245, 251, 255),
                    Color.fromARGB(255, 175, 203, 244),
                  ],
                  radius: .5,
                  center: Alignment(0.2, -.6),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomTopBar(
                      showBackIcon: true,
                      showNotificationButton: false,
                      docId: _receivedDocId,
                    ),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Child Profile",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Text(
                                'Please make sure all the details are right.'),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundColor: const Color(0xff4c505b),
                                      backgroundImage: _selectedImage != null
                                          ? FileImage(
                                              File(_selectedImage!.path))
                                          : _imageUrl != null
                                              ? NetworkImage(_imageUrl!)
                                              : const AssetImage(
                                                      'assets/dummy-profile-pic.png')
                                                  as ImageProvider,
                                      child: _selectedImage == null &&
                                              _imageUrl == null
                                          ? const Icon(
                                              Icons.add,
                                              size: 40,
                                              color: Color.fromARGB(
                                                  255, 134, 134, 134),
                                            )
                                          : null,
                                    ),
                                    if (_selectedImage != null ||
                                        _imageUrl != null)
                                      const Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: CircleAvatar(
                                          backgroundColor: AppColors.white,
                                          radius: 18,
                                          child: Icon(
                                            Icons.edit,
                                            size: 18,
                                            color: AppColors.black,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: _nameController,
                              validator: _validateName,
                              decoration: InputDecoration(
                                hintText: 'Name',
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 20.0,
                                  horizontal: 25.0,
                                ),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(241, 241, 241, 255),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _dateController,
                              readOnly: true,
                              validator: _validateDateOfBirth,
                              decoration: InputDecoration(
                                suffixIcon:
                                    const Icon(Icons.calendar_month_outlined),
                                hintText: 'Date of Birth',
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 25.0),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(241, 241, 241, 255),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide.none),
                              ),
                              onTap: _selectDate,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text('Select Gender'),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    Radio<String>(
                                      activeColor: AppColors.primaryColor,
                                      value: 'Male',
                                      groupValue: selectedGender,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedGender = value!;
                                        });
                                      },
                                    ),
                                    const Text('Male'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Radio<String>(
                                      activeColor: AppColors.primaryColor,
                                      value: 'Female',
                                      groupValue: selectedGender,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedGender = value!;
                                        });
                                      },
                                    ),
                                    const Text('Female'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Radio<String>(
                                      activeColor: AppColors.primaryColor,
                                      value: 'Other',
                                      groupValue: selectedGender,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedGender = value!;
                                        });
                                      },
                                    ),
                                    const Text('Other'),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _registerChild();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 15, 0, 15),
                                    ),
                                    child: const Text(
                                      'Save',
                                      style: TextStyle(
                                          fontSize: 20, color: AppColors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
