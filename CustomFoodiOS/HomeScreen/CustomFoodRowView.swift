//
//  CustomFoodRowView.swift
//  CustomFood (iOS)
//
//  Created by fabiola ramirez on 7/13/21.
//

import SwiftUI

struct CustomFoodRowView: View {
    
    let customFood: CustomFood
    
    var body: some View {
        ZStack {
            Rectangle().fill(Color.systemBackground)
            HStack {
                Text("\(customFood.name)")
                    .foregroundColor(.black)
                Spacer()
                Text("\(customFood.carbs) g")
                    .foregroundColor(.gray)
            }
            .padding()
        }
    }
}
