//
//  DrawViewController.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/25/22.
//
// using https://github.com/zekunyan/TTGTagCollectionView + https://www.youtube.com/watch?v=dKe59TavIEc


import TTGTags
import UIKit
import SwiftUI
//import DropDown

class HomeViewController : UIViewController,TTGTextTagCollectionViewDelegate{
    
    @IBOutlet var selectButton: UIButton!
    @IBOutlet var optionButtons: [UIButton]!
    @IBOutlet weak var styleButton: UIButton!
    @IBOutlet weak var mediumButton: UIButton!
    @IBOutlet weak var madeButton: UIButton!
    @IBOutlet weak var suggestedButton: UIButton!
    
    let collectionView =  TTGTextTagCollectionView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBackButton(view: self)
        navigationController?.isNavigationBarHidden = true
        
        collectionView.alignment = .center
//        collectionView.backgroundColor = UIColor.lightGray
        collectionView.delegate = self
        view.addSubview(collectionView)

        styleButton.setTitle("Style", for: .normal)
        mediumButton.setTitle("Medium", for: .normal)
        madeButton.setTitle("Made Of...", for: .normal)
        suggestedButton.setTitle("Suggested Topics", for: .normal)
        
        UserDefaults.standard.set([],forKey: "selectedTags")

    }
    
    func visibleButton(){
        optionButtons.forEach{
            button in UIView.animate(withDuration: 0.1){
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func selectAction(_ sender: Any) {
        collectionView.isHidden = true
        visibleButton()
    }
    
    
    //["Artstation", "Unreal Engine Rendering", "Digital Art", "Pencil Sketch", "Paint", "Low Poly", "Film Grain", "Hyper Realistic", "Epic Scale", "Sense of Awe", "Hypermaximalist", "Artstation HQ", "Cinematic"]
    
    let styleArray = ["Abstract","Realism","Impressionism","Moderism","Cubism","Minimalism","Art Deco","Expressionism","Banksy","Futurism","Gothic","OP-Art","Pop Art","Ukiyo-E","Symbolism","Renaissance","Purism","Pop Surealism","Neo-Baroque","Fauvism","Art Nouveau","Baroque"]
    let mediumArray = ["Oil Paint","Chalk","Watercolour", "Spray Paint", "Pixel", "Bokeh", "Acrylic", "Ink","Crayon","Glass Paint","Charcoal","Pastel","Glitter","Freeform Ferrofluids","Metallic","Shiny","Matte","Neon"]
    let madeArray = ["Buttons", "Crystals", "Glass", "Tape", "Coins", "Wood", "Food", "Plastic","Bronze","Gold","Silver","Marble","Sand","Ice","Bubbles","Clay","Wax","Flower","Plants","Shell","CD","Newspaper","Bones","Jade","Rubber"]
    let suggestedArray = ["Landscape","Fantasy","Geometric","Modern","Cityscape","Portrait","Urban","Mosaic","Collage","New Beginning","Cyberpunk","Inner Demon","Ambience","Dodecahedron","Medival Warriors","Coastline","Underwater"]
    
    @IBAction func optionAction(_ sender: UIButton){
        visibleButton()
        collectionView.removeAllTags()
        
        switch sender.currentTitle {
        case "Style":
            tagContent(array: styleArray)
        case "Medium":
            tagContent(array: mediumArray)
        case "Made Of...":
            tagContent(array: madeArray)
        case "Suggested Topics":
            tagContent(array: suggestedArray)
        default:
            tagContent(array: [])
        }
        collectionView.isHidden = false
    }
    var selectedTags: [String]!

    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTap tag: TTGTextTag!, at index: UInt) {
        
        selectedTags = UserDefaults.standard.stringArray(forKey: "selectedTags") ?? []
        
        if tag.selected == true {
            selectedTags.append(tag.content.getAttributedString().string)
        }
        else{
            for (index, t) in selectedTags.enumerated(){
                if tag.content.getAttributedString().string == t {
                    selectedTags.remove(at: index)
                }
            }
        }
        UserDefaults.standard.set(selectedTags,forKey: "selectedTags")
//        print("selection tags")
//        print(selectedTags)
    }
    
    func tagContent(array: [String]){
    
        for text in array{
            let style = TTGTextTagStyle.init()
            style.extraSpace = CGSize.init(width: 20, height: 20)
            style.shadowColor = UIColor.clear
            style.cornerRadius = 8
            style.backgroundColor = #colorLiteral(red: 0.7864235067, green: 0.724478529, blue: 0.9273951054, alpha: 1)

            let selected = TTGTextTagStyle.init()
            selected.extraSpace = CGSize.init(width: 20, height: 20)
            selected.shadowColor = UIColor.clear
            selected.cornerRadius = 8
            selected.backgroundColor = #colorLiteral(red: 0.4619611431, green: 0.5393713899, blue: 0.9273951054, alpha: 1)
            
            let tag = TTGTextTag.init()

            tag.content = TTGTextTagStringContent(text: text ,textFont: UIFont.systemFont(ofSize: 20), textColor: UIColor.systemIndigo)
            tag.style = style
            tag.selectedStyle = selected
            
            if selectedTags != nil {
                for t in selectedTags{
                    if text == t {
                        tag.selected = true
                    }
                }
            }
        
            collectionView.addTag(tag)
        }
        collectionView.reload()
    }
    
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            collectionView.frame = CGRect(x: 0, y: 180, width: view.frame.size.width, height: view.frame.size.height)
        }
}

