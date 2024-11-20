class InventoryItem {
  final int id;
  final String name;
  final int quantity;
  final String description;

  InventoryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.description,
  });

  // Convert an InventoryItem into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'description': description,
    };
  }

  // Convert a Map into an InventoryItem
  factory InventoryItem.fromMap(Map<String, dynamic> map) {
    return InventoryItem(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      description: map['description'],
    );
  }
}
