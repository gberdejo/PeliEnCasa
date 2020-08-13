import 'dart:async';
import 'dart:convert';

import 'package:go_back_class_flutter/src/models/actores_model.dart';
import 'package:go_back_class_flutter/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;

class PeliculasProvider {
  String _apiKey = "6e1aa2aad0b4e62806ffaaa40ecfd8d4";
  String _url = "api.themoviedb.org";
  String _language = "es-ES";

  int _popularesPage = 0;

  List<Pelicula> _populares = new List();

  bool _cargando = false;

  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _peticionHttp(Uri url) async {
    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);
    final peliculas = new Peliculas.fromJsomList(decodeData['results']);
    return peliculas.listItems;
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, "3/movie/now_playing",
        {'api_key': _apiKey, 'language': _language});
    return await _peticionHttp(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    _popularesPage++;
    if (_cargando) return [];

    _cargando = true;
    //print("cargando siguiente...");
    final url = Uri.https(_url, "3/movie/popular", {
      'api_key': _apiKey,
      'language': _language,
      'page': _popularesPage.toString()
    });
    final resp = await _peticionHttp(url);
    _populares.addAll(resp);
    //print("\n ahora es ${_populares.length}");
    popularesSink(_populares);
    _cargando = false;
    return resp;
  }

  Future<List<Actor>> getCast(String peliId) async {
    final url = Uri.https(_url, '3/movie/$peliId/credits',
        {'api_key': _apiKey, 'language': _language});
    final res = await http.get(url);
    //print(res.statusCode);
    //print(res.body);
    final decodeData = json.decode(res.body);

    final cast = new Cast.fromJonList(decodeData['cast']);
    return cast.actores;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {
    final url = Uri.https(_url, "3/search/movie",
        {'api_key': _apiKey, 'language': _language, 'query': query});
    return await _peticionHttp(url);
  }
}
