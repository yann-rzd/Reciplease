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
        self.title = "Reciplease"
        ingredientTableView.dataSource = self
        ingredientTableView.delegate = self
        setupViews()
        setupBindinds()
    }
    
    // MARK: - INTERNAL: properties
    

    
    
    // MARK: - INTERNAL: functions
    
    func setupBindinds() {
        fridgeService.ingredientsDidChange = { [weak self] in
            DispatchQueue.main.async {
                self?.ingredientTableView.reloadData()
            }
        }
        
        fridgeService.ingredientTextDidChange = { [weak self] ingredientToAdd in
            DispatchQueue.main.async {
                self?.ingredientAdderTextField.text = ingredientToAdd
            }
        }
    }
    
    @objc func addIngredient() {
        guard let ingredient = ingredientAdderTextField.text else { return }
        fridgeService.add(ingredient: ingredient)
        fridgeService.emptyIngredientText()
    }
    
    @objc func clearIngredients() {
        fridgeService.clearIngredientsList()
    }
    
    @objc func searchForRecipes() {
        let recipeListViewController = RecipeListViewController()
        recipeListViewController.testTitle = "Search Results"
        navigationController?.pushViewController(recipeListViewController, animated: true)
    }
    
    
    // MARK: - PRIVATE: properties
    
    private let fridgeService = FridgeService.shared
    
    private var whatsInYourFridgeLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "What's in your fridge ?"
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        
        
        return label
    }()
    
    private var ingredientAdderTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "Lemon, Cheese, Sausages..."
        textField.font = .systemFont(ofSize: 18)
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.addUnderLine()
        
        return textField
    }()
    
    private var addIngredientButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.configuration = .tinted()
        button.setTitle("Add", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.text = "Add"
        button.titleLabel?.font = .systemFont(ofSize: 18.0, weight: .regular)
        button.tintColor = .green
        button.addTarget(self, action: #selector(addIngredient), for: .touchUpInside)
        return button
    }()
    
    private var yourIngredientsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Your ingredients :"
        label.textColor = .white
        label.font = .systemFont(ofSize: 22)
        return label
    }()
    
    private var clearIngredientsButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.configuration = .tinted()
        button.setTitle("Clear all", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.text = "Clear"
        button.titleLabel?.font = .systemFont(ofSize: 18.0, weight: .regular)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(clearIngredients), for: .touchUpInside)
        return button
    }()
    
    private let indicateAndAddIngredientStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 1
        stackView.alignment = .firstBaseline

        return stackView
    }()
    
    private let ingredientsLabelAndClearButtonStackView : UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
//        stackView.isLayoutMarginsRelativeArrangement = true
//        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        return stackView
    }()
    
    private let ingredientAdderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.backgroundColor = .white
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        return stackView
    }()
    
    private let mainIngredientsListStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.backgroundColor = UIColor.mainBackgroundColor
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        return stackView
    }()
    
    private let ingredientTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CustomIngredientTableViewCell.self, forCellReuseIdentifier: CustomIngredientTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var searchForRecipesButton: UIButton = {
        let button = UIButton()

        button.setTitle("Search for recipes", for: .normal)
        button.backgroundColor = UIColor.greenButtonColor
        button.frame.size.height = 60
        button.addTarget(self, action: #selector(searchForRecipes), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    
    // MARK: - PRIVATE: functions
    
    private func setupViews() {
        setupIngredientAdderContainer()
        setupingredientsLabelAndClearButton()
        setupSearchButton()
        
    }
    
    private func setupIngredientAdderContainer() {
        indicateAndAddIngredientStackView.addArrangedSubview(ingredientAdderTextField)
        indicateAndAddIngredientStackView.addArrangedSubview(addIngredientButton)
        ingredientAdderStackView.addArrangedSubview(whatsInYourFridgeLabel)
        ingredientAdderStackView.addArrangedSubview(indicateAndAddIngredientStackView)
        
        view.addSubview(ingredientAdderStackView)
        
        NSLayoutConstraint.activate([
            ingredientAdderStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            ingredientAdderStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            ingredientAdderStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
    
    private func setupingredientsLabelAndClearButton() {
        ingredientTableView.backgroundColor = UIColor.mainBackgroundColor
        ingredientsLabelAndClearButtonStackView.addArrangedSubview(yourIngredientsLabel)
        ingredientsLabelAndClearButtonStackView.addArrangedSubview(clearIngredientsButton)
        mainIngredientsListStackView.addArrangedSubview(ingredientsLabelAndClearButtonStackView)
        mainIngredientsListStackView.addArrangedSubview(ingredientTableView)
        
        view.addSubview(mainIngredientsListStackView)
        
        NSLayoutConstraint.activate([
            mainIngredientsListStackView.topAnchor.constraint(equalTo: ingredientAdderStackView.bottomAnchor),
            mainIngredientsListStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainIngredientsListStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainIngredientsListStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
        ])
    }
    
    private func setupSearchButton() {
        view.addSubview(searchForRecipesButton)

        NSLayoutConstraint.activate([
            searchForRecipesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchForRecipesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            searchForRecipesButton.topAnchor.constraint(equalTo: mainIngredientsListStackView.bottomAnchor, constant: 20),
            searchForRecipesButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            searchForRecipesButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
            
        ])
    }
    
    
}

extension FridgeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fridgeService.addedIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomIngredientTableViewCell.identifier, for: indexPath) as? CustomIngredientTableViewCell else {
            return UITableViewCell()
        }
        let addedIngredient = fridgeService.addedIngredients[indexPath.row]
//        fridgeService.add(ingredient: addedIngredient)
        cell.ingredientName = addedIngredient
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension FridgeViewController: UITableViewDelegate {

}

extension UITextField {
    
    func addUnderLine () {
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: self.frame.height + 30, width: self.frame.width + 280, height: 1) // Automatic width underlined ?
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
        
    }
    
}

extension UIColor {
    class var greenButtonColor: UIColor {
        if let color = UIColor(named: "greenButtonColor") {
            return color
        }
        fatalError("Could not find weatherCellsBackground color")
    }
}
