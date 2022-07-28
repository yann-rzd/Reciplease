//
//  TabBarViewController.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 28/07/2022.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        
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
                for: RecipeListViewController(),
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
