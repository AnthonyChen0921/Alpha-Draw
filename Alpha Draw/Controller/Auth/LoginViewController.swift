//
//  LoginViewController.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/24/22.
//

import UIKit
import Firebase
import TextFieldEffects

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTextInputField: UITextField!
    @IBOutlet weak var emailTextInputField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add style to text input fields
        addStyleToInputField(inputField: emailTextInputField)
        addStyleToInputField(inputField: passwordTextInputField)
    }

    // login button clicked trigger the login process, if the login is successful, the user will be redirected to the home screen
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
                    // save user id to UserDefaults
                    UserDefaults.standard.set(authResult?.user.uid, forKey: "user_id")
                    self.performSegue(withIdentifier: "loginToHome", sender: self)
                }
            }
        }
    }
    
    /**
        * This function adds style to the input field
        */
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

    // when click other place on screen, dismiss keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // when click return on keyboard, dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
