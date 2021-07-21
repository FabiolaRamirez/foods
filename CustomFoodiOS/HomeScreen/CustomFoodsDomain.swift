//
//  CustomFoodsDomain.swift
//  CustomFoodiOS
//
//  Created by fabiola ramirez on 7/14/21.
//

import SwiftUI
import ComposableArchitecture


enum SortMode {
    case alphabetical
    case recently
    case highestToLowest
    case lowestToHighest
}

struct FoodsState: Equatable {
    var foods: [CustomFood] = []
    var isShowingFormScreen = false
    var isEditMode = false
    var foodSelected: CustomFood?
    var indexFoodSelected: Int?
    var isShowingSortOptions = false
    var editMode = EditMode.inactive
    var currentFoodName = ""
    var currentCarbs = ""
    var maximumFoodsNumber = 20
    var isFoodNameValid: Bool { currentFoodName.count <= maximumFoodsNumber && !currentFoodName.isEmpty }
    var isFoodNameValidMessage: String {
        currentFoodName.isEmpty ? "* Enter a name" : "\(currentFoodName.count)/20 characters"
    }
}


enum FoodsAction: Equatable {
    case showFoodForm(Bool)
    case showAddMode
    case showEditMode
    case selectFood(CustomFood, Int)
    case showSortOptions(Bool)
    case deleteFood(IndexSet)
    case moveFood(IndexSet, Int)
    case addFood(CustomFood)
    case updateFood(String, String, Int)
    case sortBy(SortMode)
    case switchEditMode
    case foodNameChanged(String)
    case carbsChanged(String)
}

struct FoodsEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let foodsReducer = Reducer<FoodsState, FoodsAction, FoodsEnvironment> { state, action, environment in
    switch action {
    case let .showFoodForm(show):
        state.isShowingFormScreen = show
        return .none
    case .showAddMode:
        state.isEditMode = false
        state.currentFoodName = ""
        state.currentCarbs = ""
        return Effect(value: .showFoodForm(true))
    case .showEditMode:
        state.isEditMode = true
        return Effect(value: .showFoodForm(true))
    case let .selectFood(food, index):
        state.currentFoodName = food.name
        state.currentCarbs = String(food.carbs)
        state.foodSelected = food
        state.indexFoodSelected = index
        return Effect(value: .showEditMode)
    case let .deleteFood(indexSet):
        state.foods.remove(atOffsets: indexSet)
        return .none
    case let .moveFood(source, destination):
        state.foods.move(fromOffsets: source, toOffset: destination)
        return .none
    case let .addFood(food):
        state.foods.append(food)
        return Effect(value: .showFoodForm(false))
    case let .updateFood(currentFoodName, currentCarbs, index):
        state.foods[index].name = currentFoodName
        state.foods[index].carbs = Int(currentCarbs) ?? 0
        return Effect(value: .showFoodForm(false))
    case let .showSortOptions(show):
        state.isShowingSortOptions = show
        return .none
    case let .sortBy(sortMode):
        switch sortMode {
        case .alphabetical:
            state.foods.sort { $0.name.lowercased() < $1.name.lowercased() }
        case .recently:
            state.foods.sort { $0.createdDate > $1.createdDate }
        case .highestToLowest:
            state.foods.sort { $0.carbs > $1.carbs }
        case .lowestToHighest:
            state.foods.sort { $0.carbs < $1.carbs }
        }
        return Effect(value: .showSortOptions(false))
    case .switchEditMode:
        state.editMode = state.editMode == .active ? .inactive : .active
        return .none
    case let .foodNameChanged(foodName):
        state.currentFoodName = foodName
        return .none
    case let .carbsChanged(carbs):
        state.currentCarbs = carbs
        return .none
    }
}
