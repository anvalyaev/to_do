import 'package:flutter/material.dart';
import '../presenters/to_do_list.dart' as bloc_presenters;
import '../presenters/presenter_provider.dart';
import '../interactor/data_stores/database/repositories/to_do_item.dart';
import '../utilities/translations/apptranslations.dart';

class ToDoList extends StatelessWidget {
  Icon iconForFilter(bloc_presenters.Filter filter) {
    switch (filter) {
      case bloc_presenters.Filter.all:
        return Icon(Icons.list);
        break;
      case bloc_presenters.Filter.done:
        return Icon(Icons.check_box);
        break;
      case bloc_presenters.Filter.todo:
        return Icon(Icons.check_box_outline_blank);
        break;
      default:
        return Icon(Icons.ac_unit);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc_presenters.ToDoList bloc =
        PresenterProvider.of<bloc_presenters.ToDoList>(context);

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Center(
              child: ValueListenableBuilder(
            valueListenable: bloc.toDoItems,
            builder:
                (BuildContext context, List<ToDoItem> value, Widget child) {
              return Text("${value.length}");
            },
          )),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              bloc.events.add(bloc_presenters.DeleateAll());
            },
          ),
          ValueListenableBuilder(
            valueListenable: bloc.filter,
            builder: (BuildContext context, bloc_presenters.Filter value,
                Widget child) {
              return IconButton(
                icon: iconForFilter(value),
                onPressed: () {
                  bloc.events.add(bloc_presenters.ChangeFilter());
                },
              );
            },
          ),
        ],
        title: Text(Translation.of(context).text("to_do_list")),
      ),
      body: ValueListenableBuilder(
          valueListenable: bloc.toDoItems,
          builder: (BuildContext context, List<ToDoItem> value, Widget child) {
            {
              print("rebuild: $value");
              return ListView.builder(
                itemCount: value.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                      key: Key(value[index].id),
                      onDismissed: (direction) {
                        bloc.events.add(bloc_presenters.RemoveItem(id: value[index].id));
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(value[index].title),
                          subtitle: Text(value[index].description),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              bloc.events.add(bloc_presenters.ShowEditItem(id: value[index].id));
                            },
                          ),
                          leading: Checkbox(
                            value: value[index].done,
                            onChanged: (bool val) {
                              bloc.events.add(bloc_presenters.ChangeStatusItem(id: value[index].id, done: val));
                            },
                          ),
                        ),
                      ));
                },
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          bloc.events.add(bloc_presenters.ShowCreateItem());
        },
      ),
    );
  }
}
