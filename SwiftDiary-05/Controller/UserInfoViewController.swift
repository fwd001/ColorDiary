//
//  UserInfoViewController.swift
//  SwiftDiary-05
//
//  Created by 伏文东 on 2017/11/9.
//  Copyright © 2017年 伏文东. All rights reserved.
//

import UIKit
import CoreData

class UserInfoViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    // MARK: 完成按钮
    @IBAction func done(_ sender: UIBarButtonItem) {
        
        kDefaults.set(nameTF.text, forKey: "name")
        kDefaults.set(infoTF.text, forKey: "introduce")
        if isPhotoChange {
            
            upDataInfo(image: headPortrait.image!)
            tempbuttonAction()
        }
        dismiss(animated: true, completion: nil)
    }
    // MARK: 取消按钮
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    // MARK: 头像图片
    @IBOutlet weak var headPortrait: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    // MARK: 修改图片按
    @IBOutlet weak var changeHeadBtn: UIButton!
    @IBOutlet weak var changeView: UIView!
    @IBAction func changeHeadPortrait(_ sender: UIButton) {
        photoSelected(btn: sender)
        
    }
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var infoTF: UITextField!
    var isPhotoChange = false
    // MARK: 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: 弹出alert
    @objc func photoSelected(btn: UIButton) {
        nameTF.resignFirstResponder()
        infoTF.resignFirstResponder()
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let photo = UIAlertAction(title: "相册", style: .default) { (_) in
            self.openPhotoAlbum()
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(photo)
        alert.addAction(cancel)
        if DeviceInfo.deviceIsPhone() {
            present(alert, animated: true, completion: nil)
        } else {
            let popPresenter = alert.popoverPresentationController
            popPresenter?.sourceView = btn
            popPresenter?.sourceRect = btn.bounds
            popPresenter?.permittedArrowDirections = .any
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    // MARK: 点击跟换头像按钮
    func openPhotoAlbum()  {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        let pick = UIImagePickerController()
        pick.allowsEditing = true
        pick.delegate = self
        present(pick, animated: true, completion: nil)
    }
    // MARK: UIImage Picker Controller Delegate 弹起相册
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        let size = CGSize(width: 90, height: 90)
        guard let img = UIImage.avatarImage(image: image, size: size) else { return }
        headPortrait.image = img
        isPhotoChange = true
        dismiss(animated: true, completion: nil)
    }
    
    // 通知主界面去刷新头像
    let notifiMycationName = NSNotification.Name(rawValue: "saveInfo")
    func tempbuttonAction() {
        NotificationCenter.default.post(name: notifiMycationName, object:nil)
    }
    
}
// MARK:- 遵守NSFetchedResultsControllerDelegate协议
extension UserInfoViewController: NSFetchedResultsControllerDelegate  {
    
    func upDataInfo(image: UIImage) {
        let request : NSFetchRequest<UserInfoMo> = UserInfoMo.fetchRequest()
        let pro = NSPredicate.init(format: "sign = %d", 1)
        request.predicate = pro
        do {
            let result = try kAppDelegate.persistentContainer.viewContext.fetch(request)
            for infoNew in result {
                infoNew.headPortrait = UIImageJPEGRepresentation(image, 0.5)
                infoNew.sign = 1;
                kAppDelegate.saveContext()
            }
        } catch  {
            print(error)
        }
    }
}

// MARK:- 设置UI界面
extension UserInfoViewController {
    func setupUI()  {
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        setupBtn()
        if DeviceInfo.deviceIsPhone() {
            headPortrait.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(photoSelected))
            tap.numberOfTapsRequired = 1
            tap.numberOfTouchesRequired = 1
            headPortrait.addGestureRecognizer(tap)
        }
        
        headPortrait.image = UIImage(data: infos[0].headPortrait!)
        nameTF.text = kDefaults.string(forKey: "name")
        infoTF.text = kDefaults.string(forKey: "introduce")
        
        nameTF.delegate = self
        infoTF.delegate = self
        nameTF.tag = 1001
        infoTF.tag = 1002
    }
    func setupBtn()  {
        headPortrait.contentMode = .scaleAspectFill
        headPortrait.layer.cornerRadius = 45
        headPortrait.clipsToBounds = true
        
        backgroundView.layer.shadowOffset = CGSize(width: -2, height: 2)
        backgroundView.layer.shadowOpacity = 0.5
        backgroundView.layer.shadowRadius = 3
        backgroundView.layer.cornerRadius = 45
        backgroundView.layer.masksToBounds = false
        
        changeView.layer.shadowOffset = CGSize(width: -1, height: 1)
        changeView.layer.shadowOpacity = 0.3
        changeView.layer.shadowRadius = 1
        changeView.layer.cornerRadius = 12
        changeView.layer.masksToBounds = false
        
        changeHeadBtn.layer.borderColor = UIColor(r: 255, g: 47, b: 146).cgColor
        changeHeadBtn.layer.borderWidth = 1
        changeHeadBtn.setTitleColor(UIColor.groupTableViewBackground, for: .highlighted) //setTitleColor(UIColor(r: 141, g: 175, b: 91), for: .highlighted)
        changeHeadBtn.setBackgroundImage(UIImage.imageWithColor(
            color: UIColor(red:255/255, green:47/255, blue:146/255, alpha:1),
            size: CGSize(width: 90, height: 30)),
                                         for: .highlighted)
    }
    
    // MARK: 让分割线顶头
    override func viewDidLayoutSubviews() {
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
}
// MARK:- 遵守textfield代理
extension UserInfoViewController: UITextFieldDelegate {
    // 限制textField字数
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else  {return true}
        let newLenght = text.count + string.count - range.length
        if textField.tag == 1001 {
            return newLenght <= 24
        } else {
            return newLenght <= 28
        }
    }
}




































