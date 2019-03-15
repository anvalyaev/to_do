import 'package:flutter/material.dart';
import '../bloc_presenters/index.dart' as bloc_presenters;
import '../bloc_presenters/bloc_presenter_provider.dart';
import '../interactor/data_stores/database/repositories/to_do_item.dart';

class ToDoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc_presenters.ToDoList bloc =
        BlocPresenterProvider.of<bloc_presenters.ToDoList>(context);

    return Scaffold(
      appBar: AppBar(title: Text('TO DO')),
      body: StreamBuilder(
          stream: bloc.list.stream,
          initialData: bloc.list.value,
          builder:
              (BuildContext context, AsyncSnapshot<List<ToDoItem>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(snapshot.data[index].title),
                    subtitle: Text(snapshot.data[index].description),
                    leading: Checkbox(
                      value: snapshot.data[index].done,
                      onChanged: (bool val) {
                        bloc.changeStatusItem.add(bloc_presenters.ChangeStatusItemData(
                            snapshot.data[index].id, val));
                      },
                    ),
                  );
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
