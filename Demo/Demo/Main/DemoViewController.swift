//
//  ViewController.swift
//  Demo
//
//  Created by Jie Zhang on 2022/12/10.
//

import UIKit
import ZJTableViewManager

class DemoViewController: UIViewController {
    var tableView: UITableView!
    var manager: ZJTableViewManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        ZJTableViewManager.isDebug = true

        tableView = UITableView(frame: view.bounds, style: .grouped)
        view.addSubview(tableView)
        manager = ZJTableViewManager(tableView: tableView)

        tableView.tableFooterView = UIView()
        let section = ZJTableViewSection()
        manager.add(section: section)

        let titles = ["Basic", "Retractable", "SlideDelete", "Sections", "AutomaticHeight", "AccordionEffect", "UpdateHeight", "Selection"]
        for i in titles {
            let item = ZJSystemStyleItem(text: i)
            item.accessoryType = .disclosureIndicator
            section.add(item: item)

            item.setSelectionHandler { _ in

                if i == "Basic" {
                    let vc = BasicViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
//                else if i == "Retractable" {
//                    let vc = RetractableViewController()
//                    self.navigationController?.pushViewController(vc, animated: true)
//                } else if i == "SlideDelete" {
//                    let vc = EditingViewController()
//                    self.navigationController?.pushViewController(vc, animated: true)
//                } else if i == "Sections" {
//                    let vc = SectionsViewController()
//                    self.navigationController?.pushViewController(vc, animated: true)
//                } else if i == "AutomaticHeight" {
//                    let vc = AutomaticHeightViewController()
//                    self.navigationController?.pushViewController(vc, animated: true)
//                } else if i == "AccordionEffect" {
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let vc = storyboard.instantiateViewController(withIdentifier: "AccordionEffectViewController")
//                    self.navigationController?.pushViewController(vc, animated: true)
//                } else if i == "UpdateHeight" {
//                    let vc = UpdateHeightViewController()
//                    self.navigationController?.pushViewController(vc, animated: true)
//                } else if i == "Selection" {
//                    let vc = SelectionViewController()
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
            }
        }

        addFPS()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
