// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nu_parent/Components/bottom_bar.dart';
import 'package:nu_parent/child_dashboard.dart';
import 'package:nu_parent/Components/appbar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfile extends StatefulWidget {
  final String? childId;

  const EditProfile({Key? key, required this.childId}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String name = '';
  String gender = '';
  String dob = '';
  String image = 'assets/dummy-profile-pic.png';
  bool isLoading = true;
  String selectedGender = '';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  XFile? _selectedImage;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    loadChildData();
  }

  void updateSelectedGender(String gender) {
    setState(() {
      selectedGender = gender;
    });
  }

  void updateProfile() async {
    if (widget.childId != null) {
      final userDoc =
          FirebaseFirestore.instance.collection('child').doc(widget.childId);

      // Check if any data has changed
      if (nameController.text != name ||
          dobController.text != dob ||
          selectedGender != gender ||
          _selectedImage != null) {
        // Update only if there are changes

        // Check if name is null and set it to an empty string
        final updatedName = nameController.text;

        await userDoc.update({
          'name': updatedName,
          'dateOfBirth': dobController.text,
          'gender': selectedGender,
        }).then((_) async {
          // Update the local state with the new data.
          setState(() {
            name = updatedName;
            dob = dobController.text;
            gender = selectedGender;
          });

          // Handle updating the profile picture here (if needed).
          if (_selectedImage != null) {
            final storage = FirebaseStorage.instance;
            final Reference storageRef = storage
                .ref()
                .child('user_profile_images/${widget.childId}.jpg');
            final UploadTask uploadTask =
                storageRef.putFile(File(_selectedImage!.path));

            await uploadTask.whenComplete(() async {
              final imageUrl = await storageRef.getDownloadURL();
              setState(() {
                image = imageUrl; // Update profileImageUrl with new URL
              });
              userDoc.update({
                'imageUrl': imageUrl,
              });
            });
          }

          // Show a success message or navigate to another page.
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Profile updated successfully'),
          ));
        }).catchError((error) {
          print('Error updating user data: $error');
          // Handle the error.
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error updating profile: $error'),
          ));
        });
      } else {
        // No changes were made
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No changes were made.'),
        ));
      }
    }
  }

  void loadChildData() async {
    if (widget.childId != "") {
      try {
        final userDoc =
            FirebaseFirestore.instance.collection('child').doc(widget.childId);
        final documentSnapshot = await userDoc.get();

        if (documentSnapshot.exists) {
          final childData = documentSnapshot.data();
          setState(() {
            name = childData?['name'] ?? 'Name not Found';
            dob = childData?['dateOfBirth'] as String? ?? 'DOB not Found';
            selectedGender =
                childData?['gender'] as String? ?? 'Gender not Found';

            if (childData?['imageUrl'] != null) {
              image = childData?['imageUrl'] as String;
            }

            isLoading = false; // Set loading state to false
          });
        }
      } catch (error) {
        // Handle any potential errors
        print('Error retrieving user data: $error');
      }
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
        dobController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
        dob = DateFormat('dd-MM-yyyy').format(pickedDate);
        // Reset name when date is selected
        // Reset profile image when date is selected
        _selectedImage = null;
      });
    }
  }

  void deleteChild() async {
    if (widget.childId != null) {
      try {
        final userDoc =
            FirebaseFirestore.instance.collection('child').doc(widget.childId);

        await userDoc.delete();

        // Show a success message or navigate to another page.
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Child deleted successfully'),
        ));

        // Redirect to ChildDashboard after deletion
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ChildDashboard()),
        );
      } catch (error) {
        print('Error deleting user data: $error');
        // Handle the error.
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error deleting child: $error'),
        ));
      }
    }
  }

  bool check = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomBar(),
      body: isLoading ? _buildLoading() : buildProfileContent(),
    );
  }

  Widget _buildLoading() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/Logo.png',
            height: 150,
          ),
          const SizedBox(height: 40),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget buildProfileContent() {
    return Container(
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
      child: ListView(
        children: [
          const CustomAppBar(),
          Form(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                children: [
                  const Text(
                    'Edit Profile',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _pickImage();
                    },
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: _selectedImage != null
                          ? FileImage(File(_selectedImage!.path))
                          : (image != "assets/dummy-profile-pic.png"
                              ? NetworkImage(image)
                              : const AssetImage('assets/dummy-profile-pic.png')
                                  as ImageProvider),
                      child: const Icon(Icons.edit),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    title: Text('Name: $name'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        nameController.text = name;
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _buildEditDialog(
                              'Edit Name',
                              'New Name',
                              nameController,
                              () {
                                updateProfile();
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Date of Birth: $dob'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        dobController.text = dob;
                        _selectDate();
                      },
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Gender",
                      style: TextStyle(fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildGenderButton(Icons.male, 'Male'),
                      buildGenderButton(Icons.female, 'Female'),
                      buildGenderButton(Icons.transgender, 'Others'),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      updateProfile();
                    },
                    child: const Text('Update'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      deleteChild();
                    },
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditDialog(
    String title,
    String hintText,
    TextEditingController controller,
    VoidCallback onSave,
  ) {
    return AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: hintText),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: onSave,
          child: const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = XFile(pickedFile.path);
      });
    }
  }

  Widget buildGenderButton(IconData icon, String gender) {
    return OutlinedButton(
      style: ButtonStyle(
        side: MaterialStateProperty.all(BorderSide(
          width: 1,
          color: selectedGender == gender ? Colors.blue : const Color(0xff4338CA),
        )),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed) ||
                states.contains(MaterialState.selected)) {
              return Colors.blue.withOpacity(0.2);
            } else if (selectedGender == gender) {
              return Colors.blue.withOpacity(0.1);
            }
            return Colors.transparent;
          },
        ),
      ),
      onPressed: () {
        updateSelectedGender(gender);
      },
      child: Icon(icon),
    );
  }
}
