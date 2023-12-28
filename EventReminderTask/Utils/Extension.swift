//
//  Extension.swift
//  EventReminderTask
//
//  Created by Rizwan on 9/28/23.
//

import UIKit


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlert(title: String, msg: String){
        let alert = UIAlertController(title: title,
                                      message: msg,
                                      preferredStyle: .alert)

        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)

        

        alert.addAction(okayAction)
        self.present(alert, animated: true)
    }
    
    func showAlertWithCompletion(title: String, msg: String, completion: @escaping (UIAlertAction)->()){
        let alert = UIAlertController(title: title,
                                      message: msg,
                                      preferredStyle: .alert)

        let okayAction = UIAlertAction(title: "Cancel", style: .destructive) { action in
            completion(action)
        }

        let cancelAction = UIAlertAction(title: "Not Now", style: .cancel)

        alert.addAction(okayAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
}
