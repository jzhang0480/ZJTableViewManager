//
//  ZJSystemStyleCell.swift
//  NewRetail
//
//  Created by Javen on 2018/2/8.
//  Copyright © 2018年 . All rights reserved.
//

import UIKit

open class ZJSystemStyleItem: ZJItem, ZJItemable {
    public static var cellClass: ZJBaseCell.Type { return ZJSystemStyleCell.self }
    public var labelText: String?
    public var detailLabelText: String?
    public var textAlignment: NSTextAlignment = .left
    public var detailTextAlignment: NSTextAlignment = .left
    public var image: UIImage?
    public var highlightedImage: UIImage?
    public var style: UITableViewCell.CellStyle = .default
    public var accessoryType: UITableViewCell.AccessoryType = .none
    public var accessoryView: UIView?

    public convenience init(text: String?) {
        self.init()
        labelText = text
    }
}

public class ZJSystemStyleCell: ZJCell<ZJSystemStyleItem>, ZJCellable {
    public func cellPrepared() {
        textLabel?.text = item.labelText
        textLabel?.textAlignment = item.textAlignment
        detailTextLabel?.text = item.detailLabelText
        detailTextLabel?.textAlignment = item.detailTextAlignment
        accessoryView = item.accessoryView
        imageView?.image = item.image
        imageView?.highlightedImage = item.highlightedImage
        accessoryType = item.accessoryType
    }
}
