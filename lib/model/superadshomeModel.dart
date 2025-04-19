class SuperAdCarModel {
  final int id;
  final int user;
  final String title;
  final String description; // تم إضافة الوصف
  final String brand;
  final String model;
  final int year;
  final String location;
  final String price;
  final String image;
  final String saleType;
  final int views;
  final DateTime createdAt;
  final String phoneNumber; // تم إضافة رقم الهاتف

  SuperAdCarModel({
    required this.id,
    required this.user,
    required this.title,
    required this.description, // إضافة الوصف في المُنشئ
    required this.brand,
    required this.model,
    required this.year,
    required this.location,
    required this.price,
    required this.image,
    required this.saleType,
    required this.views,
    required this.createdAt,
    required this.phoneNumber, // إضافة رقم الهاتف في المُنشئ
  });

  factory SuperAdCarModel.fromJson(Map<String, dynamic> json) {
    return SuperAdCarModel(
      id: json['id']??'',
      user: json['user']??'',
      title: json['title']??'',
      description: json['description']??'', // إضافة الوصف من JSON
      brand: json['brand']??'',
      model: json['model']??'',
      year: json['year']??'',
      location: json['location']??'',
      price: json['price']??'',
      image: json['image']??'',
      saleType: json['sale_type']??'',
      views: json['views']??'',
      createdAt: DateTime.parse(json['created_at']??''),
      phoneNumber: json['phone_number']??'', // إضافة رقم الهاتف من JSON
    );
  }
}

class SuperAdsPropertyModel {
  final int id;
  final int user;
  final String title;
  final int bedrooms;  // عدد الغرف
  final int bathrooms;  // عدد الحمامات
  final String area;  // المساحة
  final String location;
  final  String price;  // السعر
  final String image;
  final String saleType;  // نوع البيع (للبيع أو للإيجار)
  final int views;
  final DateTime createdAt;

  SuperAdsPropertyModel({
    required this.id,
    required this.user,
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

  factory SuperAdsPropertyModel.fromJson(Map<String, dynamic> json) {
    return SuperAdsPropertyModel(
      id: json['id']??'',
      user: json['user']??'',
      title: json['title']??'',
      bedrooms: json['bedrooms']??'',
      bathrooms: json['bathrooms']??'',
      area: json['area']??'',
      location: json['location']??'',
      price: json['price']??'',
      image: json['image']??'',
      saleType: json['sale_type']??'',
      views: json['views']??'',
      createdAt: DateTime.parse(json['created_at']??''),
    );
  }
}


class SuperAdsTruckModel {
  final int id;
  final int user;
  final String title;
  final String description;
  final String brand;
  final String model;
  final int year;
  final String location;
  final String price;
  final String image;
  final String saleType; // نوع البيع (للبيع أو للإيجار)
  final int views;
  final DateTime createdAt;
  final String phoneNumber;

  SuperAdsTruckModel({
    required this.id,
    required this.user,
    required this.title,
    required this.description,
    required this.brand,
    required this.model,
    required this.year,
    required this.location,
    required this.price,
    required this.image,
    required this.saleType,
    required this.views,
    required this.createdAt,
    required this.phoneNumber,
  });

  factory SuperAdsTruckModel.fromJson(Map<String, dynamic> json) {
    return SuperAdsTruckModel(
      id: json['id']??'',
      user: json['user']??'',
      title: json['title']??'',
      description: json['description']??'',
      brand: json['brand']??'',
      model: json['model']??'',
      year: json['year']??'',
      location: json['location']??'',
      price: json['price']??'',
      image: json['image']??'',
      saleType: json['sale_type']??'',
      views: json['views']??'',
      createdAt: DateTime.parse(json['created_at']??''),
      phoneNumber: json['phone_number']??'',
    );
  }
}
