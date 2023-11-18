import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/screens/favourite_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokemon App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
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

  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoritePokemonIds = prefs.getStringList('favorites') ?? [];
    });
  }

  Future<void> saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favorites', favoritePokemonIds);
  }

  Future<void> loadBucketItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bucketItems = prefs.getStringList('bucketItems') ?? [];
    });
  }

  Future<void> saveBucketItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('bucketItems', bucketItems);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokemon App'),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.shopping_cart),
                if (bucketItems.isNotEmpty)
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 8,
                      child: Text(
                        bucketItems.length.toString(),
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BucketScreen(bucketItems: bucketItems),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: pokemons.length,
        itemBuilder: (context, index) {
          Pokemon pokemon = pokemons[index];
          bool isFavorite = favoritePokemonIds.contains(pokemon.name);
          bool isAddedToBucket = bucketItems.contains(pokemon.name);

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blueAccent, Colors.greenAccent],
              ),
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
              leading: CircleAvatar(
                backgroundImage: NetworkImage(pokemon.imageUrl),
              ),
              title: Text(
                pokemon.name,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
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
                    icon: Icon(Icons.add_shopping_cart),
                    onPressed: () {
                      setState(() {
                        if (!isAddedToBucket) {
                          bucketItems.add(pokemon.name);
                          saveBucketItems();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Added to Bucket'),
                          ));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Already Added to Bucket'),
                          ));
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.shopping_cart),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BucketScreen(bucketItems: bucketItems),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavouriteScreen(favoritePokemonIds: favoritePokemonIds, favoriteItems: [],),
                  ),
                );
              },
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

  Pokemon({
    required this.name,
    required this.imageUrl,
  });
}

class BucketScreen extends StatelessWidget {
  final List<String> bucketItems;

  const BucketScreen({Key? key, required this.bucketItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bucket'),
      ),
      body: ListView.builder(
        itemCount: bucketItems.length,
        itemBuilder: (context, index) {
          String pokemonName = bucketItems[index];

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blueAccent, Colors.greenAccent],
              ),
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
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${index + 1}.png'),
              ),
              title: Text(
                pokemonName,
                style: TextStyle(color: Colors.white),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Removed from Bucket'),
                  ));
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class FavouriteScreen extends StatelessWidget {
  final List<String> favoriteItems;

  const FavouriteScreen({Key? key, required this.favoriteItems, required List<String> favoritePokemonIds}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: ListView.builder(
        itemCount: favoriteItems.length,
        itemBuilder: (context, index) {
          String pokemonName = favoriteItems[index];

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blueAccent, Colors.greenAccent],
              ),
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
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${index + 1}.png'),
              ),
              title: Text(
                pokemonName,
                style: TextStyle(color: Colors.white),
              ),
              trailing: IconButton(
                icon: Icon(Icons.favorite, color: Colors.red),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Removed from Favorites'),
                  ));
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
