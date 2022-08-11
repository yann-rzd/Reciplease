//
//  FavoriteRecipeDetailsViewControllerTableViewController.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 09/08/2022.
//

import UIKit
import SafariServices

class FavoriteRecipeDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Reciplease"
        ingredientsTableView.dataSource = self
        ingredientsTableView.delegate = self
        setupViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        recipeService.removeSelectedFavoriteRecipe()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        ingredientsTableView.rowHeight = self.view.safeAreaLayoutGuide.layoutFrame.height / 11
        recipeLabel.scrollRangeToVisible(NSMakeRange(0, 0))
    }
    
    // MARK: - INTERNAL: functions
    
    @objc func getDirectionsRecipes() {
        guard let url = recipeService.selectedRecipe.first?.url,
              let urlString = URL(string: url) else {
            return
        }
        
        let safariVC = SFSafariViewController(url: urlString)
        present(safariVC, animated: true, completion: nil)
        
        safariVC.delegate = self
    }
    
    // MARK: - PRIVATE: properties
    
    private let recipeService = RecipeService.shared
    
    private let recipeImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "defaultRecipeImage")
        image.tintColor = .white
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private var recipeLabel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Pizza"
        label.textContainerInset = UIEdgeInsets(top: 150, left: 8, bottom: 0, right: 8)
        label.textAlignment = .center
        label.textColor = .white
        label.tintColor = .white
        label.font = .systemFont(ofSize: 26)
        label.isEditable = false
        label.layer.contents = UIImage(named: "defaultRecipeImage")
        
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
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(getDirectionsRecipes), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    var textViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - PRIVATE: functions
    
    private func setupViews() {
        setupRecipeLabelWithimage()
        setupIndicators()
        setupIngredients()
        setupGetDirectionsButton()
        setupContent()
        
    }
    
    private func setupContent() {
        recipeLabel.text = recipeService.selectedFavoriteRecipe.first?.title
        recommendationNumberLabel.text = recipeService.selectedFavoriteRecipe.first?.yield.description
        recipeDurationLabel.text = recipeService.selectedFavoriteRecipe.first?.recipeTime.description
        
        let imageUrl = recipeService.selectedFavoriteRecipe.first?.imageUrl
        let imageURL = NSURL(string: imageUrl ?? "")
        guard let data = NSData(contentsOf: imageURL! as URL) else {return}
        let imagedData = data
        recipeLabel.layer.contents = UIImage(data: imagedData as Data)?.cgImage
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
        ingredientsTableView.rowHeight = UITableView.automaticDimension
        ingredientsTableView.estimatedRowHeight = 44.0
        ingredientsTableView.rowHeight = UITableView.automaticDimension
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
}

// MARK: - EXTENSIONS

extension FavoriteRecipeDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let ingredientsAsString = recipeService.selectedFavoriteRecipe.first?.ingredientsDetails
        guard let ingredientsAsData = ingredientsAsString?.data(using: String.Encoding.utf16) else {
            return 0
            
        }
        
        if let ingredientsArray: [String] = try? JSONDecoder().decode([String].self, from: ingredientsAsData) {
            return ingredientsArray.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomIngredientTableViewCell.identifier, for: indexPath) as? CustomIngredientTableViewCell else {
            return UITableViewCell()
        }
        
        let ingredientsAsString = recipeService.selectedFavoriteRecipe.first?.ingredientsDetails
        guard let ingredientsAsData = ingredientsAsString?.data(using: String.Encoding.utf16) else {
            return UITableViewCell()
            
        }
        
        if let ingredientsArray: [String] = try? JSONDecoder().decode([String].self, from: ingredientsAsData) {
            let ingredients = ingredientsArray[indexPath.row]
            cell.ingredientName = ingredients
            cell.ingredientLabel.sizeToFit()
            cell.ingredientLabel.isEditable = false
            cell.ingredientLabel.textColor = .white
            cell.ingredientLabel.font = .systemFont(ofSize: 16)
            cell.ingredientLabel.backgroundColor = .mainBackgroundColor
            return cell
        } else {
            return UITableViewCell()
        }
        
        
    }
}

extension FavoriteRecipeDetailsViewController: UITableViewDelegate { }

extension FavoriteRecipeDetailsViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
