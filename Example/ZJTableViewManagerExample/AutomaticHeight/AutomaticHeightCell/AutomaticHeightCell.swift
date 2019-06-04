//
//  AutomaticHeightCell.swift
//  ZJTableViewManagerExample
//
//  Created by Javen on 2018/10/16.
//  Copyright © 2018 上海勾芒信息科技. All rights reserved.
//

import UIKit

class AutomaticHeightCellItem: ZJTableViewItem {
    var data: [String : Any]!
    
}

/// 动态高度的cell说明：支持系统autolayout搭建的cell（xib以及snapkit等基于autolayout的约束框架理论上都是支持的）
class AutomaticHeightCell: ZJTableViewCell {
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var imgSkillOne: UIImageView!
    @IBOutlet weak var imgSkillTwo: UIImageView!
    @IBOutlet weak var imgSkillThree: UIImageView!
    @IBOutlet weak var imgSkillFour: UIImageView!
    @IBOutlet weak var labelSkillOne: UILabel!
    @IBOutlet weak var labelSkillTwo: UILabel!
    @IBOutlet weak var labelSkillThree: UILabel!
    @IBOutlet weak var labelSkillFour: UILabel!

    @IBOutlet weak var fourthSkillBoard: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    /// cell即将出现在屏幕中的回调方法 在这个方法里面赋值
    override func cellWillAppear() {
        let item = self.item as! AutomaticHeightCellItem
        let name = item.data["name"] as! String
        labelName.text = name
        heroImage.image = UIImage(named: name)
        //只有存在四技能时才显示四技能这一行
        let skills = item.data["skill"] as! [[String: String]]
        fourthSkillBoard.isHidden = skills.count < 4
        for i in 0..<skills.count {
            let skill = skills[i]
            let skillName = skill["name"]!
            let skillDesc = skill["desc"]!
            if i == 0 {
                labelSkillOne.text = skillDesc
                imgSkillOne.image = UIImage(named: skillName)
            }else if i == 1 {
                labelSkillTwo.text = skillDesc
                imgSkillTwo.image = UIImage(named: skillName)
            }else if i == 2 {
                labelSkillThree.text = skillDesc
                imgSkillThree.image = UIImage(named: skillName)
            }else if i == 3 {
                labelSkillFour.text = skillDesc
                imgSkillFour.image = UIImage(named: skillName)
            }
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
