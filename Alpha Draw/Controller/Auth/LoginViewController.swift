//
//  LoginViewController.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/24/22.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTextInputField: UITextField!
    @IBOutlet weak var emailTextInputField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addStyleToInputField(inputField: emailTextInputField)
        addStyleToInputField(inputField: passwordTextInputField)
    }
    @IBAction func loginButtonClicked(_ sender: Any) {
        // check if all input fields are filled
        if emailTextInputField.text == "" || passwordTextInputField.text == "" {
            // show alert
            let alert = UIAlertController(title: "Error", message: "Please fill in all input fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alert.overrideUserInterfaceStyle = .dark
            self.present(alert, animated: true)
        } else {
            // login user
            Auth.auth().signIn(withEmail: emailTextInputField.text!, password: passwordTextInputField.text!) { authResult, error in
                if error != nil {
                    // show alert
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    alert.overrideUserInterfaceStyle = .dark
                    self.present(alert, animated: true)
                } else {
                    // show alert
                    let alert = UIAlertController(title: "Success", message: "Login Successful", preferredStyle: .alert)
                    // if user clicks on OK, go to home screen
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        self.performSegue(withIdentifier: "loginToHome", sender: self)
                    }))
                    alert.overrideUserInterfaceStyle = .dark
                    self.present(alert, animated: true)
                    
                }
            }
        }
    }
    
    func addStyleToInputField(inputField: UITextField) {
        //set the height of the input field to be 50
        inputField.frame.size.height = 50
        inputField.layer.cornerRadius = 25
        // setup a white gloomy shadow for the input field
        inputField.layer.shadowColor = UIColor.white.cgColor
        inputField.layer.shadowOffset = CGSize(width: 0, height: 0)
        inputField.layer.shadowRadius = 10
        inputField.layer.shadowOpacity = 0.5
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
