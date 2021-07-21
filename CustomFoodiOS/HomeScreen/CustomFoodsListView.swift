//
//  CustomeFoodsListView.swift
//  CustomFood (iOS)
//
//  Created by fabiola ramirez on 7/13/21.
//


import SwiftUI
import ComposableArchitecture

struct CustomFoodsListView: View {
    
    let store: Store<FoodsState, FoodsAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .leading) {
                if viewStore.state.foods.count > 0 {
                    customFoodList(with: viewStore)
                }
                else {
                    messageNodata(with: viewStore)
                }
                addViewersButton(with: viewStore)
                    
                    .actionSheet(isPresented: viewStore.binding(get: \.isShowingSortOptions, send: FoodsAction.showSortOptions), content: {
                        ActionSheet(title: Text("Sort Foods"), buttons: [.default(Text("Alphabetical"), action: {
                            
                            viewStore.send(.sortBy(.alphabetical))
                        }), .default(Text("Recently Added"), action: {
                            
                            viewStore.send(.sortBy(.recently))
                        }),.default(Text("Highest to Lowest"), action: {
                            
                            viewStore.send(.sortBy(.highestToLowest))
                        }), .default(Text("Lowest to Highest"), action: {
                            
                            viewStore.send(.sortBy(.lowestToHighest))
                        }), .cancel(Text("Cancel"), action: {
                            viewStore.send(.showSortOptions(false))
                        })])
                    })
                NavigationLink(destination: AddCustomFoodView(store: self.store), isActive: viewStore.binding(get: \.isShowingFormScreen, send: FoodsAction.showFoodForm)) { EmptyView() }
                
            }
            .navigationTitle("Custom Foods")
            .navigationBarItems(leading: sortButton(with: viewStore), trailing: EditButton())
            .environment(\.editMode, viewStore.binding(get: \.editMode, send: .switchEditMode))
    
        }
    }
    
    
    private func customFoodList(with viewStore: ViewStore<FoodsState, FoodsAction>) -> some View {
        List {
            ForEach(Array(viewStore.foods.enumerated()), id: \.offset) { index, customFood in
                CustomFoodRowView(customFood: customFood).onTapGesture() {
                    viewStore.send(.selectFood(customFood, index))
                }
            }
            .onDelete(perform: { indexSet in
                viewStore.send(.deleteFood(indexSet))
            })
            .onMove(perform: { indices, newOffset in
                viewStore.send(.moveFood(indices, newOffset))
            })
        }
    }
    
    private func messageNodata(with viewStore: ViewStore<FoodsState, FoodsAction>) -> some View {
        VStack {
            Text("You have not added any foods yet.\nTap Add Custom Food to get started")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal)
        }
    }
    
    private func addViewersButton(with viewStore: ViewStore<FoodsState, FoodsAction>) -> some View {
        Button("Add Custom Food") {
            viewStore.send(.showAddMode)
        }
        .buttonStyle(AutoPrimaryButtonStyle(disabled: viewStore.editMode == .active))
        .padding([.horizontal, .bottom])
        .disabled(viewStore.editMode == .active)
    }
    
    private func sortButton(with viewStore: ViewStore<FoodsState, FoodsAction>) -> some View {
        Button("Sort Foods") {
            viewStore.send(.showSortOptions(true))
        }
    }
    
    
}



