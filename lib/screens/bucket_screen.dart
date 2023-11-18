import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/screens/home_screen.dart';

class BucketScreen extends StatelessWidget {
  final List<Pokemon>? bucketItems;

  const BucketScreen({Key? key, this.bucketItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bucket'),
      ),
      body: ListView.builder(
        itemCount: bucketItems?.length ?? 0,
        itemBuilder: (context, index) {
          Pokemon pokemon = bucketItems![index];

          return ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(pokemon.imageUrl),
            ),
            title: Text(
              pokemon.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            subtitle: Text('ID: ${index + 1}'),
            // ... (add any other details you want to display)
          );
        },
      ),
    );
  }
}