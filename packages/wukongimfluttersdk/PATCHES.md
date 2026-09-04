# Local transport patch

Source: cached pub.dev `wukongimfluttersdk` 1.7.9, upstream project named in
the original pubspec/README. Original LICENSE (Apache-2.0), README and CHANGELOG
are retained. This is a local patch, not an official upstream release.

Included: original `lib/`, `assets/`, package metadata and license documents.
Examples and upstream tests are not vendored. Do not edit the machine pub cache.

Changes (2026-09-03):

- Added `lib/common/serialized_socket_writer.dart`: per-connection ordered
  add/flush queue, copied packet bytes, failure/close invalidation.
- Modified `lib/manager/connect_manager.dart`: uses the writer for all packets,
  replaces the socket wrapper on new connections, destroys old sockets and
  invalidates their queues, catches write failures and schedules a guarded
  reconnect. Wire protocol and message/database formats are unchanged.
- App uses this package via a path dependency. Pubspec version remains 1.7.9
  to identify the baseline; this document identifies local modifications.

Regression coverage lives in `apps/flutter_chat/test/socket_writer_test.dart`.
Original failure reproducer: `scripts/repro-im-socket.dart` (100 attempted
loopback writes, 1 received, 99 synchronous errors on the tested Dart runtime).

Upgrade policy: compare upstream fixes to these two modified source files,
run loopback, close/failure and two-device tests before returning to a hosted
dependency. Keep this patch narrowly scoped; do not silently upgrade the SDK.

## Server-scoped storage (2026-09-03)

- Options has an optional databaseNamespace; App supplies a SHA-256 of the
  normalized API origin. The protocol UID remains unchanged. Database filenames
  and SQL migration preference keys both include this namespace.
- Reject unsafe path characters and oversized identity components. Close the
  previous database before initialization, await SQL/migration writes, and clear
  channel memory cache when switching database identities.
- Files affected: common/options.dart, db/wk_db_helper.dart,
  manager/channel_manager.dart, wkim.dart. Existing unscoped databases are not
  deleted or automatically migrated. Add server-isolation regression checks
  when replacing this local SDK dependency.
