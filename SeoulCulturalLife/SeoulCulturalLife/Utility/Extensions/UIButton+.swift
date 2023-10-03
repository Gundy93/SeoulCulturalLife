//
//  UIButton+.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/27.
//

import UIKit

extension UIButton {
    
    convenience init(primaryAction: UIAction?,
                     image: UIImage? = nil,
                     title: String? = nil) {
        self.init(primaryAction: primaryAction)
        
        setImage(image,
                 for: .normal)
        setTitle(title,
                 for: .normal)
    }
}
