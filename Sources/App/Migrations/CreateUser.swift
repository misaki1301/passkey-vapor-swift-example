//
//  CreateUser.swift
//
//
//  Created by Paul Frank on 14/06/24.
//

import Foundation
import Fluent

struct CreateUser: AsyncMigration {
	func prepare(on database: any FluentKit.Database) async throws {
		try await database.schema("users")
			.id()
			.field("username", .string, .required)
			.field("password_hash", .string)
			.field("created_at", .datetime, .required)
			.unique(on: "username")
			.create()
	}
	
	func revert(on database: any Database) async throws {
		try await database.schema("users")
			.delete()
	}
	
	
}
