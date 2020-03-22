//
//  ZJTextCell.swift
//  NewRetail
//
//  Created by Javen on 2018/3/5.
//  Copyright © 2018年 上海勾芒信息科技有限公司. All rights reserved.
//

import UIKit

open class ZJTextCell: UITableViewCell, UITextViewDelegate, ZJCellProtocol {
    public var item: ZJTextItem!

    public typealias ZJCelltemType = ZJTextItem

    @IBOutlet var textView: ZJTextView!

    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textView.delegate = self
    }

    public func cellWillAppear() {
        textView.placeholder = item.placeHolder
        textView.text = item.text
        textView.backgroundColor = item.textViewBackgroundColor
    }

    public func cellDidAppear() {}

    public func cellDidDisappear() {}

    public func textViewDidChange(_ textView: UITextView) {
        item.text = textView.text
        item.didChanged?(item)
    }

    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
