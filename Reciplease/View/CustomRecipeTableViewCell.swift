//
//  CustomRecipeTableViewCell.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 01/08/2022.
//

import UIKit

final class CustomRecipeTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - INTERNAL: properties
    
    static let identifier = "CustomRecipeTableViewCell"
    
    
    // MARK: - INTERNAL: functions
    
    // MARK: - PRIVATE: properties
    
    private let backgroundImage = UIImageView(image: UIImage(named: "defaultRecipeImage"))
    
    private var recipeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Pizza"
        label.textColor = .white
        label.tintColor = .white
        label.font = .systemFont(ofSize: 22)
        label.backgroundColor = UIColor.green
        return label
    }()
    
    private var ingredientsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Mozzarella, Basil, Large tomato"
        label.textColor = .white
        label.tintColor = .white
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private var recommendationNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "126"
        label.textColor = .white
        label.tintColor = .white
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    private var thumbUpImage: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "hand.thumbsup.fill")
        image.frame = CGRect(x: 10, y: 10, width: 10, height: 10)
        return image
    }()
    
    private var recipeDurationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "15m"
        label.textColor = .white
        label.tintColor = .white
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    private var recipeDurationImage: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "clock.arrow.circlepath")
        image.frame = CGRect(x: 10, y: 10, width: 10, height: 10)
        return image
    }()
    
    private var recipeDescriptionImage: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "defaultRecipeImage")
        image.frame = CGRect(x: 10, y: 10, width: 10, height: 10)
        return image
    }()

    private let recommendationRecipeStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 2
        stackView.backgroundColor = UIColor.mainBackgroundColor
        return stackView
    }()
    
    private let durationRecipeStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 2
        stackView.backgroundColor = UIColor.mainBackgroundColor
        return stackView
    }()
    
    private let indicatorsRecipeStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 2
        stackView.backgroundColor = UIColor.red
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        return stackView
    }()
    
    private let nameAndDescriptionRecipeStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        stackView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        return stackView
    }()
    
    private let mainStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        stackView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        return stackView
    }()
    
    // MARK: - PRIVATE: functions
    
    private func commonInit() -> Void {

        //Recipe indicators container
        recommendationRecipeStackView.addArrangedSubview(recommendationNumberLabel)
        recommendationRecipeStackView.addArrangedSubview(thumbUpImage)
        
        durationRecipeStackView.addArrangedSubview(recipeDurationLabel)
        durationRecipeStackView.addArrangedSubview(recipeDurationImage)
        
        indicatorsRecipeStackView.addArrangedSubview(recommendationRecipeStackView)
        indicatorsRecipeStackView.addArrangedSubview(durationRecipeStackView)
        
        //Recipe name and ingredient container
        nameAndDescriptionRecipeStackView.addArrangedSubview(recipeLabel)
        nameAndDescriptionRecipeStackView.addArrangedSubview(ingredientsLabel)
        
        //Main stackview
        mainStackView.addArrangedSubview(indicatorsRecipeStackView)
        mainStackView.addArrangedSubview(nameAndDescriptionRecipeStackView)
        
        contentView.addSubview(mainStackView)
        
//        NSLayoutConstraint.activate([
//            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            mainStackView.topAnchor.constraint(equalTo: self.topAnchor),
//            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
//            
//        ])
    }

}
