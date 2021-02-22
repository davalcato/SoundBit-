//
//  AuthViewController.swift
//  SoundBit
//
//  Created by Daval Cato on 2/20/21.
//

import UIKit
import WebKit

class AuthViewController: UIViewController, WKNavigationDelegate {
    
    private let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        
        return webView
        
    }()
    
    // Here letting the WelcomeViewController the user has signed in successfully
    public var completionHandler: ((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = .systemBackground
        // shows when the page get loaded
        webView.navigationDelegate = self
        view.addSubview(webView)
        guard let url = AuthManager.shared.signInURL else {
            return
        }
        
        webView.load(URLRequest(url: url))
                
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // Get the URL that is starting to load
        guard let url = webView.url else {
            
            return
        }
        // If the URL has a perimeter for code Exchange the code for access token
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == "code" })?.value else {
            return
        }
        webView.isHidden = true
        
        print("Code: \(code)")
        AuthManager.shared.exchangeCodeForToken(code: code) { [weak self] success in
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
                self?.completionHandler?(success)
            }
        }
    }
}
