"use strict";
var obj1 = document.getElementById("selfile");
var BunsekiString = document.test.txt;
var str;
var Bunseki_element = document.getElementById("Result_element");
var b = 0;
var a = 0;    
var cut1       = [];//コード内容と、説明文に分ける
var ExplainB   = "";//説明文内容
var Expalin    = [];//説明文達の配列
var ContentB   = "";//コンテンツ内容
var Content    = [];//コンテンツ達の配列
var LineCnt = [];
var AllLineCnt = 0;
var Comment_;
var Surash;
var CommentCreate;

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

    cut1 = str.split("************************************************************************\n");

    for (var i = 0; i < cut1.length - 1; i++) {
        if (i % 2 == 0) {
            Content[a] = cut1[i+2];
            
            ContentB = Content[a];
            ContentBunseki(ContentB);
            a++;
        }
        else if (i % 2 == 1) {
            Expalin[b] = cut1[i];
            Expalin[b] = Expalin[b].replace(/[//]/g, '');
            Expalin[b] = Expalin[b].replace(/[//*]/g, '');
            Expalin[b] = Expalin[b].replace(/[//**]/g, '');

            //console.log(b, "個目");
            if(b === 0){
                console.log(b)
                HenkouLog(Expalin[0])
            }
            ExplainB = Expalin[b];
            Bunseki(ExplainB);
            b++;
        }
    }
};
//*****************************************************************************************************************
//コンテンツを分析
//***************************************************************************************************************** 
function ContentBunseki(ContentB) {
    var ContentChild = [];
    ContentChild = ContentB.split("\n");
    //最初のコンテンツのみ、宣言分析関数を使う。
    if (a == 0)
        SengenBunseki(ContentChild);
    LineCnt[a] = ContentChild.length - 1;

}

//-----------------コンテンツのコードとコメントを区別する関数-----------------------------------------------------------
function CommentOutBunri(i, ContentChild) {

    //[i]番目の行にコメントアウトがある場合、コメントアウト部分のみ抜き出す。
    if (ContentChild[i].includes('//')) {
        Surash = ContentChild[i].indexOf('//'); //ダブルスラッシュの位置の数字を抜き出す
        Comment_ = ContentChild[i].substring(Surash + 2);//ダブルスラッシュ以降の文字を抽出
        ContentChild[i] = ContentChild[i].replace('//' + Comment_, "");//コメントを文字列から削除
        CommentCreate = document.createElement('span');//div要素作成
        CommentCreate.className = 'Comment_list';//Classを指定
        CommentCreate.textContent = Comment_;//表示文字列を指定
        //console.log(i, Comment_);//確認　
    }
}
//-------------------------------------宣言部分を分類する関数------------------------------------------------------------
function SengenBunseki(ContentChild) {
    var SENGENcheck;
    var Comment_Boolean;
    for (var i = 0; i < ContentChild.length; i++)//一行ずつ特定の言葉を含んでいないか検査
    {
        ContentChild[i] = ContentChild[i].trim();
        if (ContentChild[i].includes('//')) {
            CommentOutBunri(i, ContentChild);
            Comment_Boolean = true;
        }
        //[i]番目の行　検査開始
        if (ContentChild[i].toUpperCase().startsWith('CONST') === true) {
            SENGENcheck = "Const";
        }
        else if (ContentChild[i].toUpperCase().startsWith('TYPE') === true) {
            SENGENcheck = "Type";
        }
        else if (ContentChild[i].toUpperCase().startsWith('PUBLIC') === true) {
            SENGENcheck = "Public";
        }
        else if (ContentChild[i].toUpperCase().startsWith('PRIVATE') === true) {
            SENGENcheck = "Private";
        }
        else if (ContentChild[i].toUpperCase().startsWith('FUNCTION') === true) {
            SENGENcheck = "Function";
        }
        else if (ContentChild[i].toUpperCase().startsWith('PROCEDURE') === true) {
            SENGENcheck = "Procedure";
        }
        //[i]番目の行　検査終了

        //続いてHTMLに配置
        var Sengen_listCreate = document.createElement('li');//li要素作成
        Sengen_listCreate.textContent = ContentChild[i];//表示文字列を指定

        //続いてHTMLに配置
        if (SENGENcheck === "Const") {
            Const_list.appendChild(Sengen_listCreate);//配置場所を指定
        }
        if (SENGENcheck === "Type") {
            Type_list.appendChild(Sengen_listCreate);//配置場所を指定
        }
        if (SENGENcheck === "Public") {
            Public_list.appendChild(Sengen_listCreate);//配置場所を指定
        }
        if (SENGENcheck === "Private") {
            Private_list.appendChild(Sengen_listCreate);//配置場所を指定
        }
        if (SENGENcheck === "Function") {
            Function_list.appendChild(Sengen_listCreate);//配置場所を指定
        }
        if (SENGENcheck === "Procedure") {
            Procedure_list.appendChild(Sengen_listCreate);//配置場所を指定
        }
        //コメントが含まれている場合のみ配置

        if (Comment_Boolean) {
            Sengen_listCreate.appendChild(CommentCreate);//配置場所を指定
            Comment_Boolean = false;
        }

    }

}

//*****************************************************************************************************************
//説明文を分析
//***************************************************************************************************************** 
function Bunseki(ExplainB) {
    var ExplainChild = [];

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

    //console.log(ExplainChild[0]);
    if (ExplainChild[0].includes('Proccess') === true) {
        BLOCKCreate.className = BLOCKCreate.className + ' Proccess_list';//クラスを指定
        //console.log("プロセス");
    }
    else if (ExplainChild[0].includes('Component') === true) {
        BLOCKCreate.className = BLOCKCreate.className + ' Component_list';//クラスを指定
        //console.log("コンポネート");
    }
    else {
        BLOCKCreate.className = BLOCKCreate.className + ' Sonota_list';//クラスを指定 
    }

};

//-------------------------------------------------ソート--------------------------------------------------
//document.getElementById("sortC").addEventListener("change",aaa());
function SortCode(){
    var checkedC = document.getElementById("sortCompornent").checked;
    var checkedP = document.getElementById("sortProcess").checked;
    var checkedO = document.getElementById("sortOther").checked;
    var checked = document.getElementById("sortAll").checked;
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

//--------------------------変更履歴を分析する--------------------------
function HenkouLog(SystemExplain){
    var SystemExplainChild = [];
    SystemExplainChild = SystemExplain.split("\n");
    for(var i = 0; i < SystemExplainChild.length; i++){
        SystemExplainChild[i] = SystemExplainChild[i].trim();
        var LogBoolean = SystemExplainChild[i].match(/\<.*?\>/g);//正規表現を使いで’<>’が含まれる場合tureにする
        if (LogBoolean!=null){
        console.log(SystemExplainChild[i])
        console.log(LogBoolean)
        }
    }
}




