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
        apllyAccessibility()
        setupToolBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            self?.addIngredientButton.backgroundColor = !canAddIngredient ? .greenButtonColor : .lightGrayColor
            if !canAddIngredient {
                self?.addIngredientButton.setTitleColor(.white, for: .normal)
            } else {
                self?.addIngredientButton.setTitleColor(.grayColor, for: .normal)
            }
            self?.addIngredientButton.isEnabled = !canAddIngredient ? true : false
        }
        
        fridgeService.canClearIngredientsDidChange = { [weak self] canClear in
            DispatchQueue.main.async {
                self?.clearIngredientsButton.isHidden = !canClear ? false : true
            }
        }
        
        recipeService.isLoadingChanged = { [weak self] isLoading in
            DispatchQueue.main.async {
                let buttonTitle = isLoading ? "" : "Search recipes"
                self?.searchForRecipesButton.setTitle(buttonTitle, for: .normal)
                self?.activityIndicator.isHidden = !isLoading
                self?.searchForRecipesButton.isEnabled = !isLoading
                
                if isLoading {
                    self?.activityIndicator.startAnimating()
                }
            }
        }
        
        fridgeService.isSearchEnabled = { [weak self] isSearchEnabled in
            DispatchQueue.main.async {
                self?.searchForRecipesButton.isHidden = !isSearchEnabled
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
        recipeService.removeRecipes()
        recipeService.fetchRecipes(ingredients: fridgeService.addedIngredients)

        recipeService.isFetchingRecipesSuccess = { [weak self] isSuccess in
            DispatchQueue.main.async {
                if isSuccess {
                    guard let recipes = self?.recipeService.recipes,
                          !recipes.isEmpty  else {
                        self?.alertViewService.displayAlert(on: self!, error: RecipeServiceError.noRecipeFound)
                        return
                    }
                    let recipeListViewController = RecipeListViewController()
                    recipeListViewController.shouldDisplayFavoriteRecipes = false
                    self?.navigationController?.pushViewController(recipeListViewController, animated: true)
                    self?.navigationItem.backButtonTitle = "Back"
                }
            }
        }
    }
    
    
    // MARK: - PRIVATE: properties
    
    private let fridgeService = FridgeService.shared
    private let recipeService = RecipeService.shared
    private let alertViewService = AlertViewService.shared
    
    private var whatsInYourFridgeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "What's in your fridge ?"
        label.textColor = .blackColor
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    private var ingredientAdderTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 18)
        textField.textColor = .blackColor
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.attributedPlaceholder = NSAttributedString(
            string: "Lemon, Cheese, Sausages...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray.withAlphaComponent(0.5)]
        )
        textField.addUnderLine()
        return textField
    }()
    
    private var addIngredientButton: UIButton = {
        let button = UIButton()
//        button.configuration = .tinted()
        button.setTitle("Add", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.text = "Add"
        button.titleLabel?.font = .systemFont(ofSize: 18.0, weight: .regular)
        button.backgroundColor = .lightGrayColor
        button.setTitleColor(.grayColor, for: .normal)
        button.layer.cornerRadius = 5
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
        stackView.distribution = .fillProportionally
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
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(searchForRecipes), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true

        return button
    }()
    
    
    // MARK: - PRIVATE: functions
    
    private func setupViews() {
        setupIngredientAdderContainer()
        setupingredientsLabelClearButtonAndIngredientsList()
        setupSearchButton()
    }
    
    private func apllyAccessibility() {
        ingredientAdderTextField.accessibilityLabel = "Please write here your ingredients"
        ingredientAdderTextField.isAccessibilityElement = true
        ingredientAdderTextField.font = .preferredFont(forTextStyle: .body)
        ingredientAdderTextField.adjustsFontForContentSizeCategory = true
        
        addIngredientButton.accessibilityLabel = "Validate your ingredient"
        addIngredientButton.accessibilityTraits = .button
        
        clearIngredientsButton.accessibilityLabel = "Delete all"
        clearIngredientsButton.accessibilityTraits = .button
        
        activityIndicator.accessibilityLabel = "Loading recipes indicator"
        activityIndicator.isAccessibilityElement = true
        
        searchForRecipesButton.accessibilityLabel = "Search for recipes"
        searchForRecipesButton.accessibilityTraits = .button
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
    
    private func setupingredientsLabelClearButtonAndIngredientsList() {
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
        if fridgeService.addedIngredients.count == 0 {
            self.ingredientTableView.setEmptyMessage("You haven't added any ingredients yet.")
        } else {
            self.ingredientTableView.restore()
        }
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
}

extension FridgeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            fridgeService.removeIngredient(ingredientIndex: indexPath.row)
        }
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

extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .lightGrayColor
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
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
        fatalError("Could not find color")
    }
    
    class var blackColor: UIColor {
        if let color = UIColor(named: "blackColor") {
            return color
        }
        fatalError("Could not find color")
    }
    
    class var grayColor: UIColor {
        if let color = UIColor(named: "grayColor") {
            return color
        }
        fatalError("Could not find color")
    }
    
    class var lightGrayColor: UIColor {
        if let color = UIColor(named: "lightGrayColor") {
            return color
        }
        fatalError("Could not find color")
    }
    
    class var darkGreenColor: UIColor {
        if let color = UIColor(named: "darkGreenColor") {
            return color
        }
        fatalError("Could not find color")
    }
}
