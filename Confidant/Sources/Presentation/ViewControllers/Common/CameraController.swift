//
//  CameraController.swift
//  Confidant
//
//  Created by Michael Douglas on 17/08/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//


import UIKit
import RSKImageCropper

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

typealias CameraCompletion = (_ image: UIImage?) -> Void

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

class CameraController : UIImagePickerController {

//**************************************************
// MARK: - Properties
//**************************************************

	fileprivate var completion: CameraCompletion?
	fileprivate var strongSelf: Any?
	
//**************************************************
// MARK: - Constructors
//**************************************************
	
//**************************************************
// MARK: - Protected Methods
//**************************************************

//**************************************************
// MARK: - Exposed Methods
//**************************************************

	/**
	Starts an image picker immediately.
	
	- parameters:
		- target: The target view controller in which the image picker will be presented.
		- sourceType: The image picker source type.
		- delegate: The delegate target responsible for handling the image picker events.
		- canEdit: Defines if the image picker media will be editable or not by the user.
	*/
	func present(at target: UIViewController,
	             sourceType: UIImagePickerControllerSourceType,
	             delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate & RSKImageCropViewControllerDelegate)?,
	             canEdit: Bool = true) {
		
		if UIImagePickerController.isSourceTypeAvailable(sourceType) {
			self.sourceType = sourceType
			self.delegate = delegate
			target.present(self, animated: true, completion: nil)
		}
	}
	
	/**
	Shows an action sheet to present the options to the user and then starts the image picker.
	This routine does not require any delegate, it will send back the result on a completion closure.
	
	This routine will retain the current instance temporarily during the photo selection process,
	once it's asynchronous and entirely controlled by the user. Otherwise, this instance would go away
	right after the actionSheet completion.
	
	- parameters:
		- target: The target view controller in which the image picker will be presented.
		- options: An array containing the source types.
		- remove: Wheter the remove buttons should appear or not.
		- completion: The completion closure, which will receive back the user's selected image.
	*/
	func presentOptions(at target: UIViewController,
	                    options: [UIImagePickerControllerSourceType],
	                    remove: Bool,
	                    completion: CameraCompletion?) {
		let actionSheet = UIAlertController(title: nil,
		                                    message: String.Local.pictureSource,
		                                    preferredStyle: .actionSheet)
		actionSheet.popoverPresentationController?.sourceView = target.view
		
		for item in options {
			
			if !UIImagePickerController.isSourceTypeAvailable(item) {
				continue
			}
			
			let title: String
			
			switch item {
			case .camera:
				title = String.Local.takePhoto
			case .savedPhotosAlbum:
				fallthrough
			case .photoLibrary:
				title = String.Local.choosePhoto
			}
			
			let action = UIAlertAction(title: title, style: .default) { (alert : UIAlertAction) in
				self.present(at: target, sourceType: item, delegate: self)
			}
			
			actionSheet.addAction(action)
		}
		
		if remove {
			let text = String.Local.deletePhoto
			let delete = UIAlertAction(title: text, style: .destructive) { (alert : UIAlertAction) in
				DispatchQueue.main.async {
					self.completion?(nil)
					self.strongSelf = nil
				}
			}
			
			actionSheet.addAction(delete)
		}
		
		let cancel = UIAlertAction(title: String.Local.cancel, style: .cancel)
		actionSheet.addAction(cancel)
		
		target.present(actionSheet, animated: true, completion: nil)
		self.completion = completion
		self.strongSelf = self
	}
	
//**************************************************
// MARK: - Overridden Methods
//**************************************************
}

//**********************************************************************************************************
//
// MARK: - Extension - UIImagePickerControllerDelegate, UINavigationControllerDelegate
//
//**********************************************************************************************************

extension CameraController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true, completion: nil)
		
		DispatchQueue.main.async {
			self.completion?(nil)
			self.strongSelf = nil
		}
	}
	
	func imagePickerController(_ picker: UIImagePickerController,
	                           didFinishPickingMediaWithInfo info: [String : Any]) {
		var selectedImage: UIImage?
		
		selectedImage = selectedImage ?? info[UIImagePickerControllerOriginalImage] as? UIImage
		
		let imageCropVC = RSKImageCropViewController(image: selectedImage ?? UIImage(), cropMode: RSKImageCropMode.circle)
		imageCropVC.delegate = self
		imageCropVC.modalTransitionStyle = .crossDissolve
		
		self.present(imageCropVC, animated: true)
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - RSKImageCropViewControllerDelegate
//
//**********************************************************************************************************

extension CameraController : RSKImageCropViewControllerDelegate {

	func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
		controller.dismiss(animated: true)
		
		DispatchQueue.main.async {
			self.completion?(nil)
			self.strongSelf = nil
		}
	}
	
	func imageCropViewController(_ controller: RSKImageCropViewController,
	                             didCropImage croppedImage: UIImage,
	                             usingCropRect cropRect: CGRect) {
		controller.dismiss(animated: true)
		self.dismiss(animated: true)
		
		DispatchQueue.main.async {
			self.completion?(croppedImage)
			self.strongSelf = nil
		}
	}
}
