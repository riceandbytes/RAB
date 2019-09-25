
import Foundation
import UIKit

/**
 Usage:
 
 let gradient = CAGradientLayer(start: .center, end: .bottomRight, colors: [UIColor.black.cgColor, UIColor.white.cgColor], type: .radial)
 gradient.frame = view.bounds
 view.layer.addSublayer(gradient)
 
 */
public extension CAGradientLayer {
    
    enum Point {
        case topLeft
        case centerLeft
        case bottomLeft
        case topCenter
        case center
        case bottomCenter
        case topRight
        case centerRight
        case bottomRight
        
        var point: CGPoint {
            switch self {
            case .topLeft:
                return CGPoint(x: 0, y: 0)
            case .centerLeft:
                return CGPoint(x: 0, y: 0.5)
            case .bottomLeft:
                return CGPoint(x: 0, y: 1.0)
            case .topCenter:
                return CGPoint(x: 0.5, y: 0)
            case .center:
                return CGPoint(x: 0.5, y: 0.5)
            case .bottomCenter:
                return CGPoint(x: 0.5, y: 1.0)
            case .topRight:
                return CGPoint(x: 1.0, y: 0.0)
            case .centerRight:
                return CGPoint(x: 1.0, y: 0.5)
            case .bottomRight:
                return CGPoint(x: 1.0, y: 1.0)
            }
        }
    }
    
//    convenience init(start: Point, end: Point, colors: [CGColor], layerType: CAGradientLayerType) {
    convenience init(start: Point, end: Point, colors: [CGColor]) {
        self.init()
        self.startPoint = start.point
        self.endPoint = end.point
        self.colors = colors
        self.locations = (0..<colors.count).map(NSNumber.init)
//        self.type = layerType as String
    }
}
