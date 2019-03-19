import '../entities/entity_base.dart';
import '../accessor.dart';

abstract class ActionBase{
    ActionBase(){
    _id = counter;
    ++counter;
  }

  void doAction(IAccessor accessor, void onComplete(ActionBase result));
  int get id => _id;
  int _id;
  static int counter = 0;
}