//
//  Item.swift
//  DessyPackageDescription
//
//  Created by Roy Marmelstein on 2018-04-22.
//

import Vapor
import FluentProvider
import HTTP

final class Item: Model {
    let storage = Storage()

    // MARK: Properties and database keys

    static let idType: IdentifierType = .uuid
    var message: String
    var imageURL: String

    struct Keys {
        static let id = "id"
        static let message = "message"
        static let imageURL = "imageURL"
    }

    /// Creates a new Post
    init(message: String, imageURL: String) {
        self.message = message
        self.imageURL = imageURL
    }

    // MARK: Fluent Serialization

    /// Initializes the Post from the
    /// database row
    init(row: Row) throws {
        message = try row.get(Item.Keys.message)
        imageURL = try row.get(Item.Keys.imageURL)
    }

    // Serializes the Post to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Item.Keys.message, message)
        try row.set(Item.Keys.imageURL, imageURL)
        return row
    }
}

// MARK: Fluent Preparation

extension Item: Preparation {
    /// Prepares a table/collection in the database
    /// for storing Posts
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Item.Keys.message)
            builder.string(Item.Keys.imageURL)
        }
    }

    /// Undoes what was done in `prepare`
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// MARK: JSON

// How the model converts from / to JSON.
// For example when:
//     - Creating a new Post (POST /Item)
//     - Fetching a post (GET /Item, GET /Item/:id)
//
extension Item: JSONConvertible {
    convenience init(json: JSON) throws {
        self.init(
            message: try json.get(Item.Keys.message),
            imageURL: try json.get(Item.Keys.imageURL)
        )
    }

    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Item.Keys.id, id)
        try json.set(Item.Keys.message, message)
        try json.set(Item.Keys.imageURL, imageURL)
        return json
    }
}

// MARK: HTTP

// This allows Item models to be returned
// directly in route closures
extension Item: ResponseRepresentable { }

// MARK: Update

// This allows the Item model to be updated
// dynamically by the request.
extension Item: Updateable {
    // Updateable keys are called when `post.update(for: req)` is called.
    // Add as many updateable keys as you like here.
    public static var updateableKeys: [UpdateableKey<Item>] {
        return [
            // If the request contains a String at key "content"
            // the setter callback will be called.
            UpdateableKey(Item.Keys.message, String.self) { item, message in
                item.message = message
            },
            UpdateableKey(Item.Keys.imageURL, String.self) { item, imageURL in
                item.imageURL = imageURL
            }
        ]
    }
}

extension Item {

    static let experienceID: Identifier

    var owner: Parent<Item, Experience> {
        return parent(id: experienceID)
    }
}
