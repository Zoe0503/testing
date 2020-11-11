//
//  BaseViewController.swift
//  BubblePop
//
//  Created by Radhika on 12/05/20.
//  Copyright © 2020 Radhika. All rights reserved.
//

import UIKit

//This is the base view controller class, responsible for providing general functions like displaying alerts, loaders and toast messages.
class BaseViewController: UIViewController {
    
    var loaderOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

let loaderTag = 12313435

extension BaseViewController{
    
    //MARK:- UIAlert Controller handler
    
    func showAlert(message: String?) {
        showAlert(title: gameAlertTitle, message: message)
    }
    
    func showAlert(title: String?, message: String?) {
        showAlert(title: title, message: message, actionTitle: msgOk)
    }
    
    func showAlert(title: String?, message: String?, actionTitle: String?) {
        let action = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        let alert = createAlert(title: title, message: message, actions: [action])
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(message: String?, completion: (()->Void)?) {
        let action = UIAlertAction(title: msgOk, style: .default) { (alertAction) in
            if let completion = completion {
                completion()
            }
        }
        let alert = createAlert(title: gameAlertTitle, message: message, actions: [action])
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlertWithTwoOptions(
        message:String?,
        title: String?,
        postiveOption: String? = msgOk,
        negativeOption: String? = msgCancel,
        completion: ((_ isPositive: Bool )-> Void)?) {
        let useAction = UIAlertAction(title: postiveOption, style: .default) { (alertAction) in
            if let completion = completion {
                completion(true)
            }
        }
        let cancelAction = UIAlertAction(title: negativeOption, style: .default) { (alertAction) in
            if let completion = completion {
                completion(false)
            }
        }
        let alert = createAlert(title: title, message: message, actions: [useAction, cancelAction])
        self.present(alert, animated: true, completion: nil)
    }
    
    func createAlert(title: String?, message: String?, actions: [UIAlertAction]) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        
        return alert
    }
    
    //MARK:- Loaders
    
    func showLoader(timeOut: TimeInterval = Double(kDefaultTimeOutInterval))
    {
        hideLoader()
        
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = false
            let activity = UIActivityIndicatorView(style: .large)
            activity.color = .black
            activity.tag = loaderTag
            activity.frame = CGRect(origin: self.view.center, size: CGSize(width: 0, height: 0))
            self.view.addSubview(activity)
            activity.startAnimating()
            self.loaderOn = true
            self.perform(#selector(self.hideLoader), with: nil, afterDelay: timeOut)
        }
    }
    
    @objc func hideLoader() {
        DispatchQueue.main.async {
            if let activity = self.view.viewWithTag(loaderTag) {
                self.loaderOn = false
                self.view.isUserInteractionEnabled = true
                activity.removeFromSuperview()
            }
        }
    }
}
