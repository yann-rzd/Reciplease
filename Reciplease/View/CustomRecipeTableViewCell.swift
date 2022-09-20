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
    
    var recipeModel: RecipeElements? {
        didSet {
            guard let recipeModel = recipeModel else { return }
            recipeLabel.text = recipeModel.label
            ingredientsLabel.text = recipeModel.ingredients
            recommendationNumberLabel.text = String(describing: recipeModel.yield)
            recipeDurationLabel.text = String(describing: recipeModel.time) + "m"
            triggerBackgroundRecipeImageAssignmentProcess(imageUrlString: recipeModel.image)
        }
    }
    
    
    // MARK: - INTERNAL: functions
    
    // MARK: - PRIVATE: properties
    
    private var recipeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Pizza"
        label.textColor = .white
        label.tintColor = .white
        label.font = .systemFont(ofSize: 22)
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
    
    private let nameAndDescriptionRecipeStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 2
        stackView.backgroundColor = UIColor.white.withAlphaComponent(0)
        return stackView
    }()

    
    // MARK: - PRIVATE: functions
    
    private func commonInit() -> Void {

        selectionStyle = .none
        
        //Recipe indicators container
        recommendationRecipeStackView.addArrangedSubview(recommendationNumberLabel)
        recommendationRecipeStackView.addArrangedSubview(thumbUpImage)

        durationRecipeStackView.addArrangedSubview(recipeDurationLabel)
        durationRecipeStackView.addArrangedSubview(recipeDurationImage)

        indicatorsRecipeStackView.addArrangedSubview(recommendationRecipeStackView)
        indicatorsRecipeStackView.addArrangedSubview(durationRecipeStackView)

        nameAndDescriptionRecipeStackView.addArrangedSubview(recipeLabel)
        nameAndDescriptionRecipeStackView.addArrangedSubview(ingredientsLabel)

        contentView.addSubview(indicatorsRecipeStackView)
        contentView.addSubview(nameAndDescriptionRecipeStackView)

        NSLayoutConstraint.activate([
            indicatorsRecipeStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            indicatorsRecipeStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            nameAndDescriptionRecipeStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            nameAndDescriptionRecipeStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    private func triggerBackgroundRecipeImageAssignmentProcess(imageUrlString: String?) {
        
        changeBackgroundImage(to: nil)
        
        guard let imageUrlString = imageUrlString else {
            return
        }
        
        getImageData(imageUrlString: imageUrlString) { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success((let fetchImageUrlString, let backgroundImageData)):
                    guard
                        let currentRecipeImageUrlString = self?.recipeModel?.image,
                        currentRecipeImageUrlString == fetchImageUrlString else { return }
                    let image = UIImage(data: backgroundImageData)
                    self?.changeBackgroundImage(to: image)
                case .failure:
                    self?.changeBackgroundImage(to: nil)
                    return
                }
               
            }
        }
    }
    
    private let defaultImage = UIImage(named: "default_image")
    
    
    private func changeBackgroundImage(to image: UIImage?) {
        let imageView = UIImageView(image: image ?? defaultImage)
        imageView.addBlackGradientLayerInBackground(frame: self.bounds, colors: [.clear, .black])
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        backgroundView = imageView
    }

    
    private func getImageData(
        imageUrlString: String,
        completionHandler: @escaping (Result<(String, Data), NetworkServiceError>) -> Void
    ) {
        DispatchQueue.global(qos: .background).async {
            if
                let imageURL = URL(string: imageUrlString),
                let backgroundImageData = try? Data(contentsOf: imageURL)
             {
                completionHandler(
                    .success(
                        (imageUrlString, backgroundImageData)
                    )
                )
            }
        }
    }

}

extension UIView{
   // For insert layer in Foreground
   func addBlackGradientLayerInForeground(frame: CGRect, colors:[UIColor]){
    let gradient = CAGradientLayer()
    gradient.frame = frame
    gradient.colors = colors.map{$0.cgColor}
    self.layer.addSublayer(gradient)
   }
   // For insert layer in background
   func addBlackGradientLayerInBackground(frame: CGRect, colors:[UIColor]){
    let gradient = CAGradientLayer()
    gradient.frame = frame
    gradient.colors = colors.map{$0.cgColor}
    self.layer.insertSublayer(gradient, at: 0)
   }
}
