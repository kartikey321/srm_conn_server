import 'package:dart_frog/dart_frog.dart';
import 'package:srm_conn_server/middlewares/cors_middleware.dart';

Handler middleware(Handler handler) {
  return handler.use(requestLogger()).use(corsHeaders());
}
