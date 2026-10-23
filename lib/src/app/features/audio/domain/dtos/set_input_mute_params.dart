class SetInputMuteParams {
  String inputName;
  bool muted;

  SetInputMuteParams({required this.inputName, required this.muted});

  factory SetInputMuteParams.empty() => SetInputMuteParams(inputName: '', muted: false);

  void setInputName(String value) => inputName = value;
  void setMuted(bool value) => muted = value;

  Map<String, dynamic> toJson() => {'inputName': inputName, 'inputMuted': muted};

  @override
  bool operator ==(Object other) => other is SetInputMuteParams && other.inputName == inputName && other.muted == muted;

  @override
  int get hashCode => Object.hash(inputName, muted);

  @override
  String toString() => 'SetInputMuteParams(inputName: $inputName, muted: $muted)';
}
