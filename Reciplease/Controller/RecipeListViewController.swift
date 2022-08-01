//
//  RecipeListViewController.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 28/07/2022.
//

import UIKit

final class RecipeListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Reciplease"
        
        recipeTableView.dataSource = self
        recipeTableView.delegate = self
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        recipeTableView.frame = view.bounds
        recipeTableView.rowHeight = self.view.safeAreaLayoutGuide.layoutFrame.height / 4
    }
    
    private let recipeTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CustomRecipeTableViewCell.self, forCellReuseIdentifier: CustomRecipeTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    func setupView() {
        view.addSubview(recipeTableView)
        NSLayoutConstraint.activate([
            recipeTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            recipeTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            recipeTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            recipeTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
}

extension RecipeListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
          return 1
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomRecipeTableViewCell.identifier, for: indexPath) as? CustomRecipeTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundView = UIImageView(image: UIImage(named: "defaultRecipeImage")!)

        return cell
    }

}

extension RecipeListViewController: UITableViewDelegate {

}
