//
//  Category1Cell.swift
//  Demo2
//
//  Created by Javen on 2019/5/14.
//  Copyright © 2019 上海勾芒信息科技. All rights reserved.
//

import UIKit
import ZJTableViewManager
class Category1CellItem: ZJTableViewItem {
    var title: String!
    
}

class Category1Cell: UITableViewCell, ZJCellProtocol {
    var item: Category1CellItem!
    
    typealias ZJCelltemClass = Category1CellItem
    
    func cellWillAppear() {
        
    }
    
    
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var categoryTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
//    override func cellWillAppear() {
//        super.cellWillAppear()
//        let item = self.item as! Category1CellItem
//        categoryTitle.text = item.title
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            indicatorView.backgroundColor = UIColor.blue
        }else{
            indicatorView.backgroundColor = UIColor.lightGray
        }

        // Configure the view for the selected state
    }
    
}
