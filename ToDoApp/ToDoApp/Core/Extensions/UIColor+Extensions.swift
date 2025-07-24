//
//  UIColor+Extensions.swift
//  ToDoApp
//
//  Created by Kno Harutyunyan on 24.07.25.
//

import UIKit.UIColor

extension UIColor {
    static func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}
