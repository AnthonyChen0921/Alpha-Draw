//
//  Function.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/21/22.
//

import UIKit


/**
    * @brief: get image from url, if url is not valid, use no-image image
    */
func getImageFromUrl(url: String) -> UIImage {
    // if url is not valid, use no-image image
    if url == "" {
        return UIImage(named: "no-image")!
    }
    // get the image from the url
    let url = URL(string: url)
    let data = try! Data(contentsOf: url!)
    return UIImage(data: data)!
}

/**
    *  @breif Hides the back button on the navigation bar
    */
func hidesBackButton(view: UIViewController) {
    // hides back button
    view.navigationItem.setHidesBackButton(true, animated: false)
    view.tabBarController?.navigationItem.setHidesBackButton(true, animated: false)
}

