//
//  MemoListViewController.swift
//  MemoApp_Assessment
//
//  Created by Mac Pro 15 on 2022/10/09.
//

import UIKit
import RealmSwift

class MemoListViewController: BaseViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var mainView = MemoListView()
    let tvcell = MemoListTableViewCell()
    
    let noteLocalRealm = try! Realm()
    let fixedNoteLocalRealm = try! Realm()
    
    var note : Results<Memo>! {
        didSet {
            mainView.tableView.reloadData()
            print("MEMO UPDATED")
        }
    }
    
    var fixedNote : Results<FixedMemo>! {
        didSet {
            mainView.tableView.reloadData()
            print("FIXED MEMO UPDATED")
        }
    }
    
    override func loadView() {
        self.view = mainView
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(MemoListTableViewCell.self, forCellReuseIdentifier: "MemoListTableViewCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AppLaunchStatusManager.shared.checkFirstRun() { //앱 첫실행 체크 후 alert 실행
            showAlert()
        } else { }
        
        
        
        
        note = noteLocalRealm.objects(Memo.self).sorted(byKeyPath: "memoDate", ascending: true)
        fixedNote = fixedNoteLocalRealm.objects(FixedMemo.self).sorted(byKeyPath: "memoDate", ascending: true)
        mainView.createMemoButton.addTarget(self, action: #selector(createMemoButtonClicked), for: .touchUpInside)
        
        makeSearchBar()
        navigationAttribute()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainView.tableView.reloadData()
    }
    
    @objc func createMemoButtonClicked() {
        let vc = MemoEditorViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "처음오셨군요. 환영합니다 :)", message: "당신만의 메모를 작성하고 관리해보세요!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func makeSearchBar() { //UISearchController 메서드 사용(searchBar 생성)
        searchController.searchBar.placeholder = "검색"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
    }
    
    func navigationAttribute() { //네비게이션에 searchController 등록
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let totalMemoCount = numberFormatter.string(from: NSNumber(value: note.count))! //Int -> String이므로 옵셔널 unwrapping 필요
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "\(totalMemoCount)개의 메모"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK: - 컨텐츠
    func numberOfSections(in tableView: UITableView) -> Int {
        //todo: 고정된 메모 있으면 섹션 2개, 없으면 1개
        if fixedNote != nil {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fixedNote != nil && section == 0 {
            return fixedNote.count
        } else {
            return note.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemoListTableViewCell", for: indexPath) as? MemoListTableViewCell else { return UITableViewCell() }

        if fixedNote != nil { //fixedNote에 데이터 있으면 고정된 메모, 메모데이터 별도 표시
            if indexPath.section == 0 {
                cell.titleLabel.text = fixedNote[indexPath.row].memoTitle
                cell.lastEditedDateLabel.text = "\(fixedNote[indexPath.row].memoDate)"
                cell.contentsLabel.text = fixedNote[indexPath.row].memoContents
            } else {
                cell.titleLabel.text = note[indexPath.row].memoTitle
                cell.lastEditedDateLabel.text = "\(note[indexPath.row].memoDate)"
                cell.contentsLabel.text = note[indexPath.row].memoContents
            }
        } else { //fixedNote에 데이터 없으면 메모데이터만 표시
            cell.titleLabel.text = note[indexPath.row].memoTitle
            cell.lastEditedDateLabel.text = "\(note[indexPath.row].memoDate)"
            cell.contentsLabel.text = note[indexPath.row].memoContents
        }
        
        cell.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let fixMemo = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            try! self.noteLocalRealm.write {
                self.noteLocalRealm.delete(self.note[indexPath.row])
            }
            try! self.fixedNoteLocalRealm.write {
                let fixedMemoData = FixedMemo(memoTitle: self.note[indexPath.row].memoTitle, memoDate: self.note[indexPath.row].memoDate, memoContents: self.note[indexPath.row].memoContents) //레코드 생성
                self.fixedNoteLocalRealm.add(fixedMemoData)
            }
            self.mainView.tableView.reloadData()
            print("Realm Deleted")
        }
        print(#function)
        
        //let image = note[indexPath.row].fixedMemo ? "pin.slash.fill" : "pin.slash"
        fixMemo.image = UIImage(systemName: "pin.fill")
        fixMemo.backgroundColor = .orange
        return UISwipeActionsConfiguration(actions: [fixMemo])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteMemo = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            self.showAlertForTrailingSwipe(title: "메모를 삭제하시겠습니까?") {
                /*todo: 인덱스 에러 개선
                if self.fixedNote != nil { //fixedNote에 데이터 있으면 고정된 메모데이터 삭제
                    try! self.fixedNoteLocalRealm.write {
                        self.fixedNoteLocalRealm.delete(self.fixedNote[indexPath.row])
                    }
                } else { //fixedNote에 데이터 없으면 메모데이터 삭제
                    try! self.noteLocalRealm.write {
                        self.noteLocalRealm.delete(self.note[indexPath.row])
                    }
                */
                
                try! self.noteLocalRealm.write {
                    self.noteLocalRealm.delete(self.note[indexPath.row])
                    self.mainView.tableView.reloadData() //note변수에 didSet있는데 왜 reloadData가 안될까?
                    print("Realm Deleted")
                }
            }
        }
        deleteMemo.image = UIImage(systemName: "trash.fill")
        deleteMemo.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteMemo])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //todo: 선택한 행 데이터가진 화면으로 이동 어떻게?
        self.navigationController?.pushViewController(MemoEditorViewController(), animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //MARK: - 헤더
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = .white
        header.textLabel?.font = .systemFont(ofSize: 25, weight: .bold)
        header.textLabel?.textAlignment = .left
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //todo: 필터링할 때 메모검색수 결과 표시
        if section == 0 {
            return "고정된 메모"
        } else {
            return "메모"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}

extension MemoListViewController: UISearchResultsUpdating {
    //검색필터 조건설정
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        note = noteLocalRealm.objects(Memo.self).filter("memoTitle CONTAINS '\(text)'")
    }
}
