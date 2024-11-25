import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Future Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const FuturePage(),
    );
  }
}

class FuturePage extends StatefulWidget {
  const FuturePage({super.key});

  @override
  State<FuturePage> createState() => _FuturePageState();
}

class _FuturePageState extends State<FuturePage> {
  String result = '';
  bool isLoading =
      false; // Menambahkan variabel untuk menunjukkan status loading
  late Completer<int> completer; // Menyimpan tipe data int

  Future<int> getNumber() {
    completer = Completer<int>();
    calculate(); // Memanggil fungsi calculate
    return completer.future; // Mengembalikan future dari completer
  }

  Future<void> calculate() async {
    await Future.delayed(const Duration(seconds: 5));
    completer.complete(42); // Menyelesaikan completer dengan nilai 42
  }

  Future<void> calculate2() async {
    try {
      await new Future.delayed(const Duration(seconds: 5));
    } catch (_) {
      completer.completeError({});
    }
  }

  Future<void> getData() async {
    const authority = 'www.googleapis.com';
    const path = '/books/v1/volumes/gNpXEAAAQBAJ';
    Uri url = Uri.https(authority, path);

    setState(() {
      isLoading = true; // Set loading menjadi true saat memulai permintaan
    });

    try {
      final response = await http.get(url);
      setState(() {
        result = response.body.toString().substring(0, 450);
      });
    } catch (e) {
      setState(() {
        result = 'Error: $e'; // Menangani kesalahan
      });
    } finally {
      setState(() {
        isLoading =
            false; // Set loading menjadi false setelah permintaan selesai
      });
    }
  }

  // Fungsi tambahan yang mengembalikan angka 1
  Future<int> returnOneAsync() async {
    await Future.delayed(const Duration(seconds: 3));
    return 1;
  }

  // Fungsi tambahan yang mengembalikan angka 2
  Future<int> returnTwoAsync() async {
    await Future.delayed(const Duration(seconds: 3));
    return 2;
  }

  // Fungsi tambahan yang mengembalikan angka 3
  Future<int> returnThreeAsync() async {
    await Future.delayed(const Duration(seconds: 3));
    return 3;
  }

  Future<void> count() async {
    int total = 0;
    total += await returnOneAsync();
    total += await returnTwoAsync();
    total += await returnThreeAsync();
    setState(() {
      result = total.toString();
    });
  }

  // Fungsi untuk memanggil ketiga fungsi di atas secara berurutan
  Future<void> getSequentialData() async {
    setState(() {
      isLoading = true; // Set loading menjadi true saat memulai permintaan
      result = ''; // Reset hasil sebelum mulai
    });

    try {
      int one = await returnOneAsync();
      int two = await returnTwoAsync();
      int three = await returnThreeAsync();

      setState(() {
        result = 'Results: $one, $two, $three'; // Menampilkan hasil
      });
    } catch (e) {
      setState(() {
        result = 'Error: $e'; // Menangani kesalahan
      });
    } finally {
      setState(() {
        isLoading =
            false; // Set loading menjadi false setelah permintaan selesai
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laman Eric'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('GO!'),
              onPressed: () {
                getNumber().then((value) {
                  setState(() {
                    result = value.toString();
                  });
                }).catchError((e) {
                  result = 'An error occurred';
                });
              },
            ),
            const SizedBox(height: 20),
            isLoading // Menampilkan indikator progres jika sedang loading
                ? const CircularProgressIndicator()
                : Text(result),
          ],
        ),
      ),
    );
  }
}
