//
//  ViewController.swift
//  IOSAvanzado
//
//  Created by Joaquín Corugedo Rodríguez on 13/9/22.
//

import UIKit

protocol LoginViewProtocol:AnyObject {
    
    func navigateToHome()
}

class LoginViewController: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK - Constant
    let viewModel:LoginViewModel = LoginViewModel()
    
    private let homeIdentifier = "Home"
    
    override func viewDidLoad() {
        
        viewModel.onLogin = { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.loginButton.isEnabled = true
            
            let homeStoryBoard = UIStoryboard(name: self?.homeIdentifier ?? "",bundle: nil)
            guard let nextViewController = homeStoryBoard.instantiateInitialViewController() as? HomeViewController else{return}

            self?.navigationController?.setViewControllers([nextViewController], animated: true)
        }
        
        viewModel.onError = { [weak self] alertTitle, networkError in
            self?.activityIndicator.stopAnimating()
            self?.loginButton.isEnabled = true
            self?.showAlert(title: alertTitle, message: networkError?.localizedDescription ?? "")
        }
        
        super.viewDidLoad()
    }


    @IBAction func loginPressed(_ sender: Any) {
        activityIndicator.startAnimating()
        loginButton.isEnabled = false
        
        guard let user = userTextField.text,
              let password = passwordTextField.text else {
            //Show errors validations textField
            viewModel.onError?("Error in validation of text fields",nil)

            return
        }

        if user.isEmpty || password.isEmpty {
            //Show empty validations
            viewModel.onError?("Please complete all fields to login",nil)

            return
        }
        
        viewModel.login(with: userTextField.text ?? "", password: passwordTextField.text ?? "")        

    }
}


