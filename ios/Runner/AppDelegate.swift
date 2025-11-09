import UIKit
import Flutter
import Firebase
import GoogleSignIn

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // Configure Firebase
    if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") {
      if let options = FirebaseOptions(contentsOfFile: path) {
        FirebaseApp.configure(options: options)
      }
    } else {
      // Fallback configuration
      FirebaseApp.configure()
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    
    // Handle Google Sign In
    if GIDSignIn.sharedInstance.handle(url) {
      return true
    }
    
    // Handle other URL schemes
    return super.application(app, open: url, options: options)
  }
  
  // Handle universal links
  override func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
  ) -> Bool {
    return super.application(application, continue: userActivity, restorationHandler: restorationHandler)
  }
}
