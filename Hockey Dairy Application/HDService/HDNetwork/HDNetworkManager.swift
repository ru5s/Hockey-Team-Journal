//
//  HDNetworkManager.swift
//  Hockey Team Journal
//
//  
//

import Foundation

class HDNetworkManager {
    static let shared = HDNetworkManager()
    
    private var timer: Double = 0.0
    
    func hdEventRequest(completion: @escaping (Bool) -> Void) {
        starTtimer { state in
            completion(state)
        }
    }
    
    private func starTtimer(timerEnd: @escaping (Bool) -> Void) {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { time in
            if self.timer <= 0.9 {
                self.timer += 0.1
            } else {
                time.invalidate()
                timerEnd(true)
            }
        }
    }
}
