import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSettingsPage extends StatefulWidget {
  final uuid;

  const ProfileSettingsPage({super.key, required this.uuid});

  @override
  ProfileSettingsPageState createState() => ProfileSettingsPageState();
}

class ProfileSettingsPageState extends State<ProfileSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _studentIdRegExp = RegExp(r'^JISU\/\d{4}\/\d{4}$');
  final _phoneRegExp = RegExp(r'^\d{10}$');

  String? _validateStudentId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your student ID';
    }
    if (!_studentIdRegExp.hasMatch(value)) {
      return 'Invalid student ID format';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (!_phoneRegExp.hasMatch(value)) {
      return 'Phone number must be a 10-digit number';
    }
    return null;
  }

  String? _validateDateOfBirth(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your date of birth';
    }
    // TODO: Add date validation logic
    // the date must be in the past
    // Parse the input value to a DateTime object
    final inputDate = DateTime.tryParse(value);
    if (inputDate == null) {
      return 'Invalid date format';
    }

    // Check if the input date is in the future
    if (inputDate.isAfter(DateTime.now())) {
      return 'Date of birth cannot be in the future';
    }
    return null;
  }

  String _name = '';
  String _username = '';
  String _studentID = '';
  String _phoneNumber = '';
  DateTime _dateOfBirth = DateTime.now();
  String _currentSemester = '';
  String _currentYear = '';
  List<String?> _selectedSubjects = [];

  late File _profileImage;
  late String _profileImageUrl;

  Future<void> _uploadProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });

      final ref = FirebaseStorage.instance
          .ref()
          .child('user_profile_images/$_username.jpg');

      await ref.putFile(_profileImage);
      final url = await ref.getDownloadURL();

      setState(() {
        _profileImageUrl = url;
      });
    }
  }

  Future<void> _saveUserData() async {
    final userData = {
      'name': _name,
      'username': _username,
      'student_id': _studentID,
      'phoneNumber': _phoneNumber,
      'date_of_Birth': _dateOfBirth,
      'current_sem': _currentSemester,
      'current_year': _currentYear,
      // 'selectedSubjects': _selectedSubjects,
      'photoUrl': _profileImageUrl,
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uuid)
        .set(userData);
  }

  @override
  void dispose() {
    _saveLastVisitedScreen();
    super.dispose();
  }

  Future<void> _saveLastVisitedScreen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastScreen', '/profile');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Name',
                  style: TextStyle(fontSize: 18.0),
                ),
                TextFormField(
                  initialValue: _name,
                  onChanged: (value) => setState(() => _name = value),
                  validator: (value) =>
                      value!.isEmpty ? 'Name cannot be empty' : null,
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Username',
                  style: TextStyle(fontSize: 18.0),
                ),
                TextFormField(
                  initialValue: _username,
                  onChanged: (value) => setState(() => _username = value),
                  validator: (value) =>
                      value!.isEmpty ? 'Username cannot be empty' : null,
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Student ID  (JISU/XXXX/XXXX)',
                  style: TextStyle(fontSize: 18.0),
                ),
                TextFormField(
                    initialValue: _studentID,
                    onChanged: (value) => setState(() => _studentID = value),
                    validator: _validateStudentId),
                const SizedBox(height: 16.0),
                const Text(
                  'Phone Number',
                  style: TextStyle(fontSize: 18.0),
                ),
                TextFormField(
                    initialValue: _phoneNumber,
                    onChanged: (value) => setState(() => _phoneNumber = value),
                    validator: _validatePhoneNumber),
                const SizedBox(height: 16.0),
                const Text(
                  'Date of Birth',
                  style: TextStyle(fontSize: 18.0),
                ),
                TextButton(
                  onPressed: () async {
                    final initialDate = _dateOfBirth;
                    final newDate = await showDatePicker(
                      context: context,
                      initialDate: _dateOfBirth,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (newDate != null) {
                      setState(() => _dateOfBirth = newDate);
                    }
                  },
                  child: Text(
                    _dateOfBirth != null
                        ? DateFormat('dd/MM/yyyy').format(_dateOfBirth)
                        : 'Select your date of birth',
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Current Semester',
                  style: TextStyle(fontSize: 18.0),
                ),
                TextFormField(
                  initialValue: _currentSemester,
                  onChanged: (value) =>
                      setState(() => _currentSemester = value),
                  validator: (value) => value!.isEmpty
                      ? 'Current Semester cannot be empty'
                      : null,
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Current Year',
                  style: TextStyle(fontSize: 18.0),
                ),
                TextFormField(
                  initialValue: _currentYear,
                  onChanged: (value) => setState(() => _currentYear = value),
                  validator: (value) =>
                      value!.isEmpty ? 'Current Year cannot be empty' : null,
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Subjects',
                  style: TextStyle(fontSize: 18.0),
                ),
                DropdownButtonFormField(
                  value: _selectedSubjects.isNotEmpty
                      ? _selectedSubjects[0]
                      : "Subject A",
                  onChanged: (value) =>
                      setState(() => _selectedSubjects = [value]),
                  items: const [
                    DropdownMenuItem(
                        value: 'Subject A', child: Text('Subject A')),
                    DropdownMenuItem(
                        value: 'Subject B', child: Text('Subject B')),
                    DropdownMenuItem(
                        value: 'Subject C', child: Text('Subject C')),
                  ],
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Profile Image',
                  style: TextStyle(fontSize: 18.0),
                ),
                const SizedBox(height: 8.0),
                // if (_profileImage != null)
                //   Container(
                //     height: 150.0,
                //     width: 150.0,
                //     decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       image: DecorationImage(
                //         fit: BoxFit.cover,
                //         image: FileImage(_profileImage),
                //       ),
                //     ),
                //   )
                // else if (_profileImageUrl != null)
                //   Container(
                //     height: 150.0,
                //     width: 150.0,
                //     decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       image: DecorationImage(
                //         fit: BoxFit.cover,
                //         image: NetworkImage(_profileImageUrl),
                //       ),
                //     ),
                //   )
                // else
                //   Container(
                //     height: 150.0,
                //     width: 150.0,
                //     decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       color: Colors.grey[200],
                //     ),
                //     child: IconButton(
                //       icon: Icon(Icons.add_a_photo),
                //       onPressed: _uploadProfileImage,
                //     ),
                //   ),
                const SizedBox(height: 16.0),
                const Center(
                  child: Text(
                    'Please make sure that you have entered all the details correctly before submitting.',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _saveUserData();
                      // Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
