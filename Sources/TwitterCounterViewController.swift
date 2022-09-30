//
//  TwitterCounterViewController.swift
//  TwitterCounterProject
//
//  Created by Moataz Akram on 27/09/2022.
//

import UIKit
import TwitterAPIKit
import AuthenticationServices

class TwitterCounterViewController: UIViewController {
    @IBOutlet weak var characterCountsStack: UIStackView!
    @IBOutlet weak var countTypedTitle: UILabel!
    @IBOutlet weak var countRemainingTitle: UILabel!
    @IBOutlet weak var typedCount: UILabel!
    @IBOutlet weak var remainingCount: UILabel!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var copyTextButton: UIButton!
    @IBOutlet weak var clearTextButton: UIButton!
    @IBOutlet weak var postTweetButton: UIButton!
    
    let viewModel = TwitterCounterViewModel()
    
    let placeHolderText = "Start typing! You can enter up to 280 characters"
    
    var client: TwitterAPIClient?
    var token: TwitterAuthenticationMethod.OAuth20?
    
    let consumerKey = "EOhRvxTAJkaWUE3tqWH3QvBrF"
    let consumerSecret = "Kg7KiHts2kigiWDiBlAD4pXf0RueT54dG3O5JInlUHGoTfSwv4"
    var oauthToken = "1211128639263141888-CcxBOEgohfw29jFixBh3WqvJ7I26Td"
    var oauthTokenSecret = "F3l8vXL0Lo5wL28KwJkhiHKvW2RzeGwNOlJTRQgpHsf6W"
    
    let clientId = "MFNNRy1YOWtoQkdVTTNBOFUtY0g6MTpjaQ"
    let clientSecert = "gu4mHHhUUjOIqqhgXO8mYmLWuReqyuFR8Z5f3os8W8sKSiWx5M"

    var characterCount: Int {
        (self.textField.text as NSString).length
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.controller = self
        viewModel.auth1(sessionProvider: self)
        textField.delegate = self
        setupUI()
        // Do any additional setup after loading the view.
        addKeyboardDismissHandler()
    }
    
    func setupUI() {
        typedCount.text = "0/280"
        remainingCount.text = "280"
        textField.text = placeHolderText
        textField.textColor = .placeholderText

        countTypedTitle.backgroundColor = .cyan
        countRemainingTitle.backgroundColor = .cyan
        countTypedTitle.roundUpperCorners(cornerRadius: 6)
        countRemainingTitle.roundUpperCorners(cornerRadius: 6)

        copyTextButton.layer.cornerRadius = 6
        clearTextButton.layer.cornerRadius = 6
        postTweetButton.layer.cornerRadius = 6
        textField.layer.cornerRadius = 6

        characterCountsStack.subviews.forEach{ view in
            view.layer.cornerRadius = 6
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.cyan.cgColor
        }
        
    }

    @IBAction func copyTextDidPress(_ sender: Any) {
        UIPasteboard.general.string = textField.text
    }
    
    @IBAction func clearTextDidPress(_ sender: Any) {
        textField.text = ""
        textViewDidEndEditing(textField)
    }
    
    @IBAction func postTweetDidPress(_ sender: Any) {
        postTweet()
    }
}

extension TwitterCounterViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeHolderText {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = placeHolderText
            textField.textColor = .placeholderText
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textField == textView {
            if textField.text == placeHolderText {
                typedCount.text = "0/280"
                remainingCount.text = "280"
                textField.textColor = .placeholderText
                return
            }
            textField.textColor = .label
            textField.layer.opacity = 1
            typedCount.text = "\(characterCount)/280"
            remainingCount.text = "\(280 - characterCount)"
        } else { return }
    }
}

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
}





//extension TwitterCounterViewController {
//
//    func setupTwitterSession() {
//        client = TwitterAPIClient(.oauth20(.init(
//                    clientID: clientId,
//                    scope: ["tweet.read", "tweet.write", "users.read", "offline.access"],
//                    tokenType: "bearer",
//                    expiresIn: 7200,
//                    accessToken: oauthTokenSecret,
//                    refreshToken: ""
//                )))
//        client?.refreshOAuth20Token(type: .publicClient, forceRefresh: true) { [weak self] result in
//            print("result: \(result)")
//            do {
//                let refresh = try result.get()
//                if refresh.refreshed {
//                    self?.storeToken(refresh.token)
//                }
//            } catch {
//
//            }
//        }
//
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(didRefreshOAuth20Token(_:)),
//            name: TwitterAPIClient.didRefreshOAuth20Token,
//            object: nil
//        )
//
//    }
//
//    func storeToken(_ token2: TwitterAuthenticationMethod.OAuth20) {
//        token = token2
//    }
//
//    @objc func didRefreshOAuth20Token(_ notification: Notification) {
//        guard let token = notification.userInfo?[TwitterAPIClient.tokenUserInfoKey] as? TwitterAuthenticationMethod.OAuth20 else {
//            fatalError()
//        }
//        print("didRefreshOAuth20Token", didRefreshOAuth20Token, token)
//        storeToken(token)
//    }
//
//}

