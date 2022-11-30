//
//  RegisterViewController.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/24/22.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var confirmPasswordInputField: UITextField!
    @IBOutlet weak var nameInputField: UITextField!
    @IBOutlet weak var emailInputField: UITextField!
    @IBOutlet weak var passwordInputField: UITextField!
//    @ObservedObject var passObj = PasswordValidationObj() //TO DO!!!!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add style to input fields
        addStyleToInputField(inputField: nameInputField)
        addStyleToInputField(inputField: emailInputField)
        addStyleToInputField(inputField: passwordInputField)
        addStyleToInputField(inputField: confirmPasswordInputField)
    }
    
    // when the user clicks the register button, this function is called
    @IBAction func registerButtonClicked(_ sender: Any) {
        // check if all input fields are filled
        if nameInputField.text == "" || emailInputField.text == "" || passwordInputField.text == "" || confirmPasswordInputField.text == "" {
            // show alert
            let alert = UIAlertController(title: "Error", message: "Please fill in all input fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alert.overrideUserInterfaceStyle = .dark
            self.present(alert, animated: true)
        } else {
            // check if password and confirm password are the same
            if passwordInputField.text != confirmPasswordInputField.text {
                // show alert
                let alert = UIAlertController(title: "Error", message: "Password and Confirm Password are not the same", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                alert.overrideUserInterfaceStyle = .dark
                self.present(alert, animated: true)
            } else if passwordInputField.text?.isValidPassword() == false{
                let alert = UIAlertController(title: "Error", message: "Password needs to be minimum 8 character at least 1 alphabet and 1 number", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                alert.overrideUserInterfaceStyle = .dark
                self.present(alert, animated: true)
            }
            else {
                // register user
                Auth.auth().createUser(withEmail: emailInputField.text!, password: passwordInputField.text!) { authResult, error in
                    if error != nil {
                        // show alert
                        let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        alert.overrideUserInterfaceStyle = .dark
                        self.present(alert, animated: true)
                    } else {
                        // add user to database
                        self.createUserByModal(id: (authResult?.user.uid)!)
                        // show alert
                        let alert = UIAlertController(title: "Success", message: "You have successfully registered", preferredStyle: .alert)
                        // when click on OK button, go to login page
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            self.performSegue(withIdentifier: "goToLogin", sender: self)
                        }))
                        alert.overrideUserInterfaceStyle = .dark
                        self.present(alert, animated: true)
                        
                    }
                }
            }
        }
        
    }
    
    /**
     * Create user by modal
     */
    func createUserByModal(id: String) {
        var currentTime: String = ""
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        currentTime = formatter.string(from: date)
        let user = User(id: id, name: nameInputField.text!, email: emailInputField.text!, balance: 10, pfp: "Admin/images/pfp.png", date_created: currentTime)
        let db = Firestore.firestore()
        // add user to database, set users document id to user id
        db.collection("users").document(id).setData(user.toDict()) { error in
            if error != nil {
                // show alert
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                alert.overrideUserInterfaceStyle = .dark
                self.present(alert, animated: true)
            }
        }
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
    
    
    
    
    /**
     * Add style to input field
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
    
}


class PasswordValidationObj: ObservableObject {
    @Published var pass = ""{
        didSet{
            self.isValidPassword()
        }
    }
    @Published var error = ""
    private func isValidPassword(){
        guard !self.pass.isEmpty else {
            self.error = "Required Password"
            return
        }
        if self.pass.isValidPassword() == false{
            self.error = "Password needs to be minimum 8 character at least 1 alphabet and 1 number"
        }
    }
    
        
}

extension String{
    
    
    func isValidPassword() -> Bool {
        //minimum 8 character at least 1 alphabet and 1 number:
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
}
