//
//  RealmModel.swift
//  MemoApp_Assessment
//
//  Created by Mac Pro 15 on 2022/10/09.
//

import UIKit
import RealmSwift

class Memo: Object { //realm테이블 만들기(컬럼 생성)
    @Persisted var fixedMemo: Bool
    @Persisted var editingOpened: Bool
    @Persisted var memoTitle: String
    @Persisted var memoDate = Date()
    @Persisted var memoContents: String?
    //@Persisted var memoHeader: String?
    //@Persisted var memoContents: String?
    
    @Persisted(primaryKey: true) var objectId: ObjectId //pk등록
    
    convenience init(fixedMemo: Bool, editingOpened: Bool, memoTitle: String, memoDate: Date, memoContents: String?) {
        self.init()
        self.fixedMemo = false
        self.editingOpened = false
        self.memoTitle = memoTitle
        self.memoDate = memoDate
        //self.memoHeader = memoHeader
        self.memoContents = memoContents
    }
}
