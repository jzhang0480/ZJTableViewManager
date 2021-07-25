//
//  ZJTableViewManager.swift
//  NewRetail
//
//  Created by Javen on 2018/2/8.
//  Copyright © 2018年 上海勾芒信息科技有限公司. All rights reserved.
//

import UIKit

func zj_log(_ item: Any, file: String = #file, line: Int = #line) {
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

    public func register(_ nibClass: AnyClass, _ item: AnyClass, _ bundle: Bundle = Bundle.main) {
        zj_log("\(nibClass) registered")
        if bundle.path(forResource: "\(nibClass)", ofType: "nib") != nil {
            tableView.register(UINib(nibName: "\(nibClass)", bundle: bundle), forCellReuseIdentifier: "\(item)")
        } else {
            tableView.register(nibClass, forCellReuseIdentifier: "\(item)")
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
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = getSectionAndItem(indexPath: (indexPath.section, indexPath.row))
        if obj.item.isAutoDeselect {
            tableView.deselectRow(at: indexPath, animated: true)
        }
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
        (cell as! ZJInternalCellProtocol).cellDidAppear()
    }

    public func tableView(_: UITableView, willDisplayHeaderView _: UIView, forSection section: Int) {
        let section = sectionFrom(section: section)
        section.headerWillDisplayHandler?(section)
    }

    public func tableView(_: UITableView, didEndDisplayingHeaderView _: UIView, forSection section: Int) {
        let section = sectionFrom(section: section)
        section.headerDidEndDisplayHandler?(section)
    }

    public func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = sectionFrom(section: section)
        return section.headerView
    }

    public func tableView(_: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let section = sectionFrom(section: section)
        return section.footerView
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = sectionFrom(section: section)
        if section.headerView != nil || (section.headerHeight > 0 && section.headerHeight != CGFloat.leastNormalMagnitude) {
            return section.headerHeight
        }

        if let title = section.headerTitle {
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
        let section = sectionFrom(section: section)
        return section.footerHeight
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
        let section = sectionFrom(section: section)
        return section.headerTitle
    }

    public func tableView(_: UITableView, titleForFooterInSection section: Int) -> String? {
        let section = sectionFrom(section: section)
        return section.footerTitle
    }

    public func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sectionFrom(section: section)
        return section.items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = getSectionAndItem(indexPath: (indexPath.section, indexPath.row))
        obj.item.tableViewManager = self
        // 报错在这里，可能是是没有register cell 和 item
        var cell = tableView.dequeueReusableCell(withIdentifier: obj.item.cellIdentifier) as? ZJInternalCellProtocol
        if cell == nil {
            cell = (ZJDefaultCell(style: obj.item.style, reuseIdentifier: obj.item.cellIdentifier) as ZJInternalCellProtocol)
        }
        let unwrappedCell = cell!
        if let labelText = obj.item.labelText {
            unwrappedCell.textLabel?.text = labelText
            unwrappedCell.textLabel?.textAlignment = obj.item.textAlignment
        }
        if let detailLabelText = obj.item.detailLabelText {
            unwrappedCell.detailTextLabel?.text = detailLabelText
            unwrappedCell.detailTextLabel?.textAlignment = obj.item.detailTextAlignment
        }
        if let accessoryView = obj.item.accessoryView {
            unwrappedCell.accessoryView = accessoryView
        }
        unwrappedCell.accessoryType = obj.item.accessoryType
        unwrappedCell.selectionStyle = obj.item.selectionStyle
        unwrappedCell._item = obj.item
        unwrappedCell.cellWillAppear()
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
