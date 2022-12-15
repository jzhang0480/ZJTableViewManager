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
    var type: ZJPictureCellType = .edit
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
        pictureSize = CGSize(width: pictureWidth, height: pictureWidth)
        arrPictures = arrPictures + pictures
        calculateHeight()
    }

    func updateHeight() {
        calculateHeight()
        tableViewManager.updateHeight()
    }

    func calculateHeight() {
        var picCount = arrPictures.count
        // 如果非只读的情况，则还需要多计算一个添加按钮的位置
        if type != .read {
            if arrPictures.count != Int(maxNumber) {
                picCount += 1
            }
        }
        var div = picCount / Int(column)
        let remainder = picCount % Int(column)
        if remainder != 0 {
            div = div + 1
        }

        cellHeight = CGFloat(div) * ((pictureSize?.height)! + space)
    }
}

class ZJPictureTableCell: UITableViewCell, ZJCellProtocol {
    var item: ZJPictureTableItem!

    func cellWillAppear() {
        layout.itemSize = item.pictureSize!
        layout.minimumInteritemSpacing = item.space
        layout.minimumLineSpacing = item.space

        if let edge = item.customEdgeInsets {
            collectionView.contentInset = edge
        } else {
            collectionView.contentInset = UIEdgeInsets(top: 0, left: item.space + 8, bottom: item.space, right: item.space)
        }

        collectionView.reloadData()
    }

    typealias ZJCelltemClass = ZJPictureTableItem

    var collectionView: UICollectionView!
    var layout: UICollectionViewFlowLayout!

    #if swift(>=4.2)
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            selectionStyle = UITableViewCell.SelectionStyle.none
            layout = UICollectionViewFlowLayout()
            collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 100), collectionViewLayout: layout)
            collectionView.backgroundColor = UIColor.white
            contentView.addSubview(collectionView)
            collectionView.register(UINib(nibName: "ZJPictureCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ZJPictureCollectionCell")
            collectionView.isScrollEnabled = false
            collectionView.delegate = self
            collectionView.dataSource = self
        }

    #else
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            selectionStyle = UITableViewCellSelectionStyle.none
            layout = UICollectionViewFlowLayout()
            collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 100), collectionViewLayout: layout)
            collectionView.backgroundColor = UIColor.white
            contentView.addSubview(collectionView)
            collectionView.register(UINib(nibName: "ZJPictureCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ZJPictureCollectionCell")
            collectionView.isScrollEnabled = false
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    #endif

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
    }

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
            item.superVC.present(alertVC, animated: true, completion: nil)
        }
    }

    func isDisplayAddButton() -> Bool {
        return item.arrPictures.count == Int(item.maxNumber)
    }

    func showImage(index: Int, isShowDelete: Bool) {
        let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! ZJPictureCollectionCell

        var images = [SKPhoto]()
        for image in item.arrPictures {
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
        item.superVC.present(browser, animated: true, completion: {})
    }

    @available(*, unavailable)
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
        switch item.type {
        case .read: // 只是展示图片，返回图片数量
            return item.arrPictures.count
        case .edit:
            // 如果是编辑状态，图片数量满了，就不显示添加按钮
            if item.arrPictures.count == Int(item.maxNumber) {
                return item.arrPictures.count
            } else {
                // 图片数量没有满，显示添加按钮（+1)
                return item.arrPictures.count + 1
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZJPictureCollectionCell", for: indexPath) as! ZJPictureCollectionCell
        cell.collectionView = self.collectionView
        switch item.type {
        case .read: // 只是展示图片
            cell.btnDelete.isHidden = true
            cell.config(imageModel: item.arrPictures[indexPath.item])
        case .edit:
            cell.btnDelete.isHidden = false
            // 如果是编辑状态，图片数量满了，就不显示添加按钮
            if item.arrPictures.count == indexPath.item {
                cell.btnDelete.isHidden = true
                cell.img.image = #imageLiteral(resourceName: "picture_add")
            } else {
                cell.config(imageModel: item.arrPictures[indexPath.item])
            }
        }

        weak var weakSelf = self
        cell.setDeleteHandler { currentIndex in
            weakSelf?.deletePicture(vc: nil, index: currentIndex, complete: nil)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch item.type {
        case .read:
            print("查看图片")
            showImage(index: indexPath.item, isShowDelete: false)
        case .edit:
            if item.arrPictures.count == indexPath.item {
                print("添加图片")
                let imagePickerController = ImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.imageLimit = Int(item.maxNumber - CGFloat(item.arrPictures.count))
                item.superVC.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("查看图片，可删除")
                showImage(index: indexPath.item, isShowDelete: true)
            }
        }
    }
}

// MARK: - 拍照

extension ZJPictureTableCell: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        for image in images {
            item.arrPictures.append(image)
        }
        item.updateHeight()
        collectionView.reloadData()
        item.superVC.dismiss(animated: true, completion: nil)
    }

    // 完成选择图片
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        for image in images {
            item.arrPictures.append(image)
        }
        item.updateHeight()
        collectionView.reloadData()
        item.superVC.dismiss(animated: true, completion: nil)
    }

    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        item.superVC.dismiss(animated: true, completion: nil)
    }
}

// MARK: - 拍照

extension ZJPictureTableCell: SKPhotoBrowserDelegate {
    func removePhoto(_ browser: SKPhotoBrowser, index: Int, reload: @escaping (() -> Void)) {
        deletePicture(vc: browser, index: index) {
            reload()
        }
    }

    func viewForPhoto(_ browser: SKPhotoBrowser, index: Int) -> UIView? {
        let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! ZJPictureCollectionCell
        return cell.img
    }
}
