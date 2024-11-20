import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/inventory_provider.dart';
import 'models/inventory_item.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => InventoryProvider(), // Ensure the provider is instantiated
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory Management',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: InventoryListScreen(),
    );
  }
}

class InventoryListScreen extends StatelessWidget {
  const InventoryListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inventoryProvider = Provider.of<InventoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddInventoryItemScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: inventoryProvider.items.length,
        itemBuilder: (context, index) {
          final item = inventoryProvider.items[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Text('Quantity: ${item.quantity}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InventoryItemDetailScreen(item: item),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AddInventoryItemScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  AddInventoryItemScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Inventory Item'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter item name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newItem = InventoryItem(
                      id: DateTime.now().millisecondsSinceEpoch,
                      name: nameController.text,
                      quantity: int.parse(quantityController.text),
                      description: descriptionController.text,
                    );
                    Provider.of<InventoryProvider>(context, listen: false)
                        .addItem(newItem);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InventoryItemDetailScreen extends StatelessWidget {
  final InventoryItem item;

  const InventoryItemDetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inventoryProvider = Provider.of<InventoryProvider>(context);
    final TextEditingController nameController = TextEditingController(text: item.name);
    final TextEditingController quantityController = TextEditingController(text: item.quantity.toString());
    final TextEditingController descriptionController = TextEditingController(text: item.description);

    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quantity: ${item.quantity}'),
            const SizedBox(height: 10),
            Text('Description: ${item.description}'),
            const SizedBox(height: 20),
            const Text('Edit Item'),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Item Name'),
            ),
            TextFormField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final updatedItem = InventoryItem(
                      id: item.id,
                      name: nameController.text,
                      quantity: int.parse(quantityController.text),
                      description: descriptionController.text,
                    );
                    inventoryProvider.updateItem(updatedItem);
                    Navigator.pop(context);
                  },
                  child: const Text('Update Item'),
                ),
                ElevatedButton(
                  onPressed: () {
                    inventoryProvider.deleteItem(item.id);
                    Navigator.pop(context);
                  },
                  child: const Text('Delete Item'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
