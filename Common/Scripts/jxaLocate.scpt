JsOsaDAS1.001.00bplist00�Vscript_// to run:
// % cd /Users/protools/Desktop/testScripts/
// % osascript -l JavaScript jxaLocate.scpt *01:02:03:04

ObjC.import("Foundation");
  
const args = $.NSProcessInfo.processInfo.arguments;
// from console:
// args[0..3] are filename, "/usr/bin/osascript", "-l", "JavaScript" 
// from osaScript in our program:
// @"/usr/bin/osascript,/Users/protools/Library/Scripts/jxaKeyStroke.scpt,*1234\n"	0x0000600001ebbba0
//console.log("args.count",args.count);	// note 'count', Objective C-like
result = -1;	// failure
var argv = [];

if (args.count > 1){

	var startIndex = args.js[1].js == ('-l') ? 4 : 2;	// assume we are called from the command line

	//console.log('startIndex', startIndex);

	for(let i = startIndex; i < args.count; i++){
		argv.push(ObjC.unwrap(args.objectAtIndex(i)));
	}
}
//argv = ["01:01:00:00"]
if (argv.length > 0) {

	//setCursorToolCluster()	// must be set for locate to work, cut and paste to work
	
	console.log('argv',argv);
	
  	const app = Application('System Events');
	const pt = app.processes['Pro Tools'];
  
  	if(pt){
	
		// appropriate pt window has to be raised already
		pt.frontmost = true;	// causes video to hide AleDoc overlay
		
		// Ventura, PT11 Ultimate have to provide * and \r here
	
		app.keystroke('*');	// entry mode
		
		// 'link track and edit selection' selects tracks if we send : chars
		let str = argv[0].replace(new RegExp(':', 'g'), '');
		//console.log("str",str)
		
		// feet+frames or timecode
		if(argv[0].includes("+")){
			//console.log('feet+frames');
			let ftFr = argv[0].split("+");
			app.keystroke(ftFr[0]);	// feet
			app.keyCode(124);		// right arrow
			app.keystroke(ftFr[1]);	// frames
		}else{
			//console.log('timecode');
			app.keystroke(str);
		}
		app.keystroke('\r');
		

		result = 0;

	}
}

result + "\t" + argv[0]+ "\t" + argv[1];	//1.12.24 return locate t

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
				
				var btn = btns["Tab to Transients"]
				
				console.log(btn.value(), btn.value().length)
				
				if(btn.value().length != 0){
					btn.actions['AXPress'].perform()
				}
				
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
                               jscr  ��ޭ