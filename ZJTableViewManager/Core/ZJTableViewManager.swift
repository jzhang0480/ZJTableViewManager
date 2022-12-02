//
//  ZJTableViewManager.swift
//  NewRetail
//
//  Created by Javen on 2018/2/8.
//  Copyright © 2018年 . All rights reserved.
//

import UIKit

public func zj_log(_ item: Any, file: String = #file, line: Int = #line) {
    if ZJTableViewManager.isDebug {
        var logEntry: String = String()
        if let fileName = file.components(separatedBy: "/").last {
            logEntry.append("[\(fileName):\(line)] ")
        }
        print(logEntry + "\(item)")
    }
}

open class ZJTableViewManager: NSObject {
    public static var isDebug = false
    public weak var scrollDelegate: ZJTableViewScrollDelegate?
    public var tableView: UITableView!
    public var sections: [ZJTableViewSection] = []
    var defaultTableViewSectionHeight: CGFloat {
        return tableView.style == .grouped ? 44 : 0
    }

    public func selectedItem<T: ZJTableViewItem>() -> T? {
        if let item = selectedItems().first {
            return item as? T
        }
        return nil
    }

    public func selectedItems<T: ZJTableViewItem>() -> [T] {
        if let indexPaths = tableView.indexPathsForSelectedRows {
            var items = [T]()
            for idx in indexPaths {
                if let item = sections[idx.section].items[idx.row] as? T {
                    items.append(item)
                }
            }
            return items
        }
        return []
    }

    public func selectItems(_ items: [ZJTableViewItem], animated: Bool = true, scrollPosition: UITableView.ScrollPosition = .none) {
        for item in items {
            item.select(animated: animated, scrollPosition: scrollPosition)
        }
    }

    public func deselectItems(_ items: [ZJTableViewItem], animated: Bool = true) {
        for item in items {
            item.deselect(animated: animated)
        }
    }

    public init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
    }

    /// use this method to update cell height after you change item.cellHeight.
    public func updateHeight() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    public func register(_ cell: ZJInternalCellProtocol.Type, _ item: ZJTableViewItem.Type, _ bundle: Bundle = Bundle.main) {
        zj_log("\(cell) registered")
        if bundle.path(forResource: "\(cell)", ofType: "nib") != nil {
            tableView.register(UINib(nibName: "\(cell)", bundle: bundle), forCellReuseIdentifier: "\(item)")
        } else {
            tableView.register(cell, forCellReuseIdentifier: "\(item)")
        }
    }

    func sectionFrom(section: Int) -> ZJTableViewSection {
        let section = sections.count > section ? sections[section] : nil
        assert(section != nil, "section out of range")
        return section!
    }

    func getSectionAndItem(indexPath: (section: Int, row: Int)) -> (section: ZJTableViewSection, item: ZJTableViewItem) {
        let section = sectionFrom(section: indexPath.section)
        let item = section.items.count > indexPath.row ? section.items[indexPath.row] : nil
        assert(item != nil, "row out of range")
        return (section, item!)
    }

    public func add(section: ZJTableViewSection) {
        if !section.isKind(of: ZJTableViewSection.self) {
            zj_log("error section class")
            return
        }
        section.tableViewManager = self
        sections.append(section)
    }

    public func remove(section: Any) {
        if !(section as AnyObject).isKind(of: ZJTableViewSection.self) {
            zj_log("error section class")
            return
        }
        sections.remove(at: sections.zj_indexOf(section as! ZJTableViewSection))
    }

    public func removeAllSections() {
        sections.removeAll()
    }

    public func reload() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension ZJTableViewManager: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let obj = getSectionAndItem(indexPath: (section: indexPath.section, row: indexPath.row))
        if obj.item.isAllowSelect {
            return indexPath
        } else {
            return nil
        }
    }
    
    public func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = getSectionAndItem(indexPath: (indexPath.section, indexPath.row))
        obj.item.selectionHandler?(obj.item)
    }

    public func tableView(_: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let obj = getSectionAndItem(indexPath: (section: indexPath.section, row: indexPath.row))
        return obj.item.editingStyle
    }

    public func tableView(_: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let obj = getSectionAndItem(indexPath: (section: indexPath.section, row: indexPath.row))

        if editingStyle == .delete {
            if let handler = obj.item.deletionHandler {
                handler(obj.item)
            }
        }
    }

    public func tableView(_: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt _: IndexPath) {
        (cell as! ZJInternalCellProtocol).cellDidDisappear()
    }

    public func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt _: IndexPath) {
        (cell as! ZJInternalCellProtocol).cellWillAppear()
    }

    public func tableView(_: UITableView, willDisplayHeaderView _: UIView, forSection section: Int) {
        let sectionModel = sectionFrom(section: section)
        sectionModel.headerWillDisplayHandler?(sectionModel)
    }

    public func tableView(_: UITableView, didEndDisplayingHeaderView _: UIView, forSection section: Int) {
        // 这里要做一个保护，因为这个方法在某个section被删除之后reload tableView, 会最后触发一次这个
        // section的endDisplaying方法，这时去根据section去获取section对象会获取不到。
        if sections.count > section {
            let sectionModel = sectionFrom(section: section)
            sectionModel.headerDidEndDisplayHandler?(sectionModel)
        }
    }

    public func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionModel = sectionFrom(section: section)
        return sectionModel.headerView
    }

    public func tableView(_: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionModel = sectionFrom(section: section)
        return sectionModel.footerView
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionModel = sectionFrom(section: section)
        if sectionModel.headerView != nil || (sectionModel.headerHeight > 0 && sectionModel.headerHeight != CGFloat.leastNormalMagnitude) {
            return sectionModel.headerHeight
        }

        if let title = sectionModel.headerTitle {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width - 40, height: CGFloat.greatestFiniteMagnitude))
            label.text = title
            label.font = UIFont.preferredFont(forTextStyle: .footnote)
            label.sizeToFit()
            return label.frame.height + 20.0
        } else {
            return defaultTableViewSectionHeight
        }
    }

    public func tableView(_: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sectionModel = sectionFrom(section: section)
        return sectionModel.footerHeight
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]
        let item = section.items[indexPath.row]
        #if swift(>=4.2)
            if item.cellHeight == UITableView.automaticDimension, tableView.estimatedRowHeight == 0 {
                tableView.estimatedRowHeight = 44
                tableView.estimatedSectionFooterHeight = 44
                tableView.estimatedSectionHeaderHeight = 44
            }
        #else
            if item.cellHeight == UITableViewAutomaticDimension, tableView.estimatedRowHeight == 0 {
                tableView.estimatedRowHeight = 44
                tableView.estimatedSectionFooterHeight = 44
                tableView.estimatedSectionHeaderHeight = 44
            }
        #endif

        return item.cellHeight
    }
}

// MARK: - UITableViewDataSource

extension ZJTableViewManager: UITableViewDataSource {
    public func numberOfSections(in _: UITableView) -> Int {
        return sections.count
    }

    public func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionModel = sectionFrom(section: section)
        return sectionModel.headerTitle
    }

    public func tableView(_: UITableView, titleForFooterInSection section: Int) -> String? {
        let sectionModel = sectionFrom(section: section)
        return sectionModel.footerTitle
    }

    public func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionModel = sectionFrom(section: section)
        return sectionModel.items.count
    }
    

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let (_, item) = getSectionAndItem(indexPath: (indexPath.section, indexPath.row))

        var cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier) as? ZJInternalCellProtocol
        if cell == nil {
            cell = (ZJDefaultCell(style: item.style, reuseIdentifier: item.cellIdentifier) as ZJInternalCellProtocol)
        }
        let unwrappedCell = cell!
        unwrappedCell.textLabel?.text = item.labelText
        unwrappedCell.textLabel?.textAlignment = item.textAlignment
        unwrappedCell.detailTextLabel?.text = item.detailLabelText
        unwrappedCell.detailTextLabel?.textAlignment = item.detailTextAlignment
        unwrappedCell.accessoryView = item.accessoryView
        unwrappedCell.imageView?.image = item.image
        unwrappedCell.imageView?.highlightedImage = item.highlightedImage
        unwrappedCell.accessoryType = item.accessoryType
        unwrappedCell.selectionStyle = item.selectionStyle
        unwrappedCell._item = item
        unwrappedCell.cellPrepared()
        return unwrappedCell
    }
}

extension Array where Element: Equatable {
    func zj_indexOf(_ element: Element) -> Int {
        var index: Int?

        #if swift(>=5)
            index = firstIndex { (e) -> Bool in
                e == element
            }
        #else
            index = self.index(where: { (e) -> Bool in
                e == element
            })
        #endif

        assert(index != nil, "Can't find element in array, please check you code")
        return index!
    }
}
