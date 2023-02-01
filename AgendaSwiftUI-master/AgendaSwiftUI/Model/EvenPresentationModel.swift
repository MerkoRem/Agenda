//
//  EvenPresentationModel.swift
//  AgendaSwiftUI
//
//  Created by Iker Rero Martínez on 27/1/23.
//

import Foundation

struct EventPresentationModel: Identifiable {
    let id = UUID()
    let name: String
    let date: Int
}
