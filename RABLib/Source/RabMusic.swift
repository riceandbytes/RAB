//
//  RabMusic.swift
//  RAB
//
//  Created by visvavince on 1/6/17.
//  Copyright © 2017 Rab LLC. All rights reserved.
//

import Foundation
import AVFoundation

// Use to play sounds longer than 30s
// Use for background music, not for short sounds since a delay can occur

public class RabMusic {
    private var player: AVAudioPlayer? = nil
    
    public init() {}
    
    public func playSound(_ filename: String,
                          isRepeat: Bool = false,
                          adjustVolume: Float? = nil) {
        guard let url = pathForSound(fileName: filename) else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            if isRepeat {
                player.numberOfLoops = -1
            }
            
            if let v = adjustVolume {
                player.volume = v
            }
            
            player.prepareToPlay()
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    public func stop() {
        if player != nil {
            player?.stop()
            player = nil
        }
    }
    
    private func fixedSoundFileName(fileName: String) -> String {
        let fixedSoundFileName = fileName.trimmingCharacters(in: .whitespacesAndNewlines)
        return fixedSoundFileName
    }
    
    private func pathForSound(fileName: String) -> URL? {
        let fixedSoundFileName = self.fixedSoundFileName(fileName: fileName)
        let components = fixedSoundFileName.components(separatedBy: ".")
        return Bundle.main.url(forResource: components[0], withExtension: components[1])
    }
}
