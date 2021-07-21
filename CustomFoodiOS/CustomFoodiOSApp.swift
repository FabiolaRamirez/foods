//
//  CustomFoodiOSApp.swift
//  CustomFoodiOS
//
//  Created by fabiola ramirez on 7/19/21.
//

import SwiftUI
import ComposableArchitecture

@main
struct CustomFoodiOSApp: App {
    
    let store = Store(initialState: FoodsState(), reducer: foodsReducer, environment: FoodsEnvironment(mainQueue: .main))
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                CustomFoodsListView(store: store)
            }
        }
    }
}
