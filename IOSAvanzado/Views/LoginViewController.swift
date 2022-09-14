//
//  ViewController.swift
//  IOSAvanzado
//
//  Created by Joaquín Corugedo Rodríguez on 13/9/22.
//

import UIKit

class LoginViewController: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK - Constant
    let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.isHidden = true
    }

    @IBAction func loginPressed(_ sender: Any) {
        
        guard let user = userTextField.text,
              let password = passwordTextField.text else {
            //Show errors validations textField
            showAlert(title: "Validation", message: "error in validation of text fields")
            return
        }

        if user.isEmpty || password.isEmpty {
            //Show empty validations
            showAlert(title: "Missing fields", message: "please complete all fields to login")
            return
        }
        
        
    }
}

