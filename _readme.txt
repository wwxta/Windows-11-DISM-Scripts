dism /export-image /sourceimagefile:Z:\install.wim /sourceindex:1 /destinationimagefile:Z:\install.esd /compress:recovery

Информационные команды:
dism /get-imageinfo /imagefile:Z:\install.wim
dism /image:Z:\Install /get-provisionedappxpackages > Z:\list1.txt
dism /image:Z:\Install /get-capabilities > Z:\list2.txt
dism /image:Z:\Install /get-features > Z:\list3.txt
