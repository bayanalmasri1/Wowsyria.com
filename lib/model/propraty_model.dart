class Property {
  final int id;
  final String title;
  final int bedrooms;
  final int bathrooms;
  final String area;
  final String location;
  final String price;
  final String image;
  final String saleType;
  final int views;
  final String createdAt;

  Property({
    required this.id,
    required this.title,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.location,
    required this.price,
    required this.image,
    required this.saleType,
    required this.views,
    required this.createdAt,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      title: json['title'],
      bedrooms: json['bedrooms'],
      bathrooms: json['bathrooms'],
      area: json['area'],
      location: json['location'],
      price: json['price'],
      image: json['image'],
      saleType: json['sale_type'],
      views: json['views'],
      createdAt: json['created_at'],
    );
  }
}


