//
//  AppLaunchStatusManager.swift
//  MemoApp_Assessment
//
//  Created by Mac Pro 15 on 2022/10/10.
//

import UIKit

public class AppLaunchStatusManager {
    static var shared = AppLaunchStatusManager()
    
    func checkFirstRun() -> Bool {
        if UserDefaults.standard.object(forKey: "checkIsFirstRun") == nil {
            UserDefaults.standard.set("NOT FIRST RUN", forKey: "checkIsFirstRun")
            print(UserDefaults.standard.object(forKey: "checkIsFirstRun")!)
            return true
        } else {
            print(UserDefaults.standard.object(forKey: "checkIsFirstRun")!)
            return false
        }
    }
}

