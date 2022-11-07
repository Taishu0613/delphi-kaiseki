var obj1 = document.getElementById("selfile");
var BunsekiString = document.test.txt;
var str;
var Bunseki_element = document.getElementById("Result_element");
var b = 0;
var a = 0;
var Content = [];
var LineCnt = [];
var AllLineCnt = 0;

//ダイアログでファイルが選択された時
obj1.addEventListener(
    "change",
    function (evt) {
        var file = evt.target.files;
        //FileReaderの作成
        var reader = new FileReader();
        //テキスト形式で読み込む
        reader.readAsText(file[0]);
        //読込終了後の処理
        reader.onload = function (ev) { //テキストエリアに表示する
            BunsekiString.value = reader.result;
            str = BunsekiString.value;
            Bunkai(str);
        }
    },
    false);

function Bunkai(str) {
    var cut1 = [];
    var ExplainB = "";
    var Expalin = [];
    var ContentB = "";
    
    cut1 = str.split("************************************************************************\n");

    for (var i = 0; i < cut1.length - 1; i++) {
        if (i % 2 == 0) {
            Content[a] = cut1[i+2];
            //console.log(Content[a]);
            ContentB = Content[a];
            CBunseki(ContentB);
            a++;
        }
        else if (i % 2 == 1) {
            Expalin[b] = cut1[i];
            Expalin[b] = Expalin[b].replace(/[//]/g, '');
            Expalin[b] = Expalin[b].replace(/[//*]/g, '');
            Expalin[b] = Expalin[b].replace(/[//**]/g, '');

            console.log(b, "個目");
            ExplainB = Expalin[b];
            Bunseki(ExplainB);

            b++;
        }
    }
};

function CBunseki(ContentB) {
    var ContentChild = [];
    ContentChild = ContentB.split("\n");
    LineCnt[a] = ContentChild.length - 1;
}


function Bunseki(ExplainB) {
    var RESULT = [];
    var ExplainChild = [];
    var ContentChildSplit = [];
    var c, d = 0;
    var ENames, Econtents = [];

    ExplainChild = ExplainB.split("\n");
    ExplainChild[0] = ExplainChild[0].trim();


    //------------------------------------------------------------HTMLに表示領域（ブロック）を作成------------------------------------------------------------    
    //-------タブブロック、div要素を作成------------
    var BLOCKCreate = document.createElement('div');//div要素作成
    BLOCKCreate.className = 'BLOCK';//クラスを指定
    category2.appendChild(BLOCKCreate);//配置場所を指定
    //-------チェックボックス作成------------
    var CheckboxCreate = document.createElement('input');//li要素作成
    CheckboxCreate.type = 'checkbox';//typeを指定
    CheckboxCreate.id = b + "title";//IDを指定
    BLOCKCreate.appendChild(CheckboxCreate);//配置場所を指定
    //-------＋印作成------------
    var PlusCreate = document.createElement('div');//div要素作成
    PlusCreate.className = 'cp_plus';//Classを指定
    PlusCreate.textContent = "+";//表示文字列を指定
    BLOCKCreate.appendChild(PlusCreate);//配置場所を指定
    //-------見出し作成------------
    var TitleLabel = document.createElement('label');//label要素作成
    TitleLabel.htmlFor = b + "title";//Forを指定
    TitleLabel.textContent = ExplainChild[0] + " " +  AllLineCnt + " " + LineCnt[b];//表示文字列を指定
    AllLineCnt = AllLineCnt + (ExplainChild.length + LineCnt[b] + 1);
    BLOCKCreate.appendChild(TitleLabel);//配置場所を指定
    //-------コンテンツ作成------------
    var BLOCK_ContentCreate = document.createElement('label');//label要素作成
    BLOCK_ContentCreate.className = 'BLOCK-content';//Classを指定
    BLOCKCreate.appendChild(BLOCK_ContentCreate);//配置場所を指定
    for (var i = 1; i < ExplainChild.length - 1; i++) {
        var BLOCK_Content_SplitCreate = document.createElement('li');//li要素作成
        BLOCK_Content_SplitCreate.textContent = ExplainChild[i];//表示文字列を指定
        BLOCK_ContentCreate.appendChild(BLOCK_Content_SplitCreate);//配置場所を指定
    }

    //-------------------------------------コンポーネントとプロセスとその他に分類する------------------------------------------------------------

    console.log(ExplainChild[0]);
    if (ExplainChild[0].includes('Proccess') === true) {
        BLOCKCreate.className = BLOCKCreate.className + ' Proccess_list';//クラスを指定
        console.log("プロセス");
    }
    else if (ExplainChild[0].includes('Component') === true) {
        BLOCKCreate.className = BLOCKCreate.className + ' Component_list';//クラスを指定
        console.log("コンポネート");
    }
    else {
        BLOCKCreate.className = BLOCKCreate.className + ' Sonota_list';//クラスを指定 
    }

    //console.log(RESULT[i]); 

};
//-------------------------------------------------ソート--------------------------------------------------
//document.getElementById("sortC").addEventListener("change",aaa());
function aaa(){
    var checkedC = document.getElementById("sortC").checked;
    var checkedP = document.getElementById("sortP").checked;
    var checkedO = document.getElementById("sortO").checked;
    var checked = document.getElementById("sortA").checked;
    var aa = document.querySelectorAll(".Proccess_list, .Component_list, .Sonota_list");
    var cc = document.querySelectorAll(".Proccess_list, .Sonota_list");
    var pp = document.querySelectorAll(".Component_list, .Sonota_list");
    var oo = document.querySelectorAll(".Proccess_list, .Component_list");
    //if(checked){
        for(var i=0;i < aa.length;i++){
            aa[i].style.display = "block";
        }
    //}
    if(checkedC == true){
        for(var i=0;i < cc.length;i++){
            cc[i].style.display = "none";
        }
    }
    if(checkedP == true){
        for(var i=0;i < pp.length;i++){
            pp[i].style.display = "none";
        }
    }
    if(checkedO == true){
        for(var i=0;i < oo.length;i++){
            oo[i].style.display = "none";
        }
    }
}
function bbb(){
    var checked = document.getElementById("sortA").checked;
    var aa = document.querySelectorAll(".Proccess_list, .Component_list, .Sonota_list");
    if(checked){
        for(var i=0;i < aa.length;i++){
            aa[i].style.display = "block";
        }
    }
}





