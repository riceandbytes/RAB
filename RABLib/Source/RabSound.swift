//
//  RabSound.swift
//  RAB
//
//  Created by visvavince on 1/3/17.
//  Copyright © 2017 Rab LLC. All rights reserved.
//

/***
 Load Sound
 override func viewDidLoad() {
 super.viewDidLoad()
 
 // Load sounds into memory
 RabSound.sharedManager.prepareSound("boop") // default extension is .wav
 RabSound.sharedManager.prepareSound("ding.mp3") // so other extensions you must name explicitly
 }
 
 Play preloaded sound
 // Since the sound is already loaded into memory, this will play immediately
 RabSound.sharedManager.playSound("boop")

 Remove sound
 deinit {
 // Cleanup is really simple!
 RabSound.sharedManager.removeSound("boop")
 RabSound.sharedManager.removeSound("ding.mp3")
 RabSound.sharedManager.removeSound("oops.mp3")
 
 // If you never loaded the sounds, e.g. viewDidLoad wasn't called, or submission never failed or succeeded,
 // that's ok, because these will function as no-ops
 }
 */

// ONLY FOR SHORT SOUNDS

import Foundation
//import AVFoundation
import AudioToolbox

public class RabSound {
    public class Sound {
        public var id: SystemSoundID
        public var count: Int = 1
        init(id: SystemSoundID) {
            self.id = id
        }
    }
    
    // MARK: - Constants
    private let kDefaultExtension = "wav"
    
    // MARK: - Singleton
    public static let sharedManager = RabSound()
    
    // MARK: - Private Variables
    public private(set) var sounds = [String:Sound]()
    
    // MARK: - Public
    public func prepareSound(_ fileName: String) -> String? {
        let fixedSoundFileName = self.fixedSoundFileName(fileName: fileName)
        if let sound = soundForKey(key: fixedSoundFileName) {
            sound.count += 1
            return fixedSoundFileName
        }
        
        if let pathURL = pathURLForSound(fileName: fixedSoundFileName) {
            var soundID: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(pathURL, &soundID)
            let sound = Sound(id: soundID)
            sounds[fixedSoundFileName] = sound
            return fixedSoundFileName
        }
        
        return nil
    }
    
    public func playSound(_ fileName: String) {
        let fixedSoundFileName = self.fixedSoundFileName(fileName: fileName)
        if let sound = soundForKey(key: fixedSoundFileName) {
            AudioServicesPlaySystemSound(sound.id)
        }
    }
    
    public func removeSound(_ fileName: String) {
        let fixedSoundFileName = self.fixedSoundFileName(fileName: fileName)
        if let sound = soundForKey(key: fixedSoundFileName) {
            sound.count -= 1
            if sound.count <= 0 {
                AudioServicesDisposeSystemSoundID(sound.id)
                sounds.removeValue(forKey: fixedSoundFileName)
            }
        }
    }
    
    // MARK: - Private
    private func soundForKey(key: String) -> Sound? {
        return sounds[key]
    }
    
    private func fixedSoundFileName(fileName: String) -> String {
        var fixedSoundFileName = fileName.trimmingCharacters(in: .whitespacesAndNewlines)
        var soundFileComponents = fixedSoundFileName.components(separatedBy: ".")
        if soundFileComponents.count == 1 {
            fixedSoundFileName = "\(soundFileComponents[0]).\(kDefaultExtension)"
        }
        return fixedSoundFileName
    }
    
    private func pathForSound(fileName: String) -> String? {
        let fixedSoundFileName = self.fixedSoundFileName(fileName: fileName)
        let components = fixedSoundFileName.components(separatedBy: ".")
        return Bundle.main.path(forResource: components[0], ofType: components[1])
    }
    
    private func pathURLForSound(fileName: String) -> NSURL? {
        if let path = pathForSound(fileName: fileName) {
            return NSURL(fileURLWithPath: path)
        }
        return nil
    }
}
