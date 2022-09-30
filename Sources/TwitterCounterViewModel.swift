//
//  TwitterCounterViewModel.swift
//  TwitterCounterProject
//
//  Created by Moataz Akram on 30/09/2022.
//

import Foundation
import TwitterAPIKit
import AuthenticationServices

class TwitterCounterViewModel {
    var client: TwitterAPIClient?
    var token: TwitterAuthenticationMethod.OAuth20?
    
    let consumerKey = "EOhRvxTAJkaWUE3tqWH3QvBrF"
    let consumerSecret = "Kg7KiHts2kigiWDiBlAD4pXf0RueT54dG3O5JInlUHGoTfSwv4"
    var oauthToken = "1211128639263141888-CcxBOEgohfw29jFixBh3WqvJ7I26Td"
    var oauthTokenSecret = "F3l8vXL0Lo5wL28KwJkhiHKvW2RzeGwNOlJTRQgpHsf6W"
    
    let clientId = "MFNNRy1YOWtoQkdVTTNBOFUtY0g6MTpjaQ"
    let clientSecert = "gu4mHHhUUjOIqqhgXO8mYmLWuReqyuFR8Z5f3os8W8sKSiWx5M"
    
    var controller: TwitterCounterViewController!
    
    // move to view model.
    func auth1(sessionProvider: ASWebAuthenticationPresentationContextProviding) {
        client = TwitterAPIClient(
                    consumerKey: consumerKey,
                    consumerSecret: consumerSecret,
                    oauthToken: oauthToken,
                    oauthTokenSecret: oauthTokenSecret
                )
        
        guard let client else { return }
        client.auth.oauth10a.postOAuthRequestToken(.init(oauthCallback: "TwitterCounterDemo://"))
            .responseObject { [weak self] response in
                guard let self = self else { return }
                do {
                    let success = try response.result.get()
                    let url = self.client?.auth.oauth10a.makeOAuthAuthorizeURL(.init(oauthToken: success.oauthToken))!

                    let session = ASWebAuthenticationSession(url: url!, callbackURLScheme: "twitter-api-kit-ios-sample") { url, error in

                        // url is "twitter-api-kit-ios-sample://?oauth_token=<string>&oauth_verifier=<string>"
                        guard let url = url else {
                            if let error = error {
                                self.controller.showAlert(title: "Error", message: error.localizedDescription)
                            }
                            return
                        }
                        
                        let component = URLComponents(url: url, resolvingAgainstBaseURL: false)
                        guard let oauthToken = component?.queryItems?.first(where: { $0.name == "oauth_token"} )?.value,
                              let oauthVerifier = component?.queryItems?.first(where: { $0.name == "oauth_verifier"})?.value else {
                            print("Invalid URL")
                            return
                        }
                        self.client?.auth.oauth10a.postOAuthAccessToken(.init(oauthToken: oauthToken, oauthVerifier: oauthVerifier))
                            .responseObject { response in
                                do {
                                    let token = try response.result.get()
                                    let oauthToken = token.oauthToken
                                    let oauthTokenSecret = token.oauthTokenSecret

                                    self.oauthToken = oauthToken
                                    self.oauthTokenSecret = oauthTokenSecret

                                    self.controller.showAlert(title: "Success!", message: nil) {
                                        self.controller.navigationController?.popViewController(animated: true)
                                    }
                                } catch {
                                    self.controller.showAlert(title: "Error", message: error.localizedDescription)
                                }
                            }
                    }
                    session.presentationContextProvider = sessionProvider
                    session.prefersEphemeralWebBrowserSession = true

                    session.start()

                } catch {
                    self.controller.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        
    }

}
