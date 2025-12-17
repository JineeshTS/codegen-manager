import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/types/result.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/project.dart';
import '../../domain/repositories/project_repository.dart';
import '../../data/repositories/project_repository_impl.dart';

part 'projects_provider.g.dart';

// ═══════════════════════════════════════════════════════════════
// DEPENDENCIES
// ═══════════════════════════════════════════════════════════════

@riverpod
ProjectRepository projectRepository(ProjectRepositoryRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProjectRepositoryImpl(apiClient: apiClient);
}

// ═══════════════════════════════════════════════════════════════
// PROJECTS LIST STATE
// ═══════════════════════════════════════════════════════════════

@riverpod
class ProjectsNotifier extends _$ProjectsNotifier {
  @override
  Future<List<Project>> build() async {
    return _fetchProjects();
  }

  Future<List<Project>> _fetchProjects({
    int page = 1,
    int perPage = 20,
    String? search,
    ProjectStatus? status,
  }) async {
    final repository = ref.read(projectRepositoryProvider);

    final result = await repository.getProjects(
      page: page,
      perPage: perPage,
      search: search,
      status: status,
    );

    return result.when(
      success: (projects) => projects,
      failure: (_) => [],
    );
  }

  /// Refresh projects list
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _fetchProjects());
  }

  /// Search projects
  Future<void> search(String query) async {
    state = const AsyncLoading();
    state = AsyncData(await _fetchProjects(search: query));
  }

  /// Filter by status
  Future<void> filterByStatus(ProjectStatus? status) async {
    state = const AsyncLoading();
    state = AsyncData(await _fetchProjects(status: status));
  }

  /// Create a new project
  Future<Result<Project>> createProject({
    required String name,
    required String description,
    required List<String> platforms,
    required String githubRepo,
  }) async {
    final repository = ref.read(projectRepositoryProvider);

    final result = await repository.createProject(
      name: name,
      description: description,
      platforms: platforms,
      githubRepo: githubRepo,
    );

    result.when(
      success: (_) {
        // Refresh the list after creating
        refresh();
      },
      failure: (_) {
        // Keep current state on failure
      },
    );

    return result;
  }

  /// Delete a project
  Future<Result<void>> deleteProject(String id) async {
    final repository = ref.read(projectRepositoryProvider);

    final result = await repository.deleteProject(id);

    result.when(
      success: (_) {
        // Refresh the list after deleting
        refresh();
      },
      failure: (_) {
        // Keep current state on failure
      },
    );

    return result;
  }
}
