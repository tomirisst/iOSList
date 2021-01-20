//
//  ToDoItem.swift
//  lecture3DemoSimpleApp
//
//  Created by admin on 08.01.2021.
//

import Foundation

public struct ToDoItem: Codable{
    let id: Int?
    var title: String?
    var deadLine: String?
}
