# STEPS
* 1. Download the file
* 2. Drag the file to your server resources
* 3. Item setup:
  ADD THESE TO QB-CORE/SHARED/ITEMS.LUA 

	['rollofsmallnotes']      = {['name'] = 'rollofsmallnotes',      ['label'] = 'Roll Of Small Notes',      ['weight'] = 1000,      ['type'] = 'item',      ['image'] = 'cashroll.png',      ['unique'] = true, 		['useable'] = false,      ['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'Money?'},

  ['bandofnotes'] 				 = {['name'] = 'bandofnotes', 			  	  	['label'] = 'Band Of Notes', 			['weight'] = 1000, 		['type'] = 'item', 		['image'] = 'cashstack.png', 			['unique'] = true, 		['useable'] = false, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'Money?'},

  ['markedbills'] 				 = {['name'] = 'markedbills', 			  	  	['label'] = 'Marked Money', 			['weight'] = 1000, 		['type'] = 'item', 		['image'] = 'markedbills.png', 			['unique'] = true, 		['useable'] = false, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'Money?'},

  ['suspiciouspackage'] 			 = {['name'] = 'suspiciouspackage', 			['label'] = 'Suspicious package', 		['weight'] = 10000, 	['type'] = 'item', 		['image'] = 'suspicious.png', 				['unique'] = true, 		['useable'] = false, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'This contains something illegal???'},

* 4. Copy the images from the [images] file and paste them to yourinventoryfile/html/images
* 5. If you want the animations ON go to your inventoryfile/client and make it similar like this: https://pastebin.com/9w8tWLh9 (TIP: CTRL + F : fd-oxyrun) and check if Config.ForceAnimation is set as true in config.
* 6. Check the config.lua file and make changes if needed
* 7. Restart the server
* 8. Enjoy!


    