//
//  GalleryViewController.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/25/22.
//

import UIKit

class GalleryViewController: UIViewController {

    let AlbumAccess = PhotoAccess.sharedInstance
    static let NumPerPage: Int = 21
    var ImageGallery: [UIImageView] = []
    var CachedImages: [UIImageView] = []
    var PageNumber:  Int = 0
    var PageCurrent: Int = 0
    var ImageWidth: CGFloat?
    var ImageGap:   CGFloat?
    var ImageHeight: CGFloat?

    
    @IBOutlet weak var ImageScrollView: UIScrollView!
    @IBOutlet weak var ImageArea: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ImageWidth  = ImageArea.frame.width * 0.3
        ImageGap    = ImageArea.frame.width * 0.03
        ImageHeight = ImageWidth! * 1.5

        // Initialize Swipe Gesture Recognizer
        let swipeGestureRecognizerLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeft(_:)))

        // Configure Swipe Gesture Recognizer
        swipeGestureRecognizerLeft.direction = .left
        
        ImageArea.addGestureRecognizer(swipeGestureRecognizerLeft)
        
        let swipeGestureRecognizerRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeRight(_:)))

        // Configure Swipe Gesture Recognizer
        swipeGestureRecognizerRight.direction = .right
        
        ImageArea.addGestureRecognizer(swipeGestureRecognizerRight)

        AlbumAccess.loadPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        print("viewWillAppear is called")
        updatePhotos()
        showPhotos()
    }
    
    @objc private func didSwipeLeft(_ sender: UISwipeGestureRecognizer) {
        print("swipe to left")
        if PageCurrent < PageNumber {
            PageCurrent += 1
            print("Show next page")
            
            showPhotos()
        }
    }
    
    @objc private func didSwipeRight(_ sender: UISwipeGestureRecognizer) {
            print("swipe to right")
        if PageCurrent > 0 {
            PageCurrent -= 1
            print("Show previous page")
            
            showPhotos()
        }
    }


    @IBAction func onClickImage(_ sender: UITapGestureRecognizer) {
        let loc = sender.location(in: ImageArea)
        
        print("Clicked at \(loc)")
        
        guard let vc = storyboard?.instantiateViewController(identifier: "SingleImage") as? SingleImageViewController else {
            print("Failed to get vc from stroyboard")
            return
        }
        
        let idx = getIndex(pos: loc)
        
        if idx < ImageGallery.count {
            vc.loadData(image: ImageGallery[idx].image!)
            navigationController?.pushViewController(vc, animated: true)
            print("After push view controller")
        }
    }

    func updatePhotos() {
        let count = AlbumAccess.PhotoLibary.count
        let start = CachedImages.count
        for idx in start..<count {
            let imgView = UIImageView()

            imgView.image = AlbumAccess.PhotoLibary[idx]
            print("#\(idx) image loaded")
            
            CachedImages.append(imgView)
        }
        
        let numPerPage = GalleryViewController.NumPerPage
        PageNumber = (count + numPerPage - 1) / numPerPage
    }
    
    func showPhotos(){
        let numPerPage = GalleryViewController.NumPerPage
        let imageNum  = CachedImages.count
        let pageStart = PageCurrent * numPerPage
        var pageEnd: Int
        
        if pageStart + numPerPage > imageNum - 1 {
            pageEnd = imageNum - 1
        } else {
            pageEnd = pageStart + numPerPage - 1
        }
        
        if imageNum > pageStart {
            print("Render images")

            for imgView in ImageGallery {
                ImageArea.willRemoveSubview(imgView)
                imgView.removeFromSuperview()
            }
            
            ImageScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            ImageGallery.removeAll()

            print("show cached movie from \(pageStart) to \(pageEnd)")
            for idx in pageStart...pageEnd {
                let imgView = CachedImages[idx]
                imgView.frame = getPosition(index: idx - pageStart)

                ImageArea.addSubview(imgView)
                ImageArea.didAddSubview(imgView)
                ImageGallery.append(imgView)
            }
            //self.PageNumber.text = "\(self.CurrentPage+1)/\(self.PageTotal)"
            
        }
    }
    
    func getPosition(index: Int) -> CGRect {
        let width  = ImageWidth!
        let height = ImageHeight!
        let gap    = ImageGap!
        let x: CGFloat = CGFloat(index % 3) * (width + gap) + 0.667*gap
        let y: CGFloat = CGFloat(index / 3) * (height + gap)
        let imgRect = CGRect(x: x, y: y, width: width, height: height)

        return imgRect
    }
    
    func getIndex(pos: CGPoint) -> Int {
        let width  = ImageWidth! + ImageGap!
        let height = ImageHeight! + ImageGap!
        let col:Int = Int(pos.x / (width+0.01))
        let raw:Int = Int(pos.y / (height+0.01))
        let idx:Int = col + raw*3
        
        return idx
    }
}
