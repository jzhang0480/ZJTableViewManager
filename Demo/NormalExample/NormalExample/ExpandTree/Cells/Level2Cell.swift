//
//  Level2Cell.swift
//  ZJExpandTreeDeme
//
//  Created by Javen on 2019/3/20.
//  Copyright © 2019 Javen. All rights reserved.
//

import UIKit

class Level2CellItem: ZJExpandTreeCellItem {}

class Level2Cell: UITableViewCell, ZJCellProtocol {
    var item: Level2CellItem!

    typealias ZJCellItemClass = Level2CellItem

    func cellPrepared() {}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
