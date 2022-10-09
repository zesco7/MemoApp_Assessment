//
//  MemoListViewController.swift
//  MemoApp_Assessment
//
//  Created by Mac Pro 15 on 2022/10/09.
//

import UIKit
import RealmSwift

class MemoListViewController: BaseViewController {
    
    var mainView = MemoListView()
    let tvcell = MemoListTableViewCell()
    
    let localRealm = try! Realm()
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
        
        note = localRealm.objects(Memo.self).sorted(byKeyPath: "memoDate", ascending: true)
        mainView.createMemoButton.addTarget(self, action: #selector(createMemoButtonClicked), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainView.tableView.reloadData()
    }
    
    @objc func createMemoButtonClicked() {
        let vc = MemoEditorViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK: - 컨텐츠
    func numberOfSections(in tableView: UITableView) -> Int {
        //todo: 고정된 메모 있으면 섹션 2개, 없으면 1개
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return note.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemoListTableViewCell", for: indexPath) as? MemoListTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = note[indexPath.row].memoTitle
        cell.lastEditedDateLabel.text = "\(note[indexPath.row].memoDate)"
        cell.contentsLabel.text = note[indexPath.row].memoContents
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let fixMemo = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            print(#function)
        }
        //let image = note[indexPath.row].fixedMemo ? "pin.slash.fill" : "pin.slash"
        fixMemo.image = UIImage(systemName: "pin.fill")
        return UISwipeActionsConfiguration(actions: [fixMemo])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteMemo = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            print(#function)
        }
        deleteMemo.image = UIImage(systemName: "trash.fill")
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
