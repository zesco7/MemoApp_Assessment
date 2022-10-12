//
//  BaseViewController.swift
//  MemoApp_Assessment
//
//  Created by Mac Pro 15 on 2022/10/09.
//

import UIKit
import RealmSwift
import SnapKit
import Toast

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootViewAttribute()
        configure()
    }
    
    func rootViewAttribute() {
        view.backgroundColor = .black
        view.layer.cornerRadius = 10
    }
    
    func configure() { }
}
