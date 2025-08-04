void checkForBadges({
  required String topic,
  required int currentStreak,
  required int correctAnswersInTopic,
  required int totalQuestionsInTopic,
  required Set<String> unlockedBadgeIds,
  required Function(String id, String name, String desc) onUnlock,
}) {
  // Topic-based badges
  if (topic == 'Phone Safety' &&
      correctAnswersInTopic == 1 &&
      !unlockedBadgeIds.contains('phone_guardian')) {
    onUnlock('phone_guardian', 'Phone Guardian', 'Great at phone safety!');
  }
  if (topic == 'Passwords' &&
      correctAnswersInTopic == 1 &&
      !unlockedBadgeIds.contains('password_hero')) {
    onUnlock('password_hero', 'Password Hero', 'Knows how to keep secrets!');
  }
  if (topic == 'Safe Clicking' &&
      correctAnswersInTopic == 1 &&
      !unlockedBadgeIds.contains('click_smart')) {
    onUnlock('click_smart', 'Click Smart', 'Avoids bad links!');
  }
  if (topic == 'Stranger Danger' &&
      correctAnswersInTopic == 1 &&
      !unlockedBadgeIds.contains('stranger_alert')) {
    onUnlock('stranger_alert', 'Stranger Alert', 'Stays safe online!');
  }

  // Streak badge
  if (currentStreak == 3 && !unlockedBadgeIds.contains('streak_master')) {
    onUnlock('streak_master', 'Streak Master', '3 in a row! 🔥');
  }

  // Completion badge
  if (correctAnswersInTopic == totalQuestionsInTopic &&
      !unlockedBadgeIds.contains('safety_star')) {
    onUnlock('safety_star', 'Safety Star', 'Finished a whole topic!');
  }
}
