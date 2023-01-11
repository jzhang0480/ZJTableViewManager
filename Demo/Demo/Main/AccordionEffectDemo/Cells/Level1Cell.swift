//
//  Level1Cell.swift
//  ZJAccordionEffectDemo
//
//  Created by Javen on 2019/3/20.
//  Copyright © 2019 Javen. All rights reserved.
//

import UIKit
import ZJTableViewManager

final class Level1CellItem: ZJAccordionItem, ZJItemable {
    static var cellClass: ZJBaseCell.Type { Level1Cell.self }

    override init() {
        super.init()
        height = 50
    }
}

class Level1Cell: ZJCell<Level1CellItem>, ZJCellable {
    func cellPreparedForReuse() {}

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        // Initialization code
    }
}
