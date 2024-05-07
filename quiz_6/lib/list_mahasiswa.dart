import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_6/detail_mahasiswa.dart';
import 'dart:convert';
import 'package:quiz_6/registrasi.dart';

class Mahasiswa {
  final String url;
  final String nama;
  final String phone;
  final String email;
  final String photo;

  Mahasiswa({
    required this.url,
    required this.nama,
    required this.phone,
    required this.email,
    required this.photo,
  });

  factory Mahasiswa.fromJson(Map<String, dynamic> json) {
    return Mahasiswa(
      url: json['url'],
      nama: json['nama'],
      phone: json['phone'],
      email: json['email'],
      photo: json['photo'],
    );
  }
}

class ListMahasiswa extends StatefulWidget {
  const ListMahasiswa({super.key});

  @override
  State<ListMahasiswa> createState() => _ListState();
}

class _ListState extends State<ListMahasiswa> {
  late Future<List<Mahasiswa>> futureMahasiswa;

  @override
  void initState() {
    super.initState();
    futureMahasiswa = fetchMahasiswa();
  }

  Future<List<Mahasiswa>> fetchMahasiswa() async {
    final response =
        await http.get(Uri.parse('http://192.168.50.117:8000/mahasiswa/'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Mahasiswa> mahasiswaList =
          data.map((json) => Mahasiswa.fromJson(json)).toList();
      return mahasiswaList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Mahasiswa'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Regist(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
          child: FutureBuilder<List<Mahasiswa>>(
            future: futureMahasiswa,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('Tidak ada data');
              } else {
                List<Mahasiswa>? mahasiswa = snapshot.data;
                return ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 20),
                  itemCount: mahasiswa!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DeskripsiMahasiswa(
                              mahasiswa: mahasiswa[index],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          title: Text(mahasiswa[index].nama),
                          subtitle: Text(mahasiswa[index].email),
                          leading: Image.network(mahasiswa[index].photo),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
