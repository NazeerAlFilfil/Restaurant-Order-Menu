class Customer {
  String? name;
  String? phone;
  bool blacklisted;
  String? location;
  String? comments;

  Customer({
    this.name,
    this.phone,
    this.blacklisted = false,
    this.location,
    this.comments,
  }) : assert(name != null || phone != null);

  @override
  String toString() {
    return '$name, $phone';
    //return 'Name: $name, Phone: $phone, Blacklisted?: $blacklisted, Location: $location, Comments: $comments';
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is Customer && other.name == name && other.phone == phone;
  }

  @override
  int get hashCode => Object.hash(name, phone);
}
