//
//  SceneDelegate.swift
//  MyLocations
//
//  Created by Michelle Guthrie-Harrigan on 10/3/21.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  lazy var managedObjectContext = persistentContainer.viewContext

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    let tabController = window!.rootViewController as! UITabBarController
    if let tabViewControllers = tabController.viewControllers {
      // First tab
      var navController = tabViewControllers[0] as! UINavigationController
      let controller1 = navController.viewControllers.first as! CurrentLocationViewController
      controller1.managedObjectContext = managedObjectContext
      // Second tab
      navController = tabViewControllers[1] as! UINavigationController
      let controller2 = navController.viewControllers.first as! LocationsViewController
      controller2.managedObjectContext = managedObjectContext
      // Third tab
      navController = tabViewControllers[2] as! UINavigationController
      let controller3 = navController.viewControllers.first as! MapViewController
      controller3.managedObjectContext = managedObjectContext
    }
    listenForFatalCoreDataNotifications()
  }

  func sceneDidDisconnect(_ scene: UIScene) {
 }

  func sceneDidBecomeActive(_ scene: UIScene) {
}

  func sceneWillResignActive(_ scene: UIScene) {
  }

  func sceneWillEnterForeground(_ scene: UIScene) {
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
    saveContext()
  }

  // MARK: - Core Data stack
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "MyLocations")
    container.loadPersistentStores {_, error in
      if let error = error {
        fatalError("Could not load data store: \(error)")
      }
    }
    return container
  }()

  // MARK: - Core Data Saving support
  func saveContext() {
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

  // MARK: - Helper methods
  func listenForFatalCoreDataNotifications() {
    // 1
    NotificationCenter.default.addObserver(
      forName: dataSaveFailedNotification,
      object: nil,
      queue: OperationQueue.main
    ) { _ in
      let message = """
      There was a fatal error in the app and it cannot continue.

      Press OK to terminate the app. Sorry for the inconvenience.
      """
      let alert = UIAlertController(
        title: "Internal Error",
        message: message,
        preferredStyle: .alert)

      let action = UIAlertAction(title: "OK", style: .default) { _ in
        let exception = NSException(
          name: NSExceptionName.internalInconsistencyException,
          reason: "Fatal Core Data error",
          userInfo: nil)
        exception.raise()
      }
      alert.addAction(action)

      let tabController = self.window!.rootViewController!
      tabController.present(alert, animated: true, completion: nil)
    }
  }
}
