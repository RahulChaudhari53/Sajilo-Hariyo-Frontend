import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final String? id;
  final String label; 
  final String street;
  final String city;
  final String detail;
  final String phone;

  const AddressEntity({
    this.id,
    required this.label,
    required this.street,
    required this.city,
    required this.detail,
    required this.phone,
  });

  @override
  List<Object?> get props => [id, label, street, city, detail, phone];
}
