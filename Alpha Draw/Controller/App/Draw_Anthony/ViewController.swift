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
import FSPagerView

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FSPagerViewDelegate, FSPagerViewDataSource {
    
    

    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var clearPromptButton: UIButton!
    @IBOutlet weak var wordBubbleCollectionView: UICollectionView!
    @IBOutlet weak var inputPrompt: UITextField!
    @IBOutlet weak var fsView: FSPagerView! {
        didSet {
            self.fsView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "fscell")
        }
    }
    
    
    var inspirationBubbleString: [String] = ["Apple", "Banana", "Peach", "Orange", "Watermellon", "Kiwi"]

    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBackButton(view: self)
        styleInputField(inputField: inputPrompt)
        addShadowToButton(button: createButton)
        setAllViewToAlphaZero()
        addAlphaDrawTitle()

        // Navigation Bar Animation Type
        navigationController?.hero.isEnabled = true
        navigationController?.heroNavigationAnimationType = .fade

        // FSPageView Animation Type
        fsView.transformer = FSPagerViewTransformer(type: .overlap)
    }

    // MARK: - FSPageControl
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 9
    }

    // image: UIImage(named: "Page\(index+1)")
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "fscell", at: index)

        // remove all subviews from the cell
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }

        // add an image view to the cell, with padding 10 to fspage frame
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: pagerView.frame.width - 20, height: pagerView.frame.height - 20))
        imageView.image = UIImage(named: "Page\(index+1)")
        imageView.contentMode = .scaleAspectFill
        imageView.center = cell.contentView.center
        imageView.clipsToBounds = true
        cell.contentView.addSubview(imageView)
        return cell
    }

    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        if targetIndex == 2 {
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
                self.clearPromptButton.alpha = 1
                self.wordBubbleCollectionView.alpha = 1
                self.inputPrompt.alpha = 1
            }, completion: nil)
        }
    }

    // if FsPage is touched, dismiss keyboard
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        self.view.endEditing(true)
    }

    func pagerView(_ pagerView: FSPagerView, shouldSelectItemAt index: Int) -> Bool {
        return false
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
        wordBubbleButton.addTarget(self, action: #selector(wordBubbleButtonHover), for: .touchDown)
        wordBubbleButton.addTarget(self, action: #selector(wordBubbleButtonHoverEnd), for: .touchDragExit)
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
        wordBubbleButtonHoverEnd(sender: sender)
        inputPrompt.text! += " " + (sender.titleLabel?.text)!
        changeInputFieldBackgroundToLight(inputField: inputPrompt)
        inputPrompt.becomeFirstResponder()
    }

    // if wordBubbleButton hovered, set the button to light color
    @objc func wordBubbleButtonHover(sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            sender.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.5)
        }, completion: nil)
    }

    // if wordButtonButton unhovered, set the button back
    @objc func wordBubbleButtonHoverEnd(sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            sender.backgroundColor = UIColor.purple.withAlphaComponent(0.1)
        }, completion: nil)
    }




    @IBAction func clearButtonClicked(_ sender: Any) {
        inputPrompt.text = ""
        changeInputFieldBackgroundToDark(inputField: inputPrompt)
        inputPrompt.resignFirstResponder()
    }
    





    // MARK: - Input Prompt & title

    func addAlphaDrawTitle(){
        self.parent?.navigationItem.title = "Alpha Draw"
        self.parent?.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.parent?.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.parent?.navigationController?.navigationBar.layer.shadowRadius = 2
        self.parent?.navigationController?.navigationBar.layer.shadowOpacity = 0.5
        self.parent?.navigationController?.navigationBar.layer.masksToBounds = false
    }
    
    @IBAction func inputPromptEditingDidBegin(_ sender: Any) {
        changeInputFieldBackgroundToLight(inputField: inputPrompt)
    }
    
    @IBAction func inputPromptEditingDidEnd(_ sender: Any) {
        if inputPrompt.text == "" {
            changeInputFieldBackgroundToDark(inputField: inputPrompt)
        }
    }
    @IBAction func returnKeyboardPressed(_ sender: Any) {
        inputPrompt.resignFirstResponder()
    }
    
    // Dismiss keyboard when user taps outside of input field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    



    // MARK: - Animation

    func setAllViewToAlphaZero() {
        clearPromptButton.alpha = 0
        wordBubbleCollectionView.alpha = 0
        inputPrompt.alpha = 0
        fsView.alpha = 0
        createButton.alpha = 0
    }
    // fade in all component of the view controller
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            self.inputPrompt.alpha = 1.0
            self.clearPromptButton.alpha = 1.0
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseIn, animations: {
            self.wordBubbleCollectionView.alpha = 1.0
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseIn, animations: {
            self.fsView.alpha = 1.0
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.4, options: .curveEaseIn, animations: {
            self.createButton.alpha = 1.0
        }, completion: nil)
    }

    
}

