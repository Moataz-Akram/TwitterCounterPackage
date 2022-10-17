//
//  TwitterCounterViewModel.swift
//  TwitterCounterProject
//
//  Created by Moataz Akram on 30/09/2022.
//

import Foundation
import RxSwift
import Reachability
import TwitterAPIKit
import AuthenticationServices

class TwitterCounterViewModel {
    var client: TwitterAPIClient?
    var token: TwitterAuthenticationMethod.OAuth20?
    var alretMessage = PublishSubject<(title: String, message: String)>()

    let consumerKey = "ZLauxf6o574LAdVkESupoCxc5"
    let consumerSecret = "hOKZdijHlJXXtCjanFKuXy6yrqwq2n2SAFJ2hq5rPibZ6YoV4w"
    let oauthToken = "1211128639263141888-fxov9NblIFPNbmDpEXf5mZeNguZ3af"
    let oauthTokenSecret = "xhpVASUZcgHllRu0C3JCdQUgdB91KzNOPXHJxWT5LD2ZT"

    /**
     It's the app's URL added in the project Target in info section.
     Should be same as the project URL added in Twitter developer portal when getting auth keys & tokens.
     */
    let oauthCallback: String
    
    init(oauthCallback: String) {
        self.oauthCallback = oauthCallback
        client = TwitterAPIClient(
                    consumerKey: consumerKey,
                    consumerSecret: consumerSecret,
                    oauthToken: oauthToken,
                    oauthTokenSecret: oauthTokenSecret
                )
    }
    
    func authenticateTwitter(sessionProvider: ASWebAuthenticationPresentationContextProviding) {
        
        client?.auth.oauth10a.postOAuthRequestToken(.init(oauthCallback: oauthCallback))
            .responseObject { [weak self] response in
                guard let self = self else { return }
                do {
                    let success = try response.result.get()
                    let url = self.client?.auth.oauth10a.makeOAuthAuthorizeURL(.init(oauthToken: success.oauthToken))
                    guard let url = url else { return }
                    let session = ASWebAuthenticationSession(url: url, callbackURLScheme: "twitter-api-kit-ios-sample") { [weak self] url, error in
                        guard let self = self else { return }
                            if let error = error {
                                self.client = nil
                                self.alretMessage.onNext((title: "Error", message: error.localizedDescription))
                                return
                            }
                        guard let url = url else { return }

                        let component = URLComponents(url: url, resolvingAgainstBaseURL: false)
                        guard let oauthToken = component?.queryItems?.first(where: { $0.name == "oauth_token"} )?.value,
                              let oauthVerifier = component?.queryItems?.first(where: { $0.name == "oauth_verifier"})?.value else {
                            self.client = nil
                            self.alretMessage.onNext((title: "Error", message: "Invalid URL"))
                            return
                        }
                        self.client?.auth.oauth10a.postOAuthAccessToken(.init(oauthToken: oauthToken, oauthVerifier: oauthVerifier))
                            .responseObject { response in
                                switch response.result {
                                case .success(_):
                                    let token = try? response.result.get()
                                    self.client = TwitterAPIClient(
                                        consumerKey: self.consumerKey,
                                        consumerSecret: self.consumerSecret,
                                        oauthToken: token?.oauthToken ?? "",
                                        oauthTokenSecret: token?.oauthTokenSecret ?? ""
                                    )
                                    self.alretMessage.onNext((title: "Success!", message: "authenticated successfully"))
                                case .failure(_):
                                    self.client = nil
                                    self.alretMessage.onNext((title: "Error", message: "error in verifying authorization"))
                                }
                            }
                    }
                    session.presentationContextProvider = sessionProvider
                    session.prefersEphemeralWebBrowserSession = true

                    session.start()

                } catch {
                    self.alretMessage.onNext((title: "Error", message: error.localizedDescription))
                }
            }
        
    }
    
    func postTweet(tweet: String) {
        guard let client = client else {
            alretMessage.onNext((title: "error", message: "there's no authentication with the server"))
            return
        }
        if checkInternetConnection() {
            DispatchQueue.global(qos: .background).async { [weak self, client] in
                guard let self = self else { return }

                let getTweetsRequest = GetTweetsRequestV2(ids: ["1575687922229051393"])
                let postTweet = PostTweetsRequestV2(text: tweet)
                let response = client.session.send(postTweet)
                response.responseObject { response in
                    switch response.result {
                    case .success(_):
                        print("response: \(response.prettyString)")
                        self.alretMessage.onNext((title: "success", message: "tweeted successfully!"))
                    case .failure(_):
                        self.alretMessage.onNext((title: "error", message: "failed tweeting"))
                    }
                }
            }
        } else {
            alretMessage.onNext((title: "error", message: "error in internet connection"))
        }
    }
    
    func checkInternetConnection() -> Bool {
        do {
            let reachability = try Reachability()
            switch reachability.connection {
                case .wifi, .cellular:
                    print("connected")
                return true
                default:
                    print("no connection")
                return false
            }
        } catch {
            return false
        }
    }

    func calculateTweetLength(text: String) -> Int {
        TweetValidator.shared.calculateTweetLength(text: text)
    }
}
