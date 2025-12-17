import 'package:freezed_annotation/freezed_annotation.dart';

part 'project.freezed.dart';
part 'project.g.dart';

/// Project entity representing a code generation project.
@freezed
class Project with _$Project {
  const factory Project({
    required String id,
    required String userId,
    required String name,
    required String description,
    required List<String> platforms,
    required String githubRepo,
    required bool githubConnected,
    required ProjectStatus status,
    String? templateId,
    int? totalTasks,
    int? completedTasks,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);
}

/// Extension for computed properties
extension ProjectExtension on Project {
  /// Calculate progress percentage (0-100)
  double get progressPercentage {
    if (totalTasks == null || totalTasks == 0) return 0;
    return (completedTasks ?? 0) / totalTasks! * 100;
  }

  /// Check if project has any tasks
  bool get hasTasks => (totalTasks ?? 0) > 0;
}

/// Project status enum
enum ProjectStatus {
  @JsonValue('draft')
  draft,

  @JsonValue('in_progress')
  inProgress,

  @JsonValue('completed')
  completed,

  @JsonValue('failed')
  failed;

  /// Display name for UI
  String get displayName {
    switch (this) {
      case ProjectStatus.draft:
        return 'Draft';
      case ProjectStatus.inProgress:
        return 'In Progress';
      case ProjectStatus.completed:
        return 'Completed';
      case ProjectStatus.failed:
        return 'Failed';
    }
  }
}
