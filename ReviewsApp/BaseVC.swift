//
//  BaseVCViewController.swift
//  ReviewsApp
//

import UIKit

class BaseVC: UIViewController {
    var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showActivityIndicator(title: String? = "Loading..") {
        self.bgView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        // blur effect
        if !UIAccessibility.isReduceTransparencyEnabled {
            self.bgView.backgroundColor = .clear
            
            let blurEffect = UIBlurEffect(style: .extraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.bgView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.bgView.addSubview(blurEffectView)
        } else {
            self.bgView.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.5)
        }
        
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        indicatorView.hidesWhenStopped = true
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        self.bgView.addSubview(indicatorView)
        
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = title
        label.textColor = UIColor.gray
        label.sizeToFit()
        label.center = CGPoint(x: indicatorView.center.x, y: indicatorView.center.y + 30)
        self.bgView.addSubview(label)
        
        self.view.addSubview(self.bgView)
    }
    
    func hideActivityIndicator(){
        if(self.bgView != nil && self.bgView.isDescendant(of: self.view)){
            self.bgView.removeFromSuperview()
            self.bgView = nil
        }
    }
    
    //MARK: - Controller helper methods
    func showAlertView(title: String, message: String, firstBtnTitle: String, firstBtnAction: @escaping (UIAlertAction) -> Void = { _ in}, secondBtnTitle: String? = nil, secondBtnAction: @escaping ((UIAlertAction) -> Void) = { _ in}, preferredStyle: UIAlertController.Style = .alert) {
        
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: firstBtnTitle, style: .default, handler: firstBtnAction))
        if let secBtnTitle = secondBtnTitle{
            alert.addAction(UIAlertAction(title: secBtnTitle, style: .default, handler: secondBtnAction))
        }
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}


