//
//  ZJTableViewManagerCell.swift
//  NewRetail
//
//  Created by Javen on 2018/2/8.
//  Copyright © 2018年 上海勾芒信息科技有限公司. All rights reserved.
//

import UIKit

open class ZJTableViewCell: UITableViewCell {
    public var item: ZJTableViewItem!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    open func cellWillAppear() {
        
        
    }
    
    open func cellDidAppear() {
        let item = self.item as ZJTableViewItem
        if item.isHideSeparator {
            self.separatorInset = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: self.bounds.size.width - 15)
        }else{
            self.separatorInset = UIEdgeInsets.init(top: 0, left: item.separatorLeftMargin, bottom: 0, right: 0)
        }
    }
    
    open func cellDidDisappear() {
        
    }
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

