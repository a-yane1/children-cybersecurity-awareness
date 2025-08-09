import 'api_services.dart';

class CategoryService {
  static Future<void> resetCategoryProgress(int userId, int categoryId) async {
    await ApiService.post('/reset-progress', {
      'userId': userId,
      'categoryId': categoryId,
    });
  }
}
