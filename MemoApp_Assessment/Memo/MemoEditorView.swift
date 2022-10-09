//
//  MemoEditorView.swift
//  MemoApp_Assessment
//
//  Created by Mac Pro 15 on 2022/10/09.
//

import Foundation
import UIKit

class MemoEditorView: BaseView {
    
    let memoNote: UITextView = {
       let view = UITextView()
        view.font = .systemFont(ofSize: 17)
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
