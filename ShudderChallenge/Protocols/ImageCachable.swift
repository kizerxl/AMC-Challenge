//
//  ImageCachable.swift
//  ShudderChallenge
//
//  Created by Felix Changoo on 10/27/18.
//  Copyright © 2018 Felix Changoo. All rights reserved.
//

import UIKit
import Alamofire

protocol ImageCachable {}
let imageCache = NSCache<NSString, UIImage>()

extension UIImageView: ImageCachable {}

extension ImageCachable where Self: UIImageView {
    typealias completion = (Bool) -> ()
    func getImageUsingCacheWithURLString(_ URLString: String, placeholder: UIImage?, completionHandler completion: @escaping completion) {
        
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.image = cachedImage
                completion(true)
            }
            return
        }
        self.image = placeholder
        
        if let url = URL(string: URLString) {
            Alamofire.request(url).response(completionHandler: { [weak self] response in
                guard let strongSelf = self else { return }
                
                if let data = response.data {
                    if let downloadedImage = UIImage(data: data) {
                        imageCache.setObject(downloadedImage, forKey: URLString as NSString)
                        DispatchQueue.main.async {
                            strongSelf.image = downloadedImage
                        }
                        completion(true)
                    } else {
                        strongSelf.image = placeholder
                    }
                } else {
                    strongSelf.image = placeholder
                }
            })
        }
    }
}
