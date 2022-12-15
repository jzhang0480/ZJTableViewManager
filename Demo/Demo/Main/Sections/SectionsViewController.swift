//
//  SectionsViewController.swift
//  ZJTableViewManagerExample
//
//  Created by Javen on 2018/3/13.
//  Copyright © 2018年 . All rights reserved.
//

import UIKit
import ZJTableViewManager

class SectionsViewController: UIViewController {
    var tableView: UITableView!
    var manager: ZJTableViewManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sections"

        tableView = UITableView(frame: view.bounds, style: .grouped)
        view.addSubview(tableView)
        manager = ZJTableViewManager(tableView: tableView)

        for i in 0 ... 8 {
            let section = ZJSection(headerTitle: "Section " + String(i))
            manager.add(section: section)
            section.setHeaderWillDisplayHandler { currentSection in
                zj_log("Section" + String(currentSection.index) + " will display!")
            }

            section.setHeaderDidEndDisplayHandler { _ in
//                zj_log("Section" + String(currentSection.index) + " did end display!")
            }

            for j in 0 ... 4 {
                section.add(item: ZJSystemStyleItem(text: "Section " + String(i) + " Row " + String(j)))
            }
        }

        manager.reload()
        // Do any additional setup after loading the view.
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destinationViewController.
         // Pass the selected object to the new view controller.
     }
     */
}
