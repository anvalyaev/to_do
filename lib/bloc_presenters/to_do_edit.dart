import 'package:flutter/material.dart';
import 'bloc_presenter_base.dart';
import '../interactor/actions/to_do.dart' as actions;
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

  ToDoEdit() {
    color = Output.of(this, 0xFFFFFFFF);
    busy = Output.of(this, false);
    setColor = Input.of(this, handler: (data) {
      color.value = data;
    });
    saveItem = Input.of(this, handler: (data) {
      if(busy.value) return;
      busy.value = true;
      if (toDoItemId == null) {
        execute(actions.AddToDoItem(
                title: titleController.text,
                description: descriptionController.text,
                color: color.value))
            .whenComplete(() {
          busy.value = false;
        });
      } else {
        execute(actions.EditToDoItem(toDoItemId,
                title: titleController.text,
                description: descriptionController.text,
                color: color.value))
            .whenComplete(() {
          busy.value = false;
        });
      }
    });
  }
  ToDoEdit.edit(this.toDoItemId) {
    ToDoEdit();
    busy.value = true;
    execute(actions.GetToDoItem(toDoItemId)).then((actions.GetToDoItem action) {
      titleController.text = action.item.title;
      descriptionController.text = action.item.description;
      color.value = action.item.color;
      busy.value = false;
    });
  }
}
