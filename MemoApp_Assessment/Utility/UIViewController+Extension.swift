//
//  UIViewController+Extension.swift
//  MemoApp_Assessment
//
//  Created by Mac Pro 15 on 2022/10/10.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .destructive) { ok in
            print(#function)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}
