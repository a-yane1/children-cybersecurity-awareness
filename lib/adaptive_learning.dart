class ChildAdaptiveLearning {
  String adjustDifficulty(Map<String, dynamic> userPerformance) {
    // Performance metrics specific to children
    double accuracyRate =
        userPerformance['correct_answers'] / userPerformance['total_attempts'];
    double avgResponseTime = userPerformance['avg_response_time'];
    int helpRequests = userPerformance['help_button_clicks'];
    double sessionCompletionRate =
        userPerformance['completed_sessions'] /
        userPerformance['started_sessions'];

    // Child-specific adjustment rules
    if (accuracyRate > 0.8 && avgResponseTime < 30) {
      // Quick and accurate
      return increaseDifficulty();
    } else if (accuracyRate < 0.5 || helpRequests > 3) {
      // Struggling
      return decreaseDifficulty();
    } else if (sessionCompletionRate < 0.7) {
      // Attention issues
      return reduceSessionLength();
    } else {
      return maintainCurrentLevel();
    }
  }

  String increaseDifficulty() => 'increase_difficulty';
  String decreaseDifficulty() => 'decrease_difficulty';
  String reduceSessionLength() => 'reduce_session';
  String maintainCurrentLevel() => 'maintain_level';
}
