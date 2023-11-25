// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';

// class FavoritosScreen extends StatefulWidget {
//   const FavoritosScreen({super.key});

//   @override
//   State<FavoritosScreen> createState() => _FavoritosScreenState();
// }

// class _FavoritosScreenState extends State<FavoritosScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//           padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//           child: ListView(
//             children: [
//               Wrap(
//                 spacing: 10.0,
//                 runSpacing: 15.0,
//                 alignment: WrapAlignment.center,
//                 children: books.map<Widget>((book) {
//                   if(favoritosList.contains(book['id']))
//                   return SizedBox(
//                     width: 100,
//                     child: Column(
//                       children: [
//                         Stack(
//                           children: [
//                             Image.network(
//                               book['cover_url'],
//                               width: 100,
//                               height: 160,
//                               fit: BoxFit.cover,
//                             ),
//                             Positioned(
//                                 top: 0.1,
//                                 right: 0.1,
//                                 child: IconButton(
//                                     onPressed: () => {
//                                           if (favoritosList
//                                               .contains(book['id']))
//                                             {
//                                               _removeItem(
//                                                   'favoritos', book['id'])
//                                             }
//                                           else
//                                             _adicionaItem(
//                                                 'favoritos', book['id'])
//                                         },
//                                     icon: Icon(
//                                       Icons.bookmark,
//                                       color:
//                                           (favoritosList.contains(book['id']))
//                                               ? Colors.red
//                                               : Colors.blueGrey,
//                                     ))),
//                           ],
//                         ),
//                         Text(
//                           book['title'],
//                           style: TextStyle(fontFamily: 'Noto', fontSize: 12),
//                         ),
//                         Text(
//                           book['author'],
//                           style: TextStyle(
//                               fontFamily: 'MontSerrat',
//                               fontSize: 8,
//                               color: Colors.grey),
//                         )
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ],
//           ),
//         );
//   }
// }