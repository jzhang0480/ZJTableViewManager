//
//  ZJTextFieldCell.swift
//  ZJTableViewManagerExample
//
//  Created by Javen on 2018/3/7.
//  Copyright © 2018年 . All rights reserved.
//

import UIKit
import ZJTableViewManager

public final class ZJTextFieldItem: ZJItem, ZJItemable {
    public static var cellClass: ZJBaseCell.Type { ZJTextFieldCell.self }

    public var title: String?
    public var placeHolder: String?
    public var text: String?
    public var didChanged: ((ZJTextFieldItem) -> Void)?
    public var isFullLength: Bool = false
    public var isSecureTextEntry: Bool = false

    public convenience init(title: String?, placeHolder: String?, text: String?, isFullLength: Bool = false, didChanged: ((ZJTextFieldItem) -> Void)?) {
        self.init()
        self.title = title
        self.placeHolder = placeHolder
        self.text = text
        self.isFullLength = isFullLength
        self.didChanged = didChanged
    }
}

open class ZJTextFieldCell: ZJCell<ZJTextFieldItem>, ZJCellable {
    @IBOutlet var titleConstraint: NSLayoutConstraint!
    @IBOutlet var labelTitle: UILabel!

    @IBOutlet var textField: UITextField!
    override open func awakeFromNib() {
        super.awakeFromNib()

        textField.addTarget(self, action: #selector(textFieldDidChanged(textField:)), for: UIControl.Event.editingChanged)
        // Initialization code
    }

    public func cellPreparedForReuse() {
        if item.isFullLength {
            titleConstraint.constant = 0
        } else {
            labelTitle.text = item.title
        }
        textField.isSecureTextEntry = item.isSecureTextEntry
        textField.text = item.text
        textField.placeholder = item.placeHolder
    }

    @objc func textFieldDidChanged(textField: UITextField) {
        item.text = textField.text
        item.didChanged?(item)
    }

    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
