//
//  DeviceInfo.swift
//  SwiftDiary-05
//
//  Created by 伏文东 on 2018/3/2.
//  Copyright © 2018年 伏文东. All rights reserved.
//

import UIKit

struct DeviceInfo {
    static func deviceIsPhone() -> Bool {
        var isIdiomPhone = true
        let currentDeveice = UIDevice.current
        
        if currentDeveice.userInterfaceIdiom == .phone {
            isIdiomPhone = true;
        } else if currentDeveice.userInterfaceIdiom == .pad {
            isIdiomPhone = false;
        }
        
        return isIdiomPhone;
    }
}
