import UIKit
import Flutter
import mesibo

import MesiboUI


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate,MesiboDelegate {
  
   public var fileTranserHandler: SampleAppFileTransferHandler?
      var navigationController: UINavigationController?
       
  public static  var eventController: FlutterEventSink?
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    
  ) -> Bool {
   
   guard let controller  = window?.rootViewController as? FlutterViewController else {
               return super.application(application, didFinishLaunchingWithOptions: launchOptions)
           }
    let eventMethod = FlutterMethodChannel(name: "mesibo.flutter.io/messaging",
                                              binaryMessenger: controller.binaryMessenger)
    eventMethod.setMethodCallHandler({
         (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
         // Note: this method is invoked on the UI thread.
         // Handle battery messages.
        
      if call.method == "setAccessToken" {
        guard let args = call.arguments else {
          return
        }
        if let myArgs = args as? [String: Any],
         let someInfo1 = myArgs["access"] as? String,
         let someInfo2 = myArgs["destination"] as? String {
       
            AppDelegate.eventController!(someInfo1+" Params :"+someInfo2 )
            self.startMesibo(accessToken:someInfo1)
            
            Mesibo.getInstance().run(inThread: true, handler: {
                let ui = Mesibo.getInstance().getUiOptions()
                       ui?.enableBackButton=true
                   
                       ui?.mStatusBarColor = 0xff000
                       ui?.mToolbarColor =   0xff000
                       
                          ui?.emptyUserListMessage = "No active conversations! Invite your family and friends to try mesibo."
                          
                          let mesiboController = MesiboUI.getViewController()
                       
                      
                     
                      
                          var navigationControllerMesibo: UINavigationController? =
                           UINavigationController(rootViewController: mesiboController!)
                          
             
                                 self.window?.rootViewController = nil
                                 
                                 let viewToPush = navigationControllerMesibo
                                 
                                 let navigationController = UINavigationController(rootViewController: controller)
                                 
                                 self.window = UIWindow(frame: UIScreen.main.bounds)
                                 self.window?.makeKeyAndVisible()
                                 self.window.rootViewController = navigationController
                                 navigationController.isNavigationBarHidden = false
                                 navigationController.pushViewController(viewToPush!, animated: false)
                                 
                            
                      })
        }
        }
       })

    let eventChannel = FlutterEventChannel(name: "mesibo.flutter.io/mesiboEvents", binaryMessenger: controller.binaryMessenger)
    
     eventChannel.setStreamHandler(SwiftStreamHandler())
    
   
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    
    func launchMesiboUI(controller : FlutterViewController) {
           let ui = Mesibo.getInstance().getUiOptions()
        ui?.enableBackButton=true
    
        ui?.mStatusBarColor = 0xff000
        ui?.mToolbarColor =   0xff000
        
           ui?.emptyUserListMessage = "No active conversations! Invite your family and friends to try mesibo."
           
           let mesiboController = MesiboUI.getViewController()
        
       
      
       
           var navigationControllerMesibo: UINavigationController? = nil
           if let mesiboController = mesiboController {
               navigationControllerMesibo = UINavigationController(rootViewController: mesiboController)
           }
        self.navigationController?.pushViewController(navigationControllerMesibo!, animated: true)
        
        
        UIView.animate(withDuration: 0.5, animations: {
                           self.window?.rootViewController = nil
                           
                           let viewToPush = navigationControllerMesibo
                           
            let navigationController = UINavigationController(rootViewController: controller)
                           
                           self.window = UIWindow(frame: UIScreen.main.bounds)
                           self.window?.makeKeyAndVisible()
                           self.window.rootViewController = navigationController
                           navigationController.isNavigationBarHidden = false
                           navigationController.pushViewController(viewToPush!, animated: false)
                           
                       })
      
//           setRootController(navigationController)
//
           
          MesiboUIManager.setDefaultParent(navigationController)
//
       }
    
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
       
    func setRootController(_ controller: UIViewController?) {
     self.navigationController?.pushViewController(controller!, animated: true)
        window!.makeKeyAndVisible()
//        [[UIApplication sharedApplication].keyWindow setRootViewController:rootViewController];
    }
    
    public func startMesibo(accessToken : String) {
        
//        [SampleAppListeners getInstance]; // will initiallize and register listener
//        // early initialize for reverse lookup
        var falseValue: UInt32 = 0
       
              Mesibo.getInstance()?.setAccessToken(accessToken)
        fileTranserHandler = SampleAppFileTransferHandler()
        fileTranserHandler!.initialize(accessToken:accessToken)
              Mesibo.getInstance()?.setDatabase("mesibo.db", resetTables: falseValue)
              Mesibo.getInstance()?.addListener(self)
              Mesibo.getInstance()?.start()
         AppDelegate.eventController!("Connected" )

        
//        if(mCc && [mCc intValue] > 0)
//            [ContactUtilsInstance setCountryCode:[mCc intValue]];
//
//        [GMSServices provideAPIKey:mGoogleKey];
//        [GMSPlacesClient provideAPIKey:mGoogleKey];
//
//        [MesiboInstance setSecureConnection:YES];
//        [MesiboInstance start];
        
    }
    
    
    func mesibo_(onConnectionStatus status: Int32) {
        print("Connection status: %d", status);

    }

    func mesibo_(onMessageStatus params: MesiboParams!) {
        print(params ?? "")
    }

    func mesibo_(onMessage params: MesiboParams!, data: Data!) {
        print("data")
    }

    
    
    class SwiftStreamHandler: NSObject, FlutterStreamHandler {
        public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
            events("Success")
            
           eventController=events;
            
            // any generic type or more compex dictionary of [String:Any]
//            events(FlutterError(code: "ERROR_CODE",
//                                 message: "Detailed message",
//                                 details: nil)) // in case of errors
          
            return nil
        }

        public func onCancel(withArguments arguments: Any?) -> FlutterError? {
            return nil
        }
    }
    
    
    
}
extension UIColor {
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    var hex: UInt {
        let red = UInt(coreImageColor.red * 255 + 0.5)
        let green = UInt(coreImageColor.green * 255 + 0.5)
        let blue = UInt(coreImageColor.blue * 255 + 0.5)
        return (red << 16) | (green << 8) | blue
    }
}
