//
//  ViewController.swift
//  UnderLineTextField-Example
//
//  Created by Mohammad Ali Jafarian on 10/17/17.
//  Copyright © 2017 Mohammad Ali Jafarian. All rights reserved.
//

import UIKit
import UnderLineTextField

class ViewController: UIViewController {
   
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var normalTextField: UnderLineTextField!
    @IBOutlet weak var prefilledTextfield: UnderLineTextField!
    @IBOutlet weak var bigFontTextfield: UnderLineTextField!
    @IBOutlet weak var clearButtonTextfield: UnderLineTextField!
    @IBOutlet weak var complainTextfield: UnderLineTextField!
    
    
    @IBOutlet var formFields: [UnderLineTextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formFields.forEach({ $0.delegate = self })
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(self.keyboardNotification(notification:)),
                         name: NSNotification.Name.UIKeyboardWillChangeFrame,
                         object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ViewController: UnderLineTextFieldDelegate {
    
    func textFieldValidate(underLineTextField: UnderLineTextField) throws {
        if underLineTextField == complainTextfield {
            underLineTextField.status = .error(message: "I will allways complain no mater what")
            throw FormValidationError.noReason
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case normalTextField:
            prefilledTextfield.becomeFirstResponder()
        case prefilledTextfield:
            bigFontTextfield.becomeFirstResponder()
        case bigFontTextfield:
            clearButtonTextfield.becomeFirstResponder()
        case clearButtonTextfield:
            complainTextfield.becomeFirstResponder()
        case complainTextfield:
            prefilledTextfield.becomeFirstResponder()
        default:
            break
        }
        return false
    }
    
}

@objc extension ViewController {
    func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.scrollViewBottomConstraint?.constant = 0.0
            } else {
                self.scrollViewBottomConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
}


enum FormValidationError: Error {
    case noReason
}
