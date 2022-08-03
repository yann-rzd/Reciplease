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
    
    
    
    
    // MARK: - PRIVATE: properties
    
    private let fridgeService = FridgeService.shared
    
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
        fridgeService.recipesDidChange = { [weak self] in
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
        return fridgeService.recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomRecipeTableViewCell.identifier, for: indexPath) as? CustomRecipeTableViewCell else {
            return UITableViewCell()
        }
        
        cell.backgroundView = UIImageView(image: UIImage(named: "defaultRecipeImage")!)
        let selectedRecipe = fridgeService.recipes[indexPath.row]
        cell.recipeModel = selectedRecipe
        
        return cell
    }

}

extension RecipeListViewController: UITableViewDelegate {

}
