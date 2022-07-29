//
//  CustomIngredientAdderTableViewCell.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 29/07/2022.
//

import UIKit

class CustomIngredientTableViewCell: UITableViewCell {

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
    
    
    // MARK: - PRIVATE: properties
    
    
    
    // MARK: - PRIVATE: functions
    
    private func commonInit() {
        
    }

}
