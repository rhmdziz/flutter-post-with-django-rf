// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:quiz_6/list_mahasiswa.dart';

class Regist extends StatefulWidget {
  const Regist({super.key});

  @override
  State<Regist> createState() => _RegistState();
}

class _RegistState extends State<Regist> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }

  // Fungsi untuk mengirim data ke endpoint
  Future<void> sendData(
      String name, String phone, String email, File? imageFile) async {
    try {
      var url = Uri.parse('http://192.168.50.117:8000/mahasiswa/');
      var request = http.MultipartRequest('POST', url);
      request.fields['nama'] = name;
      request.fields['phone'] = phone;
      request.fields['email'] = email;
      // Jika gambar terpilih, tambahkan sebagai file
      if (imageFile != null) {
        var stream = http.ByteStream(imageFile.openRead());
        var length = await imageFile.length();
        var multipartFile = http.MultipartFile('photo', stream, length,
            filename: imageFile.path.split('/').last);
        request.files.add(multipartFile);
      }
      var response = await http.Response.fromStream(await request.send());
      if (response.statusCode == 201) {
        // Data berhasil terkirim
        print('Data terkirim!');
        _showSuccessAlert();
      } else {
        // Gagal mengirim data

        print('Gagal mengirim data. Status code: ${response.statusCode}');
        _showErrorAlert();
      }
    } catch (e) {
      // Exception saat mengirim data
      print('Error: $e');
    }
  }

  void _showSuccessAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Data berhasil terkirim!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Metode untuk menampilkan alert kesalahan
  void _showErrorAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Gagal mengirim data.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi yang dipanggil saat tombol "Daftar Sekarang" ditekan
  void _register(String name, String phone, String email, File? imageFile) {
    sendData(name, phone, email, imageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('REGISTRASI'),
        centerTitle: true,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text('Name'),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Phone'),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Email'),
            TextField(
              // obscureText: true,
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Photo'),
            _image == null
                ? ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Pilih file'),
                  )
                : Column(
                    children: [
                      Image.file(
                        _image!,
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: _pickImage,
                        child: const Text('Ganti Foto'),
                      ),
                    ],
                  ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                _register(nameController.text, phoneController.text,
                    emailController.text, _image);
                Navigator.pop(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListMahasiswa(),
                  ),
                );
              },
              style: ButtonStyle(
                backgroundColor: const MaterialStatePropertyAll(Colors.red),
                foregroundColor: const MaterialStatePropertyAll(Colors.white),
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
                minimumSize:
                    const MaterialStatePropertyAll(Size(double.infinity, 50)),
              ),
              child: const Text('Daftar Sekarang'),
            ),
          ],
        ),
      ),
    );
  }
}
