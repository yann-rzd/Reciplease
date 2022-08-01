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
    
    // MARK: - PRIVATE: functions
    
    private func commonInit() {
        
    }

}
