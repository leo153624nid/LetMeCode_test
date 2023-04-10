//
//  SceneDelegate.swift
//  LetMeCode_test
//
//  Created by macbook on 04.04.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var navController = UINavigationController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let viewController = ReviewesModuleBuilder.build()
        self.navController = UINavigationController(rootViewController: viewController)
        
        self.window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        self.window?.windowScene = windowScene
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
    }
}

