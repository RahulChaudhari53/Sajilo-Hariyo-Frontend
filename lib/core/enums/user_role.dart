enum UserRole {
  customer,
  admin;

  /// Convert string from backend to UserRole enum
  static UserRole fromString(String? role) {
    switch (role?.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'customer':
      default:
        return UserRole.customer;
    }
  }

  /// Convert UserRole enum to string for backend
  String toBackendString() {
    switch (this) {
      case UserRole.admin:
        return 'admin';
      case UserRole.customer:
        return 'customer';
    }
  }
}

