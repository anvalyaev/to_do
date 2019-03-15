import 'dart:async';

abstract class EntityBase {
  
  StreamController<EntityBase> _controller;
  EntityBase(this._controller) {
      modelChanged();
  }
  void modelChanged() {
    _controller.sink.add(this);
  }
  
  void initialize();
  void reload();

}
