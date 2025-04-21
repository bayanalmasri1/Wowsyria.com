import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  String _email = '';
  String _phone = '';
  File? _image;
  final picker = ImagePicker();
  bool _isEditing = false;

  Future<void> fetchProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final response = await http.get(
      Uri.parse('https://www.wowsyria.com/account/profile/'),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _usernameController.text = data['username'];
        _email = data['email'] ?? '';
        _phone = data['phone'] ;
      });
    } else {
      print('Failed to load profile');
    }
  }

  Future<void> updateProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final request = http.MultipartRequest(
      'PATCH',
      Uri.parse('https://www.wowsyria.com/account/profile/'),
    );

    request.headers.addAll({
      'accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    request.fields['username'] = _usernameController.text;

    if (_image != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', _image!.path));
    }

    final response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 202) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم التحديث بنجاح')),
      );
      setState(() {
        _isEditing = false;
      });
      fetchProfile(); // تحديث البيانات المعروضة
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل التحديث')),
      );
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: Center(child: Text('Profile')),backgroundColor: Colors.teal,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            GestureDetector(
              onTap: _isEditing ? pickImage : null,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : AssetImage('assets/default_avatar.png') as ImageProvider,
                child: _image == null
                    ? Icon(Icons.camera_alt, size: 50)
                    : null,
              ),
            ),
            SizedBox(height: 20),

            // الاسم
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'User Name'),
              enabled: _isEditing,
            ),
            SizedBox(height: 12),

            TextField(
              decoration: InputDecoration(labelText: 'Email'),
              readOnly: true,
              controller: TextEditingController(text: _email),
            ),
            SizedBox(height: 12),

        
            TextField(
              decoration: InputDecoration(labelText: 'Phone Number'),
              readOnly: true,
              controller: TextEditingController(text: _phone),
            ),
            SizedBox(height: 20),

            _isEditing
                ? ElevatedButton(
                    onPressed: updateProfile,
                    child: Text('Save'),
                  )
                : ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = true;
                      });
                    },
                    child: Text('Edit'),
                  ),
          ],
        ),
      ),
    );
  }
}