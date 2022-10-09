//
//  MemoEditorViewController.swift
//  MemoApp_Assessment
//
//  Created by Mac Pro 15 on 2022/10/09.
//

import UIKit
import RealmSwift

class MemoEditorViewController: BaseViewController {
    
    var mainView = MemoEditorView()
    
    let localRealm = try! Realm()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationAttribute()
        print("Realm is located at: ", localRealm.configuration.fileURL!)
        
    }
    
    func navigationAttribute() {
        self.navigationController!.navigationBar.topItem!.title = "메모" //바버튼 제목 변경
        self.navigationController!.navigationBar.tintColor = .orange //바버튼 색상 변경
        
        let sharingButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(sharingButtonClicked))
        let completionButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completionButtonClicked))
        
        sharingButton.tintColor = .orange
        completionButton.tintColor = .orange
        
        navigationItem.rightBarButtonItems = [completionButton, sharingButton]
    }
    
    @objc func sharingButtonClicked() {
        //액티비티뷰 사용하여 메모내용 공유
    }
    
    @objc func completionButtonClicked() {
        //realm에 메모저장
        let memoData = Memo(memoTitle: mainView.memoNote.text!, memoDate: Date(), memoContents: mainView.memoNote.text!) //레코드 생성
        
        do {
            try localRealm.write {
                localRealm.add(memoData) //일기 레코드 추가
                print("Realm Success")
            }
        } catch let error {
            print(error)
        }
        
        //todo: 메모내용있으면 저장
        
        self.navigationController?.popViewController(animated: true) //완료시 메모리스트로 화면전환
    }
}
