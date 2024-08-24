//
//  SceneDelegate.swift
//  TodoListApp
//
//  Created by Evgeniy Maksimov on 19.08.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: TaskListViewController())
        
        if #available(iOS 13, *) {
            window?.overrideUserInterfaceStyle = .light
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
  
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

