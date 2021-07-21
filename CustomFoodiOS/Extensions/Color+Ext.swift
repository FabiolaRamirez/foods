//
//  Color+Ext.swift
//  CustomFood (iOS)
//
//  Created by fabiola ramirez on 7/13/21.
//

import SwiftUI

internal extension Color {
    
    private static func getColorForBundle(_ color: String) -> Color {
        return Color(color, bundle: Bundle(identifier: "insulet.CustomFoodiOS")!)
    }
    
  
    static let autoPrimary: Color = getColorForBundle("AutoPrimary")
    static let autoPrimaryDisabled: Color = getColorForBundle("AutoPrimaryDisabled")

    //System colors
    static let systemBackground: Color = Color(UIColor.systemBackground)
    
}

