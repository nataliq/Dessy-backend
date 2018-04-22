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

    static let idType: IdentifierType = .uuid

    var items: Children<Experience, Item> {
        return children()
    }

    struct Keys {
        static let id = "id"
        static let items = "items"
    }

    /// Creates a new Post
    init() {
    }

    // MARK: Fluent Serialization

    /// Initializes the Post from the
    /// database row
    init(row: Row) throws {
    }

    // Serializes the Post to the database
    func makeRow() throws -> Row {
        let row = Row()
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
        )
    }

    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Experience.Keys.id, id)
        try json.set(Experience.Keys.items, try items.all())
        return json
    }
}

// MARK: HTTP

// This allows Experience models to be returned
// directly in route closures
extension Experience: ResponseRepresentable { }

