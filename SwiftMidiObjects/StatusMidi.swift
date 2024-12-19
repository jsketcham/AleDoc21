//
//  StatusMidi.swift
//  AleDoc21
//
//  Created by Pro Tools on 9/8/23.
//

import Cocoa

class StatusMidi: NSObject {
    
    var swiftMidi : SwiftMidi?

    override init() {
        super.init()
        
        swiftMidi = SwiftMidi(self, "Status", .IN_AND_OUT);
        swiftMidi?.oscDelegate = NSApp.delegate as? any SwiftMidiOscDelegate;

    }
    @objc func midiTx(_ data : NSData){
        
        swiftMidi?.midiClient?.midiTx(data)
        
    }
}
// MARK: ---------- SwiftMidiDelegate ----------------
extension StatusMidi :SwiftMidiDelegate{
    
    @objc func noteOnService(_ midi : [UInt8], _ sender : SwiftMidi){
        
        if midi[1] == 110{
            // streamer 1 trigger, a VM15 command, ignoring the color table
            
            if let aleDelegate = NSApp.delegate as? AleDelegate{
                
                aleDelegate.triggerStreamer()
            }
        }        
    }
    @objc func controlChangeService(_ midi : [UInt8], _ sender : SwiftMidi){
        //12/19/24
        
        guard let aleDelegate = NSApp.delegate as? AleDelegate else{
            return
        }
        switch midi[0]{
        case 176:
            
            switch(midi[1]){

            case 0:

                aleDelegate.foleyClipCapture()

                break
                
            case 1:
                
                if midi[2] < 3{
                    
                    aleDelegate.matrixWindowController.rehRecPb = Int32(midi[2])

                }
                
                break
                
            case 2:
                
                aleDelegate.cycleButton()
                
                break
                    
            default: 
                break
            }
            
            break
        default: break
        }
    }
}

