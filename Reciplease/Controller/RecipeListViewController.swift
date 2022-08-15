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
        setupBindings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        recipeTableView.rowHeight = self.view.safeAreaLayoutGuide.layoutFrame.height / 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRecipes()
        print("❌❌❌ === \(recipesToDisplay)")
        print("👀👀👀 === \(recipeService.favoriteRecipes)")
    }
    
    // MARK: - INTERNAL: properties
    
    var shouldDisplayFavoriteRecipes: Bool = true

    var recipesToDisplay: [RecipeElements] {
        shouldDisplayFavoriteRecipes ? recipeService.favoriteRecipes : recipeService.recipes
    }

    
    // MARK: - PRIVATE: properties
    
    private let recipeService = RecipeService.shared
    private let recipeCoreDateService = RecipeCoreDataService.shared
    
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
    
    private func getRecipes() {
        recipeCoreDateService.getRecipes(callback: { [weak self] recipes in
            self?.recipeService.favoriteRecipes = []
            self?.recipeService.favoriteRecipes = recipes
            self?.recipeTableView.reloadData()
        })
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
        let cellImageName = selectedRecipe.image
        let imageURL = NSURL(string: cellImageName ?? "")
        
        guard let data = NSData(contentsOf: imageURL! as URL) else {
            return UITableViewCell()
            
        }
        
        cell.backgroundView = UIImageView(image: UIImage(data: data as Data))
        cell.backgroundView?.contentMode = .scaleAspectFill
        cell.backgroundView?.clipsToBounds = true
        cell.selectionStyle = .none
        
        cell.recipeModel = selectedRecipe
        
        return cell
    }
}

extension RecipeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRecipe = recipesToDisplay[indexPath.row]
        recipeService.selectedRecipe.append(selectedRecipe)
        let recipeDetailsViewController = RecipeDetailsViewController()
        
        if shouldDisplayFavoriteRecipes == true {
            recipeDetailsViewController.shouldDisplayFavoriteRecipeDetails = true
        } else {
            recipeDetailsViewController.shouldDisplayFavoriteRecipeDetails = false
        }
        
        navigationController?.pushViewController(recipeDetailsViewController, animated: true)
        navigationItem.backButtonTitle = "Back"
    }
}
