class DocumentType {
  final String value;
  final String display;
  final String? description;
  final bool isActive;

  const DocumentType({
    required this.value,
    required this.display,
    this.description,
    required this.isActive,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DocumentType &&
        other.value == value &&
        other.display == display;
  }

  @override
  int get hashCode => Object.hash(value, display);

  @override
  String toString() {
    return 'DocumentType(value: $value, display: $display, isActive: $isActive)';
  }
}