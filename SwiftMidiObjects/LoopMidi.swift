//
//  LoopMidi.swift
//  AleDoc21
//
//  Created by Pro Tools on 9/8/23.
//
/*
 Just to be clear. 4 additional MIDI slots in the pull down menu. Each with a selectable input and output. Names. Mic Preamp 1 Send. Mic Preamp 1 Return. Mic Preamp 2 Send. Mic Preamp 2 Return. Each one just sends midi data from its input to its output.
 */

import Cocoa

class LoopMidi: NSObject {
    
    var swiftMidi : SwiftMidi?
    var swiftMidi2 : SwiftMidi?
    var swiftMidi3 : SwiftMidi?
    var swiftMidi4 : SwiftMidi?
    var swiftMidi5 : SwiftMidi?
    var swiftMidi6 : SwiftMidi?
    var swiftMidi7 : SwiftMidi?
    var swiftMidi8 : SwiftMidi?

    
    override init() {
        super.init()
        
        swiftMidi = SwiftMidi(self, "Mic Preamp 1 Send", .IN_AND_OUT); swiftMidi?.loopInToOut = true
        swiftMidi2 = SwiftMidi(self, "Mic Preamp 1 Return", .IN_AND_OUT); swiftMidi2?.loopInToOut = true
        swiftMidi3 = SwiftMidi(self, "Mic Preamp 2 Send", .IN_AND_OUT); swiftMidi3?.loopInToOut = true
        swiftMidi4 = SwiftMidi(self, "Mic Preamp 2 Return", .IN_AND_OUT); swiftMidi4?.loopInToOut = true
        
        // 07/24/25
        swiftMidi5 = SwiftMidi(self, "Mic Preamp 3 Send", .IN_AND_OUT); swiftMidi5?.loopInToOut = true
        swiftMidi6 = SwiftMidi(self, "Mic Preamp 3 Return", .IN_AND_OUT); swiftMidi6?.loopInToOut = true
        swiftMidi7 = SwiftMidi(self, "Mic Preamp 4 Send", .IN_AND_OUT); swiftMidi7?.loopInToOut = true
        swiftMidi8 = SwiftMidi(self, "Mic Preamp 4 Return", .IN_AND_OUT); swiftMidi8?.loopInToOut = true


    }

}
// MARK: ---------- SwiftMidiDelegate ----------------
extension LoopMidi :SwiftMidiDelegate{
    
}
