//
//  UIViewController+Extension.swift
//  MemoApp_Assessment
//
//  Created by Mac Pro 15 on 2022/10/10.
//

import UIKit

extension UIViewController {
    func showAlertForTrailingSwipe(title: String, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .destructive) { ok in
            completionHandler() //completionHandler() 꼭 해줘야함. 없으면 외부에서 메서드실행안됨.
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
}
