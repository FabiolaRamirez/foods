//
//  CustomFoodModel.swift
//  CustomFood (iOS)
//
//  Created by fabiola ramirez on 7/13/21.
//
import SwiftUI

struct CustomFood: Identifiable, Equatable {
    var id: UUID = UUID()
    var name: String
    var carbs: Int
    var createdDate = Date()
}
