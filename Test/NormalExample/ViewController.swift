//
//  ViewController.swift
//  ZJTableViewManagerExample
//
//  Created by Javen on 2018/3/5.
//  Copyright © 2018年 上海勾芒信息科技. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var tableView: UITableView!
    var manager: ZJTableViewManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        FPSCounter.showInStatusBar()

        ZJTableViewManager.isDebug = true

        tableView = UITableView(frame: view.bounds, style: .grouped)
        view.addSubview(tableView)
        manager = ZJTableViewManager(tableView: tableView)

        tableView.tableFooterView = UIView()
        let section = ZJTableViewSection()
        manager.add(section: section)

        let titles = ["Basic", "Retractable", "SlideDelete", "Sections", "AutomaticHeight", "ExpandTree", "UpdateHeight"]
        for i in titles {
            let item = ZJTableViewItem(title: i)
            item.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            item.isAutoDeselect = true
            section.add(item: item)

            item.setSelectionHandler { _ in

                if i == "Basic" {
                    let vc = FormViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if i == "Retractable" {
                    let vc = RetractableViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if i == "SlideDelete" {
                    let vc = EditingViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if i == "Sections" {
                    let vc = SectionsViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if i == "AutomaticHeight" {
                    let vc = AutomaticHeightViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if i == "ExpandTree" {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "ExpandTreeViewController")
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if i == "UpdateHeight" {
                    let vc = UpdateHeightViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

/// 假装调用接口
/// - Parameters:
///   - view: 展示indicator的view
///   - callBack: 模拟网络请求完成之后的回调
func httpRequest(view: UIView, callBack: (() -> Void)?) {
    let shadowView = UIView(frame: view.bounds)
    shadowView.backgroundColor = UIColor(white: 0, alpha: 0.5)
    view.addSubview(shadowView)

    #if swift(>=4.2)
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
    #else
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    #endif

    indicator.center = shadowView.center

    shadowView.addSubview(indicator)
    indicator.startAnimating()
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(1)) {
        indicator.stopAnimating()
        indicator.removeFromSuperview()
        shadowView.removeFromSuperview()

        callBack?()
    }
}
