import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/types/result.dart';
import '../../domain/entities/project.dart';
import '../../domain/repositories/project_repository.dart';

/// Implementation of ProjectRepository using API client.
class ProjectRepositoryImpl implements ProjectRepository {
  final ApiClient _apiClient;

  ProjectRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<Result<List<Project>>> getProjects({
    int page = 1,
    int perPage = 20,
    String? search,
    ProjectStatus? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'per_page': perPage,
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      if (status != null) {
        queryParams['status'] = status.name;
      }

      final response = await _apiClient.get(
        '/projects',
        queryParameters: queryParams,
      );

      final data = response.data['data'] as List;
      final projects = data.map((json) => Project.fromJson(json)).toList();

      return Result.success(projects);
    } on DioException catch (e) {
      return Result.failure(ApiClient.handleError(e));
    } catch (e) {
      return Result.failure(
        Failure.server(message: 'Failed to get projects: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<Project>> getProjectById(String id) async {
    try {
      final response = await _apiClient.get('/projects/$id');

      final data = response.data['data'];
      final project = Project.fromJson(data);

      return Result.success(project);
    } on DioException catch (e) {
      return Result.failure(ApiClient.handleError(e));
    } catch (e) {
      return Result.failure(
        Failure.server(message: 'Failed to get project: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<Project>> createProject({
    required String name,
    required String description,
    required List<String> platforms,
    required String githubRepo,
  }) async {
    try {
      final response = await _apiClient.post(
        '/projects',
        data: {
          'name': name,
          'description': description,
          'platforms': platforms,
          'github_repo': githubRepo,
        },
      );

      final data = response.data['data'];
      final project = Project.fromJson(data);

      return Result.success(project);
    } on DioException catch (e) {
      return Result.failure(ApiClient.handleError(e));
    } catch (e) {
      return Result.failure(
        Failure.server(message: 'Failed to create project: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<Project>> updateProject({
    required String id,
    String? name,
    String? description,
    List<String>? platforms,
    String? githubRepo,
    ProjectStatus? status,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (name != null) data['name'] = name;
      if (description != null) data['description'] = description;
      if (platforms != null) data['platforms'] = platforms;
      if (githubRepo != null) data['github_repo'] = githubRepo;
      if (status != null) data['status'] = status.name;

      final response = await _apiClient.put('/projects/$id', data: data);

      final responseData = response.data['data'];
      final project = Project.fromJson(responseData);

      return Result.success(project);
    } on DioException catch (e) {
      return Result.failure(ApiClient.handleError(e));
    } catch (e) {
      return Result.failure(
        Failure.server(message: 'Failed to update project: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void>> deleteProject(String id) async {
    try {
      await _apiClient.delete('/projects/$id');
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(ApiClient.handleError(e));
    } catch (e) {
      return Result.failure(
        Failure.server(message: 'Failed to delete project: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void>> connectGitHub({
    required String projectId,
    required String accessToken,
  }) async {
    try {
      await _apiClient.post(
        '/projects/$projectId/github/connect',
        data: {'access_token': accessToken},
      );

      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(ApiClient.handleError(e));
    } catch (e) {
      return Result.failure(
        Failure.server(
            message: 'Failed to connect GitHub: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> getGitHubStatus(
      String projectId) async {
    try {
      final response =
          await _apiClient.get('/projects/$projectId/github/status');

      final data = response.data['data'] as Map<String, dynamic>;
      return Result.success(data);
    } on DioException catch (e) {
      return Result.failure(ApiClient.handleError(e));
    } catch (e) {
      return Result.failure(
        Failure.server(
            message: 'Failed to get GitHub status: ${e.toString()}'),
      );
    }
  }
}
