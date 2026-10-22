class Category {
  final String? id;
  final String userId;
  final String name;
  final String? icon;
  final String? color;
  final DateTime? createdAt;

  Category({
    this.id,
    required this.userId,
    required this.name,
    this.icon,
    this.color,
    this.createdAt,
  });

  // create category from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String?,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  // convert category to JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'name': name,
      'icon': icon,
      'color': color,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }

  // create a copy with updated fields
  Category copyWith({
    String? id,
    String? userId,
    String? name,
    String? icon,
    String? color,
    DateTime? createdAt,
  }) {
    return Category(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Category(id: $id, name: $name, icon: $icon, color: $color)';
  }
}