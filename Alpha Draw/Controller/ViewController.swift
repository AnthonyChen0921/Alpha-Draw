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

    


    

}

