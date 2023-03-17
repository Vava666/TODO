//
//  Resources.swift
//  TODO
//
//  Created by Artem Vavilov on 03.03.2023.
//

import UIKit

//MARK: - user
enum Colors: String, CaseIterable {
    case blue = "Blue"
    case lightBlue = "LightBlue"
    case green = "Green"
    case pink = "Pink"
    case red = "Red"
    
    var color: UIColor {
        return UIColor(named: self.rawValue) ?? .clear
    }
    
    static var allCases: [Colors] {
        return [.blue, .red, .green, .pink]
    }
}

//MARK: - main
enum ColorsInter {
    static let background = UIColor(named: "Background")
    static let backgroundSub = UIColor(named: "BackgroundSub")
    static let textMain = UIColor(named: "TextMain")
    static let textSub = UIColor(named: "TextSub")
}
