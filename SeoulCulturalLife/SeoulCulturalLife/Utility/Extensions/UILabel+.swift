//
//  UILabel+.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/27.
//

import UIKit

extension UILabel {
    
    convenience init(text: String? = nil, font: UIFont = .systemFont(ofSize: 17), textAlignment: NSTextAlignment = .natural, numberOfLines: Int = 1) {
        self.init(frame: .zero)
        
        self.text = text
        self.font = font
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
    }
}
