import 'package:test/test.dart';

import 'helper.dart';

Future main() async {
  await run(await getDockerImage());
}

Future run(final DockerImage image) async {
  group('uppush', () {
    late DockerContainer container;
    late TestNextcloudClient client;
    setUp(() async {
      container = await getDockerContainer(image);
      client = await getTestClient(
        container,
        username: 'admin',
        password: 'admin',
      );
    });
    tearDown(() => container.destroy());

    test('Is installed', () async {
      final response = await client.unifiedPushProvider.check();
      expect(response.success, isTrue);
    });

    test('Set keepalive', () async {
      final response = await client.unifiedPushProvider.setKeepalive(keepalive: 10);
      expect(response.success, isTrue);
    });

    test('Create device', () async {
      final response = await client.unifiedPushProvider.createDevice(deviceName: 'Test');
      expect(response.success, isTrue);
      expect(response.deviceId, isNotEmpty);
    });

    test('Delete device', () async {
      final deviceId = (await client.unifiedPushProvider.createDevice(deviceName: 'Test')).deviceId;

      final response = await client.unifiedPushProvider.deleteDevice(deviceId: deviceId);
      expect(response.success, isTrue);
    });

    test('Create app', () async {
      final deviceId = (await client.unifiedPushProvider.createDevice(deviceName: 'Test')).deviceId;

      final response = await client.unifiedPushProvider.createApp(deviceId: deviceId, appName: 'Test');
      expect(response.success, isTrue);
      expect(response.token, isNotEmpty);
    });

    test('UnifiedPush discovery', () async {
      final response = await client.unifiedPushProvider.unifiedpushDiscovery(token: 'example');
      expect(response.unifiedpush.version, 1);
    });

    test('Matrix gateway discovery', () async {
      final response = await client.unifiedPushProvider.gatewayMatrixDiscovery();
      expect(response.unifiedpush.gateway, 'matrix');
    });

    // Deleting an app, sending a notification (also via matrix gateway) or listening for notifications is not possible because redis is not set up
  });
}