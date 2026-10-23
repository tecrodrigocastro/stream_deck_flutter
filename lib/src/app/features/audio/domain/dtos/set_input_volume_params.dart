class SetInputVolumeParams {
  String inputName;
  double volumeDb;

  SetInputVolumeParams({required this.inputName, required this.volumeDb});

  factory SetInputVolumeParams.empty() => SetInputVolumeParams(inputName: '', volumeDb: 0);

  void setInputName(String value) => inputName = value;
  void setVolumeDb(double value) => volumeDb = value;

  Map<String, dynamic> toJson() => {'inputName': inputName, 'inputVolumeDb': volumeDb};

  @override
  bool operator ==(Object other) {
    return other is SetInputVolumeParams && other.inputName == inputName && other.volumeDb == volumeDb;
  }

  @override
  int get hashCode => Object.hash(inputName, volumeDb);

  @override
  String toString() => 'SetInputVolumeParams(inputName: $inputName, volumeDb: $volumeDb)';
}
