//
//  CustomButton.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/23/22.
//
//  swiftlint: disable all
import UIKit

@IBDesignable
class UICustomButton: UIButton {
    // button border colors
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
           self.layer.borderColor = borderColor.cgColor
        }
    }// button border width
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
           self.layer.borderWidth = borderWidth
        }
    }
    
    // button corner radius
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
           self.layer.cornerRadius = cornerRadius
        }
    }
    
    public override class var layerClass: AnyClass {
           CAGradientLayer.self
    }
        
    private var gradientLayer: CAGradientLayer {
            layer as! CAGradientLayer
    }// button start color gradient
    @IBInspectable public var startColor: UIColor = .white {
        didSet {
           updateColors()
        }
    }
        
    // button end color gradient
    @IBInspectable public var endColor: UIColor = .red {
       didSet {
          updateColors()
       }
    }
        
    // button start point gradient
    @IBInspectable public var startPoint: CGPoint {
        get {
            gradientLayer.startPoint
        }
            
        set {
            gradientLayer.startPoint = newValue
        }
     }
        
     // button end point gradient
     @IBInspectable public var endPoint: CGPoint {
        get {
            gradientLayer.endPoint
        }
        set {
            gradientLayer.endPoint = newValue
        }
     }
        
     // update colores gradient
     private func updateColors() {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
     }
}

//swiftlint: enable all
extension UICustomButton {
    
    func animateButton() {
        UIView.animate(
            withDuration: 0.3,
            animations: { [unowned self] in
                self.transform = .init(scaleX: 0.9, y: 0.8)
            },
            completion: { [unowned self] _ in
                self.transform = .identity
            }
        )
    }
}
