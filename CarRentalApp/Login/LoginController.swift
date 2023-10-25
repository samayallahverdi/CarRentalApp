//
//  LoginController.swift
//  CarRentalApp
//
//  Created by BUDLCIT on 2023. 10. 23..
//

import UIKit

class LoginController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    let email = "samaya@gmail.com"
    let password = "123"
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        if (emailField.text == email) && (passwordField.text == password){
            let controller = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
            UserDefaults.standard.setValue(true, forKey: "isLogged")
            navigationController?.show(controller, sender: nil)
            

        } else if (emailField.text?.isEmpty ?? false) || (passwordField.text?.isEmpty ?? false) {
            showAlert(title: "Error", message: "Fields cannot be empty")
        } else{
            showAlert(title: "Error", message: "Check your email or password")
        }
        
    }
    
    
}
extension LoginController {
//    func login(){
//        if (emailField.text == email) && (passwordField.text == password){
//            let controller = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
//            navigationController?.show(controller, sender: nil)
//        } else if (emailField.text?.isEmpty ?? false) || (passwordField.text?.isEmpty ?? false) {
//            showAlert(title: "Error", message: "Fields cannot be empty")
//        } else{
//            showAlert(title: "Error", message: "Check your email or password")
//        }
//    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "Okay", style: .default)
        alertController.addAction(okayButton)
        self.present(alertController, animated: true)
    }
}
