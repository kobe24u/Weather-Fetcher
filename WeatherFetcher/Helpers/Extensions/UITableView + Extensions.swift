//
//  UITableView + Extensions.swift
//  WeatherFetcher
//
//  Created by Vinnie Liu on 6/2/21.
//

import UIKit

public extension UITableView {
    func dequeueOrCreateCell<T: UITableViewCell>(style: UITableViewCell.CellStyle = .default, onInit: (T) -> Void = { _ in }) -> T {
        let reuseID = String(describing: T.self)
        
        var cell: T! = self.dequeueReusableCell(withIdentifier: reuseID) as? T
        
        if cell == nil {
            cell = T(style: style, reuseIdentifier: reuseID)
        }
        
        onInit(cell)
        
        return cell
    }
}
