//
//  RecipeListViewController.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 28/07/2022.
//

import UIKit

class RecipeListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Reciplease"
    }
    
    private let ingredientTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CustomRecipeTableViewCell.self, forCellReuseIdentifier: CustomRecipeTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
}
