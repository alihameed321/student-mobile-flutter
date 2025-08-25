import '../../domain/entities/student_document.dart';

class StudentDocumentModel extends StudentDocument {
  const StudentDocumentModel({
    required super.id,
    required super.documentType,
    required super.fileName,
    required super.fileSize,
    required super.uploadedAt,
    super.description,
    super.isVerified,
    super.verifiedAt,
    super.downloadUrl,
  });

  factory StudentDocumentModel.fromJson(Map<String, dynamic> json) {
    return StudentDocumentModel(
      id: json['id'] as int,
      documentType: json['document_type'] as String,
      fileName: json['file_name'] as String,
      fileSize: json['file_size'] as int,
      uploadedAt: DateTime.parse(json['uploaded_at'] as String),
      description: json['description'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      verifiedAt: json['verified_at'] != null
          ? DateTime.parse(json['verified_at'] as String)
          : null,
      downloadUrl: json['download_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'document_type': documentType,
      'file_name': fileName,
      'file_size': fileSize,
      'uploaded_at': uploadedAt.toIso8601String(),
      'description': description,
      'is_verified': isVerified,
      'verified_at': verifiedAt?.toIso8601String(),
      'download_url': downloadUrl,
    };
  }

  StudentDocumentModel copyWith({
    int? id,
    String? documentType,
    String? fileName,
    int? fileSize,
    DateTime? uploadedAt,
    String? description,
    bool? isVerified,
    DateTime? verifiedAt,
    String? downloadUrl,
  }) {
    return StudentDocumentModel(
      id: id ?? this.id,
      documentType: documentType ?? this.documentType,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      description: description ?? this.description,
      isVerified: isVerified ?? this.isVerified,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      downloadUrl: downloadUrl ?? this.downloadUrl,
    );
  }
}
