//
//  ZJExpandTreeCell.swift
//  ZJExpandTreeDeme
//
//  Created by Javen on 2019/3/19.
//  Copyright © 2019 Javen. All rights reserved.
//

import UIKit

open class ZJExpandTreeCellItem: ZJTableViewItem {
    public private(set) var level: Int = 0
    public var isExpand = false
    public var arrSubLevel = [ZJExpandTreeCellItem]()
    /// 展开或者收起下级cell的回调
    public var willExpand: ((ZJExpandTreeCellItem) -> Void)?
    public weak var superLevelItem: ZJExpandTreeCellItem?

    public override init() {
        super.init()
        selectionStyle = .none

        setSelectionHandler { (callBackItem: ZJExpandTreeCellItem) in
            callBackItem.toggleExpand()
        }
    }

    public func addSub(item: ZJExpandTreeCellItem, section: ZJTableViewSection) {
        arrSubLevel.append(item)
        item.superLevelItem = self
        item.level = level + 1
        if ZJExpandTreeCellItem.checkIfFoldedBySupperLevel(self), isExpand {
            section.add(item: item)
        }
    }

    /// 处理展开事件，返回值是当前cell的状态（展开或者收起）
    @discardableResult public func toggleExpand() -> Bool {
        var arrItems = [ZJExpandTreeCellItem]()
        if isExpand {
            // 点击之前是打开的，直接通过递归获取item
            ZJExpandTreeCellItem.recursionForItem(self, outItems: &arrItems)
            isExpand = !isExpand
        } else {
            // 点击之前是关闭的，需要先改变isExpand属性（不这么做会导致这一个level下一级的level的cell不显示）
            isExpand = !isExpand
            ZJExpandTreeCellItem.recursionForItem(self, outItems: &arrItems)
        }
        willExpand?(self)
        if isExpand {
            section.insert(arrItems, afterItem: self, animate: .fade)
        } else {
            section.delete(arrItems, animate: .fade)
        }
        zj_log(isExpand ? "展开" : "收起")

        return isExpand
    }

    /// 递归获取一个item下面所有显示的item
    class func recursionForItem(_ item: ZJExpandTreeCellItem, outItems: inout [ZJExpandTreeCellItem]) {
        for subItem in item.arrSubLevel {
            zj_log(subItem.level)
            if item.isExpand == true {
                outItems.append(subItem)
                if item.arrSubLevel.count != 0 {
                    recursionForItem(subItem, outItems: &outItems)
                }
            }
        }
    }

    // 递归判断一个item是否在某个父节点被折叠
    class func checkIfFoldedBySupperLevel(_ item: ZJExpandTreeCellItem) -> Bool {
        guard let superItem = item.superLevelItem else {
            return item.isExpand
        }

        if superItem.isExpand {
            return checkIfFoldedBySupperLevel(superItem)
        } else {
            return false
        }
    }
}
