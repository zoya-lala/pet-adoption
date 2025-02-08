import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'pet_model.g.dart';

@HiveType(typeId: 0)
class Pet extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int age;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final String image;

  @HiveField(5)
  final bool isAdopted;

  const Pet({
    required this.id,
    required this.name,
    required this.age,
    required this.price,
    required this.image,
    this.isAdopted = false,
  });

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
