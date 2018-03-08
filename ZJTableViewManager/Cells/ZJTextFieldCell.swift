//
//  ZJTextFieldCell.swift
//  ZJTableViewManagerExample
//
//  Created by Javen on 2018/3/7.
//  Copyright © 2018年 上海勾芒信息科技. All rights reserved.
//

import UIKit

open class ZJTextFieldCell: ZJTableViewCell {
    @IBOutlet weak var titleConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        self.textField.addTarget(self, action: #selector(textFieldDidChanged(textField:)), for: UIControlEvents.editingChanged)
        // Initialization code
    }
    
    override open func cellWillAppear() {
        super.cellWillAppear()
        let item = self.item as! ZJTextFieldItem
        if item.isFullLength {
            self.titleConstraint.constant = 0
        }else{
            self.labelTitle.text = item.title
        }
        self.textField.isSecureTextEntry = item.isSecureTextEntry
        self.textField.text = item.text
        self.textField.placeholder = item.placeHolder
        
        
    }
    
    @objc func textFieldDidChanged(textField: UITextField) {
        let item = self.item as! ZJTextFieldItem
        item.text = textField.text
        item.didChanged?(item)
    }
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

