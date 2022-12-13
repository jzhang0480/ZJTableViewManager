//
//  Level0Cell.swift
//  ZJAccordionEffectDemo
//
//  Created by Javen on 2019/3/20.
//  Copyright © 2019 Javen. All rights reserved.
//

import UIKit
import ZJTableViewManager

class Level0CellItem: ZJAccordionItem {
    var title: String?
    override init() {
        super.init()
        self.cellHeight = 50
    }
}

class Level0Cell: ZJCell<Level0CellItem>, ZJCellProtocol {
    @IBOutlet var labelTitle: UILabel!

    func cellPrepared() {
        labelTitle.text = item.title
    }

    func cellDidAppear() {}

    func cellDidDisappear() {}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
