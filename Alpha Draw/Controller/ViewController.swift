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
    // current color
    var currentColor: UIColor?
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBackButton(view: self)
        styleInputField(inputField: inputPrompt)
    }

    @IBAction func inputPromptEditingDidBegin(_ sender: Any) {
        changeColorsToInputPrompt(inputPrompt: inputPrompt)
        addGloomyShadowToInputPrompt(inputPrompt: inputPrompt)
    }
    
    @IBAction func inputPromptEditingDidEnd(_ sender: Any) {
        removeGloomyShadowToInputPrompt(inputPrompt: inputPrompt)
    }
    
    // add corners to the input prompt
    func changeColorsToInputPrompt(inputPrompt: UITextField) {
        currentColor = colors.randomElement()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // create a gloomy shadow animation for the input prompt, done within 1 second
    func addGloomyShadowToInputPrompt(inputPrompt: UITextField) {
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            inputPrompt.layer.shadowColor = self.currentColor?.cgColor
            inputPrompt.layer.shadowOffset = CGSize(width: 0, height: 0)
            inputPrompt.layer.shadowRadius = 10
            inputPrompt.layer.shadowOpacity = 0.5
        }, completion: nil)
    }

    // remove the gloomy shadow animation for the input prompt, done within 1 second
    func removeGloomyShadowToInputPrompt(inputPrompt: UITextField) {
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            inputPrompt.layer.shadowColor = self.currentColor?.cgColor
            inputPrompt.layer.shadowOffset = CGSize(width: 0, height: 0)
            inputPrompt.layer.shadowRadius = 0
            inputPrompt.layer.shadowOpacity = 0
        }, completion: nil)
    }

    func styleInputField(inputField: UITextField) {
        inputField.frame.size.height = 86
        inputField.layer.cornerRadius = 15
        // add a grey background color
        inputField.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.00)
        // holder text
        inputField.attributedPlaceholder = NSAttributedString(string: "Enter a prompt", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        // specify the font size
        inputField.font = UIFont.systemFont(ofSize: 20)
        
    }
    

}

