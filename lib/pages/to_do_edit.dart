import 'package:flutter/material.dart';
import '../bloc_presenters/index.dart' as bloc_presenters;
import '../bloc_presenters/bloc_presenter_provider.dart';
import '../interactor/data_stores/database/repositories/to_do_item.dart';
import '../utilities/translations/apptranslations.dart';

class ToDoEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc_presenters.ToDoEdit bloc =
        BlocPresenterProvider.of<bloc_presenters.ToDoEdit>(context);
    return Scaffold(
        appBar: AppBar(title: Text(Translation.of(context).text("to_do_edit"))),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.done),
          onPressed: () {
            bloc.saveItem.add(context);
          },
        ),
        body: Padding(
          padding: EdgeInsets.all(12),
          child:Column(
            children: <Widget>[
              TextField(
                controller: bloc.titleController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: Translation.of(context).text("title"),
                  hintText: Translation.of(context).text("title_helper"),
                ),
              ),
              Divider(height: 5),
              Expanded(
                child: TextFormField(
                  controller: bloc.descriptionController,
                  maxLines: 100,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    // labelText: Translation.of(context).text("description"),
                    hintText:
                        Translation.of(context).text("description_helper"),
                  ),
                ),
              ),
              // Divider(height: 5),
              // Container(
              //   height: 60,
              //   child: ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //     itemBuilder: (BuildContext context, int index) {
              //       if (index >= bloc.colors.length) return null;
              //       return SizedBox(
              //         height: 55,
              //         width: 55,
              //         child: Card(
              //           color: bloc.colors[index],
              //         ),
              //       );
              //     },
              //   ),
              // )
            ],
          ),
        ));
  }
}
