//
//  Level2Cell.swift
//  ZJAccordionEffectDemo
//
//  Created by Javen on 2019/3/20.
//  Copyright © 2019 Javen. All rights reserved.
//

import UIKit
import ZJTableViewManager

final class Level2CellItem: ZJAccordionItem, ZJItemable {
    static var cellClass: ZJBaseCell.Type { Level2Cell.self }
    override init() {
        super.init()
        height = 50
    }
}

class Level2Cell: ZJCell<Level2CellItem>, ZJCellable {
    func cellPrepared() {}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
