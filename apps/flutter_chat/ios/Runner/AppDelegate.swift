import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate,
  UIDocumentInteractionControllerDelegate
{
  private var documentController: UIDocumentInteractionController?
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    guard let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "ChatFileOpener") else {
      return
    }
    FlutterMethodChannel(
      name: "chat/file_opener",
      binaryMessenger: registrar.messenger()
    ).setMethodCallHandler { [weak self] call, result in
      guard call.method == "open" else {
        result(FlutterMethodNotImplemented)
        return
      }
      guard
        let arguments = call.arguments as? [String: Any],
        let path = arguments["path"] as? String,
        !path.isEmpty
      else {
        result(FlutterError(code: "invalid_path", message: "文件路径为空", details: nil))
        return
      }
      self?.openFile(path: path, result: result)
    }
  }

  private func openFile(path: String, result: @escaping FlutterResult) {
    let url = URL(fileURLWithPath: path).standardizedFileURL
    let home = URL(fileURLWithPath: NSHomeDirectory()).standardizedFileURL.path + "/"
    guard url.path.hasPrefix(home), FileManager.default.fileExists(atPath: url.path) else {
      result(FlutterError(code: "invalid_path", message: "文件不存在或不在应用目录中", details: nil))
      return
    }
    guard let presenter = topViewController(window?.rootViewController) else {
      result(FlutterError(code: "open_failed", message: "当前页面无法打开文件", details: nil))
      return
    }
    let controller = UIDocumentInteractionController(url: url)
    controller.delegate = self
    documentController = controller
    if !controller.presentPreview(animated: true) {
      if !controller.presentOptionsMenu(from: presenter.view.bounds, in: presenter.view, animated: true) {
        documentController = nil
        result(FlutterError(code: "open_failed", message: "没有可打开此文件的应用", details: nil))
        return
      }
    }
    result(nil)
  }

  private func topViewController(_ controller: UIViewController?) -> UIViewController? {
    if let presented = controller?.presentedViewController {
      return topViewController(presented)
    }
    if let navigation = controller as? UINavigationController {
      return topViewController(navigation.visibleViewController)
    }
    if let tabs = controller as? UITabBarController {
      return topViewController(tabs.selectedViewController)
    }
    return controller
  }

  func documentInteractionControllerViewControllerForPreview(
    _ controller: UIDocumentInteractionController
  ) -> UIViewController {
    topViewController(window?.rootViewController) ?? UIViewController()
  }

  func documentInteractionControllerDidEndPreview(
    _ controller: UIDocumentInteractionController
  ) {
    documentController = nil
  }

  func documentInteractionControllerDidDismissOptionsMenu(
    _ controller: UIDocumentInteractionController
  ) {
    documentController = nil
  }
}
