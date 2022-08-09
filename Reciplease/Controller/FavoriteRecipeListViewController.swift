//
//  FavoriteRecipeViewController.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 05/08/2022.
//

import UIKit

class FavoriteRecipeListViewController: UIViewController {

    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Reciplease"
        
        recipeTableView.dataSource = self
        recipeTableView.delegate = self
        setupView()
        setupBindings()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getRecipes()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        recipeTableView.rowHeight = self.view.safeAreaLayoutGuide.layoutFrame.height / 5
    }
    
    
    // MARK: - PRIVATE: properties
    
    private let recipeService = RecipeService.shared
    
    private let recipeTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CustomFavoriteRecipeTableViewCell.self, forCellReuseIdentifier: CustomFavoriteRecipeTableViewCell.identifier)
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
        recipeService.favoriteRecipesDidChange = { [weak self] in
            DispatchQueue.main.async {
                self?.recipeTableView.reloadData()
            }
        }
    }
    
    private func getRecipes() {
        recipeService.getRecipes(callback: { [weak self] recipes in
            self?.recipeService.favoriteRecipes = []
            self?.recipeService.favoriteRecipes = recipes
            self?.recipeTableView.reloadData()
        })
    }
}

extension FavoriteRecipeListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
          return 1
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeService.favoriteRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomFavoriteRecipeTableViewCell.identifier, for: indexPath) as? CustomFavoriteRecipeTableViewCell else {
            return UITableViewCell()
        }

        let selectedRecipe = recipeService.favoriteRecipes[indexPath.row]
        let cellImageName = selectedRecipe.imageUrl
        let imageURL = NSURL(string: cellImageName ?? "")
        guard let data = NSData(contentsOf: imageURL! as URL) else {return UITableViewCell()}
        let imagedData = data
        cell.backgroundView = UIImageView(image: UIImage(data: imagedData as Data)!)
        cell.backgroundView?.contentMode = .scaleAspectFill
        cell.backgroundView?.clipsToBounds = true
        cell.selectionStyle = .none
        
        cell.recipeModel = selectedRecipe
        
        return cell
    }
}

extension FavoriteRecipeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRecipe = recipeService.favoriteRecipes[indexPath.row]
        recipeService.selectedFavoriteRecipe.append(selectedRecipe)
        let recipeDetailsViewController = FavoriteRecipeDetailsViewController()
        navigationController?.pushViewController(recipeDetailsViewController, animated: true)
        navigationItem.backButtonTitle = "Back"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recipe = recipeService.favoriteRecipes[indexPath.row]
            recipeService.removeRecipe(recipe: recipe, callback: { [weak self] in
                self?.getRecipes()
            })
        }
    }
}
