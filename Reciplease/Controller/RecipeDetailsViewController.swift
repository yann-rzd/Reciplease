//
//  RecipeDetailsViewController.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 04/08/2022.
//

import UIKit
import SafariServices

class RecipeDetailsViewController: UIViewController {

    // MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Reciplease"
        ingredientsTableView.dataSource = self
        ingredientsTableView.delegate = self
        recipeService.didProduceError = { [weak self] error in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let alertController = UIAlertController(title: "Error", message: error.errorDescription, preferredStyle: .alert)
                let okAlertAcion = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(okAlertAcion)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        setupViews()
        applyAccessibility()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !isGradientAlreadyAdded {
            recipeImage.addGradient()
            isGradientAlreadyAdded = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBindings()
        recipeService.updateAndNotifyFavoritedStateWithSelectedRecipe(selectedRecipe: selectedRecipe)
    }
    
    
    // MARK: - INTERNAL: properties
    
    var selectedRecipe: RecipeElements?
    
    
    // MARK: - INTERNAL: functions
    
    func setupBindings() {
        recipeService.isRecipeAddedToFavorite = { [weak self] isFavorited in
            DispatchQueue.main.async {
                self?.addFavoriteBarButton.tintColor = isFavorited ? .greenButtonColor : .white
            }
        }
    }
    
    @objc func getDirectionsRecipes() {
        guard let url = selectedRecipe?.url,
              let urlString = URL(string: url) else {
            return
        }
        
        let safariViewController = SFSafariViewController(url: urlString)
        present(safariViewController, animated: true, completion: nil)
        
        safariViewController.delegate = self
    }
    
    @objc func didTapAddFavoriteButton() {
        recipeService.toggleSelectedFavoriteRecipe(selectedRecipe: selectedRecipe)
    }
    
    // MARK: - PRIVATE: properties
    
    private let recipeService = RecipeService.shared
    
    private lazy var addFavoriteBarButton: UIBarButtonItem = {
        let addFavoriteBarButtonImage = UIImage(systemName: "star.fill")
        let addFavoriteBarButton = UIBarButtonItem(image: addFavoriteBarButtonImage, style: .plain, target: self, action: #selector(didTapAddFavoriteButton))
        addFavoriteBarButton.tintColor = .white
        return addFavoriteBarButton
    }()
    
    private let recipeLabelImageIndicatorsView: UIView = {
        let recipeView = UIView()
        recipeView.translatesAutoresizingMaskIntoConstraints = false
        
        return recipeView
    }()
    
    private let recipeImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        
        return image
    }()
    
    private var recipeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "--"
        label.textColor = .white
        label.font = .systemFont(ofSize: 26)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        
        return label
    }()
    
    private var ingredientsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ingredients :"
        label.textColor = .white
        label.font = .systemFont(ofSize: 22)
        return label
    }()
    
    private let ingredientsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CustomIngredientTableViewCell.self, forCellReuseIdentifier: CustomIngredientTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var recommendationNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "--"
        label.textColor = .white
        label.tintColor = .white
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private var thumbUpImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "hand.thumbsup.fill")
        image.tintColor = .white
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private var recipeDurationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "--"
        label.textColor = .white
        label.tintColor = .white
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private var recipeDurationImage: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(systemName: "clock.arrow.circlepath")
        image.tintColor = .white
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let recommendationRecipeStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        stackView.backgroundColor = UIColor.mainBackgroundColor
        return stackView
    }()
    
    private let durationRecipeStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        stackView.backgroundColor = UIColor.mainBackgroundColor
        return stackView
    }()
    
    private let indicatorsRecipeStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        stackView.backgroundColor = UIColor.mainBackgroundColor
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 7, leading: 7, bottom: 7, trailing: 7)
        stackView.layer.borderWidth = 2
        stackView.layer.cornerRadius = 10
        stackView.layer.borderColor = UIColor.white.cgColor
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
    
    private lazy var getDirectionsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Get directions", for: .normal)
        button.backgroundColor = UIColor.greenButtonColor
        button.frame.size.height = 60
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(getDirectionsRecipes), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    var textViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - PRIVATE: functions
    
    private func setupViews() {
        setupContent()
        setupRecipeImage()
        setupIndicators()
        setupRecipeLabel()
        setupRecipeLabelImageIndicatorsView()
        setupIngredients()
        setupGetDirectionsButton()
        setupNavigationBar()
    }
    
    private func applyAccessibility() {
        recipeLabel.accessibilityLabel = "Recipe title"
        recipeLabel.accessibilityTraits = .staticText
        
        recipeImage.accessibilityLabel = "Recipe image"
        recipeImage.accessibilityTraits = .image
        
        addFavoriteBarButton.accessibilityLabel = "Add this recipe in your favorites"
        addFavoriteBarButton.accessibilityTraits = .button
        
        getDirectionsButton.accessibilityLabel = "Get direction to recicpe web page"
        getDirectionsButton.accessibilityTraits = .button
    }
    
    private func setupContent() {
        recipeLabel.text = selectedRecipe?.label
        recommendationNumberLabel.text = selectedRecipe?.yield.description
        recipeDurationLabel.text = selectedRecipe?.time.description
        
        let imageUrl = selectedRecipe?.image
        let imageURL = NSURL(string: imageUrl ?? "")
        guard let data = NSData(contentsOf: imageURL! as URL) else {return}
        let imagedData = data
        
        recipeImage.image = UIImage(data: imagedData as Data)
    }

    private func setupRecipeImage() {
        recipeLabelImageIndicatorsView.addSubview(recipeImage)
        
        NSLayoutConstraint.activate([
            recipeImage.leadingAnchor.constraint(equalTo: recipeLabelImageIndicatorsView.leadingAnchor),
            recipeImage.topAnchor.constraint(equalTo: recipeLabelImageIndicatorsView.topAnchor),
            recipeImage.trailingAnchor.constraint(equalTo: recipeLabelImageIndicatorsView.trailingAnchor),
            recipeImage.bottomAnchor.constraint(equalTo: recipeLabelImageIndicatorsView.bottomAnchor)
        ])
    }
    
    private func setupIndicators() {
        recommendationRecipeStackView.addArrangedSubview(recommendationNumberLabel)
        recommendationRecipeStackView.addArrangedSubview(thumbUpImage)

        durationRecipeStackView.addArrangedSubview(recipeDurationLabel)
        durationRecipeStackView.addArrangedSubview(recipeDurationImage)

        indicatorsRecipeStackView.addArrangedSubview(recommendationRecipeStackView)
        indicatorsRecipeStackView.addArrangedSubview(durationRecipeStackView)

        recipeLabelImageIndicatorsView.addSubview(indicatorsRecipeStackView)

        NSLayoutConstraint.activate([
            indicatorsRecipeStackView.topAnchor.constraint(equalTo: recipeLabelImageIndicatorsView.topAnchor, constant: 10),
            indicatorsRecipeStackView.trailingAnchor.constraint(equalTo: recipeLabelImageIndicatorsView.trailingAnchor, constant: -10)
        ])
    }
    
    private func setupRecipeLabel() {
        recipeLabelImageIndicatorsView.addSubview(recipeLabel)
        recipeLabelImageIndicatorsView.backgroundColor = .clear
        
        
        NSLayoutConstraint.activate([
            recipeLabel.leadingAnchor.constraint(equalTo: recipeLabelImageIndicatorsView.leadingAnchor, constant: 10),
            recipeLabel.trailingAnchor.constraint(equalTo: recipeLabelImageIndicatorsView.trailingAnchor, constant: -10),
            recipeLabel.bottomAnchor.constraint(equalTo: recipeLabelImageIndicatorsView.bottomAnchor, constant: -10)
        ])
    }

    private func setupRecipeLabelImageIndicatorsView() {
        view.addSubview(recipeLabelImageIndicatorsView)
        
        NSLayoutConstraint.activate([
            recipeLabelImageIndicatorsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            recipeLabelImageIndicatorsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            recipeLabelImageIndicatorsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            recipeLabelImageIndicatorsView.bottomAnchor.constraint(equalTo: recipeImage.bottomAnchor)
        ])
    }
    
    private func setupIngredients() {
        ingredientsTableView.rowHeight = UITableView.automaticDimension
        ingredientsTableView.estimatedRowHeight = 44.0
        ingredientsTableView.rowHeight = UITableView.automaticDimension
        ingredientsTableView.backgroundColor = UIColor.mainBackgroundColor
        mainIngredientsListStackView.addArrangedSubview(ingredientsLabel)
        mainIngredientsListStackView.addArrangedSubview(ingredientsTableView)
        
        view.addSubview(mainIngredientsListStackView)
        
        NSLayoutConstraint.activate([
            mainIngredientsListStackView.topAnchor.constraint(equalTo: recipeLabelImageIndicatorsView.bottomAnchor),
            mainIngredientsListStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainIngredientsListStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainIngredientsListStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
        ])
    }
    
    private var isGradientAlreadyAdded = false
    
    private func setupGetDirectionsButton() {
        view.addSubview(getDirectionsButton)

        NSLayoutConstraint.activate([
            getDirectionsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getDirectionsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            getDirectionsButton.topAnchor.constraint(equalTo: mainIngredientsListStackView.bottomAnchor, constant: 20),
            getDirectionsButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            getDirectionsButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItems = [
            addFavoriteBarButton
        ]
    }
}

// MARK: - EXTENSIONS

extension RecipeDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let ingredientsNumber = selectedRecipe?.ingredientsList else {
            return 0
        }
            return ingredientsNumber.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomIngredientTableViewCell.identifier, for: indexPath) as? CustomIngredientTableViewCell else {
            return UITableViewCell()
        }
        
        let ingredients = selectedRecipe?.ingredientsList?[indexPath.row]
        cell.ingredientName = ingredients
        return cell
    }
}

extension RecipeDetailsViewController: UITableViewDelegate { }

extension RecipeDetailsViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension UIView {
    func addGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds

        let startColor = UIColor.clear.cgColor
        let endColor = UIColor.black.cgColor
        gradient.colors = [startColor, endColor]
        gradient.locations = [0.0, 1.0]
        self.layer.insertSublayer(gradient, at: 10)
    }
}
