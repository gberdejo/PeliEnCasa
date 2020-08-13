import 'package:flutter/material.dart';
import 'package:go_back_class_flutter/src/models/actores_model.dart';
import 'package:go_back_class_flutter/src/models/pelicula_model.dart';
import 'package:go_back_class_flutter/src/providers/peliculas_provider.dart';

class PeliculaDetalle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      //backgroundColor: Colors.black26,
      body: CustomScrollView(
        slivers: <Widget>[
          _crearAppbar(pelicula),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(
              height: 10,
            ),
            _posterTitulo(context, pelicula),
            _description(pelicula),
            _description(pelicula),
            _description(pelicula),
            _description(pelicula),
            _description(pelicula),
            _description(pelicula),
            _description(pelicula),
            _description(pelicula),
            _description(pelicula),
            _description(pelicula),
            _crearCasting(pelicula)
          ]))
        ],
      ),
    );
  }

  Widget _crearAppbar(Pelicula pelicula) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 250.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: FadeInImage(
          placeholder: AssetImage("assets/img/loading.gif"),
          image: NetworkImage(pelicula.getBackgroundImg()),
          fit: BoxFit.cover,
          fadeInDuration: Duration(microseconds: 1000),
        ),
        title: Text(
          pelicula.title,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
      ),
    );
  }

  Widget _posterTitulo(BuildContext context, Pelicula pelicula) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: pelicula.uniqueId,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: FadeInImage(
                        height: 150,
                        placeholder: AssetImage("assets/img/no-image.jpg"),
                        image: NetworkImage(pelicula.getPosterImf())),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Flexible(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      pelicula.title,
                      style: Theme.of(context).textTheme.headline6,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      pelicula.originalTitle,
                      style: Theme.of(context).textTheme.subtitle1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.star_border),
                        Text(
                          pelicula.voteAverage.toString(),
                          style: Theme.of(context).textTheme.subtitle1,
                        )
                      ],
                    )
                  ],
                ))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _description(Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _crearCasting(Pelicula pelicula) {
    final peliculaProvider = new PeliculasProvider();
    return FutureBuilder(
      future: peliculaProvider.getCast(pelicula.id.toString()),
      //initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          //print(snapshot.data);
          return _crearActoresPageView(snapshot.data);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _crearActoresPageView(List<Actor> actores) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        itemCount: actores.length,
        controller: PageController(initialPage: 1, viewportFraction: 0.3),
        itemBuilder: (context, index) => _actorTarjeta(context, actores[index]),
      ),
    );
  }

  Widget _actorTarjeta(BuildContext context, Actor actor) {
    return Container(
      margin: EdgeInsets.only(right: 20.0),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
                height: 150,
                fit: BoxFit.cover,
                placeholder: AssetImage("assets/img/no-image.jpg"),
                image: NetworkImage(actor.getFoto())),
          ),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
          )
        ],
      ),
    );
  }
}
