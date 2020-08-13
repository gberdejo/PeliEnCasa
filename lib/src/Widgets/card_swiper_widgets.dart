import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:go_back_class_flutter/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Pelicula> peliculas;

  CardSwiper({@required this.peliculas});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Swiper(
      itemCount: peliculas.length,
      //pagination: new SwiperPagination(),
      //control: new SwiperControl(),
      layout: SwiperLayout.STACK,
      itemWidth: _screenSize.width * 0.60,
      itemHeight: _screenSize.height * 0.50,

      itemBuilder: (BuildContext context, int index) {
        peliculas[index].uniqueId = "${peliculas[index].id}-poster";
        return Hero(
          tag: peliculas[index].uniqueId,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'detalle',
                      arguments: peliculas[index]);
                },
                child: FadeInImage(
                    //fadeInDuration: Duration(microseconds: 1000),
                    placeholder: AssetImage("assets/img/no-image.jpg"),
                    fit: BoxFit.cover,
                    image: NetworkImage(peliculas[index].getPosterImf())),
              )),
        );
      },
    );
  }
}
