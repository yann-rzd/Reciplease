//
//  FridgeViewController.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 28/07/2022.
//

import UIKit

final class FridgeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Reciplease"
        ingredientTableView.dataSource = self
        ingredientTableView.delegate = self
        ingredientAdderTextField.delegate = self
        setupViews()
        setupToolBar()
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
        
        fridgeService.didProduceError = { [weak self] myError in
            let alertController = UIAlertController(
                title: "Error",
                message: myError.errorDescription,
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            self?.present(alertController, animated: true)
        }
        
        fridgeService.canAddIngredientDidChange = { [weak self] canAddIngredient in
            self?.addIngredientButton.tintColor = !canAddIngredient ? .green : .gray
            self?.addIngredientButton.isEnabled = !canAddIngredient ? true : false
        }
        
        fridgeService.canClearIngredientsDidChange = { [weak self] canClear in
            self?.clearIngredientsButton.isHidden = !canClear ? false : true
        }
        
        recipeService.isLoadingChanged = { [weak self] isLoading in
            DispatchQueue.main.async {
                let buttonTitle = isLoading ? "" : "Search recipes"
                self?.searchForRecipesButton.setTitle(buttonTitle, for: .normal)
                self?.activityIndicator.isHidden = !isLoading
                
                if isLoading {
                    self?.activityIndicator.startAnimating()
                }
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
//        recipeService.fetchRecipes(ingredients: fridgeService.addedIngredients)
        
        recipeService.fetchRecipes(ingredients: fridgeService.addedIngredients) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.alertViewService.displayAlert(on: self, error: error)
                case .success:
                    break
                }
            }
        }
        
        recipeService.isFetchingRecipesSuccess = { [weak self] isSuccess in
            DispatchQueue.main.async {
                if isSuccess {
                    let recipeListViewController = RecipeListViewController()
                    self?.navigationController?.pushViewController(recipeListViewController, animated: true)
                    self?.navigationItem.backButtonTitle = "Back"
                }
            }
        }
        
//        let recipeListViewController = RecipeListViewController()
//        navigationController?.pushViewController(recipeListViewController, animated: true)
//        navigationItem.backButtonTitle = "Back"
    }
    
    
    // MARK: - PRIVATE: properties
    
    private let fridgeService = FridgeService.shared
    private let recipeService = RecipeService.shared
    private let alertViewService = AlertViewService.shared
    
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
        button.tintColor = .gray
        button.isEnabled = false
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
        button.isHidden = true
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
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        return activityIndicator
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
    
    private func setupToolBar() {
        let toolBar = UIToolbar()
        
        let clearButton = UIBarButtonItem(
            title: "CLEAR",
            primaryAction: UIAction(handler: { [weak self] _ in self?.fridgeService.emptyIngredientText() } )
        )
        
        clearButton.tintColor = .gray
        
        let doneButton = UIBarButtonItem(
            title: "DONE",
            primaryAction: UIAction(handler: { [weak self] _ in self?.view.endEditing(true) } )
        )
        
        toolBar.items = [
            clearButton,
            .flexibleSpace(),
            doneButton
           
        ]
        
        toolBar.sizeToFit()
        ingredientAdderTextField.inputAccessoryView = toolBar
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
        searchForRecipesButton.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            searchForRecipesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchForRecipesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            searchForRecipesButton.topAnchor.constraint(equalTo: mainIngredientsListStackView.bottomAnchor, constant: 20),
            searchForRecipesButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            searchForRecipesButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: searchForRecipesButton.centerYAnchor)
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
        
        let addedIngredient = fridgeService.addedIngredients[indexPath.row].capitalized
        cell.ingredientName = addedIngredient
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


extension FridgeViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let textFieldText = textField.text,
              let rangeIn = Range(range, in: textFieldText)
        else {
            return false
        }
        
        if string == "" && textFieldText.count == 1 {
            fridgeService.ingredientText = ""
            return false
        }
        
        let valueToConvertText = textFieldText.replacingCharacters(in: rangeIn, with: string)
    
        fridgeService.ingredientText = valueToConvertText
        
        return false
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
