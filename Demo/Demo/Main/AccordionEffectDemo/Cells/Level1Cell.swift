//
//  Level1Cell.swift
//  ZJAccordionEffectDemo
//
//  Created by Javen on 2019/3/20.
//  Copyright © 2019 Javen. All rights reserved.
//

import UIKit
import ZJTableViewManager

class Level1CellItem: ZJAccordionItem {
    override init() {
        super.init()
        self.cellHeight = 50
    }
}

class Level1Cell: ZJCell<Level1CellItem>, ZJCellProtocol {

    func cellPrepared() {}

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        // Initialization code
    }
}
