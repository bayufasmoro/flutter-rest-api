import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..get('/echo/<message>', _echoHandler)
  ..get('/api/contacts', _getContact);

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

Response _getContact(Request request) {
  final response = {
    "success": true,
    "status": {
      "code": "200",
      "message": "Successful retrieval for contacts"
    },
    "data": [
      {
        "id": "user00001",
        "name": "A Sebastian A/L Anthony",
        "email": "sebastian@hyped.com.my"
      },
      {
        "id": "user00002",
        "name": "Balu Govindasamy",
        "email": "balugov@gmail.com"
      },
      {
        "id": "user00003",
        "name": "Chong How Kee",
        "email": "chonghowkee@yahoo.com"
      },
      {
        "id": "user00004",
        "name": "Robert A/L Francis",
        "email": "robert@hotmail.com"
      },
      {
        "id": "user00005",
        "name": "Teoh Min Kee",
        "email": "teohminkee@inglab.com.my"
      }
    ]
  };

  return Response.ok(json.encode(response), headers: {'Content-type': 'application/json'});
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
