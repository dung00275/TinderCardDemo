//  File name   : Login.swift
//
//  Author      : Dung Vu
//  Created date: 11/1/20
//  Version     : 1.00
//  --------------------------------------------------------------
//  
//  --------------------------------------------------------------

import Foundation
struct LoginInfo : Codable {
	let uuid : String?
	let username : String?
	let password : String?
	let salt : String?
	let md5 : String?
	let sha1 : String?
	let sha256 : String?

	enum CodingKeys: String, CodingKey {

		case uuid = "uuid"
		case username = "username"
		case password = "password"
		case salt = "salt"
		case md5 = "md5"
		case sha1 = "sha1"
		case sha256 = "sha256"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
		username = try values.decodeIfPresent(String.self, forKey: .username)
		password = try values.decodeIfPresent(String.self, forKey: .password)
		salt = try values.decodeIfPresent(String.self, forKey: .salt)
		md5 = try values.decodeIfPresent(String.self, forKey: .md5)
		sha1 = try values.decodeIfPresent(String.self, forKey: .sha1)
		sha256 = try values.decodeIfPresent(String.self, forKey: .sha256)
	}

}
