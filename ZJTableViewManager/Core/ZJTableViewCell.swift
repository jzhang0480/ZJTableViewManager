//
//  ZJTableViewManagerCell.swift
//  NewRetail
//
//  Created by Javen on 2018/2/8.
//  Copyright © 2018年 上海勾芒信息科技有限公司. All rights reserved.
//

import UIKit

public class ZJTableViewCell: UITableViewCell {
    var item: Any!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func cellWillAppear() {
        
        
    }
    
    public func cellDidAppear() {
        let item = self.item as! ZJTableViewItem
        if item.isHideSeparator {
            self.separatorInset = UIEdgeInsetsMake(0, 15, 0, self.bounds.size.width - 15)
        }else{
            self.separatorInset = UIEdgeInsetsMake(0, item.separatorLeftMargin, 0, 0)
        }
    }
    
    public func cellDidDisappear() {
        
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
