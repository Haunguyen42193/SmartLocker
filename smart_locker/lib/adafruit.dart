import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_config/flutter_config.dart';

Future<void> connectToAdafruitIO() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  final apiKey = FlutterConfig.get('YOUR_API_KEY');
  final client = MqttServerClient('mqtt.adafruit.com', '');
  client.logging(on: false);

  final MqttConnectMessage connectMessage = MqttConnectMessage()
      .withClientIdentifier('your_client_id')
      .keepAliveFor(60)
      .startClean()
      .withWillTopic('your_username/feeds/your_feed')
      .withWillMessage('offline')
      .withWillQos(MqttQos.atMostOnce);

  client.connectionMessage = connectMessage;

  try {
    await client.connect('nghiavahau', apiKey);
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      print('Connected to Adafruit IO');
      // Bắt đầu gửi và nhận dữ liệu từ Adafruit IO ở đây
    } else {
      print('Failed to connect to Adafruit IO');
    }
  } catch (e) {
    print('Exception: $e');
  }
}
