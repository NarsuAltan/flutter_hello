import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    var flutterChannel: FlutterMethodChannel?
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      let controller: FlutterViewController = window?.rootViewController as! FlutterViewController

      flutterChannel = FlutterMethodChannel(name: "my_custom_channel", binaryMessenger: controller.binaryMessenger)
      
      
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
          if granted {
              DispatchQueue.main.async {
                  UIApplication.shared.registerForRemoteNotifications()
              }
          } else {
              print("用户拒绝通知权限: \(String(describing: error))")
          }
      }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    /// 成功获取 APNs deviceToken
    override func application(_ application: UIApplication,
                              didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 转成字符串方便调试
        let tokenParts = deviceToken.map { String(format: "%02.2hhx", $0) }
        let token = tokenParts.joined()

        print("APNs Device Token: \(token)")
        
        let data: [String: Any] = [
               "type": "apnsToken",
               "value": token
           ]

        flutterChannel?.invokeMethod("onNativeEvent", arguments: data)
    }

    /// 注册失败
    override func application(_ application: UIApplication,
                              didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs 注册失败: \(error.localizedDescription)")
    }
}
