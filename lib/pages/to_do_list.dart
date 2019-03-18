import 'package:flutter/material.dart';
import '../bloc_presenters/index.dart' as bloc_presenters;
import '../bloc_presenters/bloc_presenter_provider.dart';
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
        BlocPresenterProvider.of<bloc_presenters.ToDoList>(context);

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
                    Center(
              child: StreamBuilder(
            stream: bloc.list.stream,
            initialData: bloc.list.value,
            builder:
                (BuildContext context, AsyncSnapshot<List<ToDoItem>> snapshot) {
              return Text("${snapshot.data.length}");
            },
          )),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              bloc.deleateAll.add(null);
            },
          ),
          StreamBuilder(
            stream: bloc.filter.stream,
            initialData: bloc.filter.value,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return IconButton(
                icon: iconForFilter(snapshot.data),
                onPressed: () {
                  bloc.changeFilter.add(null);
                },
              );
            },
          ),
        ],
        title: Text(Translation.of(context).text("to_do_list")),
      ),
      body: StreamBuilder(
          stream: bloc.list.stream,
          initialData: bloc.list.value,
          builder:
              (BuildContext context, AsyncSnapshot<List<ToDoItem>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                      key: Key(snapshot.data[index].id),
                      onDismissed: (direction) {
                        bloc.removeItem.add(snapshot.data[index].id);
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(snapshot.data[index].title),
                          subtitle: Text(snapshot.data[index].description),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              bloc.showEditItem.add(snapshot.data[index].id);
                            },
                          ),
                          leading: Checkbox(
                            value: snapshot.data[index].done,
                            onChanged: (bool val) {
                              bloc.changeStatusItem.add(
                                  bloc_presenters.ChangeStatusItemData(
                                      snapshot.data[index].id, val));
                            },
                          ),
                        ),
                      ));
                },
              );
            }
            return Container();
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          bloc.showCreateItem.add(context);
        },
      ),
    );
  }
}
