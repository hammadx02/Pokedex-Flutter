import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bucket_screen.dart';
import 'favourite_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Pokemon> pokemons = [];
  List<String> favoritePokemonIds = [];
  List<String> bucketItems = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
    loadBucketItems();
    loadPokemons();
  }

  Future<void> saveBucketItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('bucketItems', bucketItems);
  }

  Future<void> loadBucketItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bucketItems = prefs.getStringList('bucketItems') ?? [];
    });
  }

  Future<void> saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favorites', favoritePokemonIds);
  }

  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoritePokemonIds = prefs.getStringList('favorites') ?? [];
    });
  }

  Future<void> loadPokemons() async {
    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=20'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> results = data['results'];

      List<Pokemon> fetchedPokemons = results
          .map((pokemon) => Pokemon(
                name: pokemon['name'],
                imageUrl:
                    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${results.indexOf(pokemon) + 1}.png',
              ))
          .toList();

      setState(() {
        pokemons = fetchedPokemons;
      });
    } else {
      throw Exception('Failed to load Pokemon');
    }
  }

  void _removePokemonFromBucket(Pokemon pokemon) {
    setState(() {
      bucketItems.remove(pokemon.name);
      saveBucketItems();
    });
  }

  void _updateFavorites(List<String> updatedFavorites) {
    setState(() {
      favoritePokemonIds = updatedFavorites;
      saveFavorites();
    });
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Stack(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () async {
                      // Clear bucketItems upon logout
                      setState(() {
                        bucketItems.clear();
                        saveBucketItems();
                      });

                      await FirebaseAuth.instance.signOut();

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BucketScreen(
                            bucketPokemons: pokemons
                                .where((pokemon) =>
                                    bucketItems.contains(pokemon.name))
                                .toList(),
                            removePokemon: _removePokemonFromBucket,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              if (bucketItems.isNotEmpty)
                Positioned(
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 10,
                    child: Text(
                      bucketItems.length.toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: pokemons.length,
          itemBuilder: (context, index) {
            Pokemon pokemon = pokemons[index];
            bool isFavorite = favoritePokemonIds.contains(pokemon.name);
            bool isInBucket = bucketItems.contains(pokemon.name);

            return InkWell(
              onTap: () {},
              child: Container(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      child: Image.network(
                        pokemon.imageUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      pokemon.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : null,
                          ),
                          onPressed: () {
                            setState(() {
                              if (isFavorite) {
                                favoritePokemonIds.remove(pokemon.name);
                              } else {
                                favoritePokemonIds.add(pokemon.name);
                              }
                              saveFavorites();
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            isInBucket
                                ? Icons.shopping_cart
                                : Icons.add_shopping_cart,
                            color: isInBucket ? Colors.green : null,
                          ),
                          onPressed: () {
                            setState(() {
                              if (!bucketItems.contains(pokemon.name)) {
                                bucketItems.add(pokemon.name);
                                saveBucketItems();
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 150,
        child: DotNavigationBar(
          enableFloatingNavBar: true,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoritesScreen(
                      favoritePokemons: pokemons
                          .where((pokemon) =>
                              favoritePokemonIds.contains(pokemon.name))
                          .toList(),
                      updateFavorites: _updateFavorites,
                      removePokemon: _removePokemonFromBucket,
                    ),
                  ),
                );
              }
            });
          },
          items: [
            DotNavigationBarItem(
              icon: const Icon(Icons.home),
              selectedColor: Colors.blue,
            ),
            DotNavigationBarItem(
              icon: const Icon(Icons.favorite),
              selectedColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}

class Pokemon {
  final String name;
  final String imageUrl;

  Pokemon({required this.name, required this.imageUrl});
}
