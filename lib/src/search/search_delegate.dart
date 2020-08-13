import 'package:flutter/material.dart';
import 'package:go_back_class_flutter/src/models/pelicula_model.dart';
import 'package:go_back_class_flutter/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  String seleccion = "";
  final peliculasProvider = new PeliculasProvider();
  final peliculas = [
    'ironman 1',
    'superman',
    'joker',
    'batman 1',
    'batman 2',
    'batman 3',
    'batman 4',
    'los mopets',
    'avengers',
    'wollverine',
    'la mascara',
    'naruto',
  ];

  final sugerencias = ['joker', 'superman'];

  @override
  List<Widget> buildActions(BuildContext context) {
    // acciones de nuestro appbar

    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // crea los resultados de vamos a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.cyan,
        child: Text("$seleccion"),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return Container();

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      //initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {
          final peliculas = snapshot.data;
          return ListView(
            children: peliculas.map((e) {
              return ListTile(
                leading: FadeInImage(
                    placeholder: AssetImage("assets/img/no-image.jpg"),
                    image: NetworkImage(e.getPosterImf())),
                title: Text(e.title),
                subtitle: Text(e.originalTitle),
                onTap: () {
                  close(context, null);
                  e.uniqueId = "";
                  Navigator.pushNamed(context, "detalle", arguments: e);
                },
              );
            }).toList(),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  /*  @override
  Widget buildSuggestions(BuildContext context) {
    // son las sugerencias que aparecen cuando la persona escribe
    final listaSugerida = query.isEmpty
        ? sugerencias
        : peliculas
            .where((element) =>
                element.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
    return ListView.builder(
      itemCount: listaSugerida.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Icon(Icons.movie_filter),
          title: Text(listaSugerida[index]),
          onTap: () {
            seleccion = listaSugerida[index];
            showResults(context);
          },
        );
      },
    );
  }*/
}
