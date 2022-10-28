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
    let memoEditorView = MemoEditorView()
    let vc = MemoListViewController()
    var tasks : Results<Memo>! {
        didSet {
            print("MEMO UPDATED")
        }
    }
    
    var memoDataInRealm : Memo?

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasks = noteLocalRealm.objects(Memo.self)

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
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func sharingButtonClicked() {
        //액티비티뷰 사용하여 메모내용 공유
    }
    
    //뒤로가기+realm에 메모저장
    @objc func completionButtonClicked() {
        
        let date = Date()
        memoDataInRealm = Memo(fixedMemo: false, editingOpened: false, memoTitle: mainView.memoNote.text!, memoDate: date, memoContents: mainView.memoNote.text!)  //레코드 생성
        
        //메모 생성&수정: 메모 첫 생성 했을 때 텍스트뷰에 내용 입력하면 메모 레코드 추가 + 화면전환
            if MemoEditorView.memoEditingOpened == false { //메모 첫 생성 했을 때
                if mainView.memoNote.text != "" { //텍스트뷰에 내용 입력하면
                do {
                    try noteLocalRealm.write {
                        noteLocalRealm.add(memoDataInRealm!) //메모 레코드 추가
                        print("Realm Add Success")
                        print("메모제목: \(memoDataInRealm!.memoTitle)")
                    }
                } catch let error {
                    print(error)
                }
                self.navigationController?.popViewController(animated: true) //화면전환
            } else { //내용 입력안하면
                self.navigationController?.popViewController(animated: true)
            }
        } else { //메모 수정 시도
            
//            do {
//                try noteLocalRealm.write {
//                    memoDataInRealm?.memoTitle = mainView.memoNote.text
//                }
//            } catch let error {
//                print(error)
//            }
            print("memo data in textView", mainView.memoNote.text)
//            self.navigationController?.popViewController(animated: true) //화면전환
            print("Memo Edited")
        }
    }
}
