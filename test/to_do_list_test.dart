import 'package:test/test.dart';
import 'package:to_do/interactor/actions/index.dart' as actions;
import 'package:to_do/interactor/notifications/index.dart' as notifications;
import 'package:to_do/interactor/data_stores/database/repositories/index.dart';
import 'package:to_do/interactor/accessor_dummy.dart';

void main() {
  AccessorDummy accessor = new AccessorDummy();
  group('To do list:', () {
    test(
        'Новая задача может быть добавлена в список задач, при этом она имеет статус не выполненной',
        () async {
      actions.GetToDoList result1 =
          await accessor.runAction(actions.GetToDoList());
      int beforeCount = result1.items.length;
      actions.AddToDoItem result =
          await accessor.runAction(actions.AddToDoItem());
      actions.GetToDoList result2 =
          await accessor.runAction(actions.GetToDoList());
      actions.GetToDoItem result3 =
          await accessor.runAction(actions.GetToDoItem(result.item.id));

      int afterCount = result2.items.length;
      expect(afterCount, beforeCount + 1);
      expect(result3.item.done, false);
    });
    test(
        'После добавления новой задачи число невыполненных задач увеличивается на единицу',
        () async {
      actions.GetToDoList result1 =
          await accessor.runAction(actions.GetToDoList(done: false));
      int beforeNotDoneCount = result1.items.length;
      await accessor.runAction(actions.AddToDoItem());
      actions.GetToDoList result3 =
          await accessor.runAction(actions.GetToDoList());
      int afterNotDoneCount = result3.items.length;
      expect(afterNotDoneCount, beforeNotDoneCount + 1);
    });
    test('Можно удалить задачу из списка', () async {
      actions.AddToDoItem result1 =
          await accessor.runAction(actions.AddToDoItem());
      ToDoItem newToDoItem = result1.item;
      actions.GetToDoList result2 =
          await accessor.runAction(actions.GetToDoList());
      int beforeCount = result2.items.length;
      await accessor.runAction(actions.RemoveToDoItem(newToDoItem.id));
      actions.GetToDoList result4 =
          await accessor.runAction(actions.GetToDoList());
      int afterCount = result4.items.length;
      expect(afterCount, beforeCount - 1);
    });
    test(
        'При удалении выполненной задачи число невыполненных задач не изменяется',
        () async {
      actions.AddToDoItem result1 =
          await accessor.runAction(actions.AddToDoItem());
      actions.AddToDoItem result2 =
          await accessor.runAction(actions.AddToDoItem());
      actions.EditToDoItem result3 = await accessor
          .runAction(actions.EditToDoItem(result2.item.id, done: true));
      actions.GetToDoList result4 =
          await accessor.runAction(actions.GetToDoList(done: false));
      int beforeCount = result4.items.length;
      actions.RemoveToDoItem result5 =
          await accessor.runAction(actions.RemoveToDoItem(result3.item.id));
      actions.GetToDoList result6 =
          await accessor.runAction(actions.GetToDoList(done: false));
      int afterCount = result6.items.length;
      expect(afterCount, beforeCount);
    });
    test(
        'При удалении не выполненной задачи число невыполненных задач уменьшается на единицу',
        () async {
      actions.AddToDoItem result1 =
          await accessor.runAction(actions.AddToDoItem());
      actions.AddToDoItem result2 =
          await accessor.runAction(actions.AddToDoItem());
      actions.EditToDoItem result3 = await accessor
          .runAction(actions.EditToDoItem(result2.item.id, done: true));
      actions.GetToDoList result4 =
          await accessor.runAction(actions.GetToDoList(done: false));
      int beforeCount = result4.items.length;
      actions.RemoveToDoItem result5 =
          await accessor.runAction(actions.RemoveToDoItem(result1.item.id));
      actions.GetToDoList result6 =
          await accessor.runAction(actions.GetToDoList(done: false));
      int afterCount = result6.items.length;
      expect(afterCount, beforeCount - 1);
    });

    test('Фильтр невыполненных задач отбирает только невыполненные задачи',
        () async {
      actions.AddToDoItem result1 =
          await accessor.runAction(actions.AddToDoItem(done: true));
      actions.AddToDoItem result2 =
          await accessor.runAction(actions.AddToDoItem(done: false));
      actions.AddToDoItem result3 =
          await accessor.runAction(actions.AddToDoItem(done: true));
      actions.AddToDoItem result4 =
          await accessor.runAction(actions.AddToDoItem(done: false));
      actions.GetToDoList result6 =
          await accessor.runAction(actions.GetToDoList(done: false));
      for (ToDoItem item in result6.items) {
        if (item.done == true) expect(true, false);
      }
    });

    test('Фильтр выполненных задач отбирает только выполненные задачи',
        () async {
      actions.AddToDoItem result1 =
          await accessor.runAction(actions.AddToDoItem(done: true));
      actions.AddToDoItem result2 =
          await accessor.runAction(actions.AddToDoItem(done: false));
      actions.AddToDoItem result3 =
          await accessor.runAction(actions.AddToDoItem(done: true));
      actions.AddToDoItem result4 =
          await accessor.runAction(actions.AddToDoItem(done: false));
      actions.GetToDoList result6 =
          await accessor.runAction(actions.GetToDoList(done: true));
      for (ToDoItem item in result6.items) {
        if (item.done == false) expect(true, false);
      }
    });
    test(
        'Невыполненную задачу можно пометить выполненной, при этом число невыполненных задач уменьшается на единицу',
        () async {
      actions.AddToDoItem result1 =
          await accessor.runAction(actions.AddToDoItem());
      actions.AddToDoItem result2 =
          await accessor.runAction(actions.AddToDoItem());
      actions.GetToDoList result4 =
          await accessor.runAction(actions.GetToDoList(done: false));
      int beforeCount = result4.items.length;
      actions.EditToDoItem result3 = await accessor
          .runAction(actions.EditToDoItem(result2.item.id, done: true));
      actions.GetToDoList result6 =
          await accessor.runAction(actions.GetToDoList(done: false));
      int afterCount = result6.items.length;
      expect(afterCount, beforeCount - 1);
    });
    test(
        'Выполненную задачу можно пометить невыполненной, при этом число невыполненных задач увеличивается на единицу',
        () async {
      actions.AddToDoItem result1 =
          await accessor.runAction(actions.AddToDoItem(done: true));
      actions.AddToDoItem result2 =
          await accessor.runAction(actions.AddToDoItem(done: true));
      actions.GetToDoList result4 =
          await accessor.runAction(actions.GetToDoList(done: false));
      int beforeCount = result4.items.length;
      actions.EditToDoItem result3 = await accessor
          .runAction(actions.EditToDoItem(result2.item.id, done: false));
      actions.GetToDoList result6 =
          await accessor.runAction(actions.GetToDoList(done: false));
      int afterCount = result6.items.length;
      expect(afterCount, beforeCount + 1);
    });
  });
}
