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
    
    let noteLocalRealm = try! Realm()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationAttribute()
        print("NoteLocalRealm is located at: ", noteLocalRealm.configuration.fileURL!)
        mainView.memoNote.becomeFirstResponder() //todo: 키보드가 텍스트뷰 가릴 때 키보드 올리기(IQKeyboardManager)
        
    }
    
    func navigationAttribute() {
        //todo: 백버튼에 <표시 UIImage(systemName: "chevron.backward")
        //self.navigationController!.navigationBar.topItem!.title = "메모" //바버튼 제목 변경
        self.navigationController!.navigationBar.tintColor = .orange //바버튼 색상 변경
        let backButton = UIBarButtonItem(title: "메모", style: .plain, target: self, action: #selector(backButtonClicked))
        let sharingButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(sharingButtonClicked))
        let completionButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completionButtonClicked))
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItems = [completionButton, sharingButton]
    }
    
    //뒤로가기+realm에 메모저장
    @objc func backButtonClicked() {
        print(#function)
        if mainView.memoNote.text == "" {
            self.navigationController?.popViewController(animated: true) //완료시 메모리스트로 화면전환
        } else {
            let date = Date()
            let memoData = Memo(fixedMemo: false, memoTitle: mainView.memoNote.text!, memoDate: date, memoContents: mainView.memoNote.text!)  //레코드 생성
            do {
                try noteLocalRealm.write {
                    noteLocalRealm.add(memoData) //일기 레코드 추가
                    print("Realm Success")
                }
            } catch let error {
                print(error)
            }
            self.navigationController?.popViewController(animated: true) //완료시 메모리스트로 화면전환
        }
    }
    
    @objc func sharingButtonClicked() {
        //액티비티뷰 사용하여 메모내용 공유
    }
    
    //뒤로가기+realm에 메모저장
    @objc func completionButtonClicked() {
        if mainView.memoNote.text == "" {
            self.navigationController?.popViewController(animated: true) //완료시 메모리스트로 화면전환
        } else {
            let date = Date()
            let memoData = Memo(fixedMemo: false, memoTitle: mainView.memoNote.text!, memoDate: date, memoContents: mainView.memoNote.text!)  //레코드 생성
            do {
                try noteLocalRealm.write {
                    noteLocalRealm.add(memoData) //일기 레코드 추가
                    print("Realm Success")
                }
            } catch let error {
                print(error)
            }
            self.navigationController?.popViewController(animated: true) //완료시 메모리스트로 화면전환
        }
    }
}
