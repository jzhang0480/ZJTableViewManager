//
//  ZJSystemStyleCell.swift
//  NewRetail
//
//  Created by Javen on 2018/2/8.
//  Copyright © 2018年 . All rights reserved.
//

import UIKit

public final class ZJSystemStyleItem: ZJItem, ZJItemable {
    public static var cellClass: ZJBaseCell.Type { return ZJSystemStyleCell.self }
    public var style: UITableViewCell.CellStyle = .default
    public var labelText: String?
    public var detailLabelText: String?
    public var textAlignment: NSTextAlignment = .left
    public var detailTextAlignment: NSTextAlignment = .left
    public var image: UIImage?
    public var highlightedImage: UIImage?
    public var accessoryType: UITableViewCell.AccessoryType = .none
    public var accessoryView: UIView?

    public init(style: UITableViewCell.CellStyle = .default, labelText: String? = nil, detailLabelText: String? = nil, textAlignment: NSTextAlignment = .left, detailTextAlignment: NSTextAlignment = .left, image: UIImage? = nil, highlightedImage: UIImage? = nil, accessoryType: UITableViewCell.AccessoryType = .none, accessoryView: UIView? = nil) {
        self.style = style
        self.labelText = labelText
        self.detailLabelText = detailLabelText
        self.textAlignment = textAlignment
        self.detailTextAlignment = detailTextAlignment
        self.image = image
        self.highlightedImage = highlightedImage
        self.accessoryType = accessoryType
        self.accessoryView = accessoryView
    }
}

public class ZJSystemStyleCell: ZJCell<ZJSystemStyleItem>, ZJCellable {
    public func cellPreparedForReuse() {
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
