//
//  User.swift
//
//
//  Created by Paul Frank on 14/06/24.
//

import Fluent
import Vapor
import WebAuthn

final class User: Model, Content {
	
	static let schema = "users"
	
	@ID(key: .id)
	var id: UUID?
	
	@Field(key: "username")
	var username: String
	
	@Field(key: "password_hash")
	var passwordHash: String?
	
	@Timestamp(key: "created_at", on: .create)
	var createdAt: Date?
	
	@Children(for: \.$user)
	var credentials: [WebAuthnCredential]
	
	init() {}
	
	init(id: UUID? = nil, username: String, passwordHash: String? = nil, createdAt: Date? = nil) {
		self.id = id
		self.username = username
		self.passwordHash = passwordHash
		self.createdAt = createdAt
	}
}

extension User {
	var webAuthnUser: PublicKeyCredentialUserEntity {
		PublicKeyCredentialUserEntity(id: [UInt8](id!.uuidString.utf8), name: username, displayName: username)
	}
}

extension User: ModelSessionAuthenticatable {}
