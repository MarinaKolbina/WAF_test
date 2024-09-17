//
//  UIImageViewExtension.swift
//  TestAssigmentWAF
//
//  Created by Marina Kolbina on 14/09/2024.
//

import UIKit
import SDWebImage

extension UIImageView {
    func loadImage(from urlString: String, placeholder: UIImage? = nil) {
        guard let url = URL(string: urlString) else {
            self.image = placeholder
            return
        }
        
        self.sd_setImage(with: url, placeholderImage: placeholder, options: .highPriority, completed: nil)
    }
}
