import 'package:flutter/material.dart';
import 'package:pokedex/screens/home_screen.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Pokemon> favoritePokemons;
  final Function(List<String>) updateFavorites;
  final Function(Pokemon) removePokemon;

  const FavoritesScreen({
    super.key,
    required this.favoritePokemons,
    required this.updateFavorites,
    required this.removePokemon,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
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
        itemCount: widget.favoritePokemons.length,
        itemBuilder: (context, index) {
          Pokemon pokemon = widget.favoritePokemons[index];

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
                icon: const Icon(Icons.favorite, color: Colors.red),
                onPressed: () {
                  setState(() {
                    widget.favoritePokemons.remove(pokemon);
                    widget.updateFavorites(widget.favoritePokemons
                        .map((favPokemon) => favPokemon.name)
                        .toList());
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
