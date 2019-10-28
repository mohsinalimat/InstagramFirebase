//
//  CustomImageView.swift
//  InstagramFirebase
//
//  Created by renks on 22/10/2019.
//  Copyright © 2019 Renald Shchetinin. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastUrlUsedToLoadImage: String?
    
    func loadImage(urlString: String) {
        lastUrlUsedToLoadImage = urlString
        
        self.image = nil
        
        if let cacheImage = imageCache[urlString] {
            self.image = cacheImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to fetch post image:", err)
                return
            }
            
            if url.absoluteString != self.lastUrlUsedToLoadImage { return }
            
            guard let imageData = data else { return }
            
            let photoImage = UIImage(data: imageData)
            
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
        }.resume()
    }
}
