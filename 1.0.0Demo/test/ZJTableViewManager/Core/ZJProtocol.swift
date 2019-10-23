//
//  ZJProtocol.swift
//  test
//
//  Created by Jie Zhang on 2019/10/18.
//  Copyright © 2019 Green Dot. All rights reserved.
//

import Foundation
import UIKit

public protocol ZJCellProtocol where Self: UITableViewCell {
    func cellWillAppear(_ cellItem: ZJTableViewItem)
    func cellDidAppear()
    func cellDidDisappear()
}

public protocol ZJPrepareProtocol where Self: UITableViewCell {
    associatedtype ZJTableViewItemType: ZJTableViewItem
    var item: ZJTableViewItemType! { get set }
    func prepareWillAppear(_ i: AnyObject)
}

extension ZJPrepareProtocol {
    
    /// Must write prepareWillAppear(:) method at the top of cellWillAppear(:)
    ///
    /// - Parameter i: Item
    public func prepareWillAppear(_ i: AnyObject) {
        let inItem = i as? ZJTableViewItemType
        assert(inItem != nil, "i must confirm to ZJPrepareProtocol")
        item = inItem
    }
}



