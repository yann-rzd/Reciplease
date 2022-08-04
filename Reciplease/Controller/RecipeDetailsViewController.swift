//
//  RecipeDetailsViewController.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 04/08/2022.
//

import UIKit

class RecipeDetailsViewController: UIViewController {

    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Reciplease"
        ingredientsTableView.dataSource = self
        ingredientsTableView.delegate = self
        setupViews()
    }
    
    // MARK: - INTERNAL: functions
    
    @objc func getDirectionsRecipes() {
        
    }
    
    @objc func didTapAddFavoriteButton() {
        
    }
    
    // MARK: - PRIVATE: properties
    
    private let fridgeService = FridgeService.shared
    
    private lazy var addFavoriteBarButton: UIBarButtonItem = {
        let addCityBarButtonImage = UIImage(systemName: "star.fill")
        let addCityBarButton = UIBarButtonItem(image: addCityBarButtonImage, style: .plain, target: self, action: #selector(didTapAddFavoriteButton))
        addCityBarButton.tintColor = .white
        return addCityBarButton
    }()
    
    private let recipeImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "defaultRecipeImage")
        image.tintColor = .white
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private var recipeLabel: UITextField = {
        let label = UITextField()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Pizza"
        label.textAlignment = .center
        label.contentVerticalAlignment = .bottom
        label.textColor = .white
        label.tintColor = .white
        label.font = .systemFont(ofSize: 26)
        label.backgroundColor = UIColor(patternImage: UIImage(named: "defaultRecipeImage")!)
        
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
        tableView.register(CustomIngredientDetailsTableViewCell.self, forCellReuseIdentifier: CustomIngredientDetailsTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var recommendationNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "126"
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
        label.text = "15m"
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
        button.addTarget(self, action: #selector(getDirectionsRecipes), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    // MARK: - PRIVATE: functions
    
    private func setupViews() {
        setupRecipeLabelWithimage()
        setupIndicators()
        setupIngredients()
        setupGetDirectionsButton()
        setupNavigationBar()
        
    }
    
    private func setupRecipeLabelWithimage() {
        view.addSubview(recipeLabel)
        NSLayoutConstraint.activate([
            recipeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            recipeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            recipeLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            recipeLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -400)
        ])
    }
    
    private func setupIndicators() {
        recommendationRecipeStackView.addArrangedSubview(recommendationNumberLabel)
        recommendationRecipeStackView.addArrangedSubview(thumbUpImage)

        durationRecipeStackView.addArrangedSubview(recipeDurationLabel)
        durationRecipeStackView.addArrangedSubview(recipeDurationImage)

        indicatorsRecipeStackView.addArrangedSubview(recommendationRecipeStackView)
        indicatorsRecipeStackView.addArrangedSubview(durationRecipeStackView)
        
        view.addSubview(indicatorsRecipeStackView)
        
        NSLayoutConstraint.activate([
            indicatorsRecipeStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            indicatorsRecipeStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
    
    private func setupIngredients() {
        ingredientsTableView.backgroundColor = UIColor.mainBackgroundColor
        mainIngredientsListStackView.addArrangedSubview(ingredientsLabel)
        mainIngredientsListStackView.addArrangedSubview(ingredientsTableView)
        
        view.addSubview(mainIngredientsListStackView)
        
        NSLayoutConstraint.activate([
            mainIngredientsListStackView.topAnchor.constraint(equalTo: recipeLabel.bottomAnchor),
            mainIngredientsListStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainIngredientsListStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainIngredientsListStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
        ])
    }
    
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomIngredientDetailsTableViewCell.identifier, for: indexPath) as? CustomIngredientDetailsTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


extension RecipeDetailsViewController: UITableViewDelegate {

}
