//
//  Level2Cell.swift
//  ZJExpandTreeDeme
//
//  Created by Javen on 2019/3/20.
//  Copyright © 2019 Javen. All rights reserved.
//

import UIKit
import ZJTableViewManager

class Level2CellItem: ZJTableViewAccordionItem {
    override init() {
        super.init()
        self.cellHeight = 50
    }
}

class Level2Cell: UITableViewCell, ZJCellProtocol {
    var item: Level2CellItem!

    typealias ZJCellItemClass = Level2CellItem

    func cellPrepared() {}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
