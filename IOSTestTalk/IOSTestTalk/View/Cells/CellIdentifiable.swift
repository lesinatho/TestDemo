//
//  CellIdentifiable.swift
//

import Foundation
import UIKit


// MARK: -  For using identifier and nib of cell 
protocol CellIdentifiable {
    static var nib: UINib { get }
    static var identifier: String { get }
}

extension CellIdentifiable {
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    static var identifier: String {
        return String(describing: self)
    }

}
