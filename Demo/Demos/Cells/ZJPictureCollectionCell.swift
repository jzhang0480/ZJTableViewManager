//
//  ZJPictureCollectionCell.swift
//  NewRetail
//
//  Created by Javen on 2018/3/1.
//  Copyright © 2018年 上海勾芒信息科技有限公司. All rights reserved.
//

import UIKit

typealias ZJPictureDeleteHandler = ((Int) -> Void)
class ZJPictureCollectionCell: UICollectionViewCell {
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var img: UIImageView!
    weak var collectionView: UICollectionView?
    var item: ZJPictureTableItem?
    
    var deleteHandler: ZJPictureDeleteHandler?
    func setDeleteHandler(temp: @escaping ZJPictureDeleteHandler) {
        self.deleteHandler = temp
    }
    func config(imageModel: Any){
        if (imageModel as AnyObject).isKind(of: UIImage.self) {
            self.img.image = imageModel as? UIImage
        }
    }
    
    @IBAction func actionDelete(_ sender: Any) {
        if let handler = self.deleteHandler {
            handler((self.collectionView?.indexPath(for: self)?.item)!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
