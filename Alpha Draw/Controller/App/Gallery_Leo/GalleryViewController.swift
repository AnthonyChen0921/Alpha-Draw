//
//  GalleryViewController.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/25/22.
//

import UIKit

class GalleryViewController: UIViewController {

    let AlbumAccess = PhotoAccess.sharedInstance
    let NumPerPage: Int = 21
    var ImageGallery: [UIImageView] = []
    var RecentGallery: [UIImageView] = []
    var CachedImages: [UIImageView] = []
    var RecentImages: [UIImageView] = []
    var RecentImageStartAt: Int = 0
    var PageNumber:  Int = 0
    var PageCurrent: Int = 0
    var ImageWidth: CGFloat?
    var ImageGap:   CGFloat?
    var ImageHeight: CGFloat?
    let db = Firebase()

    
    @IBOutlet weak var ImageAreaHeight: NSLayoutConstraint!
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

        //AlbumAccess.loadPhotos()
        loadPhotosFromDB()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        print("viewWillAppear is called")
        updatePhotos()
        showPhotos()
    }
    
    @objc private func didSwipeLeft(_ sender: UISwipeGestureRecognizer) {
        print("swipe to left")
        if PageCurrent < PageNumber - 1 {
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
        
        guard let vc = storyboard?.instantiateViewController(identifier: "SingleImage") as? SingleImageViewController else {
            print("Failed to get vc from stroyboard")
            return
        }
        
        let idx = getIndex(pos: loc)
        print("Clicked at \(loc), index is \(idx)")
        
        if idx < ImageGallery.count {
            vc.loadData(image: ImageGallery[idx].image!)
            navigationController?.pushViewController(vc, animated: true)
            print("After push view controller")
        }

        let recentStart = 3 * ((ImageGallery.count + 2)/3)

        if idx < recentStart {
            return
        }
        
        let offset = idx - recentStart
        if offset < RecentGallery.count {
            vc.loadData(image: RecentGallery[offset].image!)
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func updatePhotos() {
        let count = AlbumAccess.PhotoLibary.count
        let start = CachedImages.count
        for idx in 0..<count {
            let imgView = UIImageView()

            imgView.image = AlbumAccess.PhotoLibary[idx]
            print("From PhotoLibary #\(idx) image loaded")
            
            CachedImages.insert(imgView, at: idx)
        }
        AlbumAccess.PhotoLibary.removeAll()
        RecentImageStartAt = 3 * ((CachedImages.count + 2)/3)
        let numPerPage = NumPerPage
        PageNumber = (RecentImageStartAt + RecentImages.count + numPerPage - 1) / numPerPage
    }
    
    func showPhotos() {
        showImageGallery()
        showRecentGallery()
    }
    
    func showImageGallery() {
        let numPerPage = NumPerPage
        let imageNum  = CachedImages.count
        let pageStart = PageCurrent * numPerPage
        var pageEnd: Int
        
        if pageStart + numPerPage > imageNum - 1 {
            pageEnd = imageNum - 1
        } else {
            pageEnd = pageStart + numPerPage - 1
        }
        
        for imgView in ImageGallery {
            ImageArea.willRemoveSubview(imgView)
            imgView.removeFromSuperview()
        }
        
        ImageScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        ImageGallery.removeAll()



        if imageNum > pageStart {
            print("Render images")

            print("show cached images from \(pageStart) to \(pageEnd)")
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
    
    func loadPhotosFromDB() {
        if let user_id = UserDefaults.standard.string(forKey: "user_id") {
            db.getImageListFromStorageByUserID(userid: user_id, completion: { results in
                for imageID in results {
                    self.db.getImageFromStorageById(id: imageID, userid: user_id, imageType: "StableDiffusion", completion: { image in
                        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                        imgView.image = image
                        self.RecentImages.append(imgView)
                        print("Photo #\(self.RecentImages.count) has been loaded from firebase")
                        self.showRecentGallery()
                    })
                }
            })
        }
    }
    
    func showRecentGallery() {
        let pageStart = PageCurrent * NumPerPage

        let start = 3 * ((ImageGallery.count + 2) / 3)
        if start >= 21 {
            return
        }

        if RecentImageStartAt > pageStart + start {
            return
        }
        
        for imgView in RecentGallery {
            ImageArea.willRemoveSubview(imgView)
            imgView.removeFromSuperview()
        }
        
        RecentGallery.removeAll()

        let imageStart = pageStart + start - RecentImageStartAt
        var pageRest = 21 - start
        let imageRest = RecentImages.count - imageStart
        if pageRest > imageRest {
            pageRest = imageRest
        }

        for idx in 0 ..< pageRest {
            let imageIndex = idx + imageStart
            let imgView = RecentImages[imageIndex]
            imgView.frame = getPosition(index: start + idx)

            ImageArea.addSubview(imgView)
            ImageArea.didAddSubview(imgView)
            RecentGallery.append(imgView)
        }
        
        let constraint = (ImageHeight! + ImageGap!) * CGFloat((start + pageRest + 2)/3)
        if constraint < ImageScrollView.frame.height {
            ImageAreaHeight.constant = ImageScrollView.frame.height
        } else {
            ImageAreaHeight.constant = constraint
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
