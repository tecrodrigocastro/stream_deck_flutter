class SwitchSceneParams {
  String sceneName;

  SwitchSceneParams({required this.sceneName});

  factory SwitchSceneParams.empty() => SwitchSceneParams(sceneName: '');

  void setSceneName(String value) => sceneName = value;

  Map<String, dynamic> toJson() => {'sceneName': sceneName};

  @override
  bool operator ==(Object other) => other is SwitchSceneParams && other.sceneName == sceneName;

  @override
  int get hashCode => sceneName.hashCode;

  @override
  String toString() => 'SwitchSceneParams(sceneName: $sceneName)';
}
