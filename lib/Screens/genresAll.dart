import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'GridShow.dart';
import 'SHOW.dart';


class GenresAll extends StatefulWidget {
  final genresDataAll, index;
  GenresAll(this.genresDataAll  , this.index);
  @override
  _GenresAllState createState() => _GenresAllState();
}

class _GenresAllState extends State<GenresAll> {

  @override
  void initState() {
    super.initState();
    initFun();
    setState(() {
      
    });

  }


  var genreMovies , genreTv;
    initFun()async{
       var tv = widget.genresDataAll[widget.index]['_links']['wp:post_type'][0]['href'];
    var movie = widget.genresDataAll[widget.index]['_links']['wp:post_type'][1]['href'];

    var dataTv = await http.get("$tv");
    var dataMovie = await http.get("$movie");
    setState(() {
      genreTv = jsonDecode(dataTv.body);
      genreMovies = jsonDecode(dataMovie.body);

      print(genreMovies);
    });
    }
  var height , width;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return 
    genreMovies == null ? Center(child: CircularProgressIndicator(),) :
      Container(
      child:  Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Container(
                width: 4,
                height: 15,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(4),
                ),
                margin: EdgeInsets.only(left: width * 0.05),
              ),
              Container(
                margin: EdgeInsets.only(left: width * 0.01),
                child: Text("${widget.genresDataAll[widget.index]['name']}",
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ]),
            Container(
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Grid(genreMovies)));
                },
                child: Text(
                  "SEE ALL",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          height: height * 0.235,
          margin: EdgeInsets.only(
            left: width * 0.05,
          ),
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: genreMovies.length == null ? 0 : genreMovies.length,
            itemBuilder: (BuildContext context, int i) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SHOW(genreMovies[i]),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(
                    right: width * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: height * 0.165,
                        width: width * 0.27,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: NetworkImage(
                                "https://image.tmdb.org/t/p/original${genreMovies[i]['dt_poster']}"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Container(
                        width: width * 0.27,
                        margin: EdgeInsets.only(
                          top: height * 0.02,
                        ),
                        child: Text(
                          "${genreMovies[i]['original_title']}",
                          style: TextStyle(fontSize: 8.0, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
    );
  }
}