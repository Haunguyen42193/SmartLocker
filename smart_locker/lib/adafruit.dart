import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:typed_data/typed_data.dart' show Uint8Buffer;
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter/widgets.dart';

class AdafruitIoClient {
  final MqttServerClient client;

  AdafruitIoClient(String username, String apiKey)
      : client = MqttServerClient('io.adafruit.com', username) {
    client.port = 1883;
    client.logging(on: true);
  }

  Future<void> connect(String username) async {
    // WidgetsFlutterBinding.ensureInitialized();
    // await FlutterConfig.loadEnvVariables();
    // final apiKey = FlutterConfig.get('YOUR_API_KEY');
    final MqttClientConnectionStatus? connectionStatus =
        await client.connect(username, 'aio_Skzh53SB6VTRhD6Yk32adYL8eG2a');

    if (connectionStatus != null) {
      print('Connected: ${connectionStatus.state}');
    } else {
      print('Failed to connect');
    }
  }

  void subscribe(String feedName) {
    client.subscribe('nghiavahau/feeds/$feedName', MqttQos.exactlyOnce);
  }

  void publish(String feedName, String message) {
    // Chuyển đổi chuỗi thành Uint8List (Uint8Buffer)
    final messageBytes = Uint8List.fromList(utf8.encode(message));

    // Tạo Uint8Buffer từ Uint8List
    final messageBuffer = Uint8Buffer()..addAll(messageBytes);

    client.publishMessage(
        'nghiavahau/feeds/$feedName', MqttQos.exactlyOnce, messageBuffer);
  }

  Stream<List<MqttReceivedMessage<MqttMessage>>> getUpdates() {
    return client.updates!;
  }

  void disconnect() {
    client.disconnect();
  }
}

// void main() async {
//   final adafruitClient =
//       AdafruitIoClient('', ''); // Không cần truyền apiKey ở đây

//   bool isButtonPressed = false; // Biến để theo dõi trạng thái nút "SendOTP"

//   try {
//     await adafruitClient.connect('nghiavahau');

//     if (adafruitClient.client.connectionStatus?.state ==
//         MqttConnectionState.connected) {
//       print('Connected to Adafruit IO');

//       adafruitClient.subscribe('SendOTP'); // Đăng ký theo dõi feed "SendOTP"
//       adafruitClient.subscribe('Nhatky'); // Đăng ký theo dõi feed "Nhatky"

//       // Lắng nghe các cập nhật từ cả hai feed
//       adafruitClient.getUpdates().listen((List<MqttReceivedMessage<MqttMessage>> event) {
//         final message = event[0].payload.toString();
//         final topic = event[0].topic;

//         print('Received message on topic $topic: $message');

//         // Kiểm tra nếu message là '1' (nút SendOTP được bấm), thì gửi dữ liệu mới lên feed "Nhatky"
//         if (topic == 'nghiavahau/feeds/SendOTP' && message == '1') {
//           // Thay đổi dữ liệu cần gửi lên feed "Nhatky" ở đây
//           final newDataForNhatky = 'New data for Nhatky feed';
//           adafruitClient.publish('Nhatky', newDataForNhatky);
//           print('Updated Nhatky feed with new data: $newDataForNhatky');
//         }
//       });

//       // Đợi một khoảng thời gian sau đó ngắt kết nối
//       await Future.delayed(Duration(seconds: 5));
//       adafruitClient.disconnect();
//       print('Disconnected from Adafruit IO');
//     } else {
//       print('Failed to connect to Adafruit IO');
//     }
//   } catch (e) {
//     print('Exception: $e');
//   }
// }
