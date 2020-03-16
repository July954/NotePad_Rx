//
//  AppDelegate.swift
//  Notepad
//
//  Created by adcapsule on 2020/02/15.
//  Copyright © 2020 shAhn. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let rootVC = UINavigationController()
        rootVC.setNavigationBarHidden(true, animated: false)
        self.window?.rootViewController = rootVC
        
        let vc = Utilty.shared.getStoryboardWithController(strSBName: "Main", strControllerName: "ViewController") as! ViewController
        rootVC.pushViewController(vc, animated: true)
        
        return true
    }

    
    //MARK: Core Data stack
    lazy var presistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name:  "NotePadCoreData")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("APP ERROR ::: \(error)")
            }
        }
        return container
    }()
    

    //MARK: Core Data Saving Support
    func saveContext() {
        let context = presistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch (let error as NSError?) {
                if error != nil {
                    fatalError("APP ERROR ::: saveContext \(String(describing: error))")
                }
            }
        }
    }
}

