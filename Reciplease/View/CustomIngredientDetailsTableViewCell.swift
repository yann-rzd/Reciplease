//
//  CustomIngredientDetailsTableViewCell.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 04/08/2022.
//

import UIKit

class CustomIngredientDetailsTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    
    // MARK: - INTERNAL: properties
    
    static let identifier = "CustomIngredientDetailsTableViewCell"
    
    var ingredientName: String? {
        didSet {
            ingredientLabel.text = "- \(ingredientName ?? "")"
        }
    }
    
    
    // MARK: - PRIVATE: properties
    
    private var ingredientLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "- Tomatoes"
        label.textColor = .white
        label.tintColor = .white
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    // MARK: - PRIVATE: functions
    
    private func commonInit() -> Void {
        contentView.backgroundColor = UIColor.mainBackgroundColor
        contentView.addSubview(ingredientLabel)
        
        NSLayoutConstraint.activate([
            ingredientLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            ingredientLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}

