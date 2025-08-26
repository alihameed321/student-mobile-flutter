class DocumentSharingInfo {
  final int documentId;
  final String title;
  final String documentType;
  final bool isOfficial;
  final DateTime issuedDate;
  final SharingCapabilities sharingCapabilities;

  const DocumentSharingInfo({
    required this.documentId,
    required this.title,
    required this.documentType,
    required this.isOfficial,
    required this.issuedDate,
    required this.sharingCapabilities,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DocumentSharingInfo &&
        other.documentId == documentId &&
        other.title == title &&
        other.documentType == documentType;
  }

  @override
  int get hashCode => Object.hash(documentId, title, documentType);

  @override
  String toString() {
    return 'DocumentSharingInfo(documentId: $documentId, title: $title, documentType: $documentType)';
  }
}

class SharingCapabilities {
  final bool canShare;
  final bool canGenerateLink;
  final bool supportsAccessControl;
  final String reason;

  const SharingCapabilities({
    required this.canShare,
    required this.canGenerateLink,
    required this.supportsAccessControl,
    required this.reason,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SharingCapabilities &&
        other.canShare == canShare &&
        other.canGenerateLink == canGenerateLink &&
        other.supportsAccessControl == supportsAccessControl;
  }

  @override
  int get hashCode => Object.hash(canShare, canGenerateLink, supportsAccessControl);

  @override
  String toString() {
    return 'SharingCapabilities(canShare: $canShare, canGenerateLink: $canGenerateLink, supportsAccessControl: $supportsAccessControl)';
  }
}

class DocumentSharingLink {
  final int documentId;
  final String sharingToken;
  final String sharingUrl;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final AccessSettings accessSettings;

  const DocumentSharingLink({
    required this.documentId,
    required this.sharingToken,
    required this.sharingUrl,
    required this.createdAt,
    this.expiresAt,
    required this.accessSettings,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DocumentSharingLink &&
        other.documentId == documentId &&
        other.sharingToken == sharingToken;
  }

  @override
  int get hashCode => Object.hash(documentId, sharingToken);

  @override
  String toString() {
    return 'DocumentSharingLink(documentId: $documentId, sharingToken: $sharingToken)';
  }
}

class AccessSettings {
  final bool downloadEnabled;
  final bool viewEnabled;
  final int? maxDownloads;
  final bool requiresAuth;

  const AccessSettings({
    required this.downloadEnabled,
    required this.viewEnabled,
    this.maxDownloads,
    required this.requiresAuth,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AccessSettings &&
        other.downloadEnabled == downloadEnabled &&
        other.viewEnabled == viewEnabled &&
        other.maxDownloads == maxDownloads &&
        other.requiresAuth == requiresAuth;
  }

  @override
  int get hashCode => Object.hash(downloadEnabled, viewEnabled, maxDownloads, requiresAuth);

  @override
  String toString() {
    return 'AccessSettings(downloadEnabled: $downloadEnabled, viewEnabled: $viewEnabled, maxDownloads: $maxDownloads, requiresAuth: $requiresAuth)';
  }
}