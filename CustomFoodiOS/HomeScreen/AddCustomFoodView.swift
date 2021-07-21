//
//  AddCustomFoodView.swift
//  CustomFood (iOS)
//
//  Created by fabiola ramirez on 7/13/21.
//

import SwiftUI
import ComposableArchitecture
//import Combine

struct AddCustomFoodView: View {
    
    let store: Store<FoodsState, FoodsAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        
                        VStack(alignment: .leading) {
                            Text("FOOD NAME")
                                .bold()
                                .padding()
                            TextField("Enter a name", text: viewStore.binding(get: \.currentFoodName, send: FoodsAction.foodNameChanged))
                                .foregroundColor(viewStore.isFoodNameValid ? .black : .red)
                                .font(Font.system(size: 34, weight: .bold, design: .default))
                                .disableAutocorrection(true)
                                .textContentType(.name)
                                .keyboardType(.default)
                                .autocapitalization(.sentences)
                                .padding(.horizontal)
                            Divider()
                            Text(viewStore.isFoodNameValidMessage)
                                .font(.footnote)
                                .foregroundColor(viewStore.isFoodNameValid ? .black : .red)
                                .padding([.bottom, .horizontal])
                            
                        }
                        
                        VStack(alignment: .leading) {
                            Text("CARBS (g)")
                                .bold()
                                .padding()
                            TextField("0 g", text: viewStore.binding(get: \.currentCarbs, send: FoodsAction.carbsChanged))
                                .foregroundColor(.black)
                                .font(Font.system(size: 34, weight: .bold, design: .default))
                                .disableAutocorrection(true)
                                .keyboardType(.decimalPad)
                                .autocapitalization(.none)
                                .padding(.horizontal)
                            Divider()
                        }
                        
                        
                    }
                }
                
                saveCustomFoodButton(with: viewStore)
            }
            .navigationBarTitle(
                Text(!viewStore.state.isEditMode ? "Add Custom Food" : "Edit Custom Food"), displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                viewStore.send(.showFoodForm(false))
            })
            .edgesIgnoringSafeArea(.leading)
            .navigationBarBackButtonHidden(true)
        }.onTapGesture {
            self.hideKeyboard()
        }
    }
    
    private func saveCustomFoodButton(with viewStore: ViewStore<FoodsState, FoodsAction>) -> some View {
        Button("Save to Custom Foods") {
            if !viewStore.isEditMode {
                let food = CustomFood(name: viewStore.currentFoodName, carbs: Int(viewStore.currentCarbs) ?? 0)
                viewStore.send(.addFood(food))
            } else {
                viewStore.send(.updateFood(viewStore.currentFoodName, viewStore.currentCarbs, viewStore.indexFoodSelected!))
            }
        }
        .buttonStyle(AutoPrimaryButtonStyle(disabled: !viewStore.isFoodNameValid))
        .padding([.horizontal, .bottom])
        .disabled(!viewStore.isFoodNameValid)
    }
}
