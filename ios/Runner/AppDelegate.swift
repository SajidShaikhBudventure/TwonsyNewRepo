import UIKit
import Flutter
import mesibo

import MesiboUI


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate,MesiboDelegate {
     
   public var fileTranserHandler: SampleAppFileTransferHandler?
    public var deviceTokenString :String? = nil
    
  public static  var eventController: FlutterEventSink?
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    
  ) -> Bool {
  
    guard let controller  = window?.rootViewController as? FlutterViewController else {
               return super.application(application, didFinishLaunchingWithOptions: launchOptions)
           }
    registerForPushNotifications()
    UNUserNotificationCenter.current().delegate = self

    application.registerForRemoteNotifications()


    let eventMethod = FlutterMethodChannel(name: "mesibo.flutter.io/messaging",
                                              binaryMessenger: controller.binaryMessenger)
    eventMethod.setMethodCallHandler({
         (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
         // Note: this method is invoked on the UI thread.
         // Handle battery messages.
        if call.method == "launchMesiboUI" {


                  self.window?.rootViewController = nil


                 let navigationController = UINavigationController(rootViewController: controller)

                // self.window = UIWindow(frame: UIScreen.main.bounds)
                 self.window?.makeKeyAndVisible()
                 self.window.rootViewController = navigationController
                 navigationController.isNavigationBarHidden = false
                 navigationController.pushViewController(SecondViewController(), animated: false)


        }


     else if call.method == "setAccessToken" {
        guard let args = call.arguments else {
          return
        }

        if let myArgs = args as? [String: Any],
         let someInfo1 = myArgs["access"] as? String,
            let _ = myArgs["destination"] as? String {
//
//            AppDelegate.eventController!(someInfo1+" Params :"+someInfo2 )
         DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
            self.startMesibo(accessToken:someInfo1)
         }


//
//          print("gggssss==============")
//
//              let ui = Mesibo.getInstance().getUiOptions()
//
//                     ui?.useLetterTitleImage =  true
//
//                     ui?.emptyUserListMessage = "No active conversations! Invite your family and friends to try mesibo."
//
//

        }
      }else  if call.method == "setNavOff" {

            UINavigationBar.appearance().tintColor = UIColor.blue

        }else  if call.method == "setNavOff" {


        }
    })

    let eventChannel = FlutterEventChannel(name: "mesibo.flutter.io/mesiboEvents", binaryMessenger: controller.binaryMessenger)

    eventChannel.setStreamHandler(SwiftStreamHandler())

 
    GeneratedPluginRegistrant.register(with: self)
   
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    func registerForPushNotifications() {
      UNUserNotificationCenter.current() // 1
        .requestAuthorization(options: [.alert, .sound, .badge]) { // 2
          granted, error in
          print("Permission granted: \(granted)") // 3
      }
    }
    
    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//         Mesibo.getInstance().setAppInForeground(nil, screenId: 0, foreground: true)
        triggerNotificationMessage()
       
               
    }
    
 
    public override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
         // NSLog(@"My token is: %@", deviceToken);
        print(deviceToken)
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
       
          deviceTokenString=token
       Mesibo.getInstance()?.setPushToken(deviceTokenString, voip: false)
      
     }
    public override func applicationWillResignActive(_ application: UIApplication) {
       
       }
       
    public override func applicationDidEnterBackground(_ application: UIApplication) {
           Mesibo.getInstance().setAppInForeground(self, screenId: 0, foreground: false)
       
       }
       
    public override func applicationWillEnterForeground(_ application: UIApplication) {

    }
       
    public override func applicationDidBecomeActive(_ application: UIApplication) {
           Mesibo.getInstance().setAppInForeground(self, screenId: 0, foreground: true)
           //[MesiboCallInstance showCallInProgress];
    
       }
       
    public override func applicationWillTerminate(_ application: UIApplication) {
       }
       
    public override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //Log("Failed to get token, error: %@", error)
  
     }
    
     
     
    func launchMesiboUI() {
        let ui = Mesibo.getInstance().getUiOptions()
        ui?.enableBackButton=true
        
        ui?.mStatusBarColor = 0x000000
        ui?.mToolbarColor =  0x000000
        
        ui?.emptyUserListMessage = "NO MESSAGES"
        
        let mesiboController = MesiboUI.getViewController()
        
        
        
        
        var navigationController: UINavigationController? = nil
        if let mesiboController = mesiboController {
            navigationController = UINavigationController(rootViewController: mesiboController)
        }
        setRootController(navigationController)
        //
        
        //           MesiboUIManager.setDefaultParent(navigationController)
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
        window!.rootViewController = controller
        window!.rootViewController = controller
        window!.makeKeyAndVisible()
        //        [[UIApplication sharedApplication].keyWindow setRootViewController:rootViewController];
    }
    public override func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
          Mesibo.getInstance().setAppInForeground(nil, screenId: -1, foreground: true)
       
    }
    
    
    public func startMesibo(accessToken : String) {
        
        //        [SampleAppListeners getInstance]; // will initiallize and register listener
        //        // early initialize for reverse lookup
        let falseValue: UInt32 = 0
        if(deviceTokenString != nil){
         
 Mesibo.getInstance()?.setPushToken(deviceTokenString, voip: false)
        }else{
          
        }
        Mesibo.getInstance()?.setAccessToken(accessToken)
       //     Mesibo.getInstance()?.setPushToken(deviceTokenString, voip: false)
        fileTranserHandler = SampleAppFileTransferHandler()
        fileTranserHandler!.initialize(accessToken:accessToken)
         
              Mesibo.getInstance()?.setDatabase("mesibo.db", resetTables: falseValue)
              Mesibo.getInstance()?.addListener(self)
          
              Mesibo.getInstance()?.start()
    
      
           
           
       
//        if(mCc && [mCc intValue] > 0)
//            [ContactUtilsInstance setCountryCode:[mCc intValue]];
//
//        [GMSServices provideAPIKey:mGoogleKey];
//        [GMSPlacesClient provideAPIKey:mGoogleKey];
//
//        [MesiboInstance setSecureConnection:YES];
//        [MesiboInstance start];
        
    }
     func mesibo_(onMessageFilter params: MesiboParams!, direction: Int32, data: Data!) -> Bool {
        return true
    }
    func mesibo_(onUserProfileUpdated profile: MesiboUserProfile!, action: Int32, refresh: Bool) {
       
        
    }
    
    func mesibo_(onShowProfile parent: Any!, profile: MesiboUserProfile!) {
        
        
    }
 
    func mesibo_(onUpdateUserProfiles profile: MesiboUserProfile!) -> Bool {
         
     return true
        
    }
    
    
    func mesibo_(onConnectionStatus status: Int32) {
        print("Connection status: %d", status);
 AppDelegate.eventController!("Connected Status" )

    }

    func mesibo_(onMessageStatus params: MesiboParams!) {
        print(params ?? "")
           print("fff")
        AppDelegate.eventController!("onMessageStatus" )

    }

    func mesibo_(onMessage params: MesiboParams!, data: Data!) {
        var message: String? = nil
        message = String(data: data, encoding: .utf8)
        debugPrint(message!)
        AppDelegate.eventController!(message! )


    }
     @objc func mesibo_(onMenuItemSelected parent: Any!, type: Int32, profile: MesiboUserProfile!, item: Int32) -> Bool {
        let boy = "Bart Simpson"+String(type)
        let age = type
        print("\(boy) is \(age)")
//        AppDelegate.eventController!("onMessage"+age )
        AppDelegate.eventController!("Heelo")


        return true
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
    public override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Tapped in notification")
    }
    
    //This is key callback to present notification while the app is in foreground
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        AppDelegate.eventController!("triggered")
        
        print("Notification being triggered")
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications
        if notification.request.identifier == "Sample"{
            
            completionHandler( [.alert,.sound,.badge])
            
        }
    }
    @IBAction  func triggerNotification(){
          
          print("notification will be triggered in five seconds..Hold on tight")
          let content = UNMutableNotificationContent()
          content.title = "New Message"
        
        content.body = "Device Token set"+deviceTokenString!
          content.sound = UNNotificationSound.default
          
          //To Present image in notification
          if let path = Bundle.main.path(forResource: "monkey", ofType: "png") {
              let url = URL(fileURLWithPath: path)
              
              do {
                  let attachment = try UNNotificationAttachment(identifier: "sampleImage", url: url, options: nil)
                  content.attachments = [attachment]
              } catch {
                  print("attachment not found.")
              }
          }
          
          // Deliver the notification in five seconds.
          let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5.0, repeats: false)
          let request = UNNotificationRequest(identifier:"Sample", content: content, trigger: trigger)
          
          UNUserNotificationCenter.current().delegate = self
          UNUserNotificationCenter.current().add(request){(error) in
              
              if (error != nil){
                  
               //   print(error?.localizedDescription)
              }
          }
      }
      @IBAction  func triggerNotificationMessage(){
              
              print("notification will be triggered in five seconds..Hold on tight")
              let content = UNMutableNotificationContent()
              content.title = "New Message"
            
            content.body = "You have received a new message."
              content.sound = UNNotificationSound.default
              
              //To Present image in notification
              if let path = Bundle.main.path(forResource: "monkey", ofType: "png") {
                  let url = URL(fileURLWithPath: path)
                  
                  do {
                      let attachment = try UNNotificationAttachment(identifier: "sampleImage", url: url, options: nil)
                      content.attachments = [attachment]
                  } catch {
                      print("attachment not found.")
                  }
              }
              
              // Deliver the notification in five seconds.
              let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5.0, repeats: false)
              let request = UNNotificationRequest(identifier:"Sample", content: content, trigger: trigger)
              
              UNUserNotificationCenter.current().delegate = self
              UNUserNotificationCenter.current().add(request){(error) in
                  
                  if (error != nil){
                      
                   //   print(error?.localizedDescription)
                  }
              }
          }
      @IBAction func stopNotification(_ sender: AnyObject) {
          
          print("Removed all pending notifications")
          let center = UNUserNotificationCenter.current()
          center.removePendingNotificationRequests(withIdentifiers: ["Sample"])
          
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
