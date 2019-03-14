import 'dart:async';

abstract class EntityBase {
  EntityBase(this._controller) {
      modelChanged();
  }
  void modelChanged() {
    _controller.sink.add(this);
  }
  
  void init();
  StreamController<EntityBase> _controller;
}
