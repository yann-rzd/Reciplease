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
    
    // MARK: - INTERRNAL: functions
    

    
    
    // MARK: - PRIVATE: properties
    
    var ingredientLabel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "- Tomatoes"
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        label.isEditable = false
        return label
    }()
    
    
    // MARK: - PRIVATE: functions
    
    private func commonInit() -> Void {
//        ingredientLabel = UITextView(frame: self.frame)
        contentView.backgroundColor = UIColor.mainBackgroundColor
        contentView.addSubview(ingredientLabel)
        
        NSLayoutConstraint.activate([
            ingredientLabel.topAnchor.constraint(equalTo: self.topAnchor),
            ingredientLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            ingredientLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            ingredientLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}


// MARK: - EXTENSIONS

extension UIColor {
    class var ingredientCellBackgroundColor: UIColor {
        if let color = UIColor(named: "mainBackgroundColor") {
            return color
        }
        fatalError("Could not find weatherCellsBackground color")
    }
}
