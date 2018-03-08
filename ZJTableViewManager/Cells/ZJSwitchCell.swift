//
//  ZJSwitchCell.swift
//  ZJTableViewManagerExample
//
//  Created by Javen on 2018/3/7.
//  Copyright © 2018年 上海勾芒信息科技. All rights reserved.
//

import UIKit

open class ZJSwitchCell: ZJTableViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override open func cellWillAppear() {
        super.cellWillAppear()
        let item = self.item as! ZJSwitchItem
        self.labelTitle.text = item.title
        self.switchButton.isOn = item.isOn
    }
    
    @IBAction func valueChanged(_ sender: UISwitch) {
        let item = self.item as! ZJSwitchItem
        item.isOn = sender.isOn
        item.didChanged?(item)
        
    }
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

