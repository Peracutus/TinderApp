//
//  SceneDelegate.swift
//  TinderApp
//
//  Created by Roman on 20.11.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
      
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = RegistrationController()
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white
    }
}

