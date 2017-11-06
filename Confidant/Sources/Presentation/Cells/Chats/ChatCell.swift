//
//  ChatCell.swift
//  Confidant
//
//  Created by Michael Douglas on 01/11/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit

//**********************************************************************************************************
//
// MARK: - Constants -
//
//**********************************************************************************************************

//**********************************************************************************************************
//
// MARK: - Definitions -
//
//**********************************************************************************************************

extension CellID {
	static var chat = String(describing: ChatCell.self)
}

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

class ChatCell: UITableViewCell {
	
//*************************************************
// MARK: - Properties
//*************************************************
	
	@IBOutlet weak var profilePictureView: CircularImage!
	@IBOutlet weak var nameLabel: LocalizedLabel!
	@IBOutlet weak var timeLabel: LocalizedLabel!
	@IBOutlet weak var contentLabel: LocalizedLabel!

//*************************************************
// MARK: - Constructors
//*************************************************

//*************************************************
// MARK: - Protected Methods
//*************************************************
	
	private func downloadPicture(for media: MediaBO?, completionHandler: @escaping LogicResult) {
		
		MediaLO.downloadImage(from: media?.fileURL ?? "") { (image, result) in
			
			media?.base64 = image?.base64EncodedString(format: .jpg,
			                                           quality: 0.5)
			
			completionHandler(result)
		}
	}

//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	func updateLayout(for model: ChatBO?) {
		
		if let model = model {
			let user = UsersLO.sharedInstance.current
			
			if user.profile.typeOfUser == .user {
				self.nameLabel.text = model.confidantProfile?.nickname
				
				if let image = model.confidantProfile?.picture?.localImage {
					self.profilePictureView.image = image
				} else {
					self.profilePictureView.loadingIndicatorView(isShow: true)
					
					self.downloadPicture(for: model.confidantProfile?.picture) { (result) in
						
						switch result {
						case .success:
							if let index = user.profile.chats?.index(where: { $0.id == model.id }) {
								user.profile.chats?[index].confidantProfile?.picture = model.confidantProfile?.picture
							}
							
							self.profilePictureView.image = model.confidantProfile?.picture?.localImage
						default:
							break
						}
						self.profilePictureView.loadingIndicatorView(isShow: false)
					}
				}
			} else {
				self.nameLabel.text = model.userProfile?.nickname
				
				if let image = model.userProfile?.picture?.localImage {
					self.profilePictureView.image = image
				} else {
					self.profilePictureView.loadingIndicatorView(isShow: true)
					
					self.downloadPicture(for: model.userProfile?.picture) { (result) in
						
						switch result {
						case .success:
							if let index = user.profile.chats?.index(where: { $0.id == model.id }) {
								user.profile.chats?[index].userProfile?.picture = model.userProfile?.picture
							}

							self.profilePictureView.image = model.userProfile?.picture?.localImage
						default:
							break
						}
						self.profilePictureView.loadingIndicatorView(isShow: false)
					}
				}
			}
			
			self.timeLabel.text = Date(timeIntervalSince1970: model.updatedDate ?? 0).localizedFromNow
			self.contentLabel.text = model.messages?.last?.content
		}
	}
}
