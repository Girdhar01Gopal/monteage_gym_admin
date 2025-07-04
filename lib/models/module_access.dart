class ModuleAccess {
  final String moduleName;
  bool accessGranted;

  ModuleAccess({required this.moduleName, required this.accessGranted});

  Map<String, dynamic> toJson() => {
    'module_name': moduleName,
    'access_granted': accessGranted,
  };

  factory ModuleAccess.fromJson(Map<String, dynamic> json) {
    return ModuleAccess(
      moduleName: json['module_name'],
      accessGranted: json['access_granted'],
    );
  }
}
