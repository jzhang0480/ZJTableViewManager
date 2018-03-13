//
//  SectionsViewController.swift
//  ZJTableViewManagerExample
//
//  Created by Javen on 2018/3/13.
//  Copyright © 2018年 上海勾芒信息科技. All rights reserved.
//

import UIKit

class SectionsViewController: UIViewController {
    var tableView: UITableView!
    var manager: ZJTableViewManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sections"
        
        self.tableView = UITableView(frame: self.view.bounds, style: .grouped)
        self.view.addSubview(self.tableView);
        self.manager = ZJTableViewManager(tableView: self.tableView)
        
        
        for i in 0...8 {
            let section = ZJTableViewSection(headerTitle: "Section " + String(i))
            self.manager.add(section: section)
            section.setHeaderWillDisplayHandler({ (currentSection) in
                print("Section" + String(currentSection.index) + " will display!")
            })
            
            section.setHeaderDidEndDisplayHandler({ (currentSection) in
                print("Section" + String(currentSection.index) + " did end display!")
            })
            
            for j in 0...4 {
                section.add(item: ZJTableViewItem(title: "Section " + String(i) + " Row " + String(j)))
            }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
