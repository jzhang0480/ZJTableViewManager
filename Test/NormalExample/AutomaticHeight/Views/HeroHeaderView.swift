//
//  HeroHeaderView.swift
//  ZJTableViewManagerExample
//
//  Created by Javen on 2019/6/19.
//  Copyright © 2019 上海勾芒信息科技. All rights reserved.
//

import UIKit

class HeroHeaderView: UIView {
    @IBOutlet var imageHero: UIImageView!
    @IBOutlet var labelHero: UILabel!

    class func view() -> HeroHeaderView {
        let nib = UINib(nibName: "HeroHeaderView", bundle: nil)
        let headerView = nib.instantiate(withOwner: nil, options: nil)[0] as! HeroHeaderView
        headerView.frame.size.height = 50
        return headerView
    }

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
         // Drawing code
     }
     */
}
