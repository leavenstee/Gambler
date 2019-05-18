//
//  OnboardingViewModel.swift
//  Gambler
//
//  Created by Steven Lee on 5/11/19.
//  Copyright © 2019 leavenstee llc. All rights reserved.
//

import Foundation
import UIKit
import CoreData

final public class OnboardingViewModel: NSObject {
    
    private let nouns = ["Mother", "Father", "Baby", "Child", "Toddler", "Teenager", "Grandmother", "Student", "Teacher", "Minister", "BusinessPerson", "SalesClerk", "Woman", "Man"]
    private let adjectives = ["Able", "Bad", "Best", "Better", "Big", "Certain", "Clear", "Different", "Early", "Easy", "Economic", "Federal", "Free", "Full", "Good", "Great", "Hard", "High", "Human", "Important", "International", "Large", "Late", "Little", "Local", "Long", "Low", "Major", "Military", "National", "New", "Old", "Only", "Other", "Political", "Possible", "Public", "Real", "Recent", "Right", "Small", "Social", "Special", "Strong", "Sure", "True", "Whole", "Young"]
    
    public var createAccountError : NSError?
    
    public var username: String? {
        didSet {
            guard let username = username else {
                fatalError("Username not set (shouldn't hit)")
            }
            
            createUserModel(with: username)
        }
    }
    
    public var randomUsername: String {
        get {
            guard let randomNoun = nouns.randomElement() else {
                return ""
            }
            guard let randomAdjective = adjectives.randomElement() else {
                return ""
            }
            return randomAdjective + randomNoun
        }
    }
    
    private func createUserModel(with username: String) {
        // Generate User Model for this device
        let appDelegate = UIApplication.shared.delegate as! AppDelegate // Move this Core Data Stuff to a core Singleton
        let context = appDelegate.persistentContainer.viewContext
        guard let userEntity = NSEntityDescription.entity(forEntityName: "User", in: context) else { return }
        let user = User(entity: userEntity, insertInto: context)
        user.currentPoints = 0.0
        user.totalPoints = 0.0
        user.username = username
        user.uuid = UUID.init()
        
        do {
            try context.save()
        } catch let error as NSError {
            createAccountError = error
        }
    }
}
