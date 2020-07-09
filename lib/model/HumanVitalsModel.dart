class HumanVitalsModel {
  String humanVitalId;
  String organizationId;
  String businessUnitId;
  String deviceId;
  int  heartRate;
  double temperature;
  String partitionKey;
  String rowKey;
  String timestamp;
  String eTag;

   HumanVitalsModel({this.humanVitalId, this.organizationId, this.businessUnitId, this.deviceId, this.heartRate,this.temperature,this.partitionKey,this.rowKey,this.timestamp,this.eTag});

   factory HumanVitalsModel.fromJson(Map<String, dynamic> json) {
    return HumanVitalsModel(
      humanVitalId: json['humanVitalId'],
      organizationId: json['organizationId'],
      businessUnitId: json['businessUnitId'],
      deviceId: json['deviceId'],
      heartRate: json['heartRate'],
      temperature: json['temperature'].toDouble(),
      partitionKey: json['partitionKey'],
      rowKey: json['rowKey'],
      timestamp:json['timestamp'],
      eTag:json['eTag']



    );
  }
}