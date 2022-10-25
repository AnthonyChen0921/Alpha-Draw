//
//  User.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/23/22.
//

import UIKit

class User: Encodable {
    var id: String?
    var name: String?
    var email: String?
    var password: String?
    var balance: Double?

    init(id: String, name: String, email: String, password: String, balance: Double) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.balance = balance
    }
}
