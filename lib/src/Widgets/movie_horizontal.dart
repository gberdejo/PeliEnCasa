import 'package:flutter/material.dart';
import 'package:go_back_class_flutter/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;
  final Function siguientePagina;

  MovieHorizontal({@required this.peliculas, @required this.siguientePagina});

  final _pageController =
      new PageController(initialPage: 1, viewportFraction: 0.3);

  @override
  Widget build(BuildContext context) {
    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        siguientePagina();
      }
    });
    final _screemSize = MediaQuery.of(context).size;
    return Container(
      height: _screemSize.height * 0.25,
      child: PageView.builder(
          pageSnapping: false,
          controller: _pageController,
          itemCount: peliculas.length,
          itemBuilder: (context, index) =>
              _tarjeta(context, peliculas[index], _screemSize)

          //children: _tarjetas(context),
          ),
    );
  }

  Widget _tarjeta(BuildContext context, Pelicula pelicula, Size screen) {
    pelicula.uniqueId = "${pelicula.id}-page";

    final _tarjeta = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                  //fadeInDuration: Duration(microseconds: 1000),
                  height: screen.height * 0.20,
                  fit: BoxFit.cover,
                  placeholder: AssetImage("assets/img/no-image.jpg"),
                  image: NetworkImage(
                    pelicula.getPosterImf(),
                  )),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            pelicula.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );

    return GestureDetector(
      child: _tarjeta,
      onTap: () {
        Navigator.pushNamed(context, 'detalle', arguments: pelicula);
      },
    );
  }
}
