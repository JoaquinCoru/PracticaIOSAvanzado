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
        
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        viewModel.callLoginService(
            user: user,
            password: password) { token, error in
                
                if let error = error {
                    // show the correct errors
                    
                    DispatchQueue.main.async {
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        self.showAlert(title: "There was an error", message: error.localizedDescription)
                        return
                    }
                  
                }
                
                if let token = token {
                    self.viewModel.saveToken(token: token)
                    DispatchQueue.main.async {
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        self.showAlert(title: "Login correcto")
                        
                    }
                }
            }
        
    }
}

