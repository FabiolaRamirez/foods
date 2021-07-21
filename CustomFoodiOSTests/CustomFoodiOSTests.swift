//
//  CustomFoodiOSTests.swift
//  CustomFoodiOSTests
//
//  Created by fabiola ramirez on 7/19/21.
//

import XCTest
import ComposableArchitecture
@testable import CustomFoodiOS

class CustomFoodiOSTests: XCTestCase {
    
    let scheduler = DispatchQueue.test
    
    func testAddFood() {
        
        let store = TestStore(
            initialState: FoodsState(),
            reducer: foodsReducer,
            environment: FoodsEnvironment(mainQueue: self.scheduler.eraseToAnyScheduler())
        )
        var food = CustomFood(name: "Apple", carbs: 4)
        food.id = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
        
        store.assert(
            .send(.showAddMode) {
                $0.isEditMode = false
            },
            .receive(.showFoodForm(true)) {
                $0.isShowingFormScreen = true
            },
            .send(.addFood(food)) {
                $0.foods = [food]
            },
            .receive(.showFoodForm(false)) {
                $0.isShowingFormScreen = false
            }
        )
    }
    
    func testEditFood() {
        let banana = CustomFood(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, name: "Banana", carbs: 3)
        let apple = CustomFood(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, name: "Apple", carbs: 5)
        let rice = CustomFood(id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!, name: "Rice", carbs: 3)
        let state = FoodsState(
            foods: [banana, apple, rice]
        )
        
        let store = TestStore(
            initialState: state,
            reducer: foodsReducer,
            environment: FoodsEnvironment(mainQueue: self.scheduler.eraseToAnyScheduler())
        )
    
        let foodSelected = state.foods.first!
        let newFood = CustomFood(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, name: "Banana2", carbs: 6, createdDate: foodSelected.createdDate)
        let indexSelected = 0
        
        store.assert(
            .send(.selectFood(foodSelected, indexSelected)) {
                $0.currentFoodName = foodSelected.name
                $0.currentCarbs = String(foodSelected.carbs)
                $0.foodSelected = foodSelected
                $0.indexFoodSelected = indexSelected
            },
            .receive(.showEditMode) {
                $0.isEditMode = true
            },
            .receive(.showFoodForm(true)) {
                $0.isShowingFormScreen = true
            },
            .send(.updateFood("Banana2", "6", indexSelected)) {
                $0.foods = [newFood, apple, rice]
            },
            .receive(.showFoodForm(false)) {
                $0.isShowingFormScreen = false
                $0.foods = [newFood, apple, rice]
            }
        )
    }
    
    func testDeleteFood() {
        let banana = CustomFood(name: "Banana", carbs: 3)
        let apple = CustomFood(name: "Apple", carbs: 5)
        let rice = CustomFood(name: "Rice", carbs: 3)
        let state = FoodsState(
            foods: [banana, apple, rice]
        )
        
        let store = TestStore(
            initialState: state,
            reducer: foodsReducer,
            environment: FoodsEnvironment(mainQueue: self.scheduler.eraseToAnyScheduler())
        )
        let indexSet: IndexSet = [1]
        
        store.assert(
            .send(.deleteFood(indexSet)) {
                $0.foods.remove(atOffsets: indexSet)
                $0.foods = [banana, rice]
            }
        )
    }
    
    func testSortByAlphabetical() {
        let banana = CustomFood(name: "Banana", carbs: 3)
        let apple = CustomFood(name: "Apple", carbs: 5)
        let rice = CustomFood(name: "Rice", carbs: 3)
        let state = FoodsState(
            foods: [banana, apple, rice]
        )
        
        let store = TestStore(
            initialState: state,
            reducer: foodsReducer,
            environment: FoodsEnvironment(mainQueue: self.scheduler.eraseToAnyScheduler())
        )
        let sortMode = SortMode.alphabetical
        store.assert(
            .send(.sortBy(sortMode)) {
                $0.foods = [apple, banana, rice]
            },
            .receive(.showSortOptions(false)) {
                $0.isShowingSortOptions = false
            }
        )
    }
    
    func testSortByRecentlyAdded() {
        var banana = CustomFood(name: "Banana", carbs: 3)
        banana.createdDate = Date(timeIntervalSince1970: 1626755053) // July 20
        var apple = CustomFood(name: "Apple", carbs: 5)
        apple.createdDate = Date(timeIntervalSince1970: 1626668653) // July 19
        var rice = CustomFood(name: "Rice", carbs: 3)
        rice.createdDate = Date(timeIntervalSince1970: 1626582253) // July 18
        
        let state = FoodsState(
            foods: [apple, rice, banana]
        )
        
        let store = TestStore(
            initialState: state,
            reducer: foodsReducer,
            environment: FoodsEnvironment(mainQueue: self.scheduler.eraseToAnyScheduler())
        )
        let sortMode = SortMode.recently
        store.assert(
            .send(.sortBy(sortMode)) {
                $0.foods = [banana, apple, rice]
            },
            .receive(.showSortOptions(false)) {
                $0.isShowingSortOptions = false
            }
        )
    }
    
    func testSortByHighestToLowest() {
        let banana = CustomFood(name: "Banana", carbs: 2)
        let apple = CustomFood(name: "Apple", carbs: 5)
        let rice = CustomFood(name: "Rice", carbs: 3)
        let state = FoodsState(
            foods: [banana, apple, rice]
        )
        
        let store = TestStore(
            initialState: state,
            reducer: foodsReducer,
            environment: FoodsEnvironment(mainQueue: self.scheduler.eraseToAnyScheduler())
        )
        let sortMode = SortMode.highestToLowest
        store.assert(
            .send(.sortBy(sortMode)) {
                $0.foods = [apple, rice, banana]
            },
            .receive(.showSortOptions(false)) {
                $0.isShowingSortOptions = false
            }
        )
    }
    
    func testSortByLowestToHighest() {
        let banana = CustomFood(name: "Banana", carbs: 2)
        let apple = CustomFood(name: "Apple", carbs: 5)
        let rice = CustomFood(name: "Rice", carbs: 3)
        let state = FoodsState(
            foods: [banana, apple, rice]
        )
        
        let store = TestStore(
            initialState: state,
            reducer: foodsReducer,
            environment: FoodsEnvironment(mainQueue: self.scheduler.eraseToAnyScheduler())
        )
        let sortMode = SortMode.lowestToHighest
        store.assert(
            .send(.sortBy(sortMode)) {
                $0.foods = [banana, rice, apple]
            },
            .receive(.showSortOptions(false)) {
                $0.isShowingSortOptions = false
            }
        )
    }
    
    
}
