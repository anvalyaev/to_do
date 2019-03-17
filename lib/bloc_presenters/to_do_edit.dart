import 'package:flutter/material.dart';
import 'bloc_presenter_base.dart';
import '../interactor/actions/to_do.dart' as actions;
import '../interactor/actions/action_base.dart' as actions;
import '../interactor/notifications/to_do_list_notifier.dart' as notifications;
import '../interactor/notifications/notification_base.dart';
import '../interactor/data_stores/database/repositories/to_do_item.dart';

class ToDoEdit extends BlocPresenterBase {
  String toDoItemId;
  Output<int> color;
  Output<bool> busy;
  Input<int> setColor;
  Input saveItem;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final List<Color> colors = [
    Color(0xFF662233),
    Color(0xFF885566),
    Color(0xFF330022),
    Color(0xFF113322),
    Color(0xFF336644),
    Color(0xFF669944),
    Color(0xFF112200),
    Color(0xFF446611),
    Color(0xFF99bb66),
    Color(0xFF99aa22),
    Color(0xFFccdd22),
    Color(0xFFffffcc),
    Color(0xFFeeee66),
    Color(0xFFccbb88),
    Color(0xFF776633),
    Color(0xFFaa8855),
    Color(0xFF332211),
    Color(0xFFaa4433),
    Color(0xFF663333),
    Color(0xFF881111),
  ];

  ToDoEdit();
  ToDoEdit.edit(this.toDoItemId);
  @override
  void initiate(BuildContext context) {
    color = Output.of(this, 0xFFFFFFFF);
    busy = Output.of(this, false);
    setColor = Input.of(this, handler: (data) {
      color.value = data;
    });
    saveItem = Input.of(this, handler: (data) {
      if (busy.value) return;
      busy.value = true;
      if (toDoItemId == null) {
        execute(actions.AddToDoItem(
                title: titleController.text,
                description: descriptionController.text,
                color: color.value))
            .whenComplete(() {
          busy.value = false;
          Navigator.of(data).pop();
        });
      } else {
        execute(actions.EditToDoItem(toDoItemId,
                title: titleController.text,
                description: descriptionController.text,
                color: color.value))
            .whenComplete(() {
          busy.value = false;
          Navigator.of(data).pop();
        });
      }
    });
    if (toDoItemId != null) {
      busy.value = true;
      execute(actions.GetToDoItem(toDoItemId))
          .then((actions.ActionBase actionBase) {
        var action = actionBase as actions.GetToDoItem;
        titleController.text = action.item.title;
        descriptionController.text = action.item.description;
        color.value = action.item.color;
        busy.value = false;
      });
    }
  }
}
