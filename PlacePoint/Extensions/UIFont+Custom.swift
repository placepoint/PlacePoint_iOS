

import UIKit

enum CustomFont: String {
    
    case ubuntuBoldItalic     = "Ubuntu-BoldItalic"
    
    case ubuntuLight    = "Ubuntu-Light"
    
    case ubuntuRegular    = "Ubuntu-Regular"
    
    case ubuntuMediumItalic    = "Ubuntu-MediumItalic"
    
    case ubuntuLightItalic    = "Ubuntu-LightItalic"
    
    case ubuntuMedium    = "Ubuntu-Medium"
    
    case ubuntuBold    = "Ubuntu-Bold"
}

extension UIFont {
    
    convenience init?(customFont: CustomFont, withSize size: CGFloat) {
        self.init(name: customFont.rawValue, size: size)
    }
}

//Ubuntu ["Ubuntu-BoldItalic", "Ubuntu-Light", "Ubuntu-Regular", "Ubuntu-MediumItalic", "Ubuntu-LightItalic", "Ubuntu-Medium", "Ubuntu-Bold"]
