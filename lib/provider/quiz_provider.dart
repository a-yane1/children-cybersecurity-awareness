import 'package:children_cs_awareness_quiz/services/user_service.dart';
import 'package:flutter/foundation.dart' hide Category;
import '../models/questions.dart';
import '../models/user.dart';
import '../models/category.dart';

class QuizProvider with ChangeNotifier {
  User? _currentUser;
  List<Category> _categories = [];
  Question? _currentQuestion;
  int? _selectedCategoryId;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get currentUser => _currentUser;
  List<Category> get categories => _categories;
  Question? get currentQuestion => _currentQuestion;
  int? get selectedCategoryId => _selectedCategoryId;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Create or login user
  Future<void> createUser(String name) async {
    _setLoading(true);
    try {
      _currentUser = await UserService.createOrGetUser(name);
      await loadCategories();
      _clearError();
    } catch (e) {
      _setError('Failed to create user: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load categories with progress
  Future<void> loadCategories() async {
    if (_currentUser == null) return;

    _setLoading(true);
    try {
      _categories = (await UserService.getCategories(
        _currentUser!.id,
      )).cast<Category>();
      _clearError();
    } catch (e) {
      _setError('Failed to load categories: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Start quiz for category
  Future<void> startQuiz(int categoryId) async {
    if (_currentUser == null) return;

    _selectedCategoryId = categoryId;
    _setLoading(true);

    try {
      _currentQuestion = await UserService.getQuestion(
        _currentUser!.id,
        categoryId,
      );
      _clearError();

      if (_currentQuestion == null) {
        _setError('No more questions available for this category');
      }
    } catch (e) {
      _setError('Failed to load question: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Submit answer
  Future<AnswerResult?> submitAnswer(
    int selectedAnswerId,
    int timeTaken, {
    bool hintUsed = false,
  }) async {
    if (_currentUser == null || _currentQuestion == null) return null;

    _setLoading(true);
    try {
      final result = await UserService.submitAnswer(
        userId: _currentUser!.id,
        questionId: _currentQuestion!.id,
        selectedAnswerId: selectedAnswerId,
        timeTaken: timeTaken,
        hintUsed: hintUsed,
      );

      // Update user points and streak
      _currentUser = User(
        id: _currentUser!.id,
        name: _currentUser!.name,
        totalPoints: _currentUser!.totalPoints + result.pointsEarned,
        currentStreak: result.isCorrect ? _currentUser!.currentStreak + 1 : 0,
        bestStreak: _currentUser!.bestStreak,
        createdAt: _currentUser!.createdAt,
        lastActive: _currentUser!.lastActive,
      );

      _clearError();
      return result;
    } catch (e) {
      _setError('Failed to submit answer: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Get next question
  Future<void> getNextQuestion() async {
    if (_currentUser == null || _selectedCategoryId == null) return;

    _setLoading(true);
    try {
      _currentQuestion = await UserService.getQuestion(
        _currentUser!.id,
        _selectedCategoryId!,
      );
      _clearError();
    } catch (e) {
      _setError('Failed to load next question: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load progress dashboard
  Future<ProgressDashboard?> loadProgress() async {
    if (_currentUser == null) return null;

    _setLoading(true);
    try {
      final progress = await UserService.getProgress(_currentUser!.id);
      _currentUser = progress.user; // Update user with latest data
      _categories = progress.categoryProgress
          .cast<Category>(); // Update categories
      _clearError();
      return progress;
    } catch (e) {
      _setError('Failed to load progress: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void clearCurrentQuestion() {
    _currentQuestion = null;
    _selectedCategoryId = null;
    notifyListeners();
  }
}
