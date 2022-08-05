//
//  CustomIngredientAdderTableViewCell.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 29/07/2022.
//

import UIKit

final class CustomIngredientTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    
    // MARK: - INTERNAL: properties
    
    static let identifier = "CustomIngredientTableViewCell"
    
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
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    // MARK: - PRIVATE: functions
    
    private func commonInit() -> Void {
        contentView.backgroundColor = UIColor.mainBackgroundColor
        contentView.addSubview(ingredientLabel)
        
        NSLayoutConstraint.activate([
            ingredientLabel.topAnchor.constraint(equalTo: self.topAnchor),
            ingredientLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            ingredientLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}

extension UIColor {
    class var ingredientCellBackgroundColor: UIColor {
        if let color = UIColor(named: "mainBackgroundColor") {
            return color
        }
        fatalError("Could not find weatherCellsBackground color")
    }
}
