//
//  ZJTextCell.swift
//  NewRetail
//
//  Created by Javen on 2018/3/5.
//  Copyright © 2018年 上海勾芒信息科技有限公司. All rights reserved.
//

import UIKit

class ZJTextCell: ZJTableViewCell, UITextViewDelegate {
    @IBOutlet weak var textView: ZJTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.textView.delegate = self
    }

    
    override func cellWillAppear() {
        super.cellWillAppear()
        let item = self.item as! ZJTextItem
        textView.placeholder = item.placeHolder
        textView.text = item.text
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let item = self.item as! ZJTextItem
        item.text = textView.text
        item.didChanged?(self.item)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
