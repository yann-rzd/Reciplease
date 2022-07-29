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
    
    // MARK: - INTERNAL: properties
    
    // MARK: - INTERNAL: functions
    
    @objc func addIngredient() {
        
    }
    
    @objc func searchForRecipes() {
        let recipeListViewController = RecipeListViewController()
        recipeListViewController.testTitle = "Search Results"
        navigationController?.pushViewController(recipeListViewController, animated: true)
    }
    
    
    // MARK: - PRIVATE: properties
    
    private var whatsInYourFridgeLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "What's in your fridge ?"
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        
        
        return label
    }()
    
    private var IngredientAdderTextField: UITextField = {
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
        
        button.addTarget(FridgeViewController.self, action: #selector(addIngredient), for: .touchUpInside)
        return button
    }()
    
    private let indicateAndAddIngredientStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.alignment = .firstBaseline
        return stackView
    }()
    
    private let mainContainerIngredientAdderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 20
        return stackView
    }()
    
//    private lazy var searchForRecipesButton: UIButton = {
//        let button = UIButton()
//
//        button.setTitle("SEARCH", for: .normal)
//        button.setTitleColor(.blue, for: .normal)
//        button.addTarget(self, action: #selector(searchForRecipes), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//
//        return button
//    }()
    
    
    // MARK: - PRIVATE: functions
    
    private func setupViews() {
        setupIngredientAdderContainer()
//        setupSearchButton()
        
    }
    
    private func setupIngredientAdderContainer() {
        indicateAndAddIngredientStackView.addArrangedSubview(IngredientAdderTextField)
        indicateAndAddIngredientStackView.addArrangedSubview(addIngredientButton)
        mainContainerIngredientAdderStackView.addArrangedSubview(whatsInYourFridgeLabel)
        mainContainerIngredientAdderStackView.addArrangedSubview(indicateAndAddIngredientStackView)
        
        view.addSubview(mainContainerIngredientAdderStackView)
        
        NSLayoutConstraint.activate([
            mainContainerIngredientAdderStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainContainerIngredientAdderStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mainContainerIngredientAdderStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
    }
    
//    private func setupSearchButton() {
//        view.addSubview(searchForRecipesButton)
//
//        NSLayoutConstraint.activate([
//            searchForRecipesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            searchForRecipesButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//    }
    
    
}

extension UITextField {
    
    func addUnderLine () {
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: self.frame.height + 30, width: self.frame.width + 277, height: 1) // Automatic width underlined ?
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
        
    }
    
}
