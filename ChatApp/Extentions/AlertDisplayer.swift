//
//  AlertDisplayer.swift
//  ChatApp
//
//  Created by s b on 15.05.2022.
//

import UIKit

protocol AlertDisplayer {
  func displayAlert(with title: String, message: String, actions: [UIAlertAction]?)
}

extension AlertDisplayer where Self: UITableViewController {
  func displayAlert(with title: String = "Something went completely wrong!", message: String, actions: [UIAlertAction]? = nil) {
    guard presentedViewController == nil else {
      return
    }
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    actions?.forEach { action in
      alertController.addAction(action)
    }
    let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alertController.addAction(ok)
      
    present(alertController, animated: true)
  }
}
