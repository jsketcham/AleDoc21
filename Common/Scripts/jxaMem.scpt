JsOsaDAS1.001.00bplist00�Vscript_
$// to run in Terminal:
// % cd /Users/protools/Desktop/testScripts
// % osascript -l JavaScript jxaRenameLastTrack.scpt foo bar
// use 'Accessibility Inspector' to determine UI hierarchy, names of elements

ObjC.import("Foundation");
  
const args = $.NSProcessInfo.processInfo.arguments;
// from console:
// args[0..3] are filename, "/usr/bin/osascript", "-l", "JavaScript" 
// from osaScript in our program:
// @"/usr/bin/osascript,/Users/protools/Library/Scripts/jxaRenameLastTrack.scpt,foobar"	0x0000600001ebbba0
//console.log("args.count",args.count);	// note 'count', Objective C-like 

var argv = [];
var result = '\t-1\terror\t';	// assume failure

if (args.count > 1){

	var startIndex = args.js[1].js == ('-l') ? 4 : 2;	// assume we are called from the command line

	//console.log('startIndex', startIndex);

	for(let i = startIndex; i < args.count; i++){
		argv.push(ObjC.unwrap(args.objectAtIndex(i)));
	}
}

if (argv.length == 0){
	argv= ["25"];	// default memory
}

//dismissModalDialog();	// dismiss modal dialogs
//console.log("argv" , argv);
//dismissModalDialog();	// dismiss modal dialogs
result = mem(argv[0]);
//let sampleRate = getTotalmixSampleRate();	//getSessionSampleRate();
//console.log('sampleRate', sampleRate);
// we get sample rate from UFX, don't need it here
result;

function mem(memorySelector){
	const app = Application('System Events');
	const pt = app.processes['Pro Tools'];

  	if(pt.exists()){
	
  		pt.frontmost = true;
		//console.log("memorySelector ",memorySelector);
		app.keyCode(65);	// '.' key
		for(let i = 0; i < memorySelector.length;i++){
		
			let c = memorySelector.charAt(i);
			let d = c - "0" + 82;
			if(d > 89){d = d + 1;}
			app.keyCode(d);
			//console.log("i:c:d ",i,":",c,":",d); 
		}
		
		app.keyCode(65);	// '.' key
		
	}
	return 0;
}
function dismissModalDialog(){

	const app = Application('System Events');
	const pt = app.processes['Pro Tools'];

  	if(pt.exists()){
	
  		pt.frontmost = true;
		
		//for(let i = 0; i < pt.windows.length; i++){
			//console.log(pt.windows[i].name());
			//console.log(pt.windows[i].properties());
			//console.log(pt.windows[i].attributes.name());
			//console.log(pt.windows[i].buttons.name());
		//}
		
		for(let i = 0; i < pt.windows.length; i++){
												
			if(pt.windows[i].buttons.name().includes('Cancel')){
											
				pt.windows[i].buttons['Cancel'].click();
				console.log('did cancel',i);
			}else if(pt.windows[i].buttons.name().includes('OK')){
											
				pt.windows[i].buttons['OK'].click();
				console.log('did OK',i);
			}	
		}
		return 0;
	}
	return -1;
}

                              
:jscr  ��ޭ