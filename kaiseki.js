"use strict";
var obj1 = document.getElementById("selfile");
var BunsekiString = document.test.txt;
var str;
var Bunseki_element = document.getElementById("Result_element");
var b = 0;
var a = 0;
var Mode = "なし";//”explain”：説明文 "content":コンテンツ
var strsplit=[];
var CodeInfo = {};
var CodeAllInfo = [];
var cut1       = [];//コード内容と、説明文に分ける
var Explain    = [];//説明文達の配列
var ContentB   = "";//コンテンツ内容
var Content    = [];//コンテンツ達の配列
var LineCnt = [];
var AllLineCnt = 0;
var Comment_;
var Surash;
var CommentCreate;
var SENGENcheck;
var Comment_Boolean;

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
    var ModeGNo=0;
    strsplit=str.split("\n");//全てのコードを改行で配列に組み込む
    for(var i = 0; i < strsplit.length; i++){
        console.log(i);
        CodeInfo.Line=i;//コードの行数を記録
        CodeInfo.String=strsplit[i].trim();//コードの文字列を記録
        CodeInfo.ModeGNo=ModeGNo;//何個目の説明文とコンテンツかを記録
//----------------------------------------説明文とコンテンツ切替処理--------------------------------------------------------------------------------
        if(CodeInfo.String.includes("************************************************************************")===true)//説明文とコンテンツが切り替わる文字列が含まれているかどうか
        {   
            if(Mode==="なし")//Modeの初期値は”なし”
            Mode="説明文";//説明文モード   
            else if(Mode==="コンテンツ") 
            {
                Mode="説明文";//説明文モード
                ModeGNo++;//説明文モードに切り替わった場合、モードグループを１上げる
            }
            else if(Mode==="説明文")
            {
                Mode="コンテンツ";//コンテンツモード
            }
            CodeInfo.ModeContentLine=0;//コンテンツモードの何行目かを初期化
        }
//----------------------------------------説明文とコンテンツ切替処理終了--------------------------------------------------------------------------------

        else if(Mode=="コンテンツ")//コンテンツモードの場合
        {
            CodeInfo.Mode="コンテンツ"//モード：コンテンツと記録する     
            ContentBunseki();
            a++;
            CodeInfo.ModeContentLine++;//コンテンツモードの何行目かを記録
        }
        else if(Mode=="説明文")//説明文モードの場合
        {
            CodeInfo.Mode="説明文"//モード：説明文と記録する
            CodeInfo.String=CodeInfo.String.replace(/[//]/g, '');
            CodeInfo.String=CodeInfo.String.replace(/[//*]/g, '');
            CodeInfo.String=CodeInfo.String.replace(/[//**]/g, '');
            CodeInfo.String=CodeInfo.String.trim();
            if(Explain[ModeGNo]==undefined)Explain[ModeGNo]="";
            Explain[ModeGNo] = Explain[ModeGNo] + CodeInfo.String + "\n";//説明文の塊を作成する
        }
        
        CodeAllInfo[i]=CodeInfo;
    }
    console.log(Explain[0]);
    console.log("CodeAllInfo完了");
    for (var i = 0; i < ModeGNo; i++) {
        if(i === 0){
            console.log(ModeGNo);
            HenkouLog(Explain[0]);
        }
        Bunseki(Explain[i],i);
    }

};

//*****************************************************************************************************************
//コンテンツを分析
//***************************************************************************************************************** 
function ContentBunseki() {
    var ContentChild = [];
    
    ContentChild = CodeInfo.String;
    //最初のコンテンツのみ、宣言分析関数を使う。
    if (CodeInfo.ModeGNo == 0)
        SengenBunseki();
    LineCnt[a] = ContentChild.length - 1;
}

//-----------------コンテンツのコードとコメントを区別する関数-----------------------------------------------------------
function CommentOutBunri() {

    //[i]番目の行にコメントアウトがある場合、コメントアウト部分のみ抜き出す。
    if (CodeInfo.String.includes('//')) {
        Surash = CodeInfo.String.indexOf('//'); //ダブルスラッシュの位置の数字を抜き出す
        Comment_ = CodeInfo.String.substring(Surash + 2);//ダブルスラッシュ以降の文字を抽出
        CodeInfo.String = CodeInfo.String.replace('//' + Comment_, "");//コメントを文字列から削除
        CommentCreate = document.createElement('span');//div要素作成
        CommentCreate.className = 'Comment_list';//Classを指定
        CommentCreate.textContent = Comment_;//表示文字列を指定
        //console.log(i, Comment_);//確認　
    }
}
//-------------------------------------宣言部分を分類する関数------------------------------------------------------------
function SengenBunseki() {
    //一行ずつ特定の言葉を含んでいないか検査
    
    CodeInfo.String = CodeInfo.String.trim();
    if (CodeInfo.String.includes('//')) {
        CommentOutBunri();
        Comment_Boolean = true;
    }
    //[i]番目の行　検査開始
    if (CodeInfo.String.toUpperCase().startsWith('CONST') === true) {
        SENGENcheck = "Const";
    }
    else if (CodeInfo.String.toUpperCase().startsWith('TYPE') === true) {
        SENGENcheck = "Type";
    }
    else if (CodeInfo.String.toUpperCase().startsWith('PUBLIC') === true) {
        SENGENcheck = "Public";
    }
    else if (CodeInfo.String.toUpperCase().startsWith('PRIVATE') === true) {
        SENGENcheck = "Private";
    }
    else if (CodeInfo.String.toUpperCase().startsWith('FUNCTION') === true) {
        SENGENcheck = "Function";
    }
    else if (CodeInfo.String.toUpperCase().startsWith('PROCEDURE') === true) {
        SENGENcheck = "Procedure";
    }
    //[i]番目の行　検査終了

    //続いてHTMLに配置
    var Sengen_listCreate = document.createElement('li');//li要素作成
    Sengen_listCreate.textContent =CodeInfo.String;//表示文字列を指定

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

//*****************************************************************************************************************
//説明文を分析
//***************************************************************************************************************** 
function Bunseki(Explain,i) {
    var ExplainChild = [];

    ExplainChild = Explain.split("\n");
    // ExplainChild[0] = ExplainChild[0].trim();


    //------------------------------------------------------------HTMLに表示領域（ブロック）を作成------------------------------------------------------------    
    //-------タブブロック、div要素を作成------------
    var BLOCKCreate = document.createElement('div');//div要素作成
    BLOCKCreate.className = 'BLOCK';//クラスを指定
    category2.appendChild(BLOCKCreate);//配置場所を指定
    //-------チェックボックス作成------------
    var CheckboxCreate = document.createElement('input');//li要素作成
    CheckboxCreate.type = 'checkbox';//typeを指定
    CheckboxCreate.id = i + "title";//IDを指定
    BLOCKCreate.appendChild(CheckboxCreate);//配置場所を指定
    //-------＋印作成------------
    var PlusCreate = document.createElement('div');//div要素作成
    PlusCreate.className = 'cp_plus';//Classを指定
    PlusCreate.textContent = "+";//表示文字列を指定
    BLOCKCreate.appendChild(PlusCreate);//配置場所を指定
    //-------見出し作成------------
    var TitleLabel = document.createElement('label');//label要素作成
    TitleLabel.htmlFor = i + "title";//Forを指定
    TitleLabel.textContent = ExplainChild[0] + " " +  AllLineCnt + " " + LineCnt[b];//表示文字列を指定
    const ABCZ = CodeAllInfo.find((Line) => { return Line.ModeGNo===i });
    console.log(ABCZ);
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
    var L=0;
    var LogArray=[];
    SystemExplainChild = SystemExplain.split("\n");
    for(var i = 0; i < SystemExplainChild.length; i++)
    {
        SystemExplainChild[i] = SystemExplainChild[i].trim();
        var LogBoolean = SystemExplainChild[i].match(/\<.*?\>/g);//正規表現を使い’<>’が含まれる場合tureにする
        //'<>'が含まれる場合
        if (LogBoolean!=null)
        {
            LogArray[L]=LogBoolean[0];
            console.log(SystemExplainChild[i])
            console.log(LogBoolean)
        }

    }
    return LogArray[SystemExplainChild.length];

}




