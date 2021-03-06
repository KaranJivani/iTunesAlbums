//
//  Extensions.swift
//  iTunesAlbums
//
//  Created by Karan Jivani on 03/24/20.
//  Copyright © 2019 Karan Jivani. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    class func showAlert(with message: String, on: UIViewController) {
        let alert = UIAlertController(title: "Some Error!!!", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

        on.present(alert, animated: true)
    }
}

extension UIView {
 
     func anchor (top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat, enableInsets: Bool) {
        
         var topInset = CGFloat(0)
         var bottomInset = CGFloat(0)
         
         if #available(iOS 11, *), enableInsets {
             let insets = self.safeAreaInsets
             topInset = insets.top
             bottomInset = insets.bottom
         }
         
         translatesAutoresizingMaskIntoConstraints = false
         
         if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop+topInset).isActive = true
         }
         if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
         }
         if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
         }
         if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom-bottomInset).isActive = true
         }
         if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
         }
         if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
         }
     }
}

extension UILabel {
    
    static func createLabel() -> UILabel {
        
        let lbl = UILabel()
        lbl.textColor = .gray
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }
    
    static func createBoldLabel() -> UILabel {
       
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 17)
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
        
    }
}

private var imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    static func createImageView() -> UIImageView {
        
        let imgView = UIImageView(image: nil)
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }
    
     /**
      Add image on ImageView by downloading image from url
      
      Download image and store in cache.
      
      Check cache, if cache is not nil then get image from cache and avoid downloading of image from url
      
      - Parameter photoURL: This is the url from where image will be downloaded
      */
     
     func loadImage(with photoURL: String?) {
         
         guard let photoURL = photoURL else {
             setImageView(with: UIImage(named: "noImage"))
             return
         }
         
         guard let url = URL(string: photoURL) else {
             return
         }
         
         if let cachedImage = imageCache.object(forKey: NSString(string: photoURL)) {
             
             self.setImageView(with: cachedImage)
             
         }else {
             
             DispatchQueue.global().async {
                 
                 URLSession.shared.dataTask(with: url) { (data, response, error) in
                     
                     if let data = data {
                         imageCache.setObject(UIImage(data: data) ?? UIImage(), forKey: NSString(string: photoURL))
                         self.setImageView(with: UIImage(data: data))
                     }
                 }.resume()
             }
         }
     }
    
    /**
     Set image on ImageView
     
     - Parameter image: image to add on ImageView
     */
    
    func setImageView(with image: UIImage?) {
        
        DispatchQueue.main.async {
            self.image = image
        }
    }
}
