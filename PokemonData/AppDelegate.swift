//
//  AppDelegate.swift
//  PokemonData
//
//  Created by Angel Avila on 4/8/19.
//  Copyright © 2019 Angel Avila. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let network = NetworkManager()
        let presenter = PokemonPresenterImpl(withNetworkLayer: network)
        let pokemonVC = PokemonViewController(withPresenter: presenter)
        let rootVC = UINavigationController(rootViewController: pokemonVC)
//        let rootVC = UIViewController(nibName: nil, bundle: nil)
        
        rootVC.view.backgroundColor = .white

        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        
        return true
    }
}

