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
    let memoEditorView = MemoEditorView()
    var note : Results<Memo>! {
        didSet {
            mainView.tableView.reloadData()
            print("MEMO UPDATED")
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
        print(#function)
        
        if AppLaunchStatusManager.shared.checkFirstRun() { //앱 첫실행 체크 후 alert 실행
            showAlert()
        } else { }
        
        note = noteLocalRealm.objects(Memo.self).sorted(byKeyPath: "memoDate", ascending: false)
        mainView.createMemoButton.addTarget(self, action: #selector(createMemoButtonClicked), for: .touchUpInside)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(#function)
        note = noteLocalRealm.objects(Memo.self).sorted(byKeyPath: "memoDate", ascending: false)
        makeSearchBar()
        navigationAttribute()
        mainView.tableView.reloadData()
    }
    
    @objc func createMemoButtonClicked() {
        let vc = MemoEditorViewController()
        MemoEditorView.memoData = ""
        //MemoEditorView.memoData?.memoTitle = "" //작성버튼으로 화면전환할때는 텍스트뷰에 아무것도 안보이게 처리
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
        //고정된 메모 있으면 섹션 2개, 없으면 1개
        let fixedMemoCount = self.noteLocalRealm.objects(Memo.self).filter("fixedMemo == true").count
        if fixedMemoCount >= 1 {
            return 2
        } else {
            return 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //todo: 메모 고정하면 고정하지 않은 메모 바뀌는 이유?
        let fixedMemoCount = self.noteLocalRealm.objects(Memo.self).filter("fixedMemo == true").count
        let unFixedMemoCount = self.noteLocalRealm.objects(Memo.self).filter("fixedMemo == false").count
        if fixedMemoCount >= 1 {
            if section == 0 {
                return fixedMemoCount
            } else {
                return unFixedMemoCount
            }
        } else {
            return unFixedMemoCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemoListTableViewCell", for: indexPath) as? MemoListTableViewCell else { return UITableViewCell() }
        let date = note[indexPath.row].memoDate
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "a hh:mm"
        
        //        //todo: 날짜별 포멧 적용
        //        if 작성일D-day {
        //            dateFormatter.dateFormat = "a hh:mm"
        //        } else if 작성일D-1 ~ 작성일D-6 {
        //            dateFormatter.dateFormat = "E요일"
        //        } else {
        //            dateFormatter.dateFormat = "YYYY. MM. dd a hh:mm"
        //        }
        
        cell.titleLabel.text = note[indexPath.row].memoTitle
        cell.lastEditedDateLabel.text = dateFormatter.string(from: date)
        cell.contentsLabel.text = note[indexPath.row].memoContents
        cell.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //fixedMemo == true 는 고정메모 섹션에 표시
        let fixMemo = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            try! self.noteLocalRealm.write { //고정여부 체크 컬럼(fixedMemo)으로 상태 구분(일반메모, 고정메모로 테이블 구분하지 않고 메모 테이블에서 컬럼 추가하여 구분)
                self.note[indexPath.row].fixedMemo = !self.note[indexPath.row].fixedMemo
            }
            self.mainView.tableView.reloadData()
        }
        let image = note[indexPath.row].fixedMemo ? "pin.slash.fill" : "pin.fill"
        fixMemo.image = UIImage(systemName: image)
        fixMemo.backgroundColor = .orange
        return UISwipeActionsConfiguration(actions: [fixMemo])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteMemo = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            self.showAlertForTrailingSwipe(title: "메모를 삭제하시겠습니까?") {
                try! self.noteLocalRealm.write {
                    self.noteLocalRealm.delete(self.note[indexPath.row])
                    self.navigationAttribute() //레코드 삭제했을때 메모갯수 변경
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
        let dataView = MemoEditorView()
        try! noteLocalRealm.write {
            note[indexPath.row].editingOpened = true
        }
        
        //MemoEditorView인스턴스 생성하면 텍스트뷰에 값 저장은 되는데
        memoEditorView.memoNote.text = self.note[indexPath.row].memoTitle
        
        //MemoEditorView클래스 프로퍼티로 텍스트뷰에 값 저장했는데 nil
//        MemoEditorView.memoData?.memoTitle = self.note[indexPath.row].memoTitle
        
        //MemoEditorView클래스 프로퍼티에서 텍스트뷰.text타입 string이면 화면 전환시 화면에 값표시됨
        //MemoEditorViewController에서 셀누르면 보이는 화면에서 완료버튼 누르면 레코드 새로 추가됨(memoEditingOpened = true일때 아무 이벤트 없는데도)
        MemoEditorView.memoData = self.note[indexPath.row].memoTitle
            
        print("didselect", memoEditorView.memoNote.text)
//        print("didselect2", MemoEditorView.memoData?.memoTitle)
        print("didselect3", MemoEditorView.memoData)
        
        self.navigationController?.pushViewController(MemoEditorViewController(), animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //MARK: - 헤더
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section >= 0 {
            guard let header = view as? UITableViewHeaderFooterView else { return }
            header.textLabel?.textColor = .white
            header.textLabel?.font = .systemFont(ofSize: 25, weight: .bold)
            header.textLabel?.textAlignment = .left
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //필터링할 때 메모검색수 결과 표시
        if numberOfSections(in: mainView.tableView) == 1 {
            return "메모"
        } else if numberOfSections(in: mainView.tableView) == 2 {
            if section == 0 {
                return "고정된 메모"
            } else {
                return "메모"
            }
        } else {
            return "메모"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if numberOfSections(in: mainView.tableView) == 1 {
            return 100
        } else if numberOfSections(in: mainView.tableView) == 2 {
            if section == 0 {
                return 50
            } else if section == 1 {
                return 100
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
}

extension MemoListViewController: UISearchResultsUpdating {
    //검색필터 조건설정
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        note = noteLocalRealm.objects(Memo.self).filter("memoTitle CONTAINS '\(text)'") //왜 필터적용+화면갱신 안되는지?
    }
}
