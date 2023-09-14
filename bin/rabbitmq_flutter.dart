import 'package:dart_amqp/dart_amqp.dart';
import 'package:rabbitmq_flutter/secure.dart';

void main() async {
  ConnectionSettings settings = ConnectionSettings(
    host: hostRabbitMq, /// your host
    virtualHost: virtualHostRabbitMq, /// your virtualhost
    port: portRabbitMq, /// your port
    authProvider: const AmqPlainAuthenticator(
      usernameRabbitMq, /// your username rabbitmq
      passwordRabbitMq, /// your password rabbitmq
    ),
  );
  Client client = Client(settings: settings);

  Channel channel = await client.channel();
  // Exchange exchange = await channel.exchange('rabbitmq_flutter', ExchangeType.DIRECT);
  Queue queue = await channel.queue(
    queueName, /// your queue name
    durable: true,
    exclusive: false,
    autoDelete: false,
  );
  Consumer consumer = await queue.consume();
  consumer.listen((AmqpMessage msg) {
    print("Msg Payload String : ${msg.payloadAsString}");
    print('Msg Payload : ${msg.payload}');
    // print('Msg Payload AsJson : ${msg.payloadAsJson}');
    print('Msg Exchange Name : ${msg.exchangeName}');
    print('Msg Routing Key: ${msg.routingKey}');
    print('Msg Properties: ${msg.properties}');
    print('Msg Delivery Tag: ${msg.deliveryTag}');
  });
}
