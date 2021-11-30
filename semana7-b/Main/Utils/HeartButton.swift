//
//  HeartButton.swift
//  semana7-b
//
//  Created by Linder Hassinger on 3/11/21.
//

import Foundation
import UIKit

class HeartButton: UIButton {
    
    private let unlikedImage = UIImage(named: "heart")
    private let likedImage = UIImage(named: "heart_like")
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setImage(unlikedImage, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: \(coder) no puede ser implementado")
    }
}
