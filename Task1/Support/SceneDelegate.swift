//
//  SceneDelegate.swift
//  Task1
//
//  Created by mac on 02/03/2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
        
      
               let tabBarController = UITabBarController()

               // Get ViewControllers from Storyboard
               let storyboard = UIStoryboard(name: "Main", bundle: nil)
               
               let ContactsVC = storyboard.instantiateViewController(withIdentifier: "ContactsVC")
               let FavoritesVC = storyboard.instantiateViewController(withIdentifier: "FavoritesVC")

               // Wrap each ViewController in a UINavigationController
               let firstNav = UINavigationController(rootViewController: ContactsVC)
               let secondNav = UINavigationController(rootViewController: FavoritesVC)

               // Set Tab Bar Items
               ContactsVC.title = "Contacts"
               FavoritesVC.title = "Favorites"

               firstNav.tabBarItem = UITabBarItem(title: "Contacts", image: UIImage(systemName: "person.circle"), tag: 0)
               secondNav.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star.fill"), tag: 1)

               // Add Navigation Controllers to the Tab Bar Controller
               tabBarController.viewControllers = [firstNav, secondNav]

               // Set Root View Controller
               window?.rootViewController = tabBarController
               window?.makeKeyAndVisible()
           
        
           window?.overrideUserInterfaceStyle = .unspecified // Change to .dark or .light
         
    
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

