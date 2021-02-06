//
//  UIViewController + Extensions.swift
//  WeatherFetcher
//
//  Created by Vinnie Liu on 6/2/21.
//

import UIKit

extension UIViewController {
    func addChildViewController(containerView: UIView, childVC: UIViewController) {
        self.addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.didMove(toParent: self)
    }
    
    func presentActionAlert(title: String, message: String, event: @escaping() -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            event()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
