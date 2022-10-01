//
//  UIViewController.swift
//  TwitterCounterProject
//
//  Created by Moataz Akram on 01/10/2022.
//

import UIKit
import AuthenticationServices

extension UIViewController {
    /// Adds *UITapGestureRecognizer* to current UIViewController's view to dismiss presented keyboard.
    public func addKeyboardDismissHandler() {
        let tap: UITapGestureRecognizer =
        UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard)
        )
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    /// Dismisses keyboard presented on the current UIViewController.
    @objc public func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlert(title: String?, message: String?, tapOK block: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default) { _ in
            block?()
        })
        present(alert, animated: true)
    }
}

extension TwitterCounterViewController: ASWebAuthenticationPresentationContextProviding {
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
}
