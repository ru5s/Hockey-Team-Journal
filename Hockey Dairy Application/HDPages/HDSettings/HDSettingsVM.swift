//
//  HDSettingsVM.swift
//  Hockey Team Journal
//
//  Created by Den on 06/03/24.
//

import StoreKit
import SwiftUI

class HDSettingsVM: ObservableObject {
    func rateApp() {
        DispatchQueue.main.async {
            let scene = UIApplication.shared.connectedScenes.first(where: {$0.activationState == .foregroundActive})
            SKStoreReviewController.requestReview(in: scene as! UIWindowScene)
        }
        
    }
    
    func sharedApp() {
        DispatchQueue.main.async {
            let appStoreURL = URL(string: "https://apps.apple.com")!
            let activityViewController = UIActivityViewController(activityItems: [appStoreURL], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = UIApplication.shared.windows.first
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY / 2, width: 0, height: 0)
            UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
        }
    }
}

