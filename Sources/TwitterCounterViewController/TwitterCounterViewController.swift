//
//  TwitterCounterViewController.swift
//  TwitterCounterProject
//
//  Created by Moataz Akram on 27/09/2022.
//

import UIKit
import AuthenticationServices
import RxSwift

public class TwitterCounterViewController: UIViewController {
    @IBOutlet weak var characterCountsStack: UIStackView!
    @IBOutlet weak var countTypedTitle: UILabel!
    @IBOutlet weak var countRemainingTitle: UILabel!
    @IBOutlet weak var typedCount: UILabel!
    @IBOutlet weak var remainingCount: UILabel!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var copyTextButton: UIButton!
    @IBOutlet weak var clearTextButton: UIButton!
    @IBOutlet weak var postTweetButton: UIButton!
    
    let viewModel: TwitterCounterViewModel
    private let disposeBag = DisposeBag()
    
    let placeHolderText = "Start typing! You can enter up to 280 characters"
    
    var characterCount: Int {
        (self.textField.text as NSString).length
    }
    
    public init(appURL: String) {
        viewModel = TwitterCounterViewModel(oauthCallback: appURL)
        super.init(nibName: String(describing: "\(TwitterCounterViewController.self)"), bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        addKeyboardDismissHandler()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    
    func setupViewModel() {
        viewModel.authenticateTwitter(sessionProvider: self)
        
        viewModel.alretMessage.subscribe { [weak self] event in
            guard let self = self else { return }
            let alertTitle = event.element?.title
            let alertMessage = event.element?.message
            self.showAlert(title: alertTitle, message: alertMessage)
        }.disposed(by: disposeBag)
    }
    
    func setupUI() {
        textField.layer.cornerRadius = 10
        textField.delegate = self
        textField.text = placeHolderText
        textField.textColor = .placeholderText
        textField.addingShadow()

        typedCount.text = "0/280"
        remainingCount.text = "280"
        countTypedTitle.backgroundColor = .systemTeal
        countRemainingTitle.backgroundColor = .systemTeal
        countTypedTitle.roundUpperCorners(cornerRadius: 10)
        countRemainingTitle.roundUpperCorners(cornerRadius: 10)
        characterCountsStack.subviews.forEach{ view in
            view.layer.cornerRadius = 10
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.systemTeal.cgColor
        }

        copyTextButton.layer.cornerRadius = 10
        clearTextButton.layer.cornerRadius = 10
        postTweetButton.layer.cornerRadius = 10
        copyTextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        clearTextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        postTweetButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)

    }

    @IBAction func copyTextDidPress(_ sender: Any) {
        UIPasteboard.general.string = textField.text
    }
    
    @IBAction func clearTextDidPress(_ sender: Any) {
        textField.text = ""
        textViewDidEndEditing(textField)
        typedCount.text = "0/280"
        remainingCount.text = "280"
    }
    
    @IBAction func postTweetDidPress(_ sender: Any) {
        viewModel.postTweet(tweet: textField.text)
    }
    
}

extension TwitterCounterViewController: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeHolderText {
            textView.text = ""
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = placeHolderText
            textField.textColor = .placeholderText
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
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

extension TwitterCounterViewController: ASWebAuthenticationPresentationContextProviding {
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
}
