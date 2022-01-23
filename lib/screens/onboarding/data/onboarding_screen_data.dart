class OnboardingScreenData {
  String imagePath;
  String title;
  String description;

  OnboardingScreenData(
      {required this.imagePath,
      required this.title,
      required this.description});

  void setImageAssetPath(String imagePath) {
    this.imagePath = imagePath;
  }

  void setTitle(String title) {
    this.title = title;
  }

  void setDescription(String description) {
    this.description = description;
  }

  String getImageAssetPath() {
    return this.imagePath;
  }

  String getTitle() {
    return this.title;
  }

  String getDescription() {
    return this.description;
  }
}

List<OnboardingScreenData> getSliders() {
  List<OnboardingScreenData> sliders = List.empty(growable: true);

  sliders.add(new OnboardingScreenData(
      imagePath: "assets/onboarding/ob1.png",
      title: "Смотри, что там у других",
      description:
          "Ты сможешь увидеть как живут люди со всей планеты Земля и не только ;)"));
  sliders.add(new OnboardingScreenData(
      imagePath: "assets/onboarding/ob1.png",
      title: "Заливай свой эксклюзиный контент, чтобы смотрели, что там у тебя",
      description:
          "Все смогут увидеть твой контент. Даже инопланетяне смогут увидеть как ты живешь xD"));
  sliders.add(new OnboardingScreenData(
      imagePath: "assets/onboarding/ob1.png",
      title: "Подписывайся на тех, кто интересен",
      description:
          "Ты будешь первым, кто узнает, что там новенького у твоих друзей"));

  return sliders;
}
