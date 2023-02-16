function YazirusiDisplay(){
    let HenkouLog = document.getElementByID('HenkouLog')
    let YAZIRUSI = document.getElementsByClassName('leader-line')
    let displaystatus = document.defaultView.getComputedStyle(HenkouLog,null).display;

    if(displaystatus === 'none'){
        //要素が非表示だったら～
        YAZIRUSI.style.display = 'none';
    }else{
        //要素が表示だったら～
        YAZIRUSI.style.display = 'block';
    }
}