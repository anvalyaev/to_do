import 'notification_base.dart';
import '../entities/entity_base.dart';
import '../entities/to_do_list.dart';
import '../data_stores/database/repositories/to_do_item.dart';

class ToDoListNotifier extends NotificationBase {
  LastChange change;
  final bool done;
  ToDoListNotifier({this.done});
  bool whenNotify(EntityBase entity) {
    bool res = true;
    if(!(entity is IToDoList)) res = false;

    if(done != null){
      IToDoList toDoList = entity;
      if(toDoList.lastChange.delta != null){
        res = (toDoList.lastChange.delta.done == done);
      }
    }
    return res;

  }

  void grabData(EntityBase entity) {
    if (!(entity is IToDoList)) return;
    IToDoList toDoList = entity;
    change = toDoList.lastChange;
  }
}
