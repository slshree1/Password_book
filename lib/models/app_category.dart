enum AppCategory {
  onlinePlatforms('Online Platforms', 'online_platforms'),
  applications('Applications', 'applications'),
  banking('Banking', 'banking'),
  socialEmail('Social / Email', 'social_email');

  final String displayName;
  final String id;

  const AppCategory(this.displayName, this.id);

  static AppCategory fromId(String id) {
    return AppCategory.values.firstWhere(
      (e) => e.id == id,
      orElse: () => AppCategory.onlinePlatforms,
    );
  }
}
