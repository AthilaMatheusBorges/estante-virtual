import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  List<dynamic> books = []; // Lista para armazenar os livros

  @override
  void initState() {
    super.initState();
    fetchBooks(); // Chamada para carregar os livros ao iniciar o aplicativo
  }

  Future<void> fetchBooks() async {
    final response =
        await http.get(Uri.parse('https://escribo.com/books.json'));

    if (response.statusCode == 200) {
      setState(() {
        books = json.decode(response.body);
        print(books); // Converte a resposta para uma lista de livros
      });
    } else {
      print('Falha ao carregar os livros');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Lista de Livros'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: ListView(
            children: [
              Wrap(
                spacing: 10.0,
                runSpacing: 15.0,
                alignment: WrapAlignment.center,
                children: books.map<Widget>((book) {
                  return SizedBox(
                    width: 100,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Image.network(
                              book['cover_url'],
                              width: 100,
                              height: 160,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                            top: 0.1,
                            right: 0.1,
                            child: IconButton(
                                onPressed: () => {},
                                icon: Icon(Icons.bookmark))),
                          ],
                        ),
                        
                        Text(
                          book['title'],
                          style: TextStyle(fontFamily: 'Noto', fontSize: 12),
                        ),
                        Text(
                          book['author'],
                          style: TextStyle(
                              fontFamily: 'MontSerrat',
                              fontSize: 8,
                              color: Colors.grey),
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ));
  }
}
