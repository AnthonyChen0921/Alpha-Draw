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
import Hero

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let viewControllerIDs = ["DrawViewController", "Sample"]
    
    

    @IBOutlet weak var clearPromptButton: UIButton!
    @IBOutlet weak var wordBubbleCollectionView: UICollectionView!
    @IBOutlet weak var inputPrompt: UITextField!

    var inspirationBubbleString: [String] = ["Apple", "Banana", "Peach", "Orange", "Watermellon", "Kiwi"]

    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBackButton(view: self)
        styleInputField(inputField: inputPrompt)
        
        navigationController?.hero.isEnabled = true
        navigationController?.heroNavigationAnimationType = .zoomOut
    }



    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSample" {
            let destinationVC = segue.destination as! OptionModalViewController
            destinationVC.hero.isEnabled = true
            destinationVC.hero.modalAnimationType = .selectBy(presenting: .fade, dismissing: .fade)
            print(1)
        }
    }





    // MARK: - Collection View Data Source

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inspirationBubbleString.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wordBubbleCell", for: indexPath) 
        // clear the cell before adding the new text
        for subview in cell.subviews {
            subview.removeFromSuperview()
        }
        let wordBubbleButton = createBubbleButton(bubbleText: inspirationBubbleString[indexPath.row])
        wordBubbleButton.addTarget(self, action: #selector(wordBubbleButtonTapped), for: .touchUpInside)
        cell.addSubview(wordBubbleButton)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 40)
    }

    // MARK: - WordBubble & Clear Button Clicked

    @objc func wordBubbleButtonTapped(sender: UIButton) {
        inputPrompt.text! += " " + (sender.titleLabel?.text)!
        changeInputFieldBackgroundToLight(inputField: inputPrompt)
        inputPrompt.becomeFirstResponder()
    }


    @IBAction func clearButtonClicked(_ sender: Any) {
        inputPrompt.text = ""
        changeInputFieldBackgroundToDark(inputField: inputPrompt)
        inputPrompt.resignFirstResponder()
    }
    


    // MARK: - Input Prompt
    
    @IBAction func inputPromptEditingDidBegin(_ sender: Any) {
        changeInputFieldBackgroundToLight(inputField: inputPrompt)
    }
    
    @IBAction func inputPromptEditingDidEnd(_ sender: Any) {
        if inputPrompt.text == "" {
            changeInputFieldBackgroundToDark(inputField: inputPrompt)
        }
    }
    
    // Dismiss keyboard when user taps outside of input field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

