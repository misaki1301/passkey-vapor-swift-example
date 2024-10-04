//
//  CreateWebAuthn.swift
//  
//
//  Created by Paul Frank on 14/06/24.
//

import Fluent

struct CreateWebAuthn: AsyncMigration {
	func prepare(on database: any FluentKit.Database) async throws {
		try await database.schema("webAuthn_Credentials")
			.field("id", .string, .identifier(auto: false))
			.field("public_key", .string, .required)
			.field("current_signCount", .uint32, .required)
			.field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
			.unique(on: "id")
			.create()
	}
	
	func revert(on database: any Database) async throws {
		try await database.schema("webAuthn_Credentials")
			.delete()
	}
}
