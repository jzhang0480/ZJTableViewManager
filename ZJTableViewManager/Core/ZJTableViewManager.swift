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

public protocol ZJTableViewScrollDelegate: NSObjectProtocol {
    @available(iOS 2.0, *)
    func scrollViewDidScroll(_ scrollView: UIScrollView) // any offset changes

    @available(iOS 3.2, *)
    func scrollViewDidZoom(_ scrollView: UIScrollView) // any zoom scale changes

    // called on start of dragging (may require some time and or distance to move)
    @available(iOS 2.0, *)
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)

    // called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
    @available(iOS 5.0, *)
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)

    // called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
    @available(iOS 2.0, *)
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)

    @available(iOS 2.0, *)
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) // called on finger up as we are moving

    @available(iOS 2.0, *)
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) // called when scroll view grinds to a halt

    @available(iOS 2.0, *)
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating

    @available(iOS 2.0, *)
    func viewForZooming(in scrollView: UIScrollView) -> UIView? // return a view that will be scaled. if delegate returns nil, nothing happens

    @available(iOS 3.2, *)
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) // called before the scroll view begins zooming its content

    @available(iOS 2.0, *)
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) // scale between minimum and maximum. called after any 'bounce' animations

    @available(iOS 2.0, *)
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool // return a yes if you want to scroll to the top. if not defined, assumes YES

    @available(iOS 2.0, *)
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) // called when scrolling animation finished. may be called immediately if already at top

    /* Also see -[UIScrollView adjustedContentInsetDidChange]
     */
    @available(iOS 11.0, *)
    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView)
}

extension ZJTableViewScrollDelegate {
    func scrollViewDidScroll(_: UIScrollView) {}

    func scrollViewDidZoom(_: UIScrollView) {}

    func scrollViewWillBeginDragging(_: UIScrollView) {}

    func scrollViewWillEndDragging(_: UIScrollView, withVelocity _: CGPoint, targetContentOffset _: UnsafeMutablePointer<CGPoint>) {}

    func scrollViewDidEndDragging(_: UIScrollView, willDecelerate _: Bool) {}

    func scrollViewWillBeginDecelerating(_: UIScrollView) {}

    func scrollViewDidEndDecelerating(_: UIScrollView) {}

    func scrollViewDidEndScrollingAnimation(_: UIScrollView) {}

    func viewForZooming(in _: UIScrollView) -> UIView? { return nil }

    func scrollViewWillBeginZooming(_: UIScrollView, with _: UIView?) {}

    func scrollViewDidEndZooming(_: UIScrollView, with _: UIView?, atScale _: CGFloat) {}

    func scrollViewShouldScrollToTop(_: UIScrollView) -> Bool { return true }

    func scrollViewDidScrollToTop(_: UIScrollView) {}

    func scrollViewDidChangeAdjustedContentInset(_: UIScrollView) {}
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
        registerDefaultCells()
    }

    /// use this method to update cell height after you change item.cellHeight.
    open func updateHeight() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    func registerDefaultCells() {
        let myBundle = Bundle(for: ZJTextItem.self)
        register(ZJTextCell.self, ZJTextItem.self, myBundle)
        register(ZJTextFieldCell.self, ZJTextFieldItem.self, myBundle)
        register(ZJSwitchCell.self, ZJSwitchItem.self, myBundle)
    }

    public func register(_ nibClass: AnyClass, _ item: AnyClass, _ bundle: Bundle = Bundle.main) {
        zj_log("\(nibClass) registered")
        if bundle.path(forResource: "\(nibClass)", ofType: "nib") != nil {
            tableView.register(UINib(nibName: "\(nibClass)", bundle: bundle), forCellReuseIdentifier: "\(item)")
        } else {
            tableView.register(nibClass, forCellReuseIdentifier: "\(item)")
        }
    }

    func sectinAndItemFrom(indexPath: IndexPath?, sectionIndex: Int?, rowIndex: Int?) -> (ZJTableViewSection?, ZJTableViewItem?) {
        var currentSection: ZJTableViewSection?
        var item: ZJTableViewItem?
        if let idx = indexPath {
            currentSection = sections[idx.section]
            item = currentSection?.items[idx.row]
        }

        if let idx = sectionIndex {
            currentSection = sections.count > idx ? sections[idx] : nil
        }

        if let idx = rowIndex {
            item = (currentSection?.items.count)! > idx ? currentSection?.items[idx] : nil
        }

        return (currentSection, item)
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

    public func transform(fromLabel: UILabel?, toLabel: UILabel?) {
        toLabel?.text = fromLabel?.text
        toLabel?.font = fromLabel?.font
        toLabel?.textColor = fromLabel?.textColor
        toLabel?.textAlignment = (fromLabel?.textAlignment)!
        if let string = fromLabel?.attributedText {
            toLabel?.attributedText = string
        }
    }
}

// MARK: - UIScrollViewDelegate

extension ZJTableViewManager: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let d = scrollDelegate {
            d.scrollViewDidScroll(scrollView)
        }
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if let d = scrollDelegate {
            d.scrollViewDidZoom(scrollView)
        }
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let d = scrollDelegate {
            d.scrollViewWillBeginDragging(scrollView)
        }
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let d = scrollDelegate {
            d.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
        }
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let d = scrollDelegate {
            d.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
        }
    }

    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if let d = scrollDelegate {
            d.scrollViewWillBeginDecelerating(scrollView)
        }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let d = scrollDelegate {
            d.scrollViewDidEndDecelerating(scrollView)
        }
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if let d = scrollDelegate {
            d.scrollViewDidEndScrollingAnimation(scrollView)
        }
    }

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if let d = scrollDelegate {
            return d.viewForZooming(in: scrollView)
        }
        return nil
    }

    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        if let d = scrollDelegate {
            d.scrollViewWillBeginZooming(scrollView, with: view)
        }
    }

    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if let d = scrollDelegate {
            d.scrollViewDidEndZooming(scrollView, with: view, atScale: scale)
        }
    }

    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        if let d = scrollDelegate {
            return d.scrollViewShouldScrollToTop(scrollView)
        }
        return false
    }

    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        if let d = scrollDelegate {
            d.scrollViewDidScrollToTop(scrollView)
        }
    }

    public func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        if let d = scrollDelegate {
            d.scrollViewDidChangeAdjustedContentInset(scrollView)
        }
    }
}

// MARK: - UITableViewDelegate

extension ZJTableViewManager: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentSection = sections[indexPath.section]
        let item = currentSection.items[indexPath.row]
        if item.isAutoDeselect {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        item.selectionHandler?(item)
    }

    public func tableView(_: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let (_, item) = sectinAndItemFrom(indexPath: indexPath, sectionIndex: nil, rowIndex: nil)
        return item!.editingStyle
    }

    public func tableView(_: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let (_, item) = sectinAndItemFrom(indexPath: indexPath, sectionIndex: nil, rowIndex: nil)

        if editingStyle == .delete {
            if let handler = item?.deletionHandler {
                handler(item!)
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
        let (currentSection, _) = sectinAndItemFrom(indexPath: nil, sectionIndex: section, rowIndex: nil)
        currentSection?.headerWillDisplayHandler?(currentSection!)
    }

    public func tableView(_: UITableView, didEndDisplayingHeaderView _: UIView, forSection section: Int) {
        let (currentSection, _) = sectinAndItemFrom(indexPath: nil, sectionIndex: section, rowIndex: nil)
        currentSection?.headerDidEndDisplayHandler?(currentSection!)
    }

    public func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let currentSection = sections[section]
        return currentSection.headerView
    }

    public func tableView(_: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let currentSection = sections[section]
        return currentSection.footerView
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let currentSection = sections[section]
        if currentSection.headerView != nil || (currentSection.headerHeight > 0 && currentSection.headerHeight != CGFloat.leastNormalMagnitude) {
            return currentSection.headerHeight
        }

        if let title = currentSection.headerTitle {
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
        let currentSection = sections[section]
        return currentSection.footerHeight
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentSection = sections[indexPath.section]
        let item = currentSection.items[indexPath.row]
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
        let (section, _) = sectinAndItemFrom(indexPath: nil, sectionIndex: section, rowIndex: nil)
        return section!.headerTitle
    }

    public func tableView(_: UITableView, titleForFooterInSection section: Int) -> String? {
        let (section, _) = sectinAndItemFrom(indexPath: nil, sectionIndex: section, rowIndex: nil)
        return section!.footerTitle
    }

    public func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSection = sections[section]
        return currentSection.items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSection = sections[indexPath.section]
        let item = currentSection.items[indexPath.row]
        item.tableViewManager = self
        // 报错在这里，可能是是没有register cell 和 item
        var cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier) as? ZJInternalCellProtocol
        if cell == nil {
            cell = (ZJTableViewCell(style: item.cellStyle, reuseIdentifier: item.cellIdentifier) as ZJInternalCellProtocol)
        }

        cell!.textLabel?.text = item.cellTitle

        cell!.accessoryType = item.accessoryType

        cell!.selectionStyle = item.selectionStyle

        cell!._item = item

        cell!.cellWillAppear()

        return cell!
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
