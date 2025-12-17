import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/types/result.dart';
import '../../domain/entities/project.dart';
import 'projects_provider.dart';

part 'project_detail_provider.g.dart';

// ═══════════════════════════════════════════════════════════════
// SINGLE PROJECT DETAIL STATE
// ═══════════════════════════════════════════════════════════════

@riverpod
class ProjectDetailNotifier extends _$ProjectDetailNotifier {
  @override
  Future<Project?> build(String projectId) async {
    return _fetchProject(projectId);
  }

  Future<Project?> _fetchProject(String projectId) async {
    final repository = ref.read(projectRepositoryProvider);

    final result = await repository.getProjectById(projectId);

    return result.when(
      success: (project) => project,
      failure: (_) => null,
    );
  }

  /// Refresh project data
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _fetchProject(projectId));
  }

  /// Update project
  Future<Result<Project>> updateProject({
    String? name,
    String? description,
    List<String>? platforms,
    String? githubRepo,
    ProjectStatus? status,
  }) async {
    final repository = ref.read(projectRepositoryProvider);

    final result = await repository.updateProject(
      id: projectId,
      name: name,
      description: description,
      platforms: platforms,
      githubRepo: githubRepo,
      status: status,
    );

    result.when(
      success: (project) {
        // Update state with the new project
        state = AsyncData(project);

        // Also refresh the projects list
        ref.invalidate(projectsNotifierProvider);
      },
      failure: (_) {
        // Keep current state on failure
      },
    );

    return result;
  }

  /// Connect GitHub repository
  Future<Result<void>> connectGitHub(String accessToken) async {
    final repository = ref.read(projectRepositoryProvider);

    final result = await repository.connectGitHub(
      projectId: projectId,
      accessToken: accessToken,
    );

    result.when(
      success: (_) {
        // Refresh project data after connecting
        refresh();
      },
      failure: (_) {
        // Keep current state on failure
      },
    );

    return result;
  }

  /// Get GitHub connection status
  Future<Result<Map<String, dynamic>>> getGitHubStatus() async {
    final repository = ref.read(projectRepositoryProvider);
    return await repository.getGitHubStatus(projectId);
  }
}
