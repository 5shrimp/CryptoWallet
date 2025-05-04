//
//  TabBarController.swift
//  CryptoWallet
//
//  Created by Дмитрий Любченко on 28.04.2025.
//

import UIKit

class TabBarController: UITabBarController  {
    let homeVC: HomeVC = {
        let controller = HomeVC()
        let tabItem = UITabBarItem.init(title: "", image: UIImage(named: "Frame 2"), selectedImage: UIImage(named: "Frame 2"))
        controller.tabBarItem = tabItem
        return controller
    }()
    
    let secondVC: UIViewController = {
        let controller = UIViewController()
        let tabItem = UITabBarItem.init(title: "", image: UIImage(named: "Frame 5"), selectedImage: UIImage(named: "Frame 5"))
        controller.tabBarItem = tabItem
        return controller
    }()
    
    let thirdVC: UIViewController = {
        let controller = UIViewController()
        let tabItem = UITabBarItem.init(title: "", image: UIImage(named: "Frame 4"), selectedImage: UIImage(named: "Frame 4"))
        controller.tabBarItem = tabItem
        return controller
    }()
    
    let fourthVC: UIViewController = {
        let controller = UIViewController()
        let tabItem = UITabBarItem.init(title: "", image: UIImage(named: "Frame 6"), selectedImage: UIImage(named: "Frame 6"))
        controller.tabBarItem = tabItem
        return controller
    }()
    
    let fiftVC: UIViewController = {
        let controller = UIViewController()
        let tabItem = UITabBarItem.init(title: "", image: UIImage(named: "Frame 7"), selectedImage: UIImage(named: "Frame 7"))
        controller.tabBarItem = tabItem
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UITabBarAppearance()
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.stackedLayoutAppearance.normal.iconColor = .black.withAlphaComponent(0.5)
        appearance.stackedLayoutAppearance.selected.iconColor = .black
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        let navController = UINavigationController.init(rootViewController: homeVC)
        viewControllers = [navController, secondVC, thirdVC, fourthVC, fiftVC]
    }
}
