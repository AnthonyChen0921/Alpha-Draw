//
//  function_uiux.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/28/22.
//

import UIKit
import FSPagerView


// create a gloomy shadow animation for the input prompt, done within 1 second
func addGloomyShadowToInputPrompt(inputPrompt: UITextField) {
    UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
        inputPrompt.layer.shadowColor = UIColor.black.cgColor
        inputPrompt.layer.shadowOffset = CGSize(width: 0, height: 0)
        inputPrompt.layer.shadowRadius = 5
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
    inputField.frame.size.height = 50
    inputField.layer.cornerRadius = 10
    // add a grey background color
    inputField.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.00)
    // holder text
    inputField.attributedPlaceholder = NSAttributedString(string: "Enter a prompt", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    // specify the font size
    inputField.font = UIFont.systemFont(ofSize: 20)
    // add a black shadow
    inputField.layer.shadowColor = UIColor.black.cgColor
    inputField.layer.shadowOffset = CGSize(width: 5, height: 5)
    inputField.layer.shadowRadius = 5
    inputField.layer.shadowOpacity = 0.5       
}

func changeInputFieldBackgroundToLight(inputField: UITextField) {
    // add a f1f1f1 background color animation
    UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
        inputField.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.00)
        inputField.layer.shadowOffset = CGSize(width: 0, height: 0)
        inputField.layer.shadowRadius = 10
    }, completion: nil)
}

func changeInputFieldBackgroundToDark(inputField: UITextField) {
    // add a grey background color animation
    UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
        inputField.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.00)
        inputField.layer.shadowOffset = CGSize(width: 5, height: 5)
        inputField.layer.shadowRadius = 5
    }, completion: nil)
}

func createBubbleButton(bubbleText: String) -> UIButton {
    // create a tinted button in the cell, style tinted button
    let wordBubbleButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    wordBubbleButton.setTitle(bubbleText, for: .normal)
    wordBubbleButton.titleLabel?.font = UIFont(name: "Arial", size: 15)
    wordBubbleButton.setTitleColor(UIColor.systemIndigo, for: .normal)
    wordBubbleButton.backgroundColor = UIColor.purple.withAlphaComponent(0.1)
    wordBubbleButton.tintColor = UIColor.lightGray
    wordBubbleButton.layer.cornerRadius = 15
    wordBubbleButton.layer.masksToBounds = true
    return wordBubbleButton
}

func addShadowToButton(button: UIButton) {
    button.layer.shadowColor = UIColor.black.cgColor
    button.layer.shadowOffset = CGSize(width: 4, height: 4)
    button.layer.shadowRadius = 5
    button.layer.shadowOpacity = 0.5
}

func createCellTitleLabel(title: String, width: Int, cell: FSPagerViewCell) -> UILabel {
    let titleLabel = UILabel(frame: CGRect(x: 0, y: 30, width: width - 80, height: 60))
    titleLabel.text = title
    titleLabel.textColor = .white
    titleLabel.textAlignment = .center
    titleLabel.center.x = cell.contentView.center.x
    titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
    titleLabel.alpha = 0
    titleLabel.numberOfLines = 2
    return titleLabel
}


func addSaveButton(x: Int, y:Int, width: Int, height: Int) -> UIButton {
    let saveButton = UIButton(frame: CGRect(x: x, y: y, width: width, height: height))
    saveButton.setTitle("Save", for: .normal)
    saveButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 15)
    saveButton.setTitleColor(.white, for: .normal)
    
    // create a linear gradient for button background color
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = saveButton.bounds
    gradientLayer.colors = [UIColor.systemMint.cgColor, UIColor.systemIndigo.cgColor, UIColor.systemPink.cgColor]
    gradientLayer.startPoint = CGPoint(x: 0, y: 0)
    gradientLayer.endPoint = CGPoint(x: 1, y: 1)
    saveButton.layer.insertSublayer(gradientLayer, at: 0)
    saveButton.layer.cornerRadius = 15
    saveButton.layer.masksToBounds = true
    saveButton.alpha = 0

    return saveButton
}

func addCancelButton(x: Int, y:Int, width: Int, height: Int) -> UIButton {
    let cancelButton = UIButton(frame: CGRect(x: x, y: y, width: width, height: height))
    cancelButton.setTitle("Restore", for: .normal)
    cancelButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 15)
    cancelButton.setTitleColor(.white, for: .normal)
    
    // create a linear gradient for button background color
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = cancelButton.bounds
    gradientLayer.colors = [UIColor.systemMint.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor ]
    gradientLayer.startPoint = CGPoint(x: 0, y: 0)
    gradientLayer.endPoint = CGPoint(x: 1, y: 1)
    cancelButton.layer.insertSublayer(gradientLayer, at: 0)
    cancelButton.layer.cornerRadius = 15
    cancelButton.layer.masksToBounds = true
    cancelButton.alpha = 0
    
    return cancelButton
}

func addShadowViewBehindButton(x: Int, y:Int, width: Int, height: Int) -> UIView {
    let shadowView = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
    shadowView.backgroundColor = .white
    shadowView.layer.shadowColor = UIColor.white.cgColor
    shadowView.layer.shadowOffset = CGSize(width: 4, height: 4)
    shadowView.layer.shadowRadius = 5
    shadowView.layer.shadowOpacity = 0.5
    shadowView.layer.cornerRadius = 15
    shadowView.layer.masksToBounds = false
    shadowView.alpha = 0
    return shadowView
}

func addLabelText(x: Int, y:Int, width: Int, height: Int, text: String) -> UILabel {
    let label = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
    label.text = text
    label.textColor = .white
    label.textAlignment = .left
    label.font = UIFont(name: "HelveticaNeue", size: 15)
    label.alpha = 0
    return label
}


func addSegementControl(x: Int, y:Int, width: Int, height: Int) -> UISegmentedControl {
    let widthSegmentedControl = UISegmentedControl(items: ["256", "512", "768"])
    widthSegmentedControl.frame = CGRect(x: x, y: y, width: width, height: height)
    widthSegmentedControl.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
    widthSegmentedControl.alpha = 0
    return widthSegmentedControl
}

func addSlider(x: Int, y:Int, width: Int, height: Int, minValue: Float, maxValue: Float, value: Float) -> UISlider {
    let slider = UISlider(frame: CGRect(x: x, y: y, width: width, height: height))
    slider.minimumValue = minValue
    slider.maximumValue = maxValue
    slider.value = value
    slider.alpha = 0
    return slider
}

func styleLabelText(x: Int, y:Int, width: Int, height: Int, text: String, label: UILabel) {
    label.frame = CGRect(x: x, y: y, width: width, height: height)
    label.text = text
    label.textColor = .white
    label.textAlignment = .left
    label.font = UIFont(name: "HelveticaNeue", size: 15)
    label.alpha = 0
}
