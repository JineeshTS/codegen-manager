import '../../../../core/types/result.dart';
import '../entities/project.dart';

/// Abstract project repository interface.
/// Defines the contract for project operations.
abstract class ProjectRepository {
  /// Get all projects for the current user
  Future<Result<List<Project>>> getProjects({
    int page = 1,
    int perPage = 20,
    String? search,
    ProjectStatus? status,
  });

  /// Get a single project by ID
  Future<Result<Project>> getProjectById(String id);

  /// Create a new project
  Future<Result<Project>> createProject({
    required String name,
    required String description,
    required List<String> platforms,
    required String githubRepo,
  });

  /// Update an existing project
  Future<Result<Project>> updateProject({
    required String id,
    String? name,
    String? description,
    List<String>? platforms,
    String? githubRepo,
    ProjectStatus? status,
  });

  /// Delete a project
  Future<Result<void>> deleteProject(String id);

  /// Connect GitHub repository
  Future<Result<void>> connectGitHub({
    required String projectId,
    required String accessToken,
  });

  /// Get GitHub connection status
  Future<Result<Map<String, dynamic>>> getGitHubStatus(String projectId);
}
