//
//  SecondViewController.swift
//  Runner
//
//  Created by aditya jaitly on 14/07/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import UIKit
import mesibo

import MesiboUI

class SecondViewController: UIViewController,MesiboDelegate,UNUserNotificationCenterDelegate {
   
    override func viewDidLoad() {
        super.viewDidLoad()
       // setUpNavBar()
        let ui = Mesibo.getInstance().getUiOptions()
//                    add(asChildViewController: MesiboUI.getViewController())
 
        self.navigationController?.navigationBar.tintColor = UIColor.white
 
        UINavigationBar.appearance().tintColor = UIColor.white
        
       let ac=MesiboReadSession()
        ac.initSession(nil, groupid: 0, query: nil, delegate: navigationController?.delegate)
                            ac.enableSummary(true)
                            ac.enableReadReceipt(true)
                            ac.read(100)
        ui?.mStatusBarColor = 0xf000000
        ui?.mToolbarColor =  0xf000000
        ui?.enableBackButton = false
        ui?.useLetterTitleImage = false
        let image : UIImage = UIImage(named:
            "chatimage")!.withAlignmentRectInsets(UIEdgeInsets(top: -105, left: -105, bottom: -105,
        right: -105))
        ui?.contactPlaceHolder = image
        
        
      
        ui?.emptyUserListMessage = "NO MESSAGES"
    
         Mesibo.getInstance()?.addListener(self)
        navigationController?.navigationItem.setHidesBackButton(true, animated:false)
        navigationController?.pushViewController(MesiboUI.getViewController(), animated: false)
//
                         
        let vc = MesiboUI.getViewController()
        
////        MesiboUIManager.launchVC_mainThread(navigationController,vc: vc)
////        MesiboUIManager.launchMesiboUI(navigationController!, withMainWindow:(UIApplication.shared.delegate?.window)! )
////
//
        vc?.navigationController?.isNavigationBarHidden = false
//        let btn = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(backAction(sender:)))
//        vc?.navigationItem.leftItemsSupplementBackButton = true
//        vc?.navigationItem.leftBarButtonItem = btn
//
////  //      vc?.navigationItem.setLeftBarButton(btn, animated: false)
//        navigationController?.present(vc!, animated: false,completion: completionHandler)

//        let nv = UINavigationController(rootViewController: vc!)
////        self.navigationController?.pushViewController(nv, animated: true)
//        self.present(nv, animated: true, completion: nil)


       
    }
    
  func completionHandler() {
    AppDelegate.eventController!("save bolean")
       
    }
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)

        if parent == nil {
            debugPrint("Back Button pressed.")
        }
    }

    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)

        // Add Child View as Subview
        view.addSubview(viewController.view)

        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    @objc func backAction (sender : UIBarButtonItem){
       AppDelegate.eventController!("BackAction" )

        dismiss(animated: true, completion: nil)
    }
    func setUpNavBar(){
        AppDelegate.eventController!("setUpNavBar" )
        
//        self.navigationItem.title = "IOS component"
//        self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "back", style: UIBarButtonItem.Style.done, target: self, action: nil)
        
    }
      
     
    
    override func viewWillAppear(_ animated: Bool) {
//        navigationController?.navigationBar.barTintColor = UIColor(red:  34/255.0, green: 149/255.0, blue: 243/255.0, alpha: 100.0/100.0)
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
//        var navigationBarAppearace = UINavigationBar.appearance()
//                navigationBarAppearace.tintColor = self.uicolorFromHex(rgbValue: 0xffffff)
//        navigationController?.navigationItem.title="INBOX MESSAGES"
        // change navigation item title color
          self.navigationController?.isNavigationBarHidden = true
      self.navigationController?.popViewController(animated: true)
           
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       
        self.navigationController?.isNavigationBarHidden = true
   
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
}
