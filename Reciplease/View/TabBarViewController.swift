//
//  TabBarViewController.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 28/07/2022.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.mainBackgroundColor
        UITabBar.appearance().backgroundColor = UIColor.mainBackgroundColor
        UITabBar.appearance().barTintColor = .gray
        UINavigationBar.appearance().backgroundColor = UIColor.mainBackgroundColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        tabBar.tintColor = .white
        
        
        setupViewContollers()
    }
    
    func setupViewContollers() {
        viewControllers = [
            createTabBarRootNavigationController(
                for: FridgeViewController(),
                title: NSLocalizedString("Search", comment: ""),
                image: UIImage(systemName: "magnifyingglass")!
            ),
            createTabBarRootNavigationController(
                for: FavoriteRecipeListViewController(),
                title: NSLocalizedString("Favorite", comment: ""),
                image: UIImage(systemName: "star")!
            )
        ]
    }
    
    private func createTabBarRootNavigationController(
        for rootViewController: UIViewController,
        title: String,
        image: UIImage
    ) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        rootViewController.navigationItem.title = title
        return navigationController
    }

}

extension UIColor {
    class var mainBackgroundColor: UIColor {
        if let color = UIColor(named: "mainBackgroundColor") {
            return color
        }
        fatalError("Could not find weatherCellsBackground color")
    }
}


