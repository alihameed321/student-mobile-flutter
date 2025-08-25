import 'package:equatable/equatable.dart';

class StudentDocument extends Equatable {
  final int id;
  final String documentType;
  final String fileName;
  final int fileSize;
  final DateTime uploadedAt;
  final String? description;
  final bool isVerified;
  final DateTime? verifiedAt;
  final String? downloadUrl;

  const StudentDocument({
    required this.id,
    required this.documentType,
    required this.fileName,
    required this.fileSize,
    required this.uploadedAt,
    this.description,
    this.isVerified = false,
    this.verifiedAt,
    this.downloadUrl,
  });

  @override
  List<Object?> get props => [
        id,
        documentType,
        fileName,
        fileSize,
        uploadedAt,
        description,
        isVerified,
        verifiedAt,
        downloadUrl,
      ];

  // Helper methods
  String get formattedFileSize {
    if (fileSize < 1024) {
      return '$fileSize B';
    } else if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  String get fileExtension {
    final parts = fileName.split('.');
    return parts.length > 1 ? parts.last.toLowerCase() : '';
  }

  bool get isPdf => fileExtension == 'pdf';
  bool get isImage => ['jpg', 'jpeg', 'png', 'gif', 'bmp'].contains(fileExtension);
  bool get isDocument => ['doc', 'docx', 'txt', 'rtf'].contains(fileExtension);

  String get documentTypeDisplayName {
    switch (documentType.toLowerCase()) {
      case 'transcript':
        return 'Academic Transcript';
      case 'id_card':
        return 'Student ID Card';
      case 'enrollment_certificate':
        return 'Enrollment Certificate';
      case 'grade_report':
        return 'Grade Report';
      case 'diploma':
        return 'Diploma';
      case 'recommendation_letter':
        return 'Recommendation Letter';
      default:
        return documentType.replaceAll('_', ' ').split(' ').map((word) => 
            word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : ''
        ).join(' ');
    }
  }

  String get verificationStatus {
    if (isVerified) {
      return 'Verified';
    } else {
      return 'Pending Verification';
    }
  }

  String get verificationStatusColor {
    return isVerified ? 'green' : 'orange';
  }
}