//
//  ZJPictureTableCell.swift
//  NewRetail
//
//  Created by Javen on 2018/3/1.
//  Copyright © 2018年 上海勾芒信息科技有限公司. All rights reserved.
//

import ImagePicker
import SKPhotoBrowser
import UIKit
import ZJTableViewManager

import ZJTableViewManager
enum ZJPictureCellType {
    case edit
    case read
}

class ZJPictureTableItem: ZJTableViewItem {
    var arrPictures: [Any] = []
    var maxNumber: CGFloat = 5
    var column: CGFloat = 4
    var type: ZJPictureCellType = ZJPictureCellType.edit
    var pictureSize: CGSize?
    var space: CGFloat = 8
    var superVC: UIViewController!
    var customEdgeInsets: UIEdgeInsets?
    
    /// 初始化图片item
    ///
    /// - Parameters:
    ///   - maxNumber: 最多允许添加几张图片
    ///   - column: 列数（一行显示几个图片）
    ///   - space: 图片间距（最后效果不一定会完全符合设置的间距，会有略微差异）
    ///   - width: 显示图片区域的宽度（一般是这个cell的宽度）
    ///   - superVC: 当前的viewcontroller
    ///   - pictures: 图片
    convenience init(maxNumber: CGFloat, column: CGFloat, space: CGFloat, width: CGFloat, superVC: UIViewController!, pictures: [Any] = []) {
        self.init()
        self.superVC = superVC
        self.maxNumber = maxNumber
        self.column = column
        self.space = space
        let tempWidth = (width - space * (column + 1) - 8) / column
        // 精确到小数点后2位，不四舍五入，防止精度问题导致不恰当的换行
        let pictureWidth = CGFloat(Int(tempWidth * 100)) / 100
        self.pictureSize = CGSize(width: pictureWidth, height: pictureWidth)
        self.arrPictures = self.arrPictures + pictures
        self.calculateHeight()
    }
    
    func updateHeight() {
        self.calculateHeight()
        tableViewManager.updateHeight()
    }
    
    func calculateHeight() {
        var picCount = self.arrPictures.count
        // 如果非只读的情况，则还需要多计算一个添加按钮的位置
        if self.type != .read {
            if self.arrPictures.count != Int(self.maxNumber) {
                picCount += 1
            }
        }
        var div = picCount / Int(self.column)
        let remainder = picCount % Int(self.column)
        if remainder != 0 {
            div = div + 1
        }
        
        self.cellHeight = CGFloat(div) * ((self.pictureSize?.height)! + self.space)
    }
}

class ZJPictureTableCell: UITableViewCell, ZJCellProtocol {
    var item: ZJPictureTableItem!
    
    func cellWillAppear() {
        self.layout.itemSize = self.item.pictureSize!
        self.layout.minimumInteritemSpacing = self.item.space
        self.layout.minimumLineSpacing = self.item.space
        
        if let edge = item.customEdgeInsets {
            self.collectionView.contentInset = edge
        } else {
            self.collectionView.contentInset = UIEdgeInsets(top: 0, left: self.item.space + 8, bottom: self.item.space, right: self.item.space)
        }
        
        self.collectionView.reloadData()
    }
    
    typealias ZJCelltemClass = ZJPictureTableItem
    
    var collectionView: UICollectionView!
    var layout: UICollectionViewFlowLayout!
    
    #if swift(>=4.2)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        self.layout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 100), collectionViewLayout: self.layout)
        self.collectionView.backgroundColor = UIColor.white
        self.contentView.addSubview(self.collectionView)
        self.collectionView.register(UINib(nibName: "ZJPictureCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ZJPictureCollectionCell")
        self.collectionView.isScrollEnabled = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    #else
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.layout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 100), collectionViewLayout: self.layout)
        self.collectionView.backgroundColor = UIColor.white
        self.contentView.addSubview(self.collectionView)
        self.collectionView.register(UINib(nibName: "ZJPictureCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ZJPictureCollectionCell")
        self.collectionView.isScrollEnabled = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    #endif
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
    }
    
//    override func cellWillAppear() {
//        super.cellWillAppear()
//        self.item = (self.item as! ZJPictureTableItem)
//        self.layout.itemSize = self.item.pictureSize!
//        self.layout.minimumInteritemSpacing = self.item.space
//        self.layout.minimumLineSpacing = self.item.space
//
//        if let edge = item.customEdgeInsets {
//            self.collectionView.contentInset = edge
//        } else {
//            self.collectionView.contentInset = UIEdgeInsets(top: 0, left: self.item.space + 8, bottom: self.item.space, right: self.item.space)
//        }
//
//        self.collectionView.reloadData()
//    }
    
    func deletePicture(vc: UIViewController?, index: Int, complete: (() -> Void)?) {
        let alertVC = UIAlertController(title: "提示", message: "确定删除此附件吗？", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "确定", style: .destructive) { [weak self] _ in
            if (self?.isDisplayAddButton())! {
                self?.item.arrPictures.remove(at: index)
                self?.collectionView.reloadData()
            } else {
                self?.item.arrPictures.remove(at: index)
                self?.collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
            }
            self?.item.updateHeight()
            
            if let handler = complete {
                handler()
            }
        }
        
        let cancel = UIAlertAction(title: "取消", style: .default, handler: nil)
        alertVC.addAction(confirm)
        alertVC.addAction(cancel)
        if let superVC = vc {
            superVC.present(alertVC, animated: true, completion: nil)
        } else {
            self.item.superVC.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func isDisplayAddButton() -> Bool {
        return self.item.arrPictures.count == Int(self.item.maxNumber)
    }
    
    func showImage(index: Int, isShowDelete: Bool) {
        let cell = self.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! ZJPictureCollectionCell
        
        var images = [SKPhoto]()
        for image in self.item.arrPictures {
            var photo: SKPhoto!
            if (image as AnyObject).isKind(of: UIImage.self) {
                photo = SKPhoto.photoWithImage(image as! UIImage)
            }
            
            images.append(photo)
            photo.shouldCachePhotoURLImage = false
        }
        SKPhotoBrowserOptions.displayDeleteButton = isShowDelete
        SKPhotoBrowserOptions.displayStatusbar = true
        SKPhotoBrowserOptions.displayAction = false
        SKPhotoBrowserOptions.displayBackAndForwardButton = false
        let browser = SKPhotoBrowser(originImage: cell.img.image!, photos: images, animatedFromView: cell.img)
        browser.initializePageIndex(index)
        browser.delegate = self as SKPhotoBrowserDelegate
        self.item.superVC.present(browser, animated: true, completion: {})
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

// MARK: - CollectionViewDelegate

extension ZJPictureTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.item.type {
        case .read: // 只是展示图片，返回图片数量
            return self.item.arrPictures.count
        case .edit:
            // 如果是编辑状态，图片数量满了，就不显示添加按钮
            if self.item.arrPictures.count == Int(self.item.maxNumber) {
                return self.item.arrPictures.count
            } else {
                // 图片数量没有满，显示添加按钮（+1)
                return self.item.arrPictures.count + 1
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZJPictureCollectionCell", for: indexPath) as! ZJPictureCollectionCell
        cell.collectionView = self.collectionView
        switch self.item.type {
        case .read: // 只是展示图片
            cell.btnDelete.isHidden = true
            cell.config(imageModel: self.item.arrPictures[indexPath.item])
        case .edit:
            cell.btnDelete.isHidden = false
            // 如果是编辑状态，图片数量满了，就不显示添加按钮
            if self.item.arrPictures.count == indexPath.item {
                cell.btnDelete.isHidden = true
                cell.img.image = #imageLiteral(resourceName: "picture_add")
            } else {
                cell.config(imageModel: self.item.arrPictures[indexPath.item])
            }
        }
        
        weak var weakSelf = self
        cell.setDeleteHandler { currentIndex in
            weakSelf?.deletePicture(vc: nil, index: currentIndex, complete: nil)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch self.item.type {
        case .read:
            print("查看图片")
            self.showImage(index: indexPath.item, isShowDelete: false)
        case .edit:
            if self.item.arrPictures.count == indexPath.item {
                print("添加图片")
                let imagePickerController = ImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.imageLimit = Int(self.item.maxNumber - CGFloat(self.item.arrPictures.count))
                self.item.superVC.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("查看图片，可删除")
                self.showImage(index: indexPath.item, isShowDelete: true)
            }
        }
    }
}

// MARK: - 拍照

extension ZJPictureTableCell: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        for image in images {
            self.item.arrPictures.append(image)
        }
        self.item.updateHeight()
        self.collectionView.reloadData()
        self.item.superVC.dismiss(animated: true, completion: nil)
    }
    
    // 完成选择图片
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        for image in images {
            self.item.arrPictures.append(image)
        }
        self.item.updateHeight()
        self.collectionView.reloadData()
        self.item.superVC.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        self.item.superVC.dismiss(animated: true, completion: nil)
    }
}

// MARK: - 拍照

extension ZJPictureTableCell: SKPhotoBrowserDelegate {
    func removePhoto(_ browser: SKPhotoBrowser, index: Int, reload: @escaping (() -> Void)) {
        self.deletePicture(vc: browser, index: index) {
            reload()
        }
    }
    
    func viewForPhoto(_ browser: SKPhotoBrowser, index: Int) -> UIView? {
        let cell = self.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! ZJPictureCollectionCell
        return cell.img
    }
}
