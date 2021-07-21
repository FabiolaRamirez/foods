//
//  View+Ext.swift
//  CustomFood (iOS)
//
//  Created by fabiola ramirez on 7/16/21.
//

import SwiftUI


extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
