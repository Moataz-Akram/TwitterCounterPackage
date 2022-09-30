//
//  TwitterCounterViewController+TwitterConfiguration.swift
//  TwitterCounterProject
//
//  Created by Moataz Akram on 28/09/2022.
//

import AuthenticationServices
import Foundation
import TwitterAPIKit

extension TwitterCounterViewController {
    func postTweet() {
        DispatchQueue.global(qos: .background).async {
            let getTweetsRequest = GetTweetsRequestV2(ids: ["1575687922229051393"])
            let response = self.viewModel.client!.session.send(getTweetsRequest)
            response.responseObject { result in
                print("result object: \(result)")
                print("result object pretty string: \(result.prettyString)")
                print("result object result: \(result.result)")
            }
        }
    }
}

extension TwitterCounterViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
}

extension UIViewController {
    func showAlert(title: String?, message: String?, tapOK block: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default) { _ in
            block?()
        })
        present(alert, animated: true)
    }
}

extension UIView {
    public func roundUpperCorners(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}
