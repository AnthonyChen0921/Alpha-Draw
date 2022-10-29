//
//  ViewController.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/21/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import TextFieldEffects

class ViewController: UIViewController {

    @IBOutlet weak var inputPrompt: UITextField!
    // create a color array to store the colors, red, green, blue, yellow, mint, purple, orange, and pink
    let colors = [UIColor.red, UIColor.green, UIColor.blue, UIColor.yellow, UIColor.systemTeal, UIColor.purple, UIColor.orange, UIColor.systemPink]

    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBackButton(view: self)
        styleInputField(inputField: inputPrompt)
    }

    @IBAction func inputPromptEditingDidBegin(_ sender: Any) {
        changeInputFieldBackgroundToLight(inputField: inputPrompt)
    }
    
    @IBAction func inputPromptEditingDidEnd(_ sender: Any) {
        if inputPrompt.text == "" {
            changeInputFieldBackgroundToDark(inputField: inputPrompt)
        }
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // create a gloomy shadow animation for the input prompt, done within 1 second
    func addGloomyShadowToInputPrompt(inputPrompt: UITextField) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            inputPrompt.layer.shadowColor = UIColor.black.cgColor
            inputPrompt.layer.shadowOffset = CGSize(width: 0, height: 0)
            inputPrompt.layer.shadowRadius = 10
            inputPrompt.layer.shadowOpacity = 0.5
        }, completion: nil)
    }

    // remove the gloomy shadow animation for the input prompt, done within 1 second
    func removeGloomyShadowToInputPrompt(inputField: UITextField) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            inputField.layer.shadowColor = UIColor.black.cgColor
            inputField.layer.shadowOffset = CGSize(width: 0, height: 0)
            inputField.layer.shadowRadius = 0
            inputField.layer.shadowOpacity = 0
        }, completion: nil)
    }

    func styleInputField(inputField: UITextField) {
        // inputField.frame.size.height = 50
        inputField.layer.cornerRadius = 15
        // add a grey background color
        inputField.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.00)
        // holder text
        inputField.attributedPlaceholder = NSAttributedString(string: "Enter a prompt", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        // specify the font size
        inputField.font = UIFont.systemFont(ofSize: 20)
        // add a black shadow
        inputField.layer.shadowColor = UIColor.black.cgColor
        inputField.layer.shadowOffset = CGSize(width: 5, height: 5)
        inputField.layer.shadowRadius = 10
        inputField.layer.shadowOpacity = 0.5       
    }

    func changeInputFieldBackgroundToLight(inputField: UITextField) {
        // add a f1f1f1 background color animation
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            inputField.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.00)
            inputField.layer.shadowOffset = CGSize(width: 0, height: 0)
            inputField.layer.shadowRadius = 15
        }, completion: nil)
    }

    func changeInputFieldBackgroundToDark(inputField: UITextField) {
        // add a grey background color animation
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            inputField.backgroundColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.00)
            inputField.layer.shadowOffset = CGSize(width: 5, height: 5)
            inputField.layer.shadowRadius = 10
        }, completion: nil)
    }


    

}

