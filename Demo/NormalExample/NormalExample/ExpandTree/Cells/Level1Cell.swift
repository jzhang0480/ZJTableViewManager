//
//  Level1Cell.swift
//  ZJExpandTreeDeme
//
//  Created by Javen on 2019/3/20.
//  Copyright © 2019 Javen. All rights reserved.
//

import UIKit

class Level1CellItem: ZJExpandTreeCellItem {}

class Level1Cell: UITableViewCell, ZJCellProtocol {
    var item: Level1CellItem!

    typealias ZJCellItemClass = Level1CellItem

    func cellPrepared() {}

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        // Initialization code
    }
}
