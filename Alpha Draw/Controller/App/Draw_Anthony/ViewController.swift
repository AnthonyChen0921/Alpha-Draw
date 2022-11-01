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
    var currentSelectedConfig: Int = 1

    var currentSelectedWidth: Int = 512
    var currentSelectedHeight: Int = 768
    var prompt_strength: Float = 0.8
    var num_inference_steps: Int = 50
    var guidance_scale: Float = 7.5

    
    
    
    // MARK: - Component links
    var sliderNum1: UILabel = UILabel()
    var sliderNum2: UILabel = UILabel()
    var sliderNum3: UILabel = UILabel()
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

    @IBAction func createButtonClicked(_ sender: Any) {
        // if the input prompt is empty, show a message
        if inputPrompt.text == "" {
            let alert = UIAlertController(title: "Empty Prompt", message: "Please enter a prompt to generate an image.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alert.overrideUserInterfaceStyle = .dark
            self.present(alert, animated: true)
        } 
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
        currentSelectedWidth = 512
        currentSelectedHeight = 768
        prompt_strength = 0.8
        num_inference_steps = 50
        guidance_scale = 7.5
    }

    // if FsPage is touched, dismiss keyboard
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        self.view.endEditing(true)
    }

    

    
    // MARK: - FSPage Filp Controller


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
            saveButton.addTarget(self, action: #selector(saveConfig), for: .touchUpInside)
            let shadowView = addShadowViewBehindButton(x: Int(pagerView.frame.width/2 + 50), y: Int(pagerView.frame.height - 60), width: 100, height: 30)
            cell?.contentView.addSubview(shadowView)
            cell?.contentView.addSubview(saveButton)

            // add a restore button to flipback the image, at the bottom of the cell
            let restoreButton = addCancelButton(x: Int(pagerView.frame.width/2 - 150), y: Int(pagerView.frame.height - 60), width: 100, height: 30)
            restoreButton.addTarget(self, action: #selector(restoreValue(_:)), for: .touchUpInside)
            let shadowView2 = addShadowViewBehindButton(x: Int(pagerView.frame.width/2 - 150), y: Int(pagerView.frame.height - 60), width: 100, height: 30)
            cell?.contentView.addSubview(shadowView2)
            cell?.contentView.addSubview(restoreButton)

            // addLabelText
            let sizeLabel = addLabelText(x: 50, y: 90, width: Int(pagerView.frame.width - 100), height: 30, text: "Size: (width x height)")
            cell?.contentView.addSubview(sizeLabel)

            // add a width segemented control to the cell, value of 256, 512, 768
            let widthSegmentedControl = addSegementControl(x: Int(pagerView.frame.width/2 - 150), y: 120, width: 300, height: 30)
            widthSegmentedControl.selectedSegmentIndex = 1
            widthSegmentedControl.addTarget(self, action: #selector(widthSegmentedControlValueChanged(_:)), for: .valueChanged)
            cell?.contentView.addSubview(widthSegmentedControl)

            // add a height segemented control to the cell, value of 256, 512, 768
            let heightSegmentedControl = addSegementControl(x: Int(pagerView.frame.width/2 - 150), y: 160, width: 300, height: 30)
            heightSegmentedControl.selectedSegmentIndex = 2
            heightSegmentedControl.addTarget(self, action: #selector(heightSegmentedControlValueChanged(_:)), for: .valueChanged)
            cell?.contentView.addSubview(heightSegmentedControl)

            // add a text label to the cell
            let promptLabel = addLabelText(x: 50, y: 210, width: Int(pagerView.frame.width - 100), height: 30, text: "Prompt_Strength: (Obdience)")
            cell?.contentView.addSubview(promptLabel)

            // add a number indicator before the slider
            styleLabelText(x: 50, y: 240, width: Int(pagerView.frame.width - 100), height: 30, text: "\(prompt_strength)", label: sliderNum1)
            cell?.contentView.addSubview(sliderNum1)

            // add a slider to the cell after the text label
            let prompt_strength_slider = addSlider(x: 80, y: 240, width: Int(pagerView.frame.width - 150), height: 30, minValue: 0, maxValue: 1, value: prompt_strength)
            prompt_strength_slider.addTarget(self, action: #selector(prompt_strength_sliderValueChanged(_:)), for: .valueChanged)
            cell?.contentView.addSubview(prompt_strength_slider)

            // add a text label to the cell
            let inferenceLabel = addLabelText(x: 50, y: 280, width: Int(pagerView.frame.width - 100), height: 30, text: "Inference_Strength: (Denoising Steps)")
            cell?.contentView.addSubview(inferenceLabel)

            // add a number indicator before the slider
            styleLabelText(x: 50, y: 310, width: Int(pagerView.frame.width - 100), height: 30, text: "\(num_inference_steps)", label: sliderNum2)
            cell?.contentView.addSubview(sliderNum2)

            // add a slider to the cell after the text label
            let inference_strength_slider = addSlider(x: 80, y: 310, width: Int(pagerView.frame.width - 150), height: 30, minValue: 0, maxValue: 500, value: Float(num_inference_steps))
            inference_strength_slider.addTarget(self, action: #selector(inference_strength_sliderValueChanged(_:)), for: .valueChanged)
            cell?.contentView.addSubview(inference_strength_slider)

            // add a text label to the cell
            let guidanceLabel = addLabelText(x: 50, y: 350, width: Int(pagerView.frame.width - 100), height: 30, text: "Guidance_Scale: (free guidance)")
            cell?.contentView.addSubview(guidanceLabel)

            // add a number indicator before the slider
            styleLabelText(x: 50, y: 380, width: Int(pagerView.frame.width - 100), height: 30, text: "\(guidance_scale)", label: sliderNum3)
            cell?.contentView.addSubview(sliderNum3)

            // add a slider to the cell after the text label
            let guidance_strength_slider = addSlider(x: 80, y: 380, width: Int(pagerView.frame.width - 150), height: 30, minValue: 0, maxValue: 20, value: guidance_scale)
            guidance_strength_slider.addTarget(self, action: #selector(guidance_strength_sliderValueChanged(_:)), for: .valueChanged)
            cell?.contentView.addSubview(guidance_strength_slider)



            // restore the value
            // restoreValue(restoreButton)
            
            // flip the image in 0.5s, and set to black
            UIView.transition(with: imageView, duration: 0.5, options: .transitionFlipFromRight, animations: {
                imageView.image = UIImage(named: "black")
            }, completion: nil)

            // add animation to fade in
            UIView.animate(withDuration: 0.5, delay: 0.5, options: [.curveEaseInOut, .allowUserInteraction], animations: {
                titleLabel.alpha = 1
                saveButton.alpha = 1
                restoreButton.alpha = 1
                shadowView.alpha = 1
                shadowView2.alpha = 1
                sizeLabel.alpha = 1
                widthSegmentedControl.alpha = 1
                heightSegmentedControl.alpha = 1
                promptLabel.alpha = 1
                self.sliderNum1.alpha = 1
                prompt_strength_slider.alpha = 1
                inferenceLabel.alpha = 1
                self.sliderNum2.alpha = 1
                inference_strength_slider.alpha = 1
                guidanceLabel.alpha = 1
                self.sliderNum3.alpha = 1
                guidance_strength_slider.alpha = 1
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
    
    @objc func saveConfig(_ sender: UIButton) {
        // get cell and image view handle
        print("saving config...")
        print("currentSelectedConfig: \(currentSelectedConfig)")
        print("width: \(currentSelectedWidth)")
        print("height: \(currentSelectedHeight)")
        print("prompt_strength: \(prompt_strength)")
        print("num_inference_steps: \(num_inference_steps)")
        print("guidance_scale: \(guidance_scale)")

    }

    
    @objc func restoreValue(_ sender: UIButton) {
        // get the cell handle
        let cell = sender.superview

        // set sliderNum1, sliderNum2, sliderNum3 to default value as defined in the beginning
        prompt_strength = 0.8
        num_inference_steps = 50
        guidance_scale = 7.5
        sliderNum1.text = "\(prompt_strength)"
        sliderNum2.text = "\(num_inference_steps)"
        sliderNum3.text = "\(guidance_scale)"

        currentSelectedWidth = 512
        currentSelectedHeight = 768
        // set segmented control to default value as defined in the beginning, get segement control from cell
        let widthSegmentedControl = cell?.subviews[7] as! UISegmentedControl
        let heightSegmentedControl = cell?.subviews[8] as! UISegmentedControl
        widthSegmentedControl.selectedSegmentIndex = 1
        heightSegmentedControl.selectedSegmentIndex = 2

        // get slider handle from cell
        let prompt_strength_slider = cell?.subviews[11] as! UISlider
        let inference_strength_slider = cell?.subviews[14] as! UISlider
        let guidance_strength_slider = cell?.subviews[17] as! UISlider
        
        // set slider to default value as defined in the beginning
        prompt_strength_slider.value = prompt_strength
        inference_strength_slider.value = Float(num_inference_steps)
        guidance_strength_slider.value = guidance_scale

    }


    
    // MARK: - FSPage Back Config

    @objc func widthSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            currentSelectedWidth = 256
            print(currentSelectedWidth)
        case 1:
            currentSelectedWidth = 512
            print(currentSelectedWidth)
        case 2:
            currentSelectedWidth = 768
            print(currentSelectedWidth)
        default:
            break
        }
    }

    @objc func heightSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            currentSelectedHeight = 256
        case 1:
            currentSelectedHeight = 512
        case 2:
            currentSelectedHeight = 768
        default:
            break
        }
    }
    
    @objc func prompt_strength_sliderValueChanged(_ sender: UISlider) {
        // round to 0.x
        let roundedValue = round(sender.value * 10) / 10
        prompt_strength = roundedValue
        sliderNum1.text = String(format: "%.1f", prompt_strength)
    }
    
    @objc func inference_strength_sliderValueChanged(_ sender: UISlider) {
        // round to int
        num_inference_steps = Int(sender.value)
        sliderNum2.text = String(num_inference_steps)
    }

    @objc func guidance_strength_sliderValueChanged(_ sender: UISlider) {
        // round to 0.x
        let roundedValue = round(sender.value * 10) / 10
        guidance_scale = roundedValue
        sliderNum3.text = String(format: "%.1f", guidance_scale)
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

