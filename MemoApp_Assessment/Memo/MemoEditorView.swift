//
//  MemoEditorView.swift
//  MemoApp_Assessment
//
//  Created by Mac Pro 15 on 2022/10/09.
//

import Foundation
import UIKit
import RealmSwift

class MemoEditorView: BaseView {
    static var memoData : String = "" //realm타입으로 받아서 view.text에 넣을수가 없어서 String으로 타입변경
    //static var memoData : Memo?
    static var memoIndex : Int?
    static var memoEditingOpened = false
    
    let memoNote: UITextView = {
        let view = UITextView()
        view.font = .systemFont(ofSize: 17)
        view.text = MemoEditorView.memoData
        //view.text = MemoEditorView.memoData?.memoTitle
        
        return view
    }()
    
    override func configureUI() {
        self.addSubview(memoNote)
    }
    
    override func setConstraints() {
       memoNote.snp.makeConstraints { make in
            make.topMargin.equalTo(0)
            make.leadingMargin.equalTo(0)
            make.trailingMargin.equalTo(0)
            make.bottomMargin.equalTo(0)
        }
    }
}
