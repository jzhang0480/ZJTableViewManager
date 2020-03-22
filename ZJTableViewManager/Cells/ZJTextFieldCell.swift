//
//  ZJTextFieldCell.swift
//  ZJTableViewManagerExample
//
//  Created by Javen on 2018/3/7.
//  Copyright © 2018年 上海勾芒信息科技. All rights reserved.
//

import UIKit

open class ZJTextFieldCell: UITableViewCell, ZJTableViewCellProtocol {
    public var item: ZJTextFieldItem!

    public typealias ZJCelltemClass = ZJTextFieldItem

    public func cellDidAppear() {}

    public func cellDidDisappear() {}

    @IBOutlet var titleConstraint: NSLayoutConstraint!
    @IBOutlet var labelTitle: UILabel!

    @IBOutlet var textField: UITextField!
    open override func awakeFromNib() {
        super.awakeFromNib()

        textField.addTarget(self, action: #selector(textFieldDidChanged(textField:)), for: UIControl.Event.editingChanged)
        // Initialization code
    }

    public func cellWillAppear() {
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

    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
