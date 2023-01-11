//
//  ZJTextCell.swift
//  NewRetail
//
//  Created by Javen on 2018/3/5.
//  Copyright © 2018年 . All rights reserved.
//

import UIKit
import ZJTableViewManager

public final class ZJTextItem: ZJItem, ZJItemable {
    public static var cellClass: ZJBaseCell.Type { ZJTextCell.self }
    public var text: String?
    public var placeHolder: String?
    public var textViewBackgroundColor: UIColor = .white
    public var didChanged: ((ZJTextItem) -> Void)?
    override init() {
        super.init()
        height = 125
        selectionStyle = UITableViewCell.SelectionStyle.none
    }

    public convenience init(text: String?, placeHolder: String, didChanged: ((ZJTextItem) -> Void)?) {
        self.init()
        self.text = text
        self.placeHolder = placeHolder
        self.didChanged = didChanged
    }
}

open class ZJTextCell: ZJCell<ZJTextItem>, UITextViewDelegate, ZJCellable {
    @IBOutlet var textView: ZJTextView!

    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textView.delegate = self
    }

    public func cellPreparedForReuse() {
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