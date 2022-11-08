//
//  User.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/23/22.
//

import UIKit

class User: Encodable {
    // basic user info
    var id: String?
    var name: String?
    var email: String?
    var balance: Double?
    var pfp: String?
    var date_created: String?

    // metadata
    var is_admin = false
    var is_banned = false
    var is_premium = false
    var is_email_verified = false

    // permissions
    var permissions: [String?] = []

    // token
    var token: String = "null"


    init (id: String?, name: String?, email: String?, balance: Double?, pfp: String?, date_created: String?) {
        self.id = id
        self.name = name
        self.email = email
        self.balance = balance
        self.pfp = pfp
        self.date_created = date_created
    }

    // createa user dictionary
    func toDict() -> [String: Any] {
        return [
            "id": self.id!,
            "name": self.name!,
            "email": self.email!,
            "balance": self.balance!,
            "pfp": self.pfp!,
            "date_created": self.date_created!,
            "is_admin": self.is_admin,
            "is_banned": self.is_banned,
            "is_premium": self.is_premium,
            "is_email_verified": self.is_email_verified,
            "permissions": self.permissions,
            "token": self.token
        ]
    }
        

}
