//
//  ZJProtocol.swift
//  test
//
//  Created by Jie Zhang on 2019/10/18.
//  Copyright © 2019 Green Dot. All rights reserved.
//

import Foundation
import UIKit

public protocol ZJItemProtocol where Self: ZJTableViewItem {}

public protocol DefaultCellProtocol where Self: UITableViewCell {
    var _item: ZJItemProtocol? { get set }
    func cellWillAppear()
    func cellDidAppear()
    func cellDidDisappear()
}

public protocol ZJCellProtocol: DefaultCellProtocol {
    associatedtype ZJCelltemType: ZJItemProtocol
    var item: ZJCelltemType! { get set }
}

public extension ZJCellProtocol {
    var _item: ZJItemProtocol? {
        get {
            return item
        }
        set {
            item = (newValue as! Self.ZJCelltemType)
        }
    }
}

extension ZJTableViewItem: ZJItemProtocol {}
