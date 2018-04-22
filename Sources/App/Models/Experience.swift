//
//  Experience.swift
//  DessyPackageDescription
//
//  Created by Roy Marmelstein on 2018-04-22.
//

import Vapor
import FluentProvider
import HTTP

final class Experience: Model {
    let storage = Storage()

    // MARK: Properties and database keys

    var itemUUIDS: [String]

    /// The column names for `id` and `content` in the database
    struct Keys {
        static let id = "id"
        static let itemUUIDS = "itemuuids"
    }

    /// Creates a new Post
    init(itemUUIDS: [String]) {
        self.itemUUIDS = itemUUIDS
    }

    // MARK: Fluent Serialization

    /// Initializes the Post from the
    /// database row
    init(row: Row) throws {
        itemUUIDS = try row.get(Experience.Keys.itemUUIDS)
    }

    // Serializes the Post to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Experience.Keys.itemUUIDS, itemUUIDS)
        return row
    }
}

// MARK: Fluent Preparation

extension Experience: Preparation {
    /// Prepares a table/collection in the database
    /// for storing Posts
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Experience.Keys.itemUUIDS)
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
//     - Creating a new Post (POST /Experience)
//     - Fetching a post (GET /Experience, GET /Experience/:id)
//
extension Experience: JSONConvertible {
    convenience init(json: JSON) throws {
        self.init(
            itemUUIDS: try json.get(Experience.Keys.itemUUIDS)
        )
    }

    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Experience.Keys.id, id)
        try json.set(Experience.Keys.itemUUIDS, itemUUIDS)
        return json
    }
}

// MARK: HTTP

// This allows Experience models to be returned
// directly in route closures
extension Experience: ResponseRepresentable { }

// MARK: Update

// This allows the Experience model to be updated
// dynamically by the request.
extension Experience: Updateable {
    // Updateable keys are called when `post.update(for: req)` is called.
    // Add as many updateable keys as you like here.
    public static var updateableKeys: [UpdateableKey<Experience>] {
        return [
            // If the request contains a String at key "content"
            // the setter callback will be called.
            UpdateableKey(Experience.Keys.itemUUIDS, [String].self) { experience, itemUUIDS in
                experience.itemUUIDS = itemUUIDS
            }
        ]
    }
}

