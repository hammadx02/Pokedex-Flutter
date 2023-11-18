// import 'package:flutter/material.dart';

// class FavouriteScreen extends StatelessWidget {
//   final List<String> favoriteItems;

//   const FavouriteScreen({Key? key, required this.favoriteItems, required List<String> favoritePokemonIds}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Favorites'),
//       ),
//       body: ListView.builder(
//         itemCount: favoriteItems.length,
//         itemBuilder: (context, index) {
//           String pokemonName = favoriteItems[index];

//           return Container(
//             margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8.0),
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [Colors.blueAccent, Colors.greenAccent],
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.5),
//                   spreadRadius: 1,
//                   blurRadius: 5,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: ListTile(
//               leading: CircleAvatar(
//                 backgroundImage: NetworkImage(
//                     'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${index + 1}.png'),
//               ),
//               title: Text(
//                 pokemonName,
//                 style: TextStyle(color: Colors.white),
//               ),
//               trailing: IconButton(
//                 icon: Icon(Icons.favorite, color: Colors.red),
//                 onPressed: () {
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                     content: Text('Removed from Favorites'),
//                   ));
//                 },
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
