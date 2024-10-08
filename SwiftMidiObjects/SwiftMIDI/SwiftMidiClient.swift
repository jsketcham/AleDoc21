//
//  MidiClient.swift
//  MtcReader
//
//  Created by Jim on 3/3/22.
//  copied from http://mattg411.com/coremidi-swift-programming/

import Cocoa
import CoreMIDI
import Foundation
import SwiftUI

let PORT_NOT_OPEN = 0

let INPUT_KEY = "Input"
let OUTPUT_KEY = "Output"
let MIDI_KEY = "MIDI"
let OFF_KEY = "Off"

//enum MENU_TYPE{
//case IN_ONLY,OUT_ONLY,IN_AND_OUT
//}

struct WordBytes{
    // a struct useful in handling word tuples
    var first : UInt8
    var second : UInt8
    var third : UInt8
    var fourth : UInt8
}

@objc protocol SwiftMidiClientDelegate{
    func processBytes(_ bytes : [UInt8])
    @objc optional func inputsChanged(_ inputNames : [String])
    @objc optional func outputsChanged(_ outputNames : [String])
    @objc optional func didSelectInput(_ input : String)
    @objc optional func didSelectOutput(_ output : String)
}

@objc class SwiftMidiClient: NSObject {
    
    var client : MIDIClientRef = 0
    var packet_list = MIDIPacketList()
    var inPort : MIDIPortRef = 0
    var outPort : MIDIPortRef = 0
    var source : MIDIEndpointRef = 0
//    var dest : MIDIEndpointRef = 0
    var destArray = Array<MIDIEndpointRef>()    // there may be multiple outputs
    var title : String?
    var defaultsInKey : String?
    var defaultsOutKey : String?
    var delegate : SwiftMidiClientDelegate?
    @objc var inputNames = [String](){
        didSet{
            
            delegate?.inputsChanged?(inputNames)
            
        }
    }
    @objc var outputNames = [String](){
        didSet{
            
            delegate?.outputsChanged?(outputNames)
            
        }
    }

    init(_ title : String,_ delegate : SwiftMidiClientDelegate, _ menuType : MENU_TYPE){
        
        super.init()
        
//        print("MidiClient init")    // 3 instances, that is our problem
        
        // add MIDI menu items
        if let mainMenu = NSApp.mainMenu{
            
            if mainMenu.item(withTitle: MIDI_KEY) == nil{
                
                let midiMenuItem = NSMenuItem(); midiMenuItem.title = MIDI_KEY
                midiMenuItem.submenu = NSMenu(title: MIDI_KEY)
                mainMenu.insertItem(midiMenuItem, at: mainMenu.numberOfItems - 1)
                
            }
            
            if mainMenu.item(withTitle: MIDI_KEY)?.submenu == nil{
                mainMenu.item(withTitle: MIDI_KEY)!.submenu = NSMenu(title: MIDI_KEY)
            }
            
            if mainMenu.item(withTitle: MIDI_KEY)!.submenu?.item(withTitle: title) == nil{
                
                // add in,out menus
                let menu = NSMenu(title: title)
                menu.addItem(withTitle: INPUT_KEY, action: nil, keyEquivalent: "")
                menu.addItem(withTitle: OUTPUT_KEY, action: nil, keyEquivalent: "")
//                outItem.toolTip = "for multiple outputs, hold OPTION key when selecting"
                
                let menuItem = NSMenuItem(title: title, action: nil, keyEquivalent: "")
                
                menuItem.submenu = menu
                
                mainMenu.item(withTitle: MIDI_KEY)!.submenu?.addItem(menuItem)

            }
         }
        
        self.title = title
        self.delegate = delegate
        
        outPort = MIDIPortRef(PORT_NOT_OPEN)
        inPort = MIDIPortRef(PORT_NOT_OPEN)
        
        defaultsInKey = self.title! + "_" + INPUT_KEY
        defaultsOutKey = self.title! + "_" + OUTPUT_KEY
        
        let defaults = UserDefaults.standard
        let registrationDefaults = [defaultsInKey! : "", defaultsOutKey! : ""]
        defaults.register(defaults: registrationDefaults)

        MIDIClientCreateWithBlock(self.title! as CFString, &client, {(_ message : (UnsafePointer<MIDINotification>)) -> Void in
            
            // add or remove menu items
            self.initMenuItems()
            
        })
        
        if menuType != .IN_ONLY{
            
            MIDIOutputPortCreate(client,defaultsOutKey! as CFString,&outPort)
            
        }
        
        if menuType != .OUT_ONLY{
            
//            // we aren't handling MIDIEventList properly, gave up, used deprecated MIDIInputPortCreate()
//            let midiReceiveBlock : MIDIReceiveBlock = {(_ evtlist : (UnsafePointer<MIDIEventList>),_ srcConnRefCon : (Optional<UnsafeMutableRawPointer>)) -> Void in
//
//                // https://itnext.io/midi-listener-in-swift-b6e5fb277406
//
//                let midiEventList: MIDIEventList = evtlist.pointee
//                var packet = midiEventList.packet
//
//                print("numPackets \(midiEventList.numPackets)")
//
//                var midiBytes = [UInt8]()
//
//                (0 ..< midiEventList.numPackets).forEach { _ in // hooray, hooray
//                    // this receiver expects mtc in small packets
//                    if packet.wordCount > 0 && packet.wordCount <= 64{
//
//                        let numBytes = Int(packet.wordCount * 4)
//
//                        var midiWords = [UInt32](repeating: 0, count: Int(packet.wordCount))
//                        memcpy(&midiWords[0],&packet.words.0,  numBytes)
//
//                        for midiWord in midiWords{
//
//                            print("midiword \(String(format: "%08x", midiWord))")
//
//                            let wordBytes = WordBytes(first: UInt8(0xff & (midiWord >> 24)),
//                                                      second: UInt8(0xff & (midiWord >> 16)),
//                                                      third: UInt8(0xff & (midiWord >> 8)),
//                                                      fourth: UInt8(0xff & midiWord))
//
//                            midiBytes.append(wordBytes.first)
//                            midiBytes.append(wordBytes.second)
//                            midiBytes.append(wordBytes.third)
//                            midiBytes.append(wordBytes.fourth)
//                        }
//
//
//                    }
//
//                    packet = MIDIEventPacketNext(&packet).pointee
//                }
//
//                if midiBytes.count > 0{self.delegate?.processBytes(midiBytes)}
//            }

            if #available(macOS 11.0, *) {
                
            //https://developer.apple.com/forums/thread/100527
            // Unmanaged.passUnretained(self).toOpaque()

                // we can't get MIDIInputPortCreateWithProtocol to work, use the deprecated method
                MIDIInputPortCreate(client,//_ client: MIDIClientRef,
                                    defaultsInKey! as CFString,// _ portName: CFString,
                                    SwiftMidiClient.readProc,//   _ readProc: MIDIReadProc,
                                    Unmanaged.passUnretained(self).toOpaque(),//   _ refCon: UnsafeMutableRawPointer?,
                                    &inPort)//   _ outPort: UnsafeMutablePointer<MIDIPortRef>) -> OSStatus

//                MIDIInputPortCreateWithProtocol(client, defaultsInKey! as CFString, MIDIProtocolID._1_0, &inPort, midiReceiveBlock )
            } else {
                // Fallback on earlier versions
                print("can't initialize MIDI input, needs MACOS 11.0 or greater")
            }
            
        }
        
        initMenuItems()
    }

    static let notifyProc : MIDINotifyProc = {(_notification : UnsafePointer<MIDINotification>, _ refCon : UnsafeMutableRawPointer?) -> Void in
        
        let midiClient: SwiftMidiClient? = Unmanaged.fromOpaque(refCon!).takeUnretainedValue()
        
        DispatchQueue.main.async { [] in
            midiClient?.initMenuItems()
        }

    }
        
    static let readProc : MIDIReadProc = {(_ pktList : UnsafePointer<MIDIPacketList>,
                                    _ readProcRefCon : UnsafeMutableRawPointer?,
                                    _ srcConnRefCon : UnsafeMutableRawPointer?) -> Void in
        
        // copying what works in Objective C, although MIDIInputPortCreate() is deprecated
        
        //https://developer.apple.com/forums/thread/80420?answerId=238250022#238250022
        // https://developer.apple.com/documentation/swift/unmanaged/fromopaque(_:)
        let midiClient: SwiftMidiClient = Unmanaged.fromOpaque(readProcRefCon!).takeUnretainedValue()
        
//        print("readProc \(midiClient.title ?? "no title")")   // we are getting 2 readProcs for one transmit

        var packet : (MIDIPacket) = pktList.pointee.packet
        
        for _ in 0..<pktList.pointee.numPackets{
            
            // 11/5/23 we saw a crash with large packets
            if Int(packet.length) == 0 || Int(packet.length) > 0x400{
                continue
            }

            var buffer = [UInt8](repeating: 0, count: Int(packet.length))
            memcpy(&buffer[0],&packet.data.0,Int(packet.length))
            
            DispatchQueue.main.async { [] in
//                print("\(buffer)")
                midiClient.delegate?.processBytes(buffer)
            }
            
            packet = MIDIPacketNext(&packet).pointee
            
        }
    }
    
    
    @objc func inputAction(_ sender: Any){
        
        let menuItem = sender as! NSMenuItem
        
        for item in menuItem.menu!.items{
            
            item.state = .off   // all off
            
        }
        
        menuItem.state = .on    // selected item on

        selectInput(menuItem.title)
        
    }
    @objc func outputAction(_ sender: Any){
        
        let flags = NSEvent.modifierFlags
        let menuItem = sender as! NSMenuItem
        var outputArray = [String]()
        
        menuItem.menu!.items[0].state = .off    // set OFF_KEY to off
        
//        print("\(menuItem.title)")
        
        if flags.contains(.option) && menuItem.title != OFF_KEY{
            
            menuItem.state = menuItem.state == .off ? .on : .off // toggle
            
            for item in menuItem.menu!.items{
                
                if item.state == .on{
                    
                    outputArray.append(item.title)
                    
                }
            }
                        
            if outputArray.count == 0{
                outputArray.append(OFF_KEY)
            }
            
        }else{
            
            // interlock
            for item in menuItem.menu!.items{
                
                item.state = .off   // all off
            }
            
            menuItem.state = .on    // selected item on
            outputArray.append(menuItem.title)
            
        }
        
        selectOutput(outputArray.joined(separator: "\t"))

    }


    func initMenuItems(){
        
        var newItem : NSMenuItem?
        
        let midiMenu = NSApp.mainMenu?.item(withTitle: MIDI_KEY)?.submenu
        let menuItem = midiMenu?.item(withTitle: title!)
        let menu = menuItem?.submenu
        let inItem = menu?.item(withTitle: INPUT_KEY)
        let outItem = menu?.item(withTitle: OUTPUT_KEY)
        
        let inMenu = NSMenu(title: INPUT_KEY)
        let outMenu = NSMenu(title: OUTPUT_KEY)
        
        let inName = UserDefaults.standard.string(forKey: defaultsInKey!)
        let outName = UserDefaults.standard.string(forKey: defaultsOutKey!)
        let outNameArray = outName?.components(separatedBy: "\t")   // multiple outputs

        inputNames = getSourceNames()
        outputNames = getDestinationNames()
        
        for name in inputNames{
            
            newItem = NSMenuItem(title: name, action: #selector(inputAction(_ :)), keyEquivalent: "")
            newItem?.target = self;
            newItem?.onStateImage = NSImage.init(named: "NSMenuRadio")
            
            if name == inName {newItem?.state = .on}
            
            inMenu.addItem(newItem!)
        }
        
        for name in outputNames{
            
            newItem = NSMenuItem(title: name, action: #selector(outputAction(_ :)), keyEquivalent: "")
            newItem?.target = self;
            newItem?.onStateImage = NSImage.init(named: "NSMenuRadio")
            
            if let _ = outNameArray?.firstIndex(of: name){
                newItem?.state = .on
            }

            outMenu.addItem(newItem!)
        }
        
        inItem?.submenu = inMenu
        outItem?.submenu = outMenu
        inItem?.isEnabled = inPort != PORT_NOT_OPEN
        outItem?.isEnabled = outPort != PORT_NOT_OPEN

        // select input and output, needs to be after menus are installed
        selectInput(inName)
        selectOutput(outName)

    }
    // http://mattg411.com/coremidi-swift-programming/
    func getDisplayName(_ obj: MIDIObjectRef) -> String
    {
        var param: Unmanaged<CFString>?
        var name: String = "Error"
        
        let err: OSStatus = MIDIObjectGetStringProperty(obj, kMIDIPropertyDisplayName, &param)
        if err == OSStatus(noErr)
        {
            name =  (param!.takeRetainedValue() as String).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        
        return name
    }
    func getSourceNames() -> [String]
    {
        var names:[String] = [OFF_KEY];
        
        let count: Int = MIDIGetNumberOfSources();
        for i in 0..<count {
            let endpoint:MIDIEndpointRef = MIDIGetSource(i);
            if (endpoint != 0)
            {
                names.append(getDisplayName(endpoint));
            }
        }
        return names;
    }
    func getDestinationNames() -> [String]
    {
        var names:[String] = [OFF_KEY];
        
        let count: Int = MIDIGetNumberOfDestinations();
        for i in 0..<count {
            let endpoint:MIDIEndpointRef = MIDIGetDestination(i);
            
            if (endpoint != 0)
            {
                names.append(getDisplayName(endpoint));
            }
        }
        return names;
    }
    func selectInput(_ input : String?){
        
        if input == nil{
            print("selectInput(), input is nil")
            return
        }
        
        if MIDIPortDisconnectSource(inPort,source) != 0{
            print("failed to disconnect previous source")
        }
        
        source = 0
        
        UserDefaults.standard.set(input!.isEmpty ? OFF_KEY : input, forKey: defaultsInKey!)
        
        let count: Int = MIDIGetNumberOfSources();
        for i in 0..<count {
            let endpoint:MIDIEndpointRef = MIDIGetSource(i);
            if (endpoint != 0 && (getDisplayName(endpoint) == input))
            {
                source = endpoint
                if MIDIPortConnectSource(inPort,source,nil) != 0{
                    print("MIDI Input: \(input ?? "INPUT MISSING") did not connect!")
                }else{
                    
//                    outputOff(input) // no feedback
                    delegate?.didSelectInput?(input!)
                }
                break
                
                
            }
        }
    }
    func outputOff(_ output : String?){
        // no feedback
        let midiMenu = NSApp.mainMenu?.item(withTitle: MIDI_KEY)?.submenu
        let menuItem = midiMenu?.item(withTitle: title!)
        let menu = menuItem?.submenu
        let item = menu?.item(withTitle: OUTPUT_KEY)
        
        var outNameArray = [String]()
        
        if let outMenu = item?.submenu{
            
            outMenu.items[0].state = .off   // OFF item
            
            for item in outMenu.items{
                
                if item.title == output{
                    
                    item.state = .off
                    break
                    
                }
                
            }
            
            for item in outMenu.items{
                
                if item.state == .on{
                    outNameArray.append(item.title)
                }
            }
            
            if outNameArray.count == 0{
                
                outMenu.items[0].state = .on    // OFF item
                outNameArray.append(OFF_KEY)
                
            }
            
            selectOutput(outNameArray.joined(separator: "\t"))
        }

    }
    func inputOff(_ input : String?){
        // no feedback
        let midiMenu = NSApp.mainMenu?.item(withTitle: MIDI_KEY)?.submenu
        let menuItem = midiMenu?.item(withTitle: title!)
        let menu = menuItem?.submenu
        let item = menu?.item(withTitle: INPUT_KEY)
        
        if let inMenu = item?.submenu{
            
            for item in inMenu.items{
                
                if item.title == input{
                    
                    if item.state == .on{
                        
                        item.state = .off
                        inMenu.items[0].state = .on // OFF item
                        
                        if MIDIPortDisconnectSource(inPort,source) != 0{
                            print("inputOff failed to disconnect previous source")
                        }else{
                            source = 0
                            print("inputOff disconnected previous source \(item.title)")
                        }

                    }
                    
                    return
                }
            }
        }
    }
    func selectOutput(_ output : String?){
        
        if output == nil{
            return
        }
        print("selectOutput \(output ?? "missing")")
        
        UserDefaults.standard.set(output!.isEmpty ? OFF_KEY : output, forKey: defaultsOutKey!)

        destArray.removeAll()   // array of out endpoints
        
        for item in output!.components(separatedBy: "\t"){
            
            let count: Int = MIDIGetNumberOfDestinations();
            for i in 0..<count {
                
                let endpoint:MIDIEndpointRef = MIDIGetDestination(i);
                
                // strings are trimmed in getDisplayName()
                let displayName = getDisplayName(endpoint)
                
//                print("\(displayName) \(displayName.count) \(item) \(item.count)")
                if (endpoint != 0 && (displayName == item))
                {
                    destArray.append(endpoint)
                    // disable 'no feedback' interlock for now
//                    inputOff(displayName)    // no feedback
                    break   // next item
                }
            }
        }
        
        delegate?.didSelectOutput?(output!)  // all outputs, separated by tabs
    }
    let twiHeader : [UInt8] = [SYSTEM_EXCLUSIVE,0,0,1,3,2,1]
    let eox : [UInt8] = [MIDI_EOX]
    
    @objc func midiTxString(_ str : String){
        
        let data = NSMutableData(bytes: twiHeader, length: twiHeader.count)
        let strData = convert78(str.data(using: String.Encoding.utf8)! as NSData)
        data.append(strData as Data)
        data.append(eox, length: eox.count)
        
        midiTx(data)
        
    }
    func convert78(_ data : NSData) -> NSData{
        
        // to transmit utf8, we encode 7 bytes to 8 bytes.
        // the 7 top bits are in [0], the bottom bits are in [1-7]
        
        let len = data.count
        var len78 = len + len / 7; if len78 % 8 != 0{len78 += 1}
        var buffer = [UInt8](repeating: 0, count: len)
        var buffer78 = [UInt8](repeating: 0, count: len78)
        data.getBytes(&buffer[0], length: len)
        
        var j = -8
        
        for i in 0..<len{
            
            if i % 7 == 0 {j += 8; buffer78[j] = 0}
            
            if buffer[i] & 0x80 == 0x80 {buffer78[j] |= 0x80}
            buffer78[j] >>= 1
            buffer78[j + 1 + (i % 7)] = buffer[i] & 0x7f
            
        }
        
        // handle case of odd length last record
        if len % 7 != 0{
            buffer78[j] >>= (7 - len % 7)
        }
        
        return NSData(bytes: buffer78, length: buffer78.count)
    }
//    @objc func midiTx(_ data : NSData){
//        
////        if self.title == "Remote"{
////            
////            print("Remote")
////        }
//        
//        // there may be multiple outputs
//        for dest in destArray{
//            
//            if dest == 0{
//                continue  // no output
//            }
//                    
//            var txBytes = [UInt8](repeating: 0, count: data.count)
//            data.getBytes(&txBytes[0], length: data.count)
//                    
//            if outPort == PORT_NOT_OPEN{
//                print("PORT_NOT_OPEN")
//                return
//            }
//            
//            var packet = MIDIPacketListInit (&packet_list);
//            
//            packet = MIDIPacketListAdd (&packet_list,
//                                        MemoryLayout.size(ofValue:packet_list),
//                                        packet,
//                                        0,  // timestamp
//                                        txBytes.count,
//                                        txBytes);
//            
//            MIDIFlushOutput(dest);
//            
//            MIDISend (
//                      outPort,
//                      dest,
//                      &packet_list
//                      );
//        }
//
//        
//    }
    @objc func midiTx(_ data : NSData){
                
        guard data.length > 0 && outPort != PORT_NOT_OPEN else{
            return
        }
        
        //var packet_list = MIDIPacketList()

        // there may be multiple outputs
        for dest in destArray{
            
            midiTx(data, dest)
            
        }
    }
    
    func midiTx(_ data : NSData, _ dest : MIDIEndpointRef){
        
        guard dest != 0 else{
            return
        }
        
        // Cancels sending packets that were previously scheduled for future delivery
        MIDIFlushOutput(dest);

        // send <256 byte packets, then remainder

        var packet_list = MIDIPacketList()
        var packet = MIDIPacketListInit (&packet_list)
        
        var txBytes = [UInt8](repeating: 0, count: data.count)
        data.getBytes(&txBytes[0], length: data.count)

        for i in 0..<txBytes.count{
            
            var txByte = txBytes[i]
            
            // packet.data is a 256 byte tuple
            // break packets on message boundaries (like MIDIEventPacket)
            // sysex, here, sends remainder so we have an empty buffer for sysex
            if txByte & 0x80 == 0x80 && packet.pointee.length > 250
                || txByte == SYSTEM_EXCLUSIVE && packet.pointee.length > 0{
                
                MIDISend (
                          outPort,
                          dest,
                          &packet_list
                          );
                
                packet = MIDIPacketListInit (&packet_list)
           }
            
            packet = MIDIPacketListAdd (&packet_list,
                                        MemoryLayout<MIDIPacketList>.size,
                                        packet,
                                        0,  // timestamp
                                        1,
                                        &txByte);
            
            // end-of-message or MIDI_EOX sends what is in the buffer
            if i == txBytes.count - 1 || txByte == MIDI_EOX{
                
                MIDISend (
                          outPort,
                          dest,
                          &packet_list
                          );
                
                packet = MIDIPacketListInit (&packet_list)
            }
        }
    }

}
