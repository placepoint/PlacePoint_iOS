//
//  AppDelegate.swift
//  PlacePoint
//
//  Created by Mac on 28/05/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import CoreData
import MMDrawerController
import GooglePlaces
import GoogleMaps
import Stripe
import Fabric
import Crashlytics
import Firebase
import OneSignal
import AppsFlyerLib

var isNotificationClicked = false

let googleApiKey = "AIzaSyAncYbdBWD9MidQI1ice8bdliLDHuM1ujY"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, OSSubscriptionObserver, AppsFlyerTrackerDelegate {

    var window: UIWindow?
    
    var mainNav: UINavigationController?
    
    var centerContainer: MMDrawerController?

    var navigationController = UINavigationController()
    
    let locationManager = CLLocationManager()
    
    // MARK: - App life cycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
         
        
        AppsFlyerTracker.shared().appsFlyerDevKey = "LocXuyz85AtUXHXPmF7ttT";
        AppsFlyerTracker.shared().appleAppID = "1409513781"
        AppsFlyerTracker.shared().delegate = self
        AppsFlyerTracker.shared().isDebug = true
       
        //GoogleApi key
        FirebaseApp.configure()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        GMSServices.provideAPIKey(googleApiKey)
        GMSPlacesClient.provideAPIKey(googleApiKey)
    
        Fabric.with([Crashlytics.self])
        
        Fabric.sharedSDK().debug = true
 
        // live stripe key = pk_live_kt0mTsSnlapCVN44Ilfy7snQ
        
        // test stripe key = pk_test_IWmxeaTtErjZDGj3Dcu2oJw0
        
         self.setUpRootVC()
        
        STPPaymentConfiguration.shared().publishableKey = "pk_live_kt0mTsSnlapCVN44Ilfy7snQ"
        
        //STPPaymentConfiguration.shared().publishableKey = "pk_test_IWmxeaTtErjZDGj3Dcu2oJw0"
        
        showAthlonePopUp = true
        
        let notificationReceivedBlock: OSHandleNotificationReceivedBlock = {
            notification in
            
        }
        
        let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
            
            let payload: OSNotificationPayload = result!.notification.payload
            
//             self.setUpTabVC()
            
              isNotificationClicked = true
            
//            if let dictPushContent = payload.additionalData as? [String:AnyObject] {
//
//
//            }
        }
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: true,
                                     kOSSettingsKeyInAppLaunchURL: true]
        
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId:"465f4f78-03a9-469e-a04f-da5f35c649d0",
                                        handleNotificationReceived: notificationReceivedBlock,
                                        handleNotificationAction: notificationOpenedBlock,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification
        
        OneSignal.promptForPushNotifications
            { (true) in
                
        }
        
        OneSignal.add(self as OSSubscriptionObserver)
        
        UIApplication.shared.statusBarStyle = .lightContent
        
       
        
        return true
    }

   
    
    func applicationWillResignActive(_ application: UIApplication) {

    }
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {

        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        AppsFlyerTracker.shared().trackAppLaunch()

        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            
            let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
            
            let userID = status.subscriptionStatus.userId
           
           UserDefaults.standard.kDeviceIdOnesignal(kDeviceId: userID!)
            
            UserDefaults.standard.synchronize()
        }
        else {
            
            UserDefaults.standard.kDeviceIdOnesignal(kDeviceId: "1")
            
            UserDefaults.standard.synchronize()
        }
    }
    
    func setUpTabVC()  {
        
      let tabVC  = TabBarVC(nibName: "TabBarVC", bundle: nil)
    
      navigationController = UINavigationController(rootViewController: tabVC)
    
      navigationController.interactivePopGestureRecognizer?.isEnabled = false
    
      window?.rootViewController = navigationController
    
      window?.makeKeyAndVisible()
        
 }
    
    // MARK: - SetUp RootsVC
    func setUpRootVC() {
        
        let checkAppAuthFirst = UserDefaults.standard.getisAppAuthFirst()

        if checkAppAuthFirst == true {
            
            let isKeyExist = CommonClass.sharedInstance.keyAlreadyExists(Key: "FCategories")
            
            if isKeyExist == true {
                
                
                let arrFCategory = UserDefaults.standard.getMultipleCatForFlashDeal()
                
                if arrFCategory.count > 0 {
                    
                     self.setUpTabVC()
                    
                } else {
                    
                    let initialVC  = MultipleTownSelectionVC(nibName: "MultipleTownSelectionVC", bundle: nil)
                    
                    navigationController = UINavigationController(rootViewController: initialVC)
                    
                    window?.rootViewController = navigationController
                    
                    window?.makeKeyAndVisible()
                }
            } else {
                
                let initialVC  = MultipleTownSelectionVC(nibName: "MultipleTownSelectionVC", bundle: nil)
                
                navigationController = UINavigationController(rootViewController: initialVC)
                
                window?.rootViewController = navigationController
                
                window?.makeKeyAndVisible()
            }
           
     

        }
        else {
        
             UserDefaults.standard.setisFirstlaunch(isFirst: true)
             UserDefaults.standard.setisFirstTutorialLive(isFirst: true)
             UserDefaults.standard.setisFirstTutorialPost(isFirst: true)
             UserDefaults.standard.setisFirstTutorialBusiness(isFirst: true)
            
             UserDefaults.standard.setBusinessProfile(value: false)
            
            let initialVC  = InitialVC(nibName: "InitialVC", bundle: nil)
            
            navigationController = UINavigationController(rootViewController: initialVC)
            
            isFirstCome = false
            
            navigationController.interactivePopGestureRecognizer?.isEnabled = false

            window?.rootViewController = navigationController
            
            window?.makeKeyAndVisible()
            
            UserDefaults.standard.setSelectedTown(value: "")
            
            UserDefaults.standard.selectedCategory(value: "")
            
            UserDefaults.standard.setBusinessUserType(userType: "")
            
        }
        
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "PlacePoint")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
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
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    //MARK: - AppsFlyer Delegates
    func onConversionDataReceived(_ installData: [AnyHashable: Any]) {
        //Handle Conversion Data (Deferred Deep Link)
    }
    
    func onConversionDataRequestFailure(_ error: Error?) {
        //    print("\(error)")
    }
    
    func onAppOpenAttribution(_ attributionData: [AnyHashable: Any]) {
        //Handle Deep Link Data
        
    }
    
    func onAppOpenAttributionFailure(_ error: Error?) {
    }
    
    // Reports app open from a Universal Link for iOS 9 or later
    // for below swift-4.2
    /*func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
     AppsFlyerTracker.shared().continue(userActivity, restorationHandler: restorationHandler)
     return true
     }*/
    
    // for swift-4.2
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        AppsFlyerTracker.shared().continue(userActivity, restorationHandler: nil)
        return true
    }
    
    // Reports app open from deep link from apps which do not support Universal Links (Twitter) and for iOS8 and below
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        AppsFlyerTracker.shared().handleOpen(url, sourceApplication: sourceApplication, withAnnotation: annotation)
        return true
    }
    
    // Reports app open from deep link for iOS 10 or later
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        AppsFlyerTracker.shared().handleOpen(url, options: options)
        return true
    }
}
