# Local patch on file_picker_darwin 1.0.4

Upstream package copied from the installed pub package, with its MIT license retained. Only the iOS media-picker completion timing is changed; the global pub cache is not modified.

Reproduced on iOS 26.5: cancel PHPicker, immediately call pickFile again. UIKit reports an attempt to present a new PHPicker on the dismissing PHPicker whose view is no longer in the window hierarchy. The Dart Future stays pending and the App remains busy.

The local change retains the busy result until dismissal completes. Selected files wait for both dismissal and file resolution. Interactive dismissal returns at didDismiss, not willDismiss; duplicate media delegate completions are guarded. This uses UIKit completion callbacks, not a fixed sleep.

Regression: integration_test/native_group_avatar_test.dart deliberately reopens immediately after cancellation. Test both cancellation/reopen and successful selection, plus peer image decoding. Keep this override until an upstream version is verified to fix the race.
