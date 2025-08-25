import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class StudentDocument extends Equatable {
  final int id;
  final String student;
  final String documentType;
  final String title;
  final String fileName;
  final DateTime issuedDate;
  final String? issuedBy;
  final bool isOfficial;
  final int downloadCount;
  final String? downloadUrl;
  final String? description;

  const StudentDocument({
    required this.id,
    required this.student,
    required this.documentType,
    required this.title,
    required this.fileName,
    required this.issuedDate,
    this.issuedBy,
    this.isOfficial = true,
    this.downloadCount = 0,
    this.downloadUrl,
    this.description,
  });

  @override
  List<Object?> get props => [
        id,
        student,
        documentType,
        title,
        fileName,
        issuedDate,
        issuedBy,
        isOfficial,
        downloadCount,
        downloadUrl,
        description,
      ];

  // Helper methods
  bool get hasBeenDownloaded => downloadCount > 0;

  String get fileExtension {
    final parts = fileName.split('.');
    return parts.length > 1 ? parts.last.toLowerCase() : '';
  }

  bool get isPdf => fileExtension == 'pdf';
  bool get isImage => ['jpg', 'jpeg', 'png', 'gif', 'bmp'].contains(fileExtension);
  bool get isDocument => ['doc', 'docx', 'txt', 'rtf'].contains(fileExtension);

  String get documentTypeDisplayName {
    switch (documentType.toLowerCase()) {
      case 'enrollment_certificate':
        return 'Enrollment Certificate';
      case 'transcript':
        return 'Official Transcript';
      case 'graduation_certificate':
        return 'Graduation Certificate';
      case 'payment_receipt':
        return 'Payment Receipt';
      case 'other':
        return 'Other Document';
      default:
        return documentType.replaceAll('_', ' ').split(' ').map((word) => 
            word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : ''
        ).join(' ');
    }
  }

  String get officialStatus {
    return isOfficial ? 'Official' : 'Unofficial';
  }

  Color get officialStatusColor {
    return isOfficial ? Colors.green : Colors.orange;
  }

  IconData get documentTypeIcon {
    switch (documentType.toLowerCase()) {
      case 'enrollment_certificate':
        return Icons.school;
      case 'transcript':
        return Icons.description;
      case 'graduation_certificate':
        return Icons.workspace_premium;
      case 'payment_receipt':
        return Icons.receipt;
      case 'other':
        return Icons.insert_drive_file;
      default:
        return Icons.description;
    }
  }

  String get downloadCountText {
    if (downloadCount == 0) {
      return 'Not downloaded';
    } else if (downloadCount == 1) {
      return 'Downloaded once';
    } else {
      return 'Downloaded $downloadCount times';
    }
  }
}