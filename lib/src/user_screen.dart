import 'package:crud_user_firebase/src/user_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserListScreen extends StatelessWidget {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  UserListScreen({super.key});

  Future<void> addUser(String name, String email) {
    return usersCollection.add({'name': name, 'email': email});
  }

  Future<void> deleteUser(String id) {
    return usersCollection.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Usuarios')),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersCollection.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();

          final users = snapshot.data!.docs.map((doc) {
            final user =
                User.fromMap(doc.data() as Map<String, dynamic>, doc.id);
            return ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person), // Ícono de persona
              ),
              title: Text(user.name),
              subtitle: Text(user.email),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => deleteUser(user.id),
              ),
            );
          }).toList();

          return ListView(children: users);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) {
            String name = '';
            String email = '';
            return AlertDialog(
              title: const Text('Agregar Usuario'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) => name = value,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                  ),
                  TextField(
                    onChanged: (value) => email = value,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    addUser(name, email);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Agregar'),
                ),
              ],
            );
          },
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
