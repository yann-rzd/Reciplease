//
//  RecipeListViewController.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 28/07/2022.
//

import UIKit

final class RecipeListViewController: UIViewController {

    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Reciplease"
        
        recipeTableView.dataSource = self
        recipeTableView.delegate = self
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        recipeTableView.rowHeight = self.view.safeAreaLayoutGuide.layoutFrame.height / 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBindings()
        recipeService.getRecipes()
        self.recipeTableView.reloadData()
    }
    
    // MARK: - INTERNAL: properties
    
    var shouldDisplayFavoriteRecipes: Bool = true

    var recipesToDisplay: [RecipeElements] {
        shouldDisplayFavoriteRecipes ? recipeService.favoriteRecipes : recipeService.recipes
    }

    
    // MARK: - PRIVATE: properties
    
    private let recipeService = RecipeService.shared
//    private let recipeCoreDateService = RecipeCoreDataService.shared
    
    private let recipeTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CustomRecipeTableViewCell.self, forCellReuseIdentifier: CustomRecipeTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - PRIVATE: functions
    
    private func setupView() {
        view.addSubview(recipeTableView)
        NSLayoutConstraint.activate([
            recipeTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            recipeTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            recipeTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            recipeTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
        
    private func setupBindings() {
        recipeService.recipesDidChange = { [weak self] in
            DispatchQueue.main.async {
                self?.recipeTableView.reloadData()
            }
        }
    }
}


// MARK: - Extensions

extension RecipeListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
          return 1
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if recipesToDisplay.count == 0 {
            self.recipeTableView.setEmptyMessage("You don't have any recipes added to your favorites yet.")
            self.recipeTableView.backgroundColor = .mainBackgroundColor
        } else {
            self.recipeTableView.backgroundColor = .mainBackgroundColor
            self.recipeTableView.restore()
        }
        
        return recipesToDisplay.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomRecipeTableViewCell.identifier, for: indexPath) as? CustomRecipeTableViewCell else {
            return UITableViewCell()
        }

        let selectedRecipe = recipesToDisplay[indexPath.row]
        cell.recipeModel = selectedRecipe
        
        return cell
    }
}

extension RecipeListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if shouldDisplayFavoriteRecipes {
            return .delete
        } else {
            return .none
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recipe = recipesToDisplay[indexPath.row]
            guard let recipeLabel = recipe.label else { return }
            recipeService.removeFavoriteRecipe(recipeTitle: recipeLabel)
            self.recipeTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRecipe = recipesToDisplay[indexPath.row]
        
        let recipeDetailsViewController = RecipeDetailsViewController()
        recipeDetailsViewController.selectedRecipe = selectedRecipe
        
        navigationController?.pushViewController(recipeDetailsViewController, animated: true)
        navigationItem.backButtonTitle = "Back"
    }
}
