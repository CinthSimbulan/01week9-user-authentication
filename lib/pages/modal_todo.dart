/*
  Created by: Claizel Coubeili Cepe
  Date: updated April 26, 2023
  Description: Sample todo app with Firebase 
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo_model.dart';
import '../providers/todo_provider.dart';

class TodoModal extends StatelessWidget {
  final String type;
  final Todo? item;
  final TextEditingController _formFieldController = TextEditingController();

  TodoModal({super.key, required this.type, required this.item});

  // Method to show the title of the modal depending on the functionality
  Text _buildTitle() {
    switch (type) {
      case 'Add':
        return const Text("Add new todo");
      case 'Edit':
        return const Text("Edit todo");
      case 'Delete':
        return const Text("Delete todo");
      default:
        return const Text("");
    }
  }

  // Method to build the content or body depending on the functionality
  Widget _buildContent(BuildContext context) {
    switch (type) {
      case 'Delete':
        {
          return Text(
            "Are you sure you want to delete '${item!.title}'?",
          );
        }
      // Edit and add will have input field in them
      default:
        return TextField(
          controller: _formFieldController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        );
    }
  }

  TextButton _dialogAction(BuildContext context) {
    return TextButton(
      onPressed: () {
        switch (type) {
          case 'Add':
            {
              // Access the collection reference
              CollectionReference todosCollection =
                  FirebaseFirestore.instance.collection('todos');
              // Add the document to the collection with explicitly included ID to add then update
              todosCollection.add({
                'userId': 1,
                'title': _formFieldController.text,
                'completed': false,
              }).then((docRef) {
                // Get the auto-generated ID
                String autoId = docRef.id;
                // Update the document with the auto-generated ID
                docRef.update({'id': autoId});
                Navigator.pop(context);
              });
              break;
            }
          case 'Edit':
            {
              context
                  .read<TodoListProvider>()
                  .editTodo(item!.id!, _formFieldController.text);

              // Remove dialog after editing
              Navigator.of(context).pop();
              break;
            }
          case 'Delete':
            {
              context.read<TodoListProvider>().deleteTodo(item!.id!);

              // Remove dialog after editing
              Navigator.of(context).pop();
              break;
            }
        }
      },
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      child: Text(type),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildTitle(),
      content: _buildContent(context),

      // Contains two buttons - add/edit/delete, and cancel
      actions: <Widget>[
        _dialogAction(context),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}
