//
//  SimpleCollectionViewController.swift
//  MemoApp_Assessment
//
//  Created by Mac Pro 15 on 2022/10/18.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "Cell"

class SimpleCollectionViewController: UICollectionViewController {
    var tasks: Results<Memo>!
    var localRealm = try! Realm()
    
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, Memo>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasks = localRealm.objects(Memo.self)
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.backgroundColor = .orange
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionView.collectionViewLayout = layout
        
        cellRegistration = UICollectionView.CellRegistration(handler: { cell, indexPath, itemIdentifier in
            var content = cell.defaultContentConfiguration()
            content.image = itemIdentifier.memoTitle == "1" ? UIImage(systemName: "person.fill") : UIImage(systemName: "person.2.fill")
            content.text = itemIdentifier.memoTitle
            content.secondaryText = "이 메모의 제목은 \(itemIdentifier.memoTitle)입니다."
            cell.contentConfiguration = content
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = tasks[indexPath.item]
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        return cell
    }
}
