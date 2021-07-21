//
//  ButtonStyles.swift
//  CustomFood (iOS)
//
//  Created by fabiola ramirez on 7/13/21.
//

import SwiftUI

struct AutoPrimaryButtonStyle: ButtonStyle {
    
    var disabled = false
    
    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .foregroundColor(Color.white)
            .padding(.vertical)
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(disabled ? Color.autoPrimaryDisabled : Color.autoPrimary)
            .cornerRadius(8)
    }
}
