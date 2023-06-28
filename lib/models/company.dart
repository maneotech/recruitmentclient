import 'dart:convert';

class Company {
  String? id;
  String name;
  String description;
  String size;
  String sellingPoints;
  String annualSales;
  String comment;

  Company(this.name, this.description, this.size, this.sellingPoints,
      this.annualSales, this.comment,
      {this.id});

  factory Company.fromReqBody(String body) {
    Map<String, dynamic> json = jsonDecode(body);

    return Company(json['name'], json['description'], json['size'],
        json['sellingPoints'], json['annualSales'], json['comment'],
        id: json['id']);
  }

  Map toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'size': size,
        'sellingPoints': sellingPoints,
        'annualSales': annualSales,
        'comment': comment,
      };
}
