//
//  Level0Cell.swift
//  ZJExpandTreeDeme
//
//  Created by Javen on 2019/3/20.
//  Copyright © 2019 Javen. All rights reserved.
//

import UIKit

class Level0CellItem: ZJExpandTreeCellItem {
    var title: String?
}

class Level0Cell: UITableViewCell, ZJTableViewCellProtocol {
    @IBOutlet weak var labelTitle: UILabel!
    var item: Level0CellItem!
    
    typealias ZJCelltemClass = Level0CellItem
    
    func cellWillAppear() {
        labelTitle.text = item.title
    }
    
    func cellDidAppear() {}
    
    func cellDidDisappear() {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
