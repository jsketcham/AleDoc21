JsOsaDAS1.001.00bplist00�Vscript_�// to run in Terminal:
// % cd /Users/protools/Desktop/testScripts
// % osascript -l JavaScript jxaIsModalDialog.scpt

ObjC.import("Foundation");
  
const args = $.NSProcessInfo.processInfo.arguments;
// from console:
// args[0..3] are filename, "/usr/bin/osascript", "-l", "JavaScript" 
// from osaScript in our program:
// @"/usr/bin/osascript,/Users/protools/Library/Scripts/jxaCutAndPaste.scpt,*1234"	0x0000600001ebbba0
//console.log("args.count",args.count);	// note 'count', Objective C-like
//
var argv = [];
var result = -1;	// assume failure

if (args.count > 1){

	var startIndex = args.js[1].js == ('-l') ? 4 : 2;	// assume we are called from the command line

	//console.log('startIndex', startIndex);

	for(let i = startIndex; i < args.count; i++){
		argv.push(ObjC.unwrap(args.objectAtIndex(i)));
	}
}

result = isModalDialog();

if(argv.length > 0){

	result = argv[0] + '\t' + result;
}

result;

function isModalDialog(){

	const app = Application('System Events');
	const pt = app.processes['Pro Tools'];

  	if(pt.exists()){
	
	
  		pt.frontmost = true;

		if(pt.windows.attributes['AXRoleDescription'].value().includes("dialog")){
			return 1;
		}else{
			return 0;
		}
	}
	return -1;
}                              �jscr  ��ޭ