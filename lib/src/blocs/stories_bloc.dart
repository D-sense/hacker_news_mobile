import 'package:rxdart/rxdart.dart';
import 'dart:async';
import '../models/item_model.dart';
import '../resources/repository.dart';

class StoriesBloc {
  final _repository = Repository();
  final _topIds = PublishSubject<List<int>>();
  final _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();
  final _itemFetcher =  PublishSubject<int>();


  //Getters to Streams
  Stream<List<int>>  get topIds => _topIds.stream;
  Stream<Map<int, Future<ItemModel>>>  get items => _itemsOutput.stream;

  //Getter to Sinks
  Function(int) get fetchItem => _itemFetcher.sink.add;

  StoriesBloc(){
    // it is recommended to be placed here to avoid running this snippet
    // every time which may affect performance.
    _itemFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput);
  }

  fetchTopIds() async{
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }


  clearCache() {
    return _repository.clearCache();
  }


  _itemsTransformer(){
    return ScanStreamTransformer(
          (Map<int, Future<ItemModel>> cache, int id, index){
        print(index);
        cache[id] = _repository.fetchItem(id);
        return cache;
      },
      <int, Future<ItemModel>>{},
    );
  }


  dispose(){
    _topIds.close();
    _itemFetcher.close();
    _itemsOutput.close();
  }

}