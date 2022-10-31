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
import Hero
import FSPagerView

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FSPagerViewDelegate, FSPagerViewDataSource {

    // MARK: - Constants
    var pageIsFront = true
    var titleArray = ["Cyberpunk AI", "Nightmare Stable-diffusion", "High-resolution Stable-diffusion", "Stable-diffusion", "Pixray Style", "Anime waifu-diffusion", "LOGO", "retrieval-augmented", "Arcane-diffusion"]
    var inspirationBubbleString: [String] = ["Apple", "Banana", "Peach", "Orange", "Watermellon", "Kiwi"]
    var currentSelectedConfig = 1
    
    
    
    // MARK: - Component links
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var clearPromptButton: UIButton!
    @IBOutlet weak var wordBubbleCollectionView: UICollectionView!
    @IBOutlet weak var inputPrompt: UITextField!
    @IBOutlet weak var fsView: FSPagerView! {
        didSet {
            self.fsView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "fscell")
        }
    }

    
    // MARK: - ViewDidLoad
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
    
    //MARK: - API Calls

    
    
    
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
        let imageView = UIImageView(frame: CGRect(x: 10, y: 20, width: pagerView.frame.width - 60, height: pagerView.frame.height - 20))
        imageView.image = UIImage(named: "Page\(index+1)")
        imageView.contentMode = .scaleAspectFill
        imageView.center = cell.contentView.center
        imageView.clipsToBounds = true

        // add to cell
        cell.contentView.addSubview(imageView)
        pageIsFront = true
        return cell
    }

    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        currentSelectedConfig = targetIndex + 1
        print("currentSelectedConfig: \(currentSelectedConfig)")
    }

    // if FsPage is touched, dismiss keyboard
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        self.view.endEditing(true)
    }

    

    
    // MARK: - FSPageFilp


    func pagerView(_ pagerView: FSPagerView, shouldSelectItemAt index: Int) -> Bool {
        if pageIsFront {
            // get cell and image view handle
            let cell = pagerView.cellForItem(at: index)
            let imageView = cell?.contentView.subviews[0] as! UIImageView
            pageIsFront = false

            // add to title label to cell
            let titleLabel = createCellTitleLabel(title: titleArray[index], width: Int(pagerView.frame.width), cell: cell!)
            cell?.contentView.addSubview(titleLabel)

            // add a save button to flipback the image, at the bottom of the cell
            let saveButton = addSaveButton(x: Int(pagerView.frame.width/2 + 50), y: Int(pagerView.frame.height - 60), width: 100, height: 30)
            saveButton.addTarget(self, action: #selector(flipBack), for: .touchUpInside)
            // saveButton.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
            let shadowView = addShadowViewBehindButton(x: Int(pagerView.frame.width/2 + 50), y: Int(pagerView.frame.height - 60), width: 100, height: 30)
            cell?.contentView.addSubview(shadowView)
            cell?.contentView.addSubview(saveButton)

            // add a cancel button to flipback the image, at the bottom of the cell
            let cancelButton = addCancelButton(x: Int(pagerView.frame.width/2 - 150), y: Int(pagerView.frame.height - 60), width: 100, height: 30)
            cancelButton.addTarget(self, action: #selector(flipBack), for: .touchUpInside)
            let shadowView2 = addShadowViewBehindButton(x: Int(pagerView.frame.width/2 - 150), y: Int(pagerView.frame.height - 60), width: 100, height: 30)
            cell?.contentView.addSubview(shadowView2)
            cell?.contentView.addSubview(cancelButton)

            // flip the image in 0.5s, and set to black
            UIView.transition(with: imageView, duration: 0.5, options: .transitionFlipFromRight, animations: {
                imageView.image = UIImage(named: "black")
            }, completion: nil)

            // add animation to fade in
            UIView.animate(withDuration: 0.5, delay: 0.5, options: [.curveEaseInOut, .allowUserInteraction], animations: {
                titleLabel.alpha = 1
                saveButton.alpha = 1
                cancelButton.alpha = 1
                shadowView.alpha = 1
                shadowView2.alpha = 1
            }, completion: nil)

        
        } 
        return false
    }

    // flip back the image
    @objc func flipBack(_ sender: UIButton) {
        // get cell and image view handle
        let cell = sender.superview
        let imageView = cell?.subviews[0] as! UIImageView
        pageIsFront = true

        // animate the image flip back
        UIView.transition(with: imageView, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            imageView.image = UIImage(named: "Page\(self.fsView.currentIndex+1)")
        }, completion: nil)

        // remove everthing except the image view
        for subview in cell!.subviews {
            if subview != imageView {
                subview.removeFromSuperview()
            }
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
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            sender.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.5)
        }, completion: nil)
    }

    // if wordButtonButton unhovered, set the button back
    @objc func wordBubbleButtonHoverEnd(sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
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
        self.navigationItem.title = "Alpha Draw"
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        self.navigationController?.navigationBar.layer.shadowRadius = 1
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.3
        self.navigationController?.navigationBar.layer.masksToBounds = false
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

