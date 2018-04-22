import Vapor

extension Droplet {
    func setupRoutes() throws {
        get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }

        get("exp") { req in
            let id = req.query?["id"]?.int ?? 0
            let experience = try Experience.find(id)
            if let json = try experience?.makeJSON() {
                return json
            } else {
                return "Error"
            }
        }

        get("createfake") { req in
            let experience = Experience()
            try? experience.save()
            let identifier = experience.id ?? Identifier.null
            let itemA = Item(message: "Hey A", imageURL: "aa", ownerId: identifier)
            let itemB = Item(message: "Hey B", imageURL: "bb", ownerId: identifier)
            let itemC = Item(message: "Hey C", imageURL: "cc", ownerId: identifier)
            do {
                try itemA.save()
                try itemB.save()
                try itemC.save()
            }
            catch {
                print("something is wrong")
            }
            return "fake id \(identifier.string)"
        }

    }
}
