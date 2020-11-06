import 'package:flutter/material.dart';
import 'package:news/src/models/item_model.dart';
import '../blocs/comments_provider.dart';
import 'dart:async';
import '../widgets/comment.dart';

class NewsDetail extends StatelessWidget{
  final int itemId;

  NewsDetail({this.itemId});

  Widget build(context){
    final bloc = CommentsProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
      ),
      body: buildBody(bloc),
    );
  }

  Widget buildBody(CommentsBloc bloc){
    return StreamBuilder(
      stream: bloc.itemWithComments,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot){
        if(!snapshot.hasData){
          return Text("loading....");
        }

        final itemFuture = snapshot.data[itemId];

        return FutureBuilder(
          future: itemFuture,
          builder: (context,  AsyncSnapshot<ItemModel> itemSnapshot){
            if(!itemSnapshot.hasData){
              return Text("loading....");
            }

            return buildList(itemSnapshot.data, snapshot.data);
          }
        );
      },
    );
  }


  Widget buildList(ItemModel item, Map<int, Future<ItemModel>> itemMap){
    final children = <Widget>[];
    children.add(buildTitle(item));


    final commentsList = item.kids.map((kidId){
      return Comment(itemId: kidId, itemMap: itemMap, depth: 0);
    }).toList();

    children.addAll(commentsList);


    return ListView(
        children: children,
    );
  }



  Widget buildTitle(ItemModel item){
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.all(10),
      child: Text(
        item.title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      )
    );
  }





  @override
  Widget buildBodyMe(ItemModel item) {
    final levelIndicator = Container(
      child: Container(
        child: LinearProgressIndicator(
            backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
            value: 1,
            valueColor: AlwaysStoppedAnimation(Colors.green)),
      ),
    );

    final coursePrice = Container(
      padding: const EdgeInsets.all(7.0),
      decoration: new BoxDecoration(
          border: new Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(5.0)),
      child: new Text(
        "votes:" + item.score.toString(),
        style: TextStyle(color: Colors.white),
      ),
    );

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 120.0),
        Icon(
          Icons.directions_car,
          color: Colors.white,
          size: 40.0,
        ),
        Container(
          width: 90.0,
          child: new Divider(color: Colors.green),
        ),
        SizedBox(height: 10.0),
        Text(
          item.title,
          style: TextStyle(color: Colors.white, fontSize: 45.0),
        ),
        SizedBox(height: 30.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(flex: 1, child: levelIndicator),
            Expanded(
                flex: 6,
                child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      item.type,
                      style: TextStyle(color: Colors.white),
                    ))),
            Expanded(flex: 1, child: coursePrice)
          ],
        ),
      ],
    );




    Widget topContent(context) {
      return Stack(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 10.0),
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.5,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("drive-steering-wheel.jpg"),
                  fit: BoxFit.cover,
                ),
              )),
          Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.5,
            padding: EdgeInsets.all(40.0),
            width: MediaQuery
                .of(context)
                .size
                .width,
            decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
            child: Center(
              child: topContentText,
            ),
          ),
          Positioned(
            left: 8.0,
            top: 60.0,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back, color: Colors.white),
            ),
          )
        ],
      );
    }


    Widget bottomContentText(ItemModel item) {
      return Text(
        item.title,
        style: TextStyle(fontSize: 18.0),
      );
    }

  }
}