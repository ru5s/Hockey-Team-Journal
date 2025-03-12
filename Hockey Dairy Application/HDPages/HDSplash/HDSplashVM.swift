//
//  HDSplashVM.swift
//  Hockey Team Journal
//
//  
//

import Foundation

class HDSplashVM: ObservableObject {
    @Published var progressBar: HDProgressBarModel = .start
    @Published var isPresented: Bool = false
    @Published var openTabview: Bool = false
    @Published var mainAnswer: Bool?
    
    private var timer: Double = 0.0
    
    private func seenOnboard() {
        let defaults = UserDefaults.standard
//        defaults.setValue(false, forKey: "seen onboard")
        let bool = defaults.bool(forKey: "seen onboard")
        if bool == true {
            openTabview.toggle()
        } else {
            isPresented.toggle()
        }
    }
    func starTtimer() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { time in
            if self.timer <= 0.9 {
                self.timer += 0.1
                if self.timer == 0.3 {
                    self.progressBar = .firstQuarter
                }
                if self.timer == 0.5 {
                    self.progressBar = .half
                }
                if self.timer == 0.7 {
                    self.progressBar = .thirdQuarter
                }
            } else {
                self.progressBar = .full
                time.invalidate()
                self.seenOnboard()
            }
        }
    }
}
