//
//  EventResponseModel.swift
//  AgendaSwiftUI
//
//  Created by Iker Rero Martínez on 27/1/23.
//

import Foundation

struct EventResponseModel: Decodable {

    let name: String?
    let date: Int?

    enum CodingKeys: String, CodingKey {
        case name
        case date
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let date = try? values.decodeIfPresent(Int.self, forKey: .date) {
            self.date = Int(date)
        } else if let date = try? values.decodeIfPresent(String.self, forKey: .date) {
            self.date = Int(date)
        } else if let _ = try? values.decodeIfPresent(Float.self, forKey: .date) {
            self.date = nil //<-- WTF!!!
        }
        else {
            self.date = try values.decodeIfPresent(Int.self, forKey: .date)
        }
        self.name = try values.decodeIfPresent(String.self, forKey: .name)
    }
}
