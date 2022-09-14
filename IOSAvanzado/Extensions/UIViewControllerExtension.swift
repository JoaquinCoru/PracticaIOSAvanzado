//
//  UIViewControllerExtension.swift
//  DragonBallXibs
//
//  Created by Joaquín Corugedo Rodríguez on 24/7/22.
//

import UIKit

extension UIViewController {
  func showAlert(title: String, message: String = "") {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "OK", style: .default)
    alert.addAction(alertAction)
    present(alert, animated: true)
  }
}

