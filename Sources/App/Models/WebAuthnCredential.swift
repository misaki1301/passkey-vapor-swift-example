//
//  File.swift
//  
//
//  Created by Paul Frank on 14/06/24.
//

import Fluent
import Vapor
import WebAuthn

final class WebAuthnCredential: Model, Content {
	
	static let schema = "webAuthn_Credentials"
	
	@ID(custom: "id", generatedBy: .user)
	var id: String?
	
	@Field(key: "public_key")
	var publicKey: String
	
	@Field(key: "current_signCount")
	var currentSignCount: Int32
	
	@Parent(key: "user_id")
	var user: User
	
	init(id: String? = nil, publicKey: String, currentSignCount: Int32, user: UUID) {
		self.id = id
		self.publicKey = publicKey
		self.currentSignCount = currentSignCount
		self.$user.id = user
	}
	
	init() {}
	
	convenience init(from credential: Credential, userID: UUID) {
		self.init(
			id: credential.id,
			publicKey: credential.publicKey.base64URLEncodedString().asString(),
			currentSignCount: Int32(credential.signCount),
			user: userID)
	}
}
