//
//  Level3Cell.swift
//  ZJExpandTreeDeme
//
//  Created by Javen on 2019/3/20.
//  Copyright © 2019 Javen. All rights reserved.
//

import UIKit

class Level3CellItem: ZJExpandTreeCellItem {}

class Level3Cell: UITableViewCell, ZJCellProtocol {
    var item: Level3CellItem!

    typealias ZJCellItemClass = Level3CellItem

    func cellWillAppear() {}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
