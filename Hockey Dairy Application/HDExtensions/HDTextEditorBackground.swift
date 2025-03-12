//
//  HDTextEditorBackground.swift
//  Hockey Team Journal
//
//  
//

import Foundation
import SwiftUI

extension View {
    func textEditorBackground(_ content: Color) -> some View {
        if #available(iOS 16.0, *) {
            return self.scrollContentBackground(.hidden)
                .background(content)
        } else {
            UITextView.appearance().backgroundColor = .clear
            return self.background(content)
        }
    }
}
