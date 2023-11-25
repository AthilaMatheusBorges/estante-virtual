import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  List<dynamic> books = [];
  List<int> favoritosList = [];
  List<int> baixadosList = [];

  @override
  void initState() {
    super.initState();

    _iniciar();
    fetchBooks(); // Chamada para carregar os livros ao iniciar o aplicativo
  }

  Future<void> _iniciar() async {
    bool favorito = await _existeLista('favoritos');
    bool baixados = await _existeLista('baixados');

    List<int> fav = [];
    List<int> bai = [];

    if (!favorito) {
      _criaLista('favoritos');
    } else
      fav = await _getLista('favoritos');

    if (!baixados)
      _criaLista('baixados');
    else
      bai = await _getLista('baixados');

    setState(() {
      if (favorito) favoritosList = fav;
      if (baixados) baixadosList = bai;
    });
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
                                    onPressed: () => {
                                          if (favoritosList
                                              .contains(book['id']))
                                            {
                                              _removeItem(
                                                  'favoritos', book['id'])
                                            }
                                          else
                                            _adicionaItem(
                                                'favoritos', book['id'])
                                        },
                                    icon: Icon(
                                      Icons.bookmark,
                                      color:
                                          (favoritosList.contains(book['id']))
                                              ? Colors.red
                                              : Colors.blueGrey,
                                    ))),
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

  Future<void> _criaLista(String key) async {
    List<int> favs = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedList = json.encode(favs);
    await prefs.setString(key, encodedList);
    print("Lista ${key} criada!");
  }

  _existeLista(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedList = prefs.getString(key);
    if (encodedList != null) {
      return true;
    } else {
      return false;
    }
  }

  _getLista(String key) async {
    List<int> lista = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedList = prefs.getString(key);
    if (encodedList != null) {
      List<dynamic> decodedList = json.decode(encodedList);
      lista = List<int>.from(decodedList);
    }
    print(lista);
    return lista;
  }

  Future<void> _adicionaItem(String key, int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedList = prefs.getString(key);
    if (encodedList != null) {
      List<dynamic> decodedList = json.decode(encodedList);
      List<int> lista = List<int>.from(decodedList);
      lista.add(id);
      String updatedList = json.encode(lista);
      await prefs.setString(key, updatedList);

      setState(() {
        if (key == 'favoritos') {
          favoritosList = lista;
        } else
          baixadosList = lista;
      });

      print('Lista editada: $lista');
    } else {
      print('Lista não encontrada!');
    }
  }

  Future<void> _removeItem(String key, int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedList = prefs.getString(key);
    if (encodedList != null) {
      List<dynamic> decodedList = json.decode(encodedList);
      List<int> lista = List<int>.from(decodedList);
      if (lista.isNotEmpty) {
        lista.removeWhere((element) => element == id);
      }
      String updatedList = json.encode(lista);
      await prefs.setString(key, updatedList);

      setState(() {
        if (key == 'favoritos') {
          favoritosList = lista;
        } else
          baixadosList = lista;
      });

      print('Item removido: $lista');
    } else {
      print('Lista não encontrada!');
    }
  }
}
