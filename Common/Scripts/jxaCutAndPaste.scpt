JsOsaDAS1.001.00bplist00�Vscript_(V// to run in Terminal:
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
var result = -1;	// assume failure

if (args.count > 1){

	var startIndex = args.js[1].js == ('-l') ? 4 : 2;	// assume we are called from the command line

	//console.log('startIndex', startIndex);

	for(let i = startIndex; i < args.count; i++){
		argv.push(ObjC.unwrap(args.objectAtIndex(i)));
	}
}
//
//argv = ["a duck and a priest", "1", "2","3"];	// argv debug

if (argv.length > 0) {
	
	console.log('argv',argv);
	
  	const app = Application('System Events');
	const pt = app.processes['Pro Tools'];
  
  	if(pt.exists()){
	
		pt.frontmost = true;
		const dialog = argv.length > 0 ? argv[0] : "";
		const recordToComposite = argv.length > 1 ? argv[1] : "1";
		const tracksUp = argv.length > 2 ? argv[2] : "1";
		const remoteOffset = argv.length > 3 ? argv[3] : "0";
		
		result = copyClipsUp(dialog, recordToComposite, tracksUp, remoteOffset);

	}
}

result;

function copyClipsUp(dialog, recordToComposite, tracksUp, remoteOffset){

//	setCursorToolCluster()();	// also turns off 'tab to transients'
	
	//var remoteOffset = parseInt(readAndSplitFile('/Documents/offset.txt', '\n'));
	//console.log(remoteOffset);
	const app = Application('System Events');
  	const pt = app.processes['Pro Tools'];
	var currentApp = Application.currentApplication();
	currentApp.includeStandardAdditions = true;
  
  	if(pt.exists()){
	
  		pt.frontmost = true;
		var names = pt.windows.name();
		for (let i = 0; i < names.length; i++){
	
			if(names[i].startsWith('Edit:')){
			
			var editWindow = pt.windows[names[i]];
			
				editWindow.actions['AXRaise'].perform();
								
				names = editWindow.groups.name()
				var last
				var lastTrackBtn	// select last track when done
				
				app.keystroke('p')	// if 2 tracks are selected, this selects 1
				
				while(names.length > 0){
				
					last = names.pop()
						
					if (last.endsWith('Track ')){

						btn = editWindow.groups[last].popUpButtons[0]	// Track Name button
							
						btn.actions['AXPress'].perform()	// select track
						lastTrackBtn = btn
							
						break	
					}
				}
				
				// offset trim (delay)
				for(let i = 0; i < remoteOffset; i++){
					app.keyCode(47);	// period key, not decimal point key
				}
							
				app.keystroke("a");	//remove front of clip
				app.keystroke('\t', { using: 'shift down' });	// select to end
				// if you decide to check the enable of the rename item, here is the test
				// let renameIsEnabled = pt.menuBars[0].menuBarItems["Clip"].menus["Clip"].menuItems['Rename...'].attributes['AXEnabled'].value()
				
				app.keystroke('R', { using: ['command down','option down','shift down'] });
				
				// wait for the name dialog to appear
			let status = waitForDialogWindow(pt,'Name',true);
							
				if(status != 0){
				
  					const returnValue = currentApp.displayAlert(
  						"clip naming error", {
    					message: "Please finish this clip operation manually",
    					as: "critical",
    					buttons: [/*"Stop",*/ "Continue"],
    					defaultButton: "Continue",
    					//cancelButton: "Stop"
					});
					
					return -1;	// TODO: an alert
				}
				
				copyToClipboard(currentApp,app);	// waits for clipboard length
				
				var ptName = currentApp.theClipboard();	//cue 012 _02-01
				
				console.log('clipboard',ptName);
				
				var splitName = ptName.split('-');
				console.log('splitName', splitName);
				if(splitName.length > 1){
					splitName.pop();	// pop last item
				}
				// this correctly handles the case of names containing '-'
				var trackName = splitName.length > 0 ?  splitName.join("-") : ptName;
				
				if(dialog.length > 0){
					trackName = trackName + ' ' + dialog;
				}
				console.log('clipName', trackName);
				
				app.keystroke(trackName); 
				app.keystroke('\r');
								
				// wait for the name dialog to close
				status = waitForDialogWindow(pt,'Name',false);
				// it is likely that we have an error dialog up, duplicate clip name
				if(status == "-1"){
					console.log('duplicate track name?');
					app.keystroke('\r');
									
					for(let i = 0; i < pt.windows.length; i++){
										
						if(pt.windows[i].buttons.name().includes('Cancel')){
											
							pt.windows[i].buttons['Cancel'].click();
							console.log('did cancel');
						}
		
					}
									
					return -1;

				}

				
				app.keystroke('x', { using: 'command down' });	// cut clip, note it does not go to the clipboard, wrong type of object
				app.keystroke('p');	// move up 1 to composite
				
				// offset trim
				for(let i = 0; i < remoteOffset; i++){
					app.keystroke(',');	// advance
				}
								
				if(recordToComposite != '0'){
					app.keystroke('v', { using: 'command down' });	//optionally copy to composite
					
					app.keystroke('\t');	// tab to boundary
					app.keystroke('\t', { using: 'shift down' });	// tab to end of previous take
					app.keyCode(51);	// delete 
					app.keystroke('\t', { using: 'option down' });	// tab to start of take
					
				}
				
				names.pop()	// skip Comp track
				
				for(i = 0; i < tracksUp; i += 1){
					
					last = names.pop()
				}
				
				delay(0.5)	// delay to avoid a double click 
				btn = editWindow.groups[last].popUpButtons[0]	// Track Name button							
				btn.actions['AXPress'].perform()	// select track
			
				delay(0.3)	// try a slight delay to see if it fixes the rare 'copy to wrong track'
				
				app.keystroke('v', { using: 'command down' });
				app.keystroke('\t');	// tab to boundary
				app.keystroke('\t', { using: 'shift down' });	// tab to end of previous take
				app.keyCode(51);	// delete 
				app.keystroke('\t', { using: 'option down' });	// tab to start of take
				
				//delay(0.5)	// delay to avoid a double click
				lastTrackBtn.actions['AXPress'].perform()	// select track

				
				
				return ptName;
			}
		}
	}

	return -1; failure
}
function waitForDialogWindow(pt,title,onOff){

// wait for the presence or absence of the dialog window
	for(let i = 0; i < 200; i++){
				
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
function readAndSplitFile(file, delimiter) {
    // Convert the file to a string
    var fileString = file.toString()
	var currentApp = Application.currentApplication()
	currentApp.includeStandardAdditions = true

    // Read the file using a specific delimiter and return the results
	var path = currentApp.doShellScript('echo $HOME') + fileString;
	try{
    	return currentApp.read(Path(path), { usingDelimiter: delimiter })[0];
	}catch(err){
		return '0';
	}
}


function linkTimelineAndEditSelection(){
  
  	const app = Application('System Events');
  	const pt = app.processes['Pro Tools'];
  
  	if(pt.exists()){
	
  		pt.frontmost = true;
	
		const names = pt.windows.name();
		console.log(names);
	
		for (let i = 0; i < names.length; i++){
	
			if(names[i].startsWith('Edit:')){
			
				var editWindow = pt.windows[names[i]];
			
				editWindow.actions['AXRaise'].perform();	
				
				// use 'Accessibility Inspector' to determine view hierarchy
				var btn = editWindow.groups["Cursor Tool Cluster"].buttons["Link Timeline and Edit Selection"];
				
				//console.log(btn.actions.name());	/* AXShowMenu,AXPress */
				if(btn.value() != "Selected"){
					btn.actions['AXPress'].perform();//click();	// both work
				}
					
				// turn off tab to transient
				
				btn = editWindow.groups["Cursor Tool Cluster"].buttons["Tab to Transients"];
				
				if(btn.value() == "Selected"){
					//console.log('performing AXPress action');
					btn.actions['AXPress'].perform();//click();	// both work
				}
			}
	
		}
  	}
	
	return false;
}

function setCursorToolCluster(){

// we need 'Tab to Transient' OFF, 'Link Timeline and Edit Selection' ON,
// 'Link Track and Edit Selection' ON

  	const app = Application('System Events');
	const pt = app.processes['Pro Tools'];

  	if(pt.exists()){
	
  		pt.frontmost = true;
	
		var names = pt.windows.name();
	
		for (let i = 0; i < names.length; i++){
	
			if(names[i].startsWith('Edit:')){
			
				var editWindow = pt.windows[names[i]];
			
				editWindow.actions['AXRaise'].perform();
				
				var cursorToolCluster = editWindow.groups["Cursor Tool Cluster"]
				
				var btns = cursorToolCluster.buttons
				//"Tab to Transients"
				
//				var btn = btns["Tab to Transients"]
				
//				console.log(btn.value(), btn.value().length)
				
//				if(btn.value().length != 0){
//					btn.actions['AXPress'].perform()
//				}
				
				btn = btns["Link Track and Edit Selection"]
				
				console.log(btn.value(), btn.value().length)
				
				if(btn.value().length == 0){
					btn.actions['AXPress'].perform()
				}
				
				btn = btns["Link Timeline and Edit Selection"]
				
				console.log(btn.value(), btn.value().length)
				
				if(btn.value().length == 0){
					btn.actions['AXPress'].perform()
				}
			}
		}
	}

return 0
}

                              (ljscr  ��ޭ