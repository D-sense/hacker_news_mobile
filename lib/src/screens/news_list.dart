import 'package:flutter/material.dart';
import '../blocs/stories_provider.dart';
import '../widgets/news_list_tile.dart';
import '../widgets/refresh.dart';


class NewsList extends StatelessWidget {

  Widget build(context){
    final bloc = StoriesProvider.of(context);

    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        title: Text("Top Posts"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              await bloc.clearCache();
              await bloc.fetchTopIds();
            },
          )
        ],
      ),
      body: buildList(bloc),

      bottomNavigationBar: makeBottom(context),
    );
  }

  Widget buildList(StoriesBloc bloc){
    return StreamBuilder(
        stream: bloc.topIds,
        builder: (context, AsyncSnapshot<List<int>> snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Refresh(
            child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, int index){

                  bloc.fetchItem(snapshot.data[index]);

                  return NewsListTile(
                      itemId: snapshot.data[index]
                  );
                }
            ),
          );

        }
    );
  }



  Widget makeBottom (BuildContext ctx){
  return Container(
    height: 55.0,
    child: BottomAppBar(
      color: Color.fromRGBO(58, 66, 86, 1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.home, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(ctx, "/");
            },
          ),
//          IconButton(
//            icon: Icon(Icons.blur_on, color: Colors.white),
//            onPressed: () {},
//          ),
//          IconButton(
//            icon: Icon(Icons.hotel, color: Colors.white),
//            onPressed: () {},
//          ),
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(ctx, "/saved_post");
            },
          )
        ],
      ),
    ),
  );
  }

}