//
//  CustomRecipeTableViewCell.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 01/08/2022.
//

import UIKit

class CustomRecipeTableViewCell: UITableViewCell {

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
    
    private var recipeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Pizza"
        label.textColor = .white
        label.tintColor = .white
        label.font = .systemFont(ofSize: 22)
        return label
    }()
    
    
    // MARK: - PRIVATE: functions
    
    private func commonInit() {
        
    }

}
