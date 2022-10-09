//
//  MemoListView.swift
//  MemoApp_Assessment
//
//  Created by Mac Pro 15 on 2022/10/09.
//

import UIKit

class MemoListView: BaseView {
    
    let totalCount : UILabel = {
        let view = UILabel()
        return view
    }()
    
    let tableView : UITableView = {
       let view = UITableView()
        view.backgroundColor = .clear
        return view
    }()
    
    let createMemoButton : UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        view.tintColor = .orange
        return view
    }()
    
    override func configureUI() {
        [tableView, createMemoButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.topMargin.equalTo(50)
            make.leadingMargin.equalTo(10)
            make.trailingMargin.equalTo(-10)
            make.bottomMargin.equalTo(-80)
        }
        
        createMemoButton.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(5)
            make.size.equalTo(40)
            make.trailingMargin.equalTo(-10)
        }
    }
}

