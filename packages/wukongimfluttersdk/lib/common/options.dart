import '../proto/proto.dart';

class Options {
  String? uid, token;

  /// Stable application-owned identifier sent in the CONNECT packet.
  /// When absent, the SDK retains its legacy generated identifier.
  String? deviceId;
  String? addr; // connect address IP:PORT
  String databaseNamespace = '';
  String get databaseIdentity {
    final user = uid ?? '';
    final safe = RegExp(r'^[a-zA-Z0-9_-]*$');
    if (user.length > 128 ||
        databaseNamespace.length > 64 ||
        !safe.hasMatch(user) ||
        !safe.hasMatch(databaseNamespace)) {
      throw ArgumentError('Unsafe local database identity');
    }
    return databaseNamespace.isEmpty ? user : '${databaseNamespace}_$user';
  }

  int protoVersion = 0x04; // protocol version
  int deviceFlag = 0;
  bool debug = true;
  Function(Function(String addr) complete)?
      getAddr; // async get connect address
  Proto proto = Proto();
  Options();

  Options.newDefault(this.uid, this.token, {this.addr});
}
