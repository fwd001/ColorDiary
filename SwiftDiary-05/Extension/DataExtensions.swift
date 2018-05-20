//
//  DataExtensions.swift
//  SwiftDiary-05
//
//  Created by 伏文东 on 2018/1/13.
//  Copyright © 2018年 伏文东. All rights reserved.
//

import UIKit
import CoreData

var infos : [UserInfoMo] = []
var info : UserInfoMo!

class DataExtensions {
    static func fetcAllData()  {
        let context = kAppDelegate.persistentContainer.viewContext
        do {
            infos = try context.fetch(UserInfoMo.fetchRequest())
        } catch  {
            print(error)
        }
    }
}

