//
//  TwitterCounterController.swift
//  
//
//  Created by Moataz Akram on 25/09/2022.
//

import Foundation
import UIKit
import Reachability

public class TwitterCounterController: UIViewController {
    let reachability = try! Reachability()

    public init(){
        super.init(nibName: "TwitterCounterController", bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        setupReachability()
    }
    
    func setupReachability() {
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
        }
    }
    
    @IBAction func testReachability(_ sender: Any) {
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }

    }
}
