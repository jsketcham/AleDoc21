JsOsaDAS1.001.00bplist00�Vscript_�// to run in Terminal:
// % cd /Users/protools/Desktop/testScripts
// % osascript -l JavaScript jxaCutAndPaste.scpt foobar 1 1

ObjC.import("Foundation");
  
const args = $.NSProcessInfo.processInfo.arguments;
// from console:
// args[0..3] are filename, "/usr/bin/osascript", "-l", "JavaScript" 
// from osaScript in our program:
// @"/usr/bin/osascript,/Users/protools/Library/Scripts/jxaCutAndPaste.scpt,*1234"	0x0000600001ebbba0
//console.log("args.count",args.count);	// note 'count', Objective C-like

var argv = [];
var result = -1;	// error

if (args.count > 1){

	var startIndex = args.js[1].js == ('-l') ? 4 : 2;	// assume we are called from the command line

	//console.log('startIndex', startIndex);

	for(let i = startIndex; i < args.count; i++){
		argv.push(ObjC.unwrap(args.objectAtIndex(i)));
	}
}
//
//argv = ["a duck and a priest", "1", "2","3"];	// argv debug

// Evan, 12/06/24- if you park the cursor over a region, 
// grab the in and out point and region name as the cue name. 
// no arguments
// expect that the mouse is over the clip
// double click
// cmd-shift-R open the name dialog, get clip name
// get start/end from main counter window
// return clipName /t start /t end

  const app = Application('System Events');
  const pt = app.processes['Pro Tools'];
  
  if(pt.exists()){
	
	pt.frontmost = true;
	
	result = doubleClick();	// select the clip
	
	let startEnd = getProToolsStartEnd()	// must be done while clip is selected
	let name = getClipName()				// de-selects clip
	let trk = getEnabledTrack()
	
	//console.log("trk",trk)
	
	result = trk  + "\t" + name + "\t" + startEnd
		
	//result = getEnabledTrack() + "\t" + getClipName() + "\t" + getProToolsStartEnd()

	}

result

function doubleClick(){

	var currentApp = Application.currentApplication();
	currentApp.includeStandardAdditions = true;

	let path =  "/Applications/AleDoc21.app/Contents/Resources/cliclick"
	currentApp.doShellScript(path + ' dc:.');	// double click at current position
	//let currentPos = currentApp.doShellScript(path + ' p').split(" ").at(-1)	// get rid of leading text
	//console.log(currentPos)
	//return currentPos

}
function getEnabledTrack(){

  	const app = Application('System Events');
	const pt = app.processes['Pro Tools'];
	const currentApp = Application.currentApplication();
	currentApp.includeStandardAdditions = true;
  
  	if(pt.exists()){
	
  		pt.frontmost = true;
	
		let path =  "/Applications/AleDoc21.app/Contents/Resources/cliclick"
		let currentPos = currentApp.doShellScript(path + ' p').split(" ").at(-1)	// remove leading text
		//console.log(currentPos)

		let yPos = currentPos.split(",")[1]
		//console.log(yPos)
	
		var names = pt.windows.name()
	
		for (let i = 0; i < names.length; i++){
	
			if(names[i].startsWith('Edit:')){
				console.log("Edit:")
				
				var editWindow = pt.windows[names[i]]
			
				editWindow.actions['AXRaise'].perform()
				
				names = editWindow.groups.name()	
				
				let upCtr = -3	// skip record, composite tracks	
				
				while(names.length > 0){
				
					var last = names.pop()
					
					// 2-ADR - Audio Track 
					if (last.endsWith('Track ')){
					
						upCtr = upCtr + 1	// count up
												
						let frame = editWindow.groups[last].attributes["AXFrame"].value()
						//console.log("frame: ",frame, "top", frame[1], "bottom",frame[3],"yPos",yPos)
						if(yPos >= frame[1] && yPos <= frame[3]){
						//console.log("track found: ", last)
						return upCtr // return count up from the bottom track
						}

					}
				}
			}
		}
	}

return -1

}
function getProToolsStartEnd(){

  	const app = Application('System Events');
	const pt = app.processes['Pro Tools'];
	result = -1;	// error
  
  	if(pt.exists()){
  		//pt.frontmost = true;
	
		var names = pt.windows.name();
		console.log(names);
	
		for (let i = 0; i < names.length; i++){
	
			if(names[i].startsWith('Edit:')){
			
				var editWindow = pt.windows[names[i]];
				// how to find things: see /Users/protools/Desktop/testScripts/jxaExamples.scpt
				let start = editWindow.groups["Counter Display Cluster"].textFields["Edit Selection Start"].value();	
				let end = editWindow.groups["Counter Display Cluster"].textFields["Edit Selection End"].value();	
				
				result = start + "\t" + end;		
			}
		}
		
	}
	
	return result;

}
function getClipName(){

	let result = -1;	// error
	
  	const app = Application('System Events');
	const pt = app.processes['Pro Tools'];
	var currentApp = Application.currentApplication();
	currentApp.includeStandardAdditions = true;

	
	if(pt.exists()){
		app.keystroke('R', { using: ['command down','option down','shift down'] });
	
		let status = waitForDialogWindow(pt,'Name',true);
	
		if (status == 0){
	
			copyToClipboard(currentApp,app);	// waits for clipboard length			
			result = currentApp.theClipboard();	//cue 012 _02-01

	
		}
		
		app.keystroke('\r');	// close the clip name dialog
		// wait for the name dialog to close
		status = waitForDialogWindow(pt,'Name',false);
		// option-tab deselects and puts cursor at start of cue
		app.keystroke('\t', { using: 'option down' });	// tab to start of take
	}

	return result;
	
}
function copyToClipboard(currentApp,app){

// clear the clipboard
// cmd-c to clipboard
// wait for non-zero clipboard length
// wait for length to stop changing
	
	currentApp.setTheClipboardTo("");
	
	app.keystroke('c', { using: 'command down' });
	
	let lastLength = 0;
	
	for(let i = 0; i < 100; i++){
	
		try{
		// "self-sent 'ascr'/'gdut' event accepted in process that isn't scriptable"
		// this error is because we are waiting for the clipboard, and is OK
				let str = currentApp.theClipboard();
				
			if(typeof(str) == 'string'){
				
					let len = str.length;
					
					if(len != 0){
						if(len == lastLength){
					
							//console.log('clipboard length',len);
							return len;
						}
						lastLength = len;
					}
				}

			
		}catch(error){
			console.log('failed to get clipboard length');
		}
	}
	return -1;
}

function waitForDialogWindow(pt,title,onOff){

// wait for the presence or absence of the dialog window
	for(let i = 0; i < 100; i++){
				
		//console.log('loop count',i);
					
		try{
				if(onOff == pt.windows.name().includes(title)){
				
					return 0;
				}

		}catch(error){
					
			console.log('waitForDialogWindow',i);
		}
									
	}
	return -1;	// failure

}
                              � jscr  ��ޭ