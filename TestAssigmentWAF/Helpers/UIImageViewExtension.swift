//
//  UIImageViewExtension.swift
//  TestAssigmentWAF
//
//  Created by Marina Kolbina on 14/09/2024.
//

import UIKit
import SDWebImage

extension UIImageView {
    func loadImage(from urlString: String, placeholder: UIImage? = nil, completion: ((Bool) -> Void)? = nil) {
        guard let url = URL(string: urlString) else {
            self.image = placeholder
            completion?(false)  // Invalid URL case
            return
        }
        
        self.sd_setImage(with: url, placeholderImage: placeholder, options: .highPriority) { (image, error, cacheType, url) in
            DispatchQueue.main.async {
                if let _ = error {
                    print("Failed to load image from URL: \(urlString)")
                    completion?(false) // Failure case
                } else {
                    completion?(true) // Success case
                }
            }
        }
    }
}
