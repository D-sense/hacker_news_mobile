import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../blocs/stories_provider.dart';
import 'dart:async';
import 'loading_container.dart';


class NewsListTile extends StatelessWidget {
  final int itemId;

  NewsListTile({this.itemId});

  Widget build(context){
    final bloc = StoriesProvider.of(context);

    return StreamBuilder(
        stream: bloc.items,
        builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot){
          if(!snapshot.hasData){
            return LoadingContainer();
          }

          return FutureBuilder(
              future: snapshot.data[itemId],
              builder: (context, AsyncSnapshot<ItemModel> itemSnapshot){
                if(!itemSnapshot.hasData){
                  return LoadingContainer();
                }

                return makeCard(context, itemSnapshot.data);
              }
          );
        }
    );
  }


  Widget buildTile(BuildContext context, ItemModel item){
    return Column(
      children: [
        ListTile(
            title: Text(item.title),
            subtitle: Text('${item.score} points'),
            trailing: Column(
              children: [
                Icon(Icons.comment),
                Text('${item.descendants}')
              ],
            )
        ),
        Divider()
      ]
    );
  }


  Card makeCard(BuildContext context, ItemModel item) => Card(
    elevation: 8.0,
    margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    child: Container(
      decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
      child: makeListTile(context, item),
    ),
  );

  Widget makeListTile(BuildContext context, ItemModel item) => ListTile(
    onTap: (){
      Navigator.pushNamed(context, '/${item.id}');
    },

    title: Text(
      item.title,
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),

    subtitle: Row(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Padding(
              padding: EdgeInsets.only(left: 0.0),
              child:Row(
                children: [
                  Icon(Icons.person, color: Colors.grey),
              Text('${item.by}',
                  style: TextStyle(color: Colors.white))
                ]
              ),

        ),

        )]
    ),

      trailing: Column(
        children: [
          Icon(Icons.mode_comment, color: Colors.grey),
          Text('${item.descendants}',
              style: TextStyle(color: Colors.white),)
        ],
      )
  );
}