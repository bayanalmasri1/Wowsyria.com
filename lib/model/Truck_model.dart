class TruckModel {
  final int id;
  final int user;
  final String title;
  final String brand;
  final String model;
  final int year;
  final String location;
  final String price;
  final String image;
  final String saleType;
  final int views;
  final DateTime createdAt;

  TruckModel({
    required this.id,
    required this.user,
    required this.title,
    required this.brand,
    required this.model,
    required this.year,
    required this.location,
    required this.price,
    required this.image,
    required this.saleType,
    required this.views,
    required this.createdAt,
  });

  factory TruckModel.fromJson(Map<String, dynamic> json) {
    return TruckModel(
      id: json['id'],
      user: json['user'],
      title: json['title'],
      brand: json['brand'],
      model: json['model'],
      year: json['year'],
      location: json['location'],
      price: json['price'],
      image: json['image'],
      saleType: json['sale_type'],
      views: json['views'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
