//
//  AlertViewService.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 04/08/2022.
//

import UIKit

final class AlertViewService {
    static let shared = AlertViewService()
    
    func displayAlert(on viewController: UIViewController, error: LocalizedError) {
        let alertController = UIAlertController(title: "Error", message: error.errorDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true)
    }
}
