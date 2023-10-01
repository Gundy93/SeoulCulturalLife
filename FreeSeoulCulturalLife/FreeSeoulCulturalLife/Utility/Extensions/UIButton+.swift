//
//  UIButton+.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/27.
//

import UIKit

extension UIButton {
    
    convenience init(primaryAction: UIAction?,
                     image: UIImage?) {
        self.init(primaryAction: primaryAction)
        setImage(image, for: .normal)
    }
    
    convenience init(title: String) {
        self.init()
        titleLabel?.text = title
    }
}
