import 'package:equatable/equatable.dart';

class Pet extends Equatable {
  final String id;
  final String name;
  final int age;
  final double price;
  final String image;
  final bool isAdopted;

  const Pet({
    required this.id,
    required this.name,
    required this.age,
    required this.price,
    required this.image,
    this.isAdopted = false,
  });

  // Copy with method to update adoption state
  Pet copyWith({bool? isAdopted}) {
    return Pet(
      id: id,
      name: name,
      age: age,
      price: price,
      image: image,
      isAdopted: isAdopted ?? this.isAdopted,
    );
  }

  // Convert to Map (for Hive/local storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'price': price,
      'image': image,
      'isAdopted': isAdopted,
    };
  }

  // Create from Map (for Hive/local storage)
  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      id: map['id'] as String,
      name: map['name'] as String,
      age: map['age'] as int,
      price: (map['price'] as num).toDouble(),
      image: map['image'] as String,
      isAdopted: map['isAdopted'] as bool,
    );
  }

  @override
  List<Object?> get props => [id, name, age, price, image, isAdopted];
}
