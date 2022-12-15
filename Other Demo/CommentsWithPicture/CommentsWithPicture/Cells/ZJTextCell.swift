//
//  ZJTextCell.swift
//  NewRetail
//
//  Created by Javen on 2018/3/5.
//  Copyright © 2018年 上海勾芒信息科技有限公司. All rights reserved.
//

import UIKit
import ZJTableViewManager

open class ZJTextItem: ZJTableViewItem {
    public var text: String?
    public var placeHolder: String?
    public var textViewBackgroundColor: UIColor = .white
    public var didChanged: ZJTableViewItemBlock?
    override init() {
        super.init()
        cellHeight = 125
        selectionStyle = UITableViewCell.SelectionStyle.none
    }

    public convenience init(text: String?, placeHolder: String, didChanged: ZJTableViewItemBlock?) {
        self.init()
        self.text = text
        self.placeHolder = placeHolder
        self.didChanged = didChanged
    }
}

open class ZJTextCell: UITableViewCell, UITextViewDelegate, ZJCellProtocol {
    public var item: ZJTextItem!

    public typealias ZJCelltemClass = ZJTextItem

    @IBOutlet var textView: ZJTextView!

    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textView.delegate = self
    }

    public func cellWillAppear() {
        textView.placeholder = item.placeHolder
        textView.text = item.text
        textView.backgroundColor = item.textViewBackgroundColor
    }

    public func textViewDidChange(_ textView: UITextView) {
        item.text = textView.text
        item.didChanged?(item)
    }

    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
