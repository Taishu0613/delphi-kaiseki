"use strict";
var obj1 = document.getElementById("selfile");
var BunsekiString = document.test.txt;
var str;
var Bunseki_element = document.getElementById("Result_element");
var b = 0;
var a = 0;
var Mode = "なし";//”explain”：説明文 "content":コンテンツ
var strsplit = [];
var CodeInfoArray = [];
var cut1       = [];//コード内容と、説明文に分ける
var Explains = [];//説明文達の配列
var ContentB   = "";//コンテンツ内容
var Contents = [];//コンテンツ達の配列
var Comment_;
var Surash;
var CommentCreate;
var SENGENcheck;
var Comment_Boolean;
var KaKuNiNpoint = 0;
var LogArray;
var KaKuNiN_TUUKA;
var KaKuNiN_list;
console.log("解析準備完了");

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
            str = reader.result;
            //str=str.replace(/[\t]/,"    ");//インデントを記録する方法
            BunsekiString.value = str;
            Bunkai(str);
            hljs.initHighlightingOnLoad();
            
        }
    },
    false);

function Bunkai(str) {
    var BlockNo = 0;
    strsplit=str.split("\n");//全てのコードを改行で配列に組み込む
    for(var i = 0; i < strsplit.length; i++){
        var CodeInfo = {};
        CodeInfo.String = strsplit[i];//コードの文字列を記録 //インデントを消すかどうかだよ
        //CodeInfo.String=strsplit[i].trim();//インデントを消すかどうかだよ
        CodeInfo.Line = i;//コードの行数を記録
        CodeInfo.BlockNo = BlockNo;//何個目の説明文とコンテンツかを記録
        //----------------------------------------説明文とコンテンツ切替処理--------------------------------------------------------------------------------
        if(CodeInfo.String.includes("************************************************************************")===true)//説明文とコンテンツが切り替わる文字列が含まれているかどうか
        {   
            if(Mode==="なし")//Modeの初期値は”なし”
            Mode="説明文";//説明文モード   
            else if(Mode==="コンテンツ") 
            {
                Mode="説明文";//説明文モード
                BlockNo++;//説明文モードに切り替わった場合、モードグループを１上げる
            }
            else if(Mode==="説明文")
            {
                Mode="コンテンツ";//コンテンツモード
            }
        }
        //----------------------------------------説明文とコンテンツ切替処理終了--------------------------------------------------------------------------------
        //-------------------------------------CodeInfoを作成しCodeAllInfoに格納------------------------------------------------------------------
        if (Mode == "コンテンツ")//コンテンツモードの場合
        {
            CodeInfo.Mode = "コンテンツ"//モード：コンテンツと記録する
            a++;
        }
        else if(Mode=="説明文")//説明文モードの場合
        {
            CodeInfo.Mode = "説明文"//モード：説明文と記録する
            CodeInfo.String = CodeInfo.String.replace("//**", '');
            CodeInfo.String = CodeInfo.String.replace("//*", '');
            CodeInfo.String = CodeInfo.String.replace("//", '');


            CodeInfo.String = CodeInfo.String.trim();
        }
        CodeInfoArray[i] = CodeInfo;
    }
    console.log("CodeAllInfo作成完了");
    //-------------------------------------CodeAInfoを作成しCodeAllInfoに格納終了------------------------------------------------------------------
    //----------------------------------------ブロックごとに配列を作成&分析-----------------------------------------------------
    for (var i = 0; i < BlockNo; i++) {
        //説明文の塊を作成する
        Explains[i] = CodeInfoArray.filter((CodeInfo) => CodeInfo.Mode === "説明文" && CodeInfo.BlockNo === i);
        //コンテンツの塊を作成する
        Contents[i] = CodeInfoArray.filter((CodeInfo) => CodeInfo.Mode === "コンテンツ" && CodeInfo.BlockNo === i);
        ExplainBunseki(Explains[i], i);//説明文を分析
        ContentBunseki(Contents[i], i);//コンテンツを分析
    }
    console.log("ブロックの数=", BlockNo);
    HenkouLog(Explains[0]);

    //----------------------------------------ブロックごとに配列を作成&分析-----------------------------------------------------
    console.log("CodeInfoArrayの各行のオプション情報");
    console.log("=CodeInfoArray[0].Line====行数");
    console.log("=CodeInfoArray[0].String==文字列");
    console.log("=CodeInfoArray[0].Mode====どちらのモードに所属か(説明文orコード本文)");
    console.log("=CodeInfoArray[0].BlockNo=何個目のブロックに所属か");
    console.log("=CodeInfoArray[0].LogID===変更履歴だった場合にIDを格納");
    console.log("=CodeInfoArray[0].LogID===変更履歴だった場合に何個目の履歴かを格納");
    console.log(CodeInfoArray);
};


//*****************************************************************************************************************
//説明文を分析
//***************************************************************************************************************** 
function ExplainBunseki(Explain, i) {
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
    const Code = CodeInfoArray.find((CodeInfo) => { return CodeInfo.BlockNo === i && CodeInfo.Mode === 'コンテンツ' });
    if (i === 0)
        TitleLabel.textContent = Explain[1].String + " " + Code.Line + " " + Contents[i].length;//表示文字列を指定
    else
        TitleLabel.textContent = Explain[0].String + " " + Code.Line + " " + Contents[i].length;//表示文字列を指定

    BLOCKCreate.appendChild(TitleLabel);//配置場所を指定
    //-------コンテンツ作成------------
    var BLOCK_ContentCreate = document.createElement('label');//label要素作成
    BLOCK_ContentCreate.className = 'BLOCK-content';//Classを指定
    BLOCKCreate.appendChild(BLOCK_ContentCreate);//配置場所を指定
    for (var i = 1; i < Explain.length - 1; i++) {
        var BLOCK_Content_SplitCreate = document.createElement('li');//li要素作成
        BLOCK_Content_SplitCreate.textContent = Explain[i].String;//表示文字列を指定
        BLOCK_ContentCreate.appendChild(BLOCK_Content_SplitCreate);//配置場所を指定
    }

    //-------------------------------------コンポーネントとプロセスとその他に分類する------------------------------------------------------------

    if (Explain[0].String.includes('Proccess') === true) {
        BLOCKCreate.className = BLOCKCreate.className + ' Proccess_list';//クラスを指定
        //console.log("プロセス");
    }
    else if (Explain[0].String.includes('Component') === true) {
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
//--------------------------変更履歴コンボボックス作成--------------------------
function HenkouLog(SystemExplain) {
    var L = 0;
    var LogID;
    for (var i = 0; i < SystemExplain.length; i++) {
        //SystemExplain[i].String = SystemExplain[i].String.trim();
        var LogBoolean = SystemExplain[i].String.match(/\<.*?\>/g);//正規表現を使い’<>’が含まれる場合tureにする
        //'<>'が含まれる場合
        if (LogBoolean != null) {
            CodeInfoArray[i].LogID = LogBoolean[0];//変更ログのIDの文字列を記録
            CodeInfoArray[i].LogNo = L;//変更ログのIDの数字を記録
            LogID = CodeInfoArray[i].LogID;
            HenkouKensaku(LogID);//ログIDを使ってコンテンツ内を検索
            // selectタグを取得する
            var select = document.getElementById("LogSelect");
            // optionタグを作成する
            var option = document.createElement("option");
            // optionタグのテキストを変更履歴の文字列に設定する
            option.text = SystemExplain[i].String;
            // optionタグのvalueをログに設定する
            option.value = LogID;
            // selectタグの子要素にoptionタグを追加する
            select.appendChild(option);
            L++;
        }
    }
    console.log("変更履歴格納完了");
}
function HenkouKensaku(LogID) {
    var LogIDPoint = 0;
    for (var a = 0; a < Contents.length; a++) {//コンテンツを一つずつ調べる
        var Content = Contents[a];
        var BeginEnd = false;
        for (var b = 0; b < Content.length; b++) {//コンテンツの行を一つずつ調べる
            var ContentChild = Content[b];
            if (ContentChild.String.includes(LogID) && ContentChild.String.startsWith("//")) {
                var DelREIGAI = (ContentChild.String.match(/\/\//g) || []).length;
                //　文字列に"//"が２つ以上のときはDELと認識し、一行だけ抜き出す。
                if (DelREIGAI === 1) {
                    if (BeginEnd) {
                        ContentChild.LogID = LogID;
                        ContentChild.LogIDPoint = LogIDPoint;
                    }
                    BeginEnd = !BeginEnd;//判定反転
                    if (BeginEnd === false) {
                        LogIDPoint++;
                    }
                }
                else {
                    ContentChild.LogID = LogID;
                    ContentChild.LogIDPoint = LogIDPoint;
                    LogIDPoint++;
                }
            }
            else if (ContentChild.String.includes(LogID)) {//ログＩDが文字の最初ではないときは1行だけ抜き出す。
                ContentChild.LogID = LogID;
                ContentChild.LogIDPoint = LogIDPoint;
                LogIDPoint++;
            }
            if (BeginEnd) {
                ContentChild.LogID = LogID;
                ContentChild.LogIDPoint = LogIDPoint;
            }
        }
    }
}
//ーーーーーーーーーーーーーーーーーーーーーーコンボボックス選択後変更履歴表示ーーーーーーーーーーーーーーーーーーーー
function SelectLogHyouzi() {
    KaKuNiNpoint=0;
    var HenkouLog_element = document.getElementById("HenkouLog");
    while (HenkouLog_element.lastChild) {
        HenkouLog_element.removeChild(HenkouLog_element.lastChild);//変更ログ初期化
    }
    // selectタグを取得する（コンボボックスの履歴IDから検索）
    var select = document.getElementById("LogSelect").value;
    console.log(select);
    LogArray = CodeInfoArray.filter((CodeInfo) => CodeInfo.LogID === select && CodeInfo.LogIDPoint != undefined);
    console.log(LogArray);
    var preBlockNo;//今いる関数名を一次的に記憶

    for (var i = 0; i < LogArray.length; i++) {
        //ログポイントが切り替わったら、グループ化（同ログポイントの最初）
        if (i == 0 || LogArray[i].LogIDPoint != LogArray[i - 1].LogIDPoint)
        {
            if (i == 0 || LogArray[i].BlockNo != preBlockNo) {//前回のログポイントと違う関数だったら関数名を表示
                var LogContent = CodeInfoArray.filter((CodeInfo) => CodeInfo.BlockNo === LogArray[i].BlockNo && CodeInfo.Mode === "コンテンツ");
                var HenkouLog_ChildName = document.createElement('div');//関数名を表示
                HenkouLog_ChildName.className = "HenkouLog_ChildName";
                HenkouLog_ChildName.textContent = LogContent[1].String;
                HenkouLog_element.appendChild(HenkouLog_ChildName);
                preBlockNo = LogArray[i].BlockNo;//今いる関数名を一次的に記憶
            }

            var HenkouLog_Child = document.createElement('div');//変更ログの一つをフィールドを作成
            HenkouLog_Child.className = "HenkouLog_Child";
            HenkouLog_element.appendChild(HenkouLog_Child);
            var LineNo = document.createElement('div');//行エリア生成
            LineNo.className = "LineNo";
            HenkouLog_Child.appendChild(LineNo);
            var highlight = document.createElement('pre');//コードエリア生成
            highlight.className = "Codelog";
            HenkouLog_Child.appendChild(highlight);
            var highlight2 = document.createElement('code');//コードエリア生成２
            highlight2.className = "delphi";
            highlight.appendChild(highlight2);
        }
        LogKaKuNiN(i, HenkouLog_Child);
        var LineNo2 = document.createElement('li');
        LineNo2.className = "LineNoChild";
        LineNo2.textContent = LogArray[i].Line;
        LineNo.appendChild(LineNo2);
        if (i == 0 || LogArray[i].LogIDPoint != LogArray[i - 1].LogIDPoint)
            highlight2.textContent = LogArray[i].String;//文字列を作成していく
        else
            highlight2.textContent = highlight2.textContent + "\n" + LogArray[i].String;//文字列を作成していく
    }
    hljs.initHighlightingOnLoad();
}
//赤枠の確認欄作成ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
function LogKaKuNiN(i, HenkouLog_Child) {
    if (i == 0 || LogArray[i].LogIDPoint != LogArray[i - 1].LogIDPoint) {//ログポイントが切り替わったら確認フィールドを作成
        var KAKUNIN_childstring = "";
        KaKuNiN_list = document.createElement('div');
        KaKuNiN_list.className = "KaKuNiN_list";
        HenkouLog_Child.appendChild(KaKuNiN_list);
        KaKuNiN_TUUKA = false;//確認通過リセット
    }
    if (LogArray[i].String.trim().startsWith("//") === false && LogArray[i].String.trim().startsWith("{") === false) {//コメントアウトされてないもの
        if (LogArray[i].String.includes('if') || KaKuNiN_TUUKA === false) {//この中に入ったら赤枠作成
            KaKuNiNpoint++;
            var KaKuNiN = document.createElement('div');
            KaKuNiN.className = "KaKuNiN";
            KaKuNiN_list.appendChild(KaKuNiN);
            var KaKuNiN_child = document.createElement('li');
            KaKuNiN_child.className = "KaKuNiN_child";
            KaKuNiN_child.contentEditable = true;
            KaKuNiN.appendChild(KaKuNiN_child);
            //以下分岐の処理
            if (LogArray[i].String.includes('if') && LogArray[i].String.startsWith("//") === false) {
                KAKUNIN_childstring = "分岐確認";
                var ifString = LogArray[i].String.trim().replace(/\t/, " ");//タブ文字を空白に変換
                if (/if not /i.test(ifString) === true) {//if Not の場合
                    var XXXbegin = ifString.search(/if not[\( ]/i) + 7;
                }
                else {
                    var XXXbegin = ifString.search(/if[\( ]/) + 3;
                }
                var XXXend = ifString.search(/[\) ](then|AND|OR|\<|\>|\=)/i);
                //substring()で指定した文字以降を切り出し。
                var XXX = ifString.substring(XXXbegin, XXXend);
                var A = "True";
                var B = "False";
                var C = "";

                if (ifString.search(/( \<| \>| \=)/) != -1 && ifString.search(/true|false/i) === -1) {//書き換える
                    var Abegin = ifString.search(/(\< |\> |\= )/);
                    var Aend = ifString.search(/[\) ](then|AND|OR)/i);
                    A = ifString.substring(Abegin + 2, Aend);
                    A = A.replace(')', "");
                    A = A.replace('then', "");
                    B = "?";
                }
                if (ifString.search(/[\) ](AND|OR)/i) != -1) {//ANDかORが含まれていた場合
                    C = "\nまたは、かつ";
                }
                var KaKuNiN_child2 = document.createElement('li');//確認要素二行目
                KaKuNiN_child2.className = "KaKuNiN_child2";
                KaKuNiN_child2.contentEditable = true;
                KaKuNiN_child2.textContent = XXX + "の値が（" + A + "," + B + "）で分岐" + C;
                KaKuNiN.appendChild(KaKuNiN_child2);
                KaKuNiN_TUUKA = true;//確認通過
            }
            //以下通過の処理
            else if (KaKuNiN_TUUKA === false) {
                //console.log(LogArray[i]);
                KAKUNIN_childstring = "通過確認";
                KaKuNiN_TUUKA = true;//確認通過
            }
            KaKuNiN_child.textContent = "No" + KaKuNiNpoint + "  " + KAKUNIN_childstring;
        }
    }
}
//*****************************************************************************************************************
//*****************************************************************************************************************
//コンテンツを分析
//*****************************************************************************************************************
//*****************************************************************************************************************
function ContentBunseki(Content, i) {
    //最初のコンテンツのみ、宣言分析関数を使う。
    if (i === 0)
        for (var a = 0; a < Content.length - 1; a++) {
            SengenBunseki(Content[a]);
        }
    else
        for (var a = 0; a < Content.length - 1; a++) {
            CommentOutBunri(Content[a]);
        }

}

//-----------------コンテンツのコードとコメントを区別する関数-----------------------------------------------------------
function CommentOutBunri(ContentChild) {

    //[i]番目の行にコメントアウトがある場合、コメントアウト部分のみ抜き出す。
    if (ContentChild.String.includes('//')) {
        Surash = ContentChild.String.indexOf('//'); //ダブルスラッシュの位置の数字を抜き出す
        Comment_ = ContentChild.String.substring(Surash + 2);//ダブルスラッシュ以降の文字を抽出
        ContentChild.Code = ContentChild.String.replace('//' + Comment_, "");//コメントを文字列から削除
        CommentCreate = document.createElement('span');//div要素作成
        CommentCreate.className = 'Comment_list';//Classを指定
        CommentCreate.textContent = Comment_;//表示文字列を指定
        ContentChild.Comment = Comment_;//コメントオブジェクトを生成
        //console.log(i, Comment_);//確認　
    }
    else {
        ContentChild.Code = ContentChild.String;
        ContentChild.Comment = "";
    }
}
//-------------------------------------宣言部分を分類する関数------------------------------------------------------------
function SengenBunseki(ContentChild) {
    //一行ずつ特定の言葉を含んでいないか検査
    ContentChild.String = ContentChild.String.trim();
    CommentOutBunri(ContentChild);

    //[i]番目の行　検査開始
    if (ContentChild.Code.toUpperCase().startsWith('CONST') === true) {
        SENGENcheck = "Const";
    }
    else if (ContentChild.Code.toUpperCase().startsWith('TYPE') === true) {
        SENGENcheck = "Type";
    }
    else if (ContentChild.Code.toUpperCase().startsWith('PUBLIC') === true) {
        SENGENcheck = "Public";
    }
    else if (ContentChild.Code.toUpperCase().startsWith('PRIVATE') === true) {
        SENGENcheck = "Private";
    }
    else if (ContentChild.Code.toUpperCase().startsWith('FUNCTION') === true) {
        SENGENcheck = "Function";
    }
    else if (ContentChild.Code.toUpperCase().startsWith('PROCEDURE') === true) {
        SENGENcheck = "Procedure";
    }
    //[i]番目の行　検査終了

    //続いてHTMLに配置
    var Sengen_listCreate = document.createElement('li');//li要素作成
    Sengen_listCreate.textContent = ContentChild.Code;//表示文字列を指定

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
    //コメントが含まれている場合配置
    if (ContentChild.Comment != "")
        Sengen_listCreate.appendChild(CommentCreate);//配置場所を指定

}

