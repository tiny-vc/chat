import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    super.scene(scene, willConnectTo: session, options: connectionOptions)
    #if DEBUG
    // Opt-in local diagnostics only; no account data or persistent telemetry.
    if ProcessInfo.processInfo.arguments.contains("--startup-probe") {
      NSLog("STARTUP_PROBE scene_connected")
    }
    if ProcessInfo.processInfo.arguments.contains("--startup-probe"),
       let windowScene = scene as? UIWindowScene,
       let controller = window?.rootViewController as? FlutterViewController {
      let traits = windowScene.traitCollection
      let color = UIColor(named: "LaunchBackground")?.resolvedColor(with: traits)
      NSLog("STARTUP_PROBE scene style=%ld background=%@ splash=%@", traits.userInterfaceStyle.rawValue,
            String(describing: color), String(describing: controller.splashScreenView?.backgroundColor))
      controller.setFlutterViewDidRenderCallback {
        NSLog("STARTUP_PROBE flutter_visible")
      }
    }
    #endif
  }
}
