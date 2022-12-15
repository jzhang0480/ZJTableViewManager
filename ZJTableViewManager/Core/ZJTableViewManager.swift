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
        var logEntry = String()
        if let fileName = file.components(separatedBy: "/").last {
            logEntry.append("[\(fileName):\(line)] ")
        }
        print(logEntry + "\(item)")
    }
}

open class ZJTableViewManager: NSObject {
    private lazy var registeredIdentifier: Set<String> = []
    public static var isDebug = false
    public weak var scrollDelegate: ZJTableViewScrollDelegate?
    public var tableView: UITableView!
    public var sections: [ZJSection] = []
    var defaultTableViewSectionHeight: CGFloat {
        return tableView.style == .grouped ? 44 : 0
    }

    public func selectedItem<T: ZJItem>() -> T? {
        if let item = selectedItems().first {
            return item as? T
        }
        return nil
    }

    public func selectedItems<T: ZJItem>() -> [T] {
        if let indexPaths = tableView.indexPathsForSelectedRows {
            var items = [T]()
            for idx in indexPaths {
                if let item = sections[idx.section][idx.row] as? T {
                    items.append(item)
                }
            }
            return items
        }
        return []
    }

    public func selectItems(_ items: [ZJItem], animated: Bool = true, scrollPosition: UITableView.ScrollPosition = .none) {
        for item in items {
            item.select(animated: animated, scrollPosition: scrollPosition)
        }
    }

    public func deselectItems(_ items: [ZJItem], animated: Bool = true) {
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

    public func register(_ itemClasses: [ZJItemable.Type], _ bundle: Bundle = Bundle.main) {
        for itemClass in itemClasses {
            register(itemClass, bundle)
        }
    }

    public func register(_ itemClass: ZJItemable.Type, _ bundle: Bundle = Bundle.main) {
        let cell = itemClass.cellClass
        let cellClass = "\(cell)"
        let reuseIdentifier = "\(itemClass)"

        guard !registeredIdentifier.contains(reuseIdentifier) else {
            return
        }

        registeredIdentifier.insert(reuseIdentifier)
        if bundle.path(forResource: cellClass, ofType: "nib") != nil {
            tableView.register(UINib(nibName: cellClass, bundle: bundle), forCellReuseIdentifier: reuseIdentifier)
        } else {
            tableView.register(cell, forCellReuseIdentifier: reuseIdentifier)
        }
        zj_log(cellClass + " registered")
    }

    public func add(section: ZJSection) {
        section.manager = self
        sections.append(section)
    }

    public func remove(section: ZJSection) {
        sections.remove(at: sections.unwrappedIndex(section))
    }

    public func removeAllSections() {
        sections.removeAll()
    }

    public func reload() {
        tableView.reloadData()
    }
    
    
    /// Returns the optimal size of the view based on its constraints
    /// - Parameter item: item
    public func layoutSizeFitting(_ item: ZJItem) -> CGSize {
        register(type(of: item) as! ZJItemable.Type)
        let cell = tableView.dequeueReusableCell(withIdentifier: item.identifier)!
        (cell as! ZJBaseCell)._item = item
        (cell as! ZJCellable).cellPrepared()

        return cell.systemLayoutSizeFitting(CGSize(width: tableView.frame.width, height: .zero), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
}

// MARK: - UITableViewDelegate

extension ZJTableViewManager: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let section = sections[indexPath.section], item = section[indexPath.row]
        if item.isAllowSelect {
            return indexPath
        } else {
            return nil
        }
    }

    public func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section], item = section[indexPath.row]
        item.selectionHandler?(item)
    }

    public func tableView(_: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let section = sections[indexPath.section], item = section[indexPath.row]
        return item.editingStyle
    }

    public func tableView(_: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section], item = section[indexPath.row]

        if editingStyle == .delete {
            if let handler = item.deletionHandler {
                handler(item)
            }
        }
    }

    public func tableView(_: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt _: IndexPath) {
        (cell as! ZJCellable).cellDidDisappear()
    }

    public func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt _: IndexPath) {
        (cell as! ZJCellable).cellWillAppear()
    }

    public func tableView(_: UITableView, willDisplayHeaderView _: UIView, forSection section: Int) {
        let section = sections[section]
        section.headerWillDisplayHandler?(section)
    }

    public func tableView(_: UITableView, didEndDisplayingHeaderView _: UIView, forSection section: Int) {
        // 这里要做一个保护，因为这个方法在某个section被删除之后reload tableView, 会最后触发一次这个
        // section的endDisplaying方法，这时去根据section去获取section对象会获取不到。
        if sections.count > section {
            let section = sections[section]
            section.headerDidEndDisplayHandler?(section)
        }
    }

    public func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = sections[section]
        return section.headerView
    }

    public func tableView(_: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let section = sections[section]
        return section.footerView
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = sections[section]
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
        let section = sections[section]
        return section.footerHeight
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section], item = section[indexPath.row]
        #if swift(>=4.2)
            if item.height == UITableView.automaticDimension, tableView.estimatedRowHeight == 0 {
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

        return item.height
    }
}

// MARK: - UITableViewDataSource

extension ZJTableViewManager: UITableViewDataSource {
    public func numberOfSections(in _: UITableView) -> Int {
        return sections.count
    }

    public func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].headerTitle
    }

    public func tableView(_: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footerTitle
    }

    public func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section], item = section[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.identifier)
        cell?.selectionStyle = item.selectionStyle
        
        if let baseCell = cell as? ZJBaseCell {
            baseCell._item = item
        }

        if let protocolCell = cell as? ZJCellable {
            protocolCell.cellPrepared()
        }
        return cell!
    }
}

extension Array where Element: Equatable {
    func unwrappedIndex(_ element: Element) -> Int {
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
