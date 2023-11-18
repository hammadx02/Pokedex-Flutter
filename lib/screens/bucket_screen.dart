import 'package:flutter/material.dart';
import 'package:pokedex/screens/home_screen.dart';

class BucketScreen extends StatefulWidget {
  final List<Pokemon> bucketPokemons;
  final Function(Pokemon) removePokemon;

  const BucketScreen({
    super.key,
    required this.bucketPokemons,
    required this.removePokemon,
  });

  @override
  State<BucketScreen> createState() => _BucketScreenState();
}

class _BucketScreenState extends State<BucketScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 120.0),
            child: Image.asset(
              'assets/images/logo.png',
              scale: 1,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.bucketPokemons.length,
        itemBuilder: (context, index) {
          Pokemon pokemon = widget.bucketPokemons[index];

          return Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              tileColor: Colors.white,
              leading: CircleAvatar(
                backgroundImage: NetworkImage(pokemon.imageUrl),
              ),
              title: Text(pokemon.name),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    widget.bucketPokemons.remove(pokemon);
                    widget.removePokemon(pokemon);
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
