//
//  ListTableViewController.swift
//  SwiftDiary-05
//
//  Created by 伏文东 on 2017/10/30.
//  Copyright © 2017年 伏文东. All rights reserved.
//

import UIKit
import CoreData

class ListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    // 头像图片
    private var headPortrait : UIImageView!
    private var letfBtnView: UIView!
    
    private var contents : [ContentMo] = []
    private var content : ContentMo!
    private var fc : NSFetchedResultsController<ContentMo>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: 设置UI
        setupUI()
        touchInfo()
        fetchAllData()
        notificationCenter()
        //第一次进入展示日记
        if !(kDefaults.bool(forKey: "ifFirst")) {
            //            for i in 1...7 {
            //                nllcontent2(i: i)
            //            }
            nllcontent()
        }
        
        DataExtensions.fetcAllData()
        showInfo()
    }
    
    //接受数据
    private func notificationCenter() {
        let notifiMycationName = NSNotification.Name(rawValue: "saveInfo")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateChange),
                                               name: notifiMycationName,
                                               object: nil)
    }
    
    @objc func updateChange() {
        showInfo()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //进入个人信息界面
    private func touchInfo() {
        headPortrait.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(photoSelected))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        headPortrait.addGestureRecognizer(tap)
    }
    @objc func photoSelected() {
        let userInfo = storyboard?.instantiateViewController(withIdentifier: "showUserInfo")
        present(userInfo!, animated: true, completion: nil)
        
    }
    
    private func showInfo() {
        let size = CGSize(width: kHeadPortraitW, height: kHeadPortraitW)
        guard let img = UIImage.navAvatarImage(
            image: UIImage(data: infos[0].headPortrait!)!,
            size: size,
            backColor: UIColor.navColor())
            else { return }
        headPortrait.image = img
    }
    // MARK: 测试
    private func nllcontent2(i: Int) {
        content = ContentMo(context: kContext)
        
        content.contentLabel = "😂😂😂😂😂"
        content.dayLabel = "\(22 + i)"
        content.yearAndMonthLabel = "2017/6"
        content.timeLabel = "22:22 "
        content.timestamp = 7 + Int64(i)
        content.dayOfWeek = Int16(i)
        kAppDelegate.saveContext()
    }
    
    private func nllcontent() {
        content = ContentMo(context: kContext)
        
        content.contentLabel = """
        欢迎使用彩色便签🤤
        
        彩色日记会把一周的7天分别以不一样的颜色展示给你
        
        每天给你不一样的感觉
        
        如果你每天坚持写一条日记
        
        7天之后你就会看到🌈哦！😂
        
        快去写一条吧🙈
        
        哈哈哈😂😂😂🤦🏻‍♂️🤤
        """
        content.dayLabel = "17"
        content.yearAndMonthLabel = "2017/2"
        content.timeLabel = "22:22"
        content.timestamp = 1
        content.dayOfWeek = 5
        kAppDelegate.saveContext()
        
        info = UserInfoMo(context: kAppDelegate.persistentContainer.viewContext)
        let size = CGSize(width: 90, height: 90)
        info.headPortrait =  UIImageJPEGRepresentation(UIImage.avatarImage(image: UIImage(named: "headPortrait")!, size: size)!, 0.5)
        info.sign = 1;
        kAppDelegate.saveContext()
        
        kDefaults.set("你是一个励志的光头", forKey: "name")
        kDefaults.set("明天的事，交给明天的我？？.....", forKey: "introduce")
        
        kDefaults.set(true, forKey: "ifFirst")
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
            
        default:
            tableView.reloadData()
        }
        if let object = controller.fetchedObjects {
            contents = object as! [ContentMo]
        }
    }
    
    private func fetchAllData() {
        let request : NSFetchRequest<ContentMo> = ContentMo.fetchRequest()
        let sd = NSSortDescriptor(key: "timestamp", ascending: false)
        request.sortDescriptors = [sd]
        
        fc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: kContext, sectionNameKeyPath: nil, cacheName: nil)
        fc.delegate = self
        do {
            try fc.performFetch()
            
            if let object = fc.fetchedObjects {
                contents = object
            }
        } catch {
            print(error)
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            kContext.delete(self.fc.object(at: indexPath))
            kAppDelegate.saveContext()
        }
    }
    
    @IBAction func close(segue: UIStoryboardSegue)  {}
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetil" {
            let detail = segue.destination as! DetailViewController
            detail.content = contents[tableView.indexPathForSelectedRow!.row]
        }
    }
}
// MARK:- 设置UI界面
extension ListTableViewController {
    private func setupUI() {
        setupNaviBar()
        tableView.separatorColor = UIColor(white: 1, alpha: 0.66)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    private func setupNaviBar()  {
        letfBtnView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        letfBtnView.backgroundColor = UIColor.clear
        
        headPortrait = UIImageView(frame: CGRect(x: 0, y: (letfBtnView.frame.height - kHeadPortraitW) / 2, width: kHeadPortraitW, height: kHeadPortraitW))
        letfBtnView.addSubview(headPortrait)
        
        let leftBtn = UIBarButtonItem.init(customView: letfBtnView)
        navigationItem.leftBarButtonItem = leftBtn
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
}
// MARK:- tableViewDataSource协议
extension ListTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Moment", for: indexPath) as! MomentCell
        cell.content = contents[indexPath.row]
        cell.selectedBackgroundView = UIView()
        switch contents[indexPath.row].dayOfWeek {
        case 1:
            customCell(cell: cell, labels: [cell.contentLabel, cell.dayLabel, cell.yearAndMonth, cell.timeLabel], textColor: kWhite, bgc: kCheng, selectColor: kSelectedCheng)
        case 2:
            customCell(cell: cell, labels: [cell.contentLabel, cell.dayLabel, cell.yearAndMonth, cell.timeLabel], textColor: kBlack, bgc: kHuang, selectColor: kSelectedHuang)
        case 3:
            customCell(cell: cell, labels: [cell.contentLabel, cell.dayLabel, cell.yearAndMonth, cell.timeLabel], textColor: kWhite, bgc: kLv, selectColor: kSelectedLv)
        case 4:
            customCell(cell: cell, labels: [cell.contentLabel, cell.dayLabel, cell.yearAndMonth, cell.timeLabel], textColor: kBlack, bgc: kQing, selectColor: kSelectedQing)
        case 5:
            customCell(cell: cell, labels: [cell.contentLabel, cell.dayLabel, cell.yearAndMonth, cell.timeLabel], textColor: kWhite, bgc: kLan, selectColor: kSelectedLan)
        case 6:
            customCell(cell: cell, labels: [cell.contentLabel, cell.dayLabel, cell.yearAndMonth, cell.timeLabel], textColor: kWhite, bgc: kZi, selectColor: kSelectedZi)
        default:
            customCell(cell: cell, labels: [cell.contentLabel, cell.dayLabel, cell.yearAndMonth, cell.timeLabel], textColor: kWhite, bgc: kChi, selectColor: kSelectedChi)
        }
        return cell
    }
    
    private func customCell(cell: UITableViewCell,labels: [UILabel], textColor: UIColor, bgc:UIColor, selectColor: UIColor)  {
        cell.backgroundColor = bgc
        cell.selectedBackgroundView?.backgroundColor = selectColor
        for label in labels {
            label.textColor = textColor
        }
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



























