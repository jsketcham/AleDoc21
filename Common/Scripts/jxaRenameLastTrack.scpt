JsOsaDAS1.001.00bplist00�Vscript_�// to run in Terminal:
// % cd /Users/protools/Desktop/testScripts
// % osascript -l JavaScript jxaRenameLastTrack.scpt foo bar
// use 'Accessibility Inspector' to determine UI hierarchy, names of elements

ObjC.import("Foundation");
  
const args = $.NSProcessInfo.processInfo.arguments;
// from console:
// args[0..3] are filename, "/usr/bin/osascript", "-l", "JavaScript" 
// from osaScript in our program:
// @"/usr/bin/osascript,/Users/protools/Library/Scripts/jxaRenameLastTrack.scpt 0 foo bar"	0x0000600001ebbba0
//console.log("args.count",args.count);	// note 'count', Objective C-like 
//

var argv = [];
var result = '\t-1\terror\t';	// assume failure

if (args.count > 1){

	var startIndex = args.js[1].js == ('-l') ? 4 : 2;	// assume we are called from the command line

	//console.log('startIndex', startIndex);

	for(let i = startIndex; i < args.count; i++){
		argv.push(ObjC.unwrap(args.objectAtIndex(i)));
	}
}

//argv = ['joeMomma','joeMomma2'];	// comment out once this is debugged

if (argv.length > 1){	// argv[0] is a switch for adrClientController rx 

	// concatenate words with blanks
	
	let newName = '';
	
	for(let i = 1; i < argv.length; i++){
	
		newName = newName + argv[i] + (i == argv.length - 1 ? '' : ' ');
	}
	
	result = renameLastTrack(newName);
	//console.log('newName', newName);
	
	if(result == '-1'){
		result = '\t-1\t' + newName + '\t';	// return switch -1 on error
	}else{
		result = '\t' + argv[0] + '\t' + result + '\t';
	}

}

result;

function renameLastTrack(newName){

  	const app = Application('System Events');
	const pt = app.processes['Pro Tools'];
	
	newName = newName.trim()	// remove whitespace
  
  	if(pt.exists()){
	
  		pt.frontmost = true;
	
		var names = pt.windows.name();
		
		//console.log('names', names);
	
		for (let i = 0; i < names.length; i++){
		
			if(names[i].startsWith('Edit:')){
			
				var editWindow = pt.windows[names[i]];
			
				editWindow.actions['AXRaise'].perform();	// editToFrount()
				
				names = editWindow.groups.name();
				
				//console.log('editWindow.groups.name', names);
				while(names.length > 0){
				
					let last = names.pop();
					//console.log(last);
					if (last.endsWith('Track ')){
					
						let pbNames = editWindow.groups[last].popUpButtons.name();
						
						console.log('popUpButtons.name', pbNames);
						
					for (let j = 0; j < pbNames.length; j++){
						
						let pbName = pbNames[j];
						
							//console.log(pbName);
						
							if(pbName.startsWith('Track name')){
							
														
								let pbButton = editWindow.groups[last].popUpButtons[pbName];
								//console.log('attributes',editWindow.groups[last].attributes.name());
								//console.log('popUpButtons.name', editWindow.groups[last].popUpButtons.name())
								//console.log('buttons.name', editWindow.groups[last].buttons.name())
								let btn = editWindow.groups[last].buttons['Track Record Enable']
								//console.log('Track Record Enable attrs',btn.attributes.name())
								//console.log('enabled',btn.enabled(),'value',btn.value())
								if(btn.value() == ""){
									//console.log('performing AXPress action');
									btn.actions['AXPress'].perform();//click();	// both work
								}
								
								let thePos = pbButton.attributes['AXPosition'].value();
								thePos[0] = thePos[0] + 4;
								thePos[1] = thePos[1] + 4;	// position slightly in to the button
								
								let oldName = pbButton.value();
								//console.log(oldName);
								
								if(newName == oldName){
								
									return oldName;	// name did not change
								}
								//console.log(oldName,newName);
								setCursorToolCluster()	// get in proper 'link' state
								
								var currentApp = Application.currentApplication();
								currentApp.includeStandardAdditions = true;
								
								//let path = "/opt/homebrew/bin/cliclick";
								let path =  "/Applications/AleDoc21.app/Contents/Resources/cliclick"
								let currentPos = currentApp.doShellScript(path + ' p');
								currentApp.doShellScript(path + ' dc:' + thePos[0] + ',' + thePos[1]);
								
								currentPos = currentPos.split(' ').pop()
								console.log('currentPos', currentPos)
								
								waitForDialogWindow(pt,true);
								app.keystroke(newName);
								app.keystroke('\r');
								let status = waitForDialogWindow(pt,false);
								
								// it is likely that we have an error dialog up, duplicate track name
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
								let s = path + ' m:' + currentPos
								console.log('doShellScript',s)
								currentApp.doShellScript(path + ' m:' + currentPos);
								
								return oldName;
							}
						}
						return -1;
						
					
						
					}
				}
			}
		}
	}

}
function waitForDialogWindow(pt,onOff){

// wait for the presence or absence of the dialog window
	for(let i = 0; i < 100; i++){
				
		//console.log('waitForDialogWindow',i);
					
		try{
				let attrs = pt.windows.attributes['AXRoleDescription'].value();
				//console.log('typeof(attrs)',typeof(attrs));
				if(typeof(attrs) == 'object' && attrs.includes('dialog') == onOff){
					//console.log('attrs',attrs);
					return 0;
				}

		}catch(error){
					
			console.log('failed to get attrs');
		}
									
	}
	return -1;

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
				let str = currentApp.theClipboard();
				//console.log('str', str);
				
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
                              � jscr  ��ޭ