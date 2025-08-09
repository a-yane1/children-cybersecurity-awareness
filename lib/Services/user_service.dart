import '../models/answer_result.dart';
import '../models/progress_dashboard.dart';
import '../models/questions.dart';
import '../models/user.dart';
import '../models/category.dart';
import 'api_services.dart';

class UserService {
  static Future<User> createOrGetUser(String name) async {
    final response = await ApiService.post('/users', {'name': name});
    return User.fromJson(response['user']);
  }

  static Future<User> getUser(int userId) async {
    final response = await ApiService.get('/users/$userId');
    return User.fromJson(response['user']);
  }

  static Future<List<Category>> getCategories(int userId) async {
    final response = await ApiService.get('/categories/$userId');
    return (response['categories'] as List)
        .map((json) => Category.fromJson(json))
        .toList();
  }

  static Future<Question?> getQuestion(int userId, int categoryId) async {
    final response = await ApiService.get('/questions/$userId/$categoryId');

    if (response['question'] == null) {
      return null;
    }

    return Question.fromJson(response['question']);
  }

  static Future<AnswerResult> submitAnswer({
    required int userId,
    required int questionId,
    required int selectedAnswerId,
    required int timeTaken,
    bool hintUsed = false,
  }) async {
    final response = await ApiService.post('/answers', {
      'userId': userId,
      'questionId': questionId,
      'selectedAnswerId': selectedAnswerId,
      'timeTaken': timeTaken,
      'hintUsed': hintUsed,
    });

    return AnswerResult.fromJson(response);
  }

  static Future<ProgressDashboard> getProgress(int userId) async {
    final response = await ApiService.get('/progress/$userId');
    return ProgressDashboard.fromJson(response);
  }
}
