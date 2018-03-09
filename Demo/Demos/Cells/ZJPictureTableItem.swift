//
//  ZJPictureTableItem.swift
//  NewRetail
//
//  Created by Javen on 2018/3/1.
//  Copyright © 2018年 上海勾芒信息科技有限公司. All rights reserved.
//

import UIKit
import ZJTableViewManager
enum ZJPictureCellType {
    case edit
    case read
}
class ZJPictureTableItem: ZJTableViewItem {
    var arrPictures: [Any] = []
    var maxNumber: CGFloat = 5
    var column: CGFloat = 4
    var type: ZJPictureCellType = ZJPictureCellType.edit
    var pictureSize: CGSize?
    var space: CGFloat = 8
    var superVC: UIViewController!
    var customEdgeInsets: UIEdgeInsets?
    
    /// 初始化图片item
    ///
    /// - Parameters:
    ///   - maxNumber: 图片的最大数量
    ///   - column: 列数
    ///   - space: 图片间距
    ///   - width: 显示图片区域的宽度（一般是这个cell的宽度）
    ///   - superVC: 当前的viewcontroller
    ///   - pictures: 图片
    convenience init(maxNumber: CGFloat, column: CGFloat, space: CGFloat, width: CGFloat, superVC: UIViewController!, pictures: [Any] = []) {
        self.init()
        self.superVC = superVC
        self.maxNumber = maxNumber
        self.column = column
        self.space = space
        let pictureWidth = (width - (space) * (column + 1)) / column
        self.pictureSize = CGSize(width: pictureWidth, height: pictureWidth)
        self.arrPictures = self.arrPictures + pictures
        self.calculateHeight()
    }
    
    override func updateHeight (){
        self.calculateHeight()
        super.updateHeight()
    }
    
    func calculateHeight() {
        var picCount = self.arrPictures.count
        //如果非只读的情况，则还需要多计算一个添加按钮的位置
        if (self.type != .read) {
            if (self.arrPictures.count != Int(self.maxNumber)) {
                picCount += 1;
            }
        }
        var div = picCount / Int(self.column);
        let remainder = picCount % Int(self.column);
        if (remainder != 0) {
            div = div + 1;
        }
        
        self.cellHeight = CGFloat(div) * ((self.pictureSize?.height)! + self.space);
    }
    
}
