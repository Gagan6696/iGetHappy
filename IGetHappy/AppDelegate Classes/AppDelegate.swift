//
//  AppDelegate.swift
//  IGetHappy
//
//  Created by Gagan on 5/9/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import GoogleSignIn
import GoogleToolboxForMac
import AVFoundation
import Speech
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        sleep(3)
        
        let result = UserDefaults.exists(key: defaultKeys.Emoji_CurrentPage)
        
        if result == false{
            Constants.pleaseTrackMood = true
            ExtensionModel.shared.Emoji_CurrentPage = 10
        }
//        }else{
//            if ExtensionModel.shared.Emoji_CurrentPage == 0{
//                ExtensionModel.shared.Emoji_CurrentPage = 10
//            }
//     }
        
        // Override point for customization after application launch.
        GIDSignIn.sharedInstance().clientID = "107448457120-71mqngc2hu279n1nrdtmu3qu4hl3m5uc.apps.googleusercontent.com"
        
        // Override point for customization after application launch.
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
       getPermissions()
        SetupInitialView()
        KQNotification.shared.registerNotification(withOptions: [.alert, .badge, .sound], completion: nil)
        return true
    }
    
    
    func SetupInitialView()
    {
        
        let result  = UserDefaults.standard.getLoggedIn()
       // let result = UserDefaults.exists(key: UserDefaultsKeys.userId.rawValue)
        if(result ?? false){
            let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
            let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "HomeVC") as! SWRevealViewController
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = initialViewControlleripad
            self.window?.makeKeyAndVisible()
        }else{
            let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
            let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "StartUpVCNav") 
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = initialViewControlleripad
            self.window?.makeKeyAndVisible()
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool
    {
        
        let GoogleDidHandle =  GIDSignIn.sharedInstance().handle(url as URL?,
                                                                 sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                                 annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        
        let facebookDidHandle = ApplicationDelegate.shared.application(app,open: url as URL ,sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String!,annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        
        return facebookDidHandle || GoogleDidHandle
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return ApplicationDelegate.shared.application(application,open: url as URL ,sourceApplication: sourceApplication,annotation: annotation)
        
        
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
          AppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        self.saveContext()
    }
    
    
    lazy var persistentContainer: NSPersistentContainer =
        {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Database")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError?
            {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext ()
    {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func getPermissions()
    {
        
        
        
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            print("Permission granted")
        case AVAudioSession.RecordPermission.denied:
            print("Pemission denied")
        case AVAudioSession.RecordPermission.undetermined:
            print("Request permission here")
            AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                // Handle granted
            })
        }
        
        
        SFSpeechRecognizer.requestAuthorization
            {
            [unowned self] (authStatus) in
            switch authStatus {
            case .authorized:
                print("Speech recognition authorization")
            case .denied:
                print("Speech recognition authorization denied")
            case .restricted:
                print("Not available on this device")
            case .notDetermined:
                print("Not determined")
            }
        }
        
        
        PHPhotoLibrary.requestAuthorization({
            (newStatus) in
            if newStatus ==  PHAuthorizationStatus.authorized {
                /* do stuff here */
            }
        })
        
    }
    
}

