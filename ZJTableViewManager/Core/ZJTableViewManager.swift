//
//  ZJTableViewManager.swift
//  NewRetail
//
//  Created by Javen on 2018/2/8.
//  Copyright © 2018年 上海勾芒信息科技有限公司. All rights reserved.
//

import UIKit
@objc public protocol ZJTableViewDelegate: NSObjectProtocol {
    @objc func scrollViewDidScroll(_ scrollView: UIScrollView)
}

open class ZJTableViewManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    public var delegate: ZJTableViewDelegate?
    public var tableView:UITableView!
    public var sections: [ZJTableViewSection] = []
    var defaultTableViewSectionHeight: CGFloat {
        get {
            return self.tableView.style == .grouped ? 44 : 0
        }
    }
    
    public init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self;
        self.tableView.layoutMargins = UIEdgeInsets.zero
        self.registerDefaultCells()
    }
    
    func registerDefaultCells() {
        let myBundle = Bundle(for: ZJTextItem.self)
        self.register(ZJTextCell.self, ZJTextItem.self, myBundle)
        self.register(ZJTextFieldCell.self, ZJTextFieldItem.self, myBundle)
        self.register(ZJSwitchCell.self, ZJSwitchItem.self, myBundle)
    }
    
    public func register(_ nibClass: AnyClass, _ item: AnyClass, _ bundle: Bundle = Bundle.main) {
        print("\(nibClass)")
        if (bundle.path(forResource: "\(nibClass)", ofType: "nib") != nil) {
            self.tableView.register(UINib.init(nibName: "\(nibClass)", bundle: bundle), forCellReuseIdentifier: "\(item)")
        }else{
            self.tableView.register(nibClass, forCellReuseIdentifier: "\(item)")
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let currentSection = sections[section]
        if currentSection.headerView != nil || (currentSection.headerHeight > 0 && currentSection.headerHeight != CGFloat.leastNormalMagnitude){
            return currentSection.headerHeight
        }
        
        if let title = currentSection.headerTitle {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width - 40, height: CGFloat.greatestFiniteMagnitude))
            label.text = title
            label.font = UIFont.preferredFont(forTextStyle: .footnote)
            label.sizeToFit()
            return label.frame.height + 20.0
        }else{
            return self.defaultTableViewSectionHeight
        }
        
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let currentSection = sections[section]
        return currentSection.headerView
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let (currentSection, _) = self.sectinAndItemFrom(indexPath: nil, sectionIndex: section, rowIndex: nil)
        currentSection?.headerWillDisplayHandler?(currentSection!)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        let (currentSection, _) = self.sectinAndItemFrom(indexPath: nil, sectionIndex: section, rowIndex: nil)
        currentSection?.headerDidEndDisplayHandler?(currentSection!)
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let currentSection = sections[section]
        return currentSection.footerHeight
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let currentSection = sections[section]
        return currentSection.footerView
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let (section, _) = self.sectinAndItemFrom(indexPath: nil, sectionIndex: section, rowIndex: nil)
        return section!.headerTitle
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let (section, _) = self.sectinAndItemFrom(indexPath: nil, sectionIndex: section, rowIndex: nil)
        return section!.footerTitle
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSection = sections[section]
        return currentSection.items.count;
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentSection = sections[indexPath.section]
        let item = currentSection.items[indexPath.row]
        return item.cellHeight
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let currentSection = sections[indexPath.section]
        let item = currentSection.items[indexPath.row]
        item.tableViewManager = self
        //报错在这里，可能是是没有register cell 和 item
        var cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier) as? ZJTableViewCell
        
        if cell == nil {
            cell = ZJTableViewCell(style: item.cellStyle!, reuseIdentifier: item.cellIdentifier)
        }
        
        if let title = item.cellTitle {
            cell?.textLabel?.text = title
        }
        
        if let separatorInset = item.separatorInset {
            cell?.separatorInset = separatorInset
        }
        
        if let accessoryType = item.accessoryType {
            cell?.accessoryType = accessoryType
        }else{
            cell?.accessoryType = .none
        }
        
        cell?.selectionStyle = item.selectionStyle
        
        cell?.item = item
        cell?.cellWillAppear()
        
        return cell!;
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //        print("didEndDisplaying")
        (cell as! ZJTableViewCell).cellDidDisappear()
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //        print("willDisplay")
        (cell as! ZJTableViewCell).cellDidAppear()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentSection = sections[indexPath.section]
        let item = currentSection.items[indexPath.row]
        if item.isAutoDeselect {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        item.selectionHandler?(item)
    }
    
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        let (_ , item) = self.sectinAndItemFrom(indexPath: indexPath, sectionIndex: nil, rowIndex: nil)
        return item!.editingStyle
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let (_ , item) = self.sectinAndItemFrom(indexPath: indexPath, sectionIndex: nil, rowIndex: nil)
        
        if editingStyle == .delete {
            if let handler = item?.deletionHandler {
                handler(item!)
            }
        }
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let d = self.delegate {
            if (d.responds(to: #selector(ZJTableViewDelegate.scrollViewDidScroll(_:)))) {
                d.scrollViewDidScroll(scrollView)
            }
        }
    }
    
    func sectinAndItemFrom(indexPath: IndexPath?, sectionIndex: Int?, rowIndex: Int?) -> (ZJTableViewSection?, ZJTableViewItem?) {
        var currentSection: ZJTableViewSection? = nil
        var item: ZJTableViewItem? = nil
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
            print("error section class")
            return
        }
        section.tableViewManager = self
        self.sections.append(section)
    }
    
    public func remove(section: Any) {
        if !(section as AnyObject).isKind(of: ZJTableViewSection.self) {
            print("error section class")
            return
        }
        self.sections.remove(at: self.sections.index(where: { (current) -> Bool in
            return current == (section as! ZJTableViewSection)
        })!)
    }
    
    public func removeAllSections() {
        self.sections.removeAll()
    }
    
    public func reload() {
        self.tableView.reloadData()
    }
    
    public func transform(fromLabel:UILabel?, toLabel:UILabel?) {
        toLabel?.text = fromLabel?.text
        toLabel?.font = fromLabel?.font
        toLabel?.textColor = fromLabel?.textColor
        toLabel?.textAlignment = (fromLabel?.textAlignment)!
        if let string = fromLabel?.attributedText {
            toLabel?.attributedText = string
        }
    }
}

