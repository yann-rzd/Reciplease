//
//  FridgeViewController.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 28/07/2022.
//

import UIKit

class FridgeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupViews()
        
    }
    
    
    private lazy var searchForRecipesButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("SEARCH", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(searchForRecipes), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private func setupViews() {
        setupSearchButton()
        // TODO: Setup other views here
        
        
        
        //-----
    }
    
    private func setupSearchButton() {
        view.addSubview(searchForRecipesButton)
        
        NSLayoutConstraint.activate([
            searchForRecipesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchForRecipesButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    
    @objc func searchForRecipes() {
        let recipeListViewController = RecipeListViewController()
        recipeListViewController.testTitle = "Search Results"
        navigationController?.pushViewController(recipeListViewController, animated: true)
    }
}
