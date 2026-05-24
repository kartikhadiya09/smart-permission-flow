/// Supported permission categories for the smart permission flow.
enum SmartPermissionType {
  /// Camera access for taking photos or scanning content.
  camera,

  /// Foreground location access for location-aware features.
  location,

  /// Microphone access for recording audio.
  microphone,

  /// Notification access for sending alerts and updates.
  notification,

  /// Photo library or media image access.
  photos,

  /// Storage access for reading or saving files.
  storage,
}
