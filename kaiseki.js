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
var cut1 = [];//コード内容と、説明文に分ける
var Explains = [];//説明文達の配列
var ContentB = "";//コンテンツ内容
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
var GyouCount;  //確認idの付与必要
var HukusuComment=false;//複数行のコメントアウト判定用
var HenkouLog_element = document.getElementById("HenkouLog");
var FirstKakuninNo = 0;
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
    strsplit = str.split("\n");//全てのコードを改行で配列に組み込む
    for (var i = 0; i < strsplit.length; i++) {
        var CodeInfo = {};
        CodeInfo.String = strsplit[i];//コードの文字列を記録 //インデントを消すかどうかだよ
        //CodeInfo.String=strsplit[i].trim();//インデントを消すかどうかだよ
        CodeInfo.Line = i;//コードの行数を記録
        CodeInfo.BlockNo = BlockNo;//何個目の説明文とコンテンツかを記録
        //----------------------------------------説明文とコンテンツ切替処理--------------------------------------------------------------------------------
        if (CodeInfo.String.includes("************************************************************************") === true)//説明文とコンテンツが切り替わる文字列が含まれているかどうか
        {
            if (Mode === "なし")//Modeの初期値は”なし”
                Mode = "説明文";//説明文モード   
            else if (Mode === "コンテンツ") {
                Mode = "説明文";//説明文モード
                BlockNo++;//説明文モードに切り替わった場合、モードグループを１上げる
            }
            else if (Mode === "説明文") {
                Mode = "コンテンツ";//コンテンツモード
            }
        }
        //----------------------------------------説明文とコンテンツ切替処理終了--------------------------------------------------------------------------------
        //-------------------------------------CodeInfoを作成しCodeInfoArrayに格納------------------------------------------------------------------
        if (Mode == "コンテンツ")//コンテンツモードの場合
        {
            CodeInfo.Mode = "コンテンツ"//モード：コンテンツと記録する
            a++;
        }
        else if (Mode == "説明文")//説明文モードの場合
        {
            CodeInfo.Mode = "説明文"//モード：説明文と記録する
            CodeInfo.String = CodeInfo.String.trim();
        }
        CodeInfoArray[i] = CodeInfo;
    }
    console.log("CodeInfoArray作成完了");
    //-------------------------------------CodeInfoを作成しCodeInfoArrayに格納終了------------------------------------------------------------------
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
        //Explain[i].String = Explain[i].String.replace("//", '');
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
function SortCode() {
    var checkedC = document.getElementById("sortCompornent").checked;
    var checkedP = document.getElementById("sortProcess").checked;
    var checkedO = document.getElementById("sortOther").checked;
    var checked = document.getElementById("sortAll").checked;
    var aa = document.querySelectorAll(".Proccess_list, .Component_list, .Sonota_list");
    var cc = document.querySelectorAll(".Proccess_list, .Sonota_list");
    var pp = document.querySelectorAll(".Component_list, .Sonota_list");
    var oo = document.querySelectorAll(".Proccess_list, .Component_list");
    //if(checked){
    for (var i = 0; i < aa.length; i++) {
        aa[i].style.display = "block";
    }
    //}
    if (checkedC == true) {
        for (var i = 0; i < cc.length; i++) {
            cc[i].style.display = "none";
        }
    }
    if (checkedP == true) {
        for (var i = 0; i < pp.length; i++) {
            pp[i].style.display = "none";
        }
    }
    if (checkedO == true) {
        for (var i = 0; i < oo.length; i++) {
            oo[i].style.display = "none";
        }
    }
}
//--------------------------変更履歴コンボボックス作成--------------------------
function HenkouLog(SystemExplain) {
    var L = 0;
    var LogID;
    // for (var i = 0; i < SystemExplain.length; i++) {
    //     //SystemExplain[i].String = SystemExplain[i].String.trim();
    //     var LogBoolean = SystemExplain[i].String.match(/\<.*?\>/g);//正規表現を使い’<>’が含まれる場合tureにする
    //     //'<>'が含まれる場合
    //     if (LogBoolean != null) {
    //         CodeInfoArray[i].LogID = LogBoolean[0];//変更ログのIDの文字列を記録
    //         CodeInfoArray[i].LogNo = L;//変更ログのIDの数字を記録
    //         LogID = CodeInfoArray[i].LogID;
    //         HenkouKensaku(LogID);//ログIDを使ってコンテンツ内を検索
    //         // selectタグを取得する
    //         var select = document.getElementById("LogSelect");
    //         // optionタグを作成する
    //         var option = document.createElement("option");
    //         // optionタグのテキストを変更履歴の文字列に設定する
    //         option.text = SystemExplain[i].String;
    //         // optionタグのvalueをログに設定する
    //         option.value = LogID;
    //         // selectタグの子要素にoptionタグを追加する
    //         select.appendChild(option);
    //         L++;
    //     }
    // }
    //Unit～より上でログIDを検索する時＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
    var Unit = /unit/g;
    var UnitNo=0;
    while(Unit.test(CodeInfoArray[UnitNo].String)===false ||CodeInfoArray[UnitNo].String.trim().startsWith("//")===true){
        UnitNo++;
    }
    for (var i = 0; i < UnitNo; i++) {
        var LogBoolean = CodeInfoArray[i].String.match(/\<.*?\>/g);//正規表現を使い’<>’が含まれる場合tureにする
        //'<>'が含まれる場合
        if (LogBoolean != null) {
            CodeInfoArray[i].LogID = LogBoolean[0];//変更ログのIDの文字列を記録
            CodeInfoArray[i].LogNo = L;//変更ログのIDの数字を記録
            LogID = CodeInfoArray[i].LogID;
            HenkouKensakuVer2(LogID,UnitNo);//ログIDを使ってコンテンツ内を検索
            // selectタグを取得する
            var select = document.getElementById("LogSelect");
            // optionタグを作成する
            var option = document.createElement("option");
            // optionタグのテキストを変更履歴の文字列に設定する
            option.text = CodeInfoArray[i].String;
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
            if (ContentChild.String.includes(LogID) && ContentChild.String.startsWith("//")) {//コメントアウトでログIDが見つかった場合
                var DelREIGAI = (ContentChild.String.match(/\/\//g) || []).length;
                //　文字列に"//"が２つ以上のときはDELと認識し、一行だけ抜き出す。
                if (DelREIGAI === 1) {//DelREIGAIではない時（通常の処理）
                    if (BeginEnd) {
                        ContentChild.LogID = LogID;
                        ContentChild.LogIDPoint = LogIDPoint;
                    }
                    BeginEnd = !BeginEnd;//判定反転
                    if (BeginEnd === false) {
                        LogIDPoint++;
                    }
                }
                else {//DelREIGAIの時
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
function HenkouKensakuVer2(LogID,UnitNo) {
    var LogIDPoint = 0;
    var BeginEnd = false;
    for (var b = UnitNo; b < CodeInfoArray.length; b++) {//CodeInfoArray(全てのプログラム)の行を一つずつ調べる
        var CodeInfo = CodeInfoArray[b];
        if (CodeInfo.String.includes(LogID) && CodeInfo.String.startsWith("//")) {//コメントアウトでログIDが見つかった場合
            var DelREIGAI = (CodeInfo.String.match(/\/\//g) || []).length;
            //　文字列に"//"が２つ以上のときはDELと認識し、一行だけ抜き出す。
            if (DelREIGAI === 1) {//DelREIGAIではない時（通常の処理）
                if (BeginEnd) {
                    CodeInfo.LogID = LogID;
                    CodeInfo.LogIDPoint = LogIDPoint;
                }
                BeginEnd = !BeginEnd;//判定反転
                if (BeginEnd === false) {
                    LogIDPoint++;
                }
            }
            else {//DelREIGAIの時
                CodeInfo.LogID = LogID;
                CodeInfo.LogIDPoint = LogIDPoint;
                LogIDPoint++;
            }
        }
        else if (CodeInfo.String.includes(LogID)) {//ログＩDが文字の最初ではないときは1行だけ抜き出す。
            CodeInfo.LogID = LogID;
            CodeInfo.LogIDPoint = LogIDPoint;
            LogIDPoint++;
        }
        if (BeginEnd) {
            CodeInfo.LogID = LogID;
            CodeInfo.LogIDPoint = LogIDPoint;
        }
    }
    
}
//ーーーーーーーーーーーーーーーーーーーーーーコンボボックス選択後変更履歴表示ーーーーーーーーーーーーーーーーーーーー
function HENSUset(){
    FirstKakuninNo=Number(document.getElementById("firstKakuninNo").value)-1;
}
function SelectLogHyouzi() {
    KaKuNiNpoint = 0;
    while (HenkouLog_element.lastChild) {
        HenkouLog_element.removeChild(HenkouLog_element.lastChild);//変更ログ初期化
    }
    var leader_lines = document.getElementsByClassName("leader-line");
    if (0 < leader_lines.length) {
        while (leader_lines.length) {
            leader_lines.item(0).remove();//leader-lineの線初期化
        }
    }
    // selectタグを取得する（コンボボックスの履歴IDから検索）
    var select = document.getElementById("LogSelect").value;
    console.log(select);
    LogArray = CodeInfoArray.filter((CodeInfo) => CodeInfo.LogID === select && CodeInfo.LogIDPoint != undefined);
    console.log(LogArray);
    var preBlockNo;//今いる関数名を一次的に記憶

    for (var i = 0; i < LogArray.length; i++) {
        //ログポイントが切り替わったら、グループ化（同ログポイントの最初）
        if (i == 0 || LogArray[i].LogIDPoint != LogArray[i - 1].LogIDPoint) {
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
            highlight2.id = "LogIDポイント" + LogArray[i].LogIDPoint;
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
    hljs.initHighlightingOnLoad();//一旦ライブラリのハイライト追加
    highlight2.textContent.split("\n");//その後もう一度spanタグを入れるため繰り返し処理
    for (var i = 0; i <= LogArray[LogArray.length - 1].LogIDPoint; i++) {
        var NowLogIDp = document.getElementById("LogIDポイント" + i)
        NowLogIDp.innerHTML = "<span id =" + i + "1番目の行>" + NowLogIDp.innerHTML + "</span>";
        var ComentElements = NowLogIDp.getElementsByClassName('hljs-comment');
        for (var b = 0; b < ComentElements.length; b++) {
            var count = (ComentElements[b].textContent.match(/\n/g) || []).length;//コメントタグの中の改行の個数
            if (count > 1) {//以下複数行のコメントアウトを1行ずつのコメントアウト判定に変更
                ComentElements[b].innerHTML ="<span>" + ComentElements[b].innerHTML + "</span>";
                ComentElements[b].innerHTML = ComentElements[b].innerHTML.replace(/\n/g, "</span>\n<span>");
                if (ComentElements[b].lastChild.textContent === "")//Spanタグが余分にできたかどうか
                    ComentElements[b].removeChild(ComentElements[b].lastChild);//余分にできたSpanタグを削除
                var ComentElements_child_count = ComentElements[b].childElementCount;
                for (var a = 0; a < ComentElements_child_count; a++) {
                    ComentElements[b].children[a].className = "hljs-comment";//コメントタグをつけなおす
                }
                ComentElements[b].id="削除対象";
                var Sakuzyo_taisyou= document.getElementById("削除対象");
                while (Sakuzyo_taisyou.firstChild) {// 親要素から最初の子要素を取得して親要素の上に子要素を移動
                    Sakuzyo_taisyou.parentNode.insertBefore(Sakuzyo_taisyou.firstChild, Sakuzyo_taisyou);
                }
                Sakuzyo_taisyou.remove();// 空の親要素を削除
            }
        }
        
        NowLogIDp.innerHTML = NowLogIDp.innerHTML.replace(/\n/g, "</span>\n<span>");//改行ごとにspanタグ
        if (NowLogIDp.lastChild.textContent === "")//Spanタグが余分にできたかどうか
            NowLogIDp.removeChild(NowLogIDp.lastChild);//余分にできたSpanタグを削除
        var NowLogIDp_child_count = NowLogIDp.childElementCount;
        console.log(NowLogIDp_child_count);
        for (var a = 0; a < NowLogIDp_child_count; a++) {
            NowLogIDp.children[a].id = (i + 1) + "の" + (a + 1) + "行目";//0始まりなので、1を+する
        }
        KakuninYazirushi(i);
    }
}
function SelectLogHyouziVer2() {
    if(FirstKakuninNo===0)
    KaKuNiNpoint = 0;
    else
    KaKuNiNpoint=FirstKakuninNo;
    while (HenkouLog_element.lastChild) {
        HenkouLog_element.removeChild(HenkouLog_element.lastChild);//変更ログ初期化
    }
    var leader_lines = document.getElementsByClassName("leader-line");
    if (0 < leader_lines.length) {
        while (leader_lines.length) {
            leader_lines.item(0).remove();//leader-lineの線初期化
        }
    }
    // selectタグを取得する（コンボボックスの履歴IDから検索）
    var select = document.getElementById("LogSelect").value;
    console.log(select);
    LogArray = CodeInfoArray.filter((CodeInfo) => CodeInfo.LogID === select && CodeInfo.LogIDPoint != undefined);
    console.log(LogArray);
    var preBlockNo;//今いる関数名を一次的に記憶

    for (var i = 0; i < LogArray.length; i++) {
        //ログポイントが切り替わったら、グループ化（同ログポイントの最初）
        if (i == 0 || LogArray[i].LogIDPoint != LogArray[i - 1].LogIDPoint) {
            if (i == 0 || LogArray[i].BlockNo != preBlockNo) {//前回のログポイントと違う関数だったら関数名を表示
                var LogContent = CodeInfoArray.filter((CodeInfo) => CodeInfo.BlockNo === LogArray[i].BlockNo && CodeInfo.Mode === "コンテンツ");
                var a =1;
                while(LogContent[a].String.startsWith("//")===true)//万が一関数名があるべき場所にコメントアウトされていたら一つ下の行に
                    a++;
                var HenkouLog_ChildName = document.createElement('div');//関数名を表示
                HenkouLog_ChildName.className = "HenkouLog_ChildName";
                HenkouLog_ChildName.contentEditable = true;
                HenkouLog_ChildName.textContent = LogContent[a].String;
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
            highlight2.id = "LogIDポイント" + LogArray[i].LogIDPoint;
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
    hljs.initHighlightingOnLoad();//一旦ライブラリのハイライト追加
    highlight2.textContent.split("\n");//その後もう一度spanタグを入れるため繰り返し処理
    for (var i = 0; i <= LogArray[LogArray.length - 1].LogIDPoint; i++) {
        var NowLogIDp = document.getElementById("LogIDポイント" + i)
        NowLogIDp.innerHTML = "<span id =" + i + "1番目の行>" + NowLogIDp.innerHTML + "</span>";
        var ComentElements = NowLogIDp.getElementsByClassName('hljs-comment');
        for (var b = 0; b < ComentElements.length; b++) {
            var count = (ComentElements[b].textContent.match(/\n/g) || []).length;//コメントタグの中の改行の個数
            if (count > 1) {//以下複数行のコメントアウトを1行ずつのコメントアウト判定に変更
                ComentElements[b].innerHTML ="<span>" + ComentElements[b].innerHTML + "</span>";
                ComentElements[b].innerHTML = ComentElements[b].innerHTML.replace(/\n/g, "</span>\n<span>");
                if (ComentElements[b].lastChild.textContent === "")//Spanタグが余分にできたかどうか
                    ComentElements[b].removeChild(ComentElements[b].lastChild);//余分にできたSpanタグを削除
                var ComentElements_child_count = ComentElements[b].childElementCount;
                for (var a = 0; a < ComentElements_child_count; a++) {
                    ComentElements[b].children[a].className = "hljs-comment";//コメントタグをつけなおす
                }
                ComentElements[b].id="削除対象";
                var Sakuzyo_taisyou= document.getElementById("削除対象");
                while (Sakuzyo_taisyou.firstChild) {// 親要素から最初の子要素を取得して親要素の上に子要素を移動
                    Sakuzyo_taisyou.parentNode.insertBefore(Sakuzyo_taisyou.firstChild, Sakuzyo_taisyou);
                }
                Sakuzyo_taisyou.remove();// 空の親要素を削除
            }
        }
        
        NowLogIDp.innerHTML = NowLogIDp.innerHTML.replace(/\n/g, "</span>\n<span>");//改行ごとにspanタグ
        if (NowLogIDp.lastChild.textContent === "")//Spanタグが余分にできたかどうか
            NowLogIDp.removeChild(NowLogIDp.lastChild);//余分にできたSpanタグを削除
        var NowLogIDp_child_count = NowLogIDp.childElementCount;
        console.log(NowLogIDp_child_count);
        for (var a = 0; a < NowLogIDp_child_count; a++) {
            NowLogIDp.children[a].id = (i + 1) + "の" + (a + 1) + "行目";//0始まりなので、1を+する
        }
        KakuninYazirushi(i);
    }
}
//赤枠の確認欄作成ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
function LogKaKuNiN(i, HenkouLog_Child) {
    if (i == 0 || LogArray[i].LogIDPoint != LogArray[i - 1].LogIDPoint) {//ログポイントが切り替わったら確認フィールドを作成
        var KAKUNIN_childstring = "";
        KaKuNiN_list = document.createElement('div');
        KaKuNiN_list.className = "KaKuNiN_list";
        KaKuNiN_list.id = "KaKuNiN_list" + (LogArray[i].LogIDPoint + 1);
        HenkouLog_Child.appendChild(KaKuNiN_list);
        KaKuNiN_TUUKA = false;//確認通過リセット
        GyouCount = 0;
    }
    GyouCount++;
    if (LogArray[i].String.trim().startsWith("{"))
        HukusuComment=true;
    else if(i!=0&&LogArray[i-1].String.trim().startsWith("}"))
        HukusuComment=false;
    if (LogArray[i].String.trim().startsWith("//") === false && HukusuComment === false &&LogArray[i].String.trim() != "") {//コメントアウトされてないもの
        if (LogArray[i].String.includes('if') || KaKuNiN_TUUKA === false) {//この中に入ったら赤枠作成
            KaKuNiNpoint++;
            var KaKuNiN = document.createElement('div');
            KaKuNiN.className = "KaKuNiN";
            KaKuNiN.id = (LogArray[i].LogIDPoint + 1) + "の" + GyouCount + "行目確認";
            KaKuNiN_list.appendChild(KaKuNiN);
            var KaKuNiN_child = document.createElement('li');
            KaKuNiN_child.className = "KaKuNiN_child";
            KaKuNiN_child.contentEditable = true;
            KaKuNiN.appendChild(KaKuNiN_child);
            //以下分岐の処理
            if (LogArray[i].String.includes('if') && LogArray[i].String.startsWith("//") === false) {//この中のに入ったら分岐確認
                KAKUNIN_childstring = "分岐確認";
                var ifString = LogArray[i].String.trim().replace(/\t/, " ");//タブ文字を空白に変換
                var A = "True";//左側
                var B = "False";//右側の選択肢
                var C = "";//AND・ORが続く時用
                var D = "";
                var E = "";
                var F="";
                //以下一つ目の条件判定
                if (/if not /i.test(ifString) === true) //if Not の場合
                    var XXXbegin = ifString.search(/if not[\( ]/i) + 7;
                else 
                    var XXXbegin = ifString.search(/if[\( ]/) + 3;
                var XXXend = ifString.search(/[\) ](then|AND|OR|\<|\>|\=)/i);
                //substring()で指定した文字以降を切り出し。
                var XXX = ifString.substring(XXXbegin, XXXend);
                var ifend1 = ifString.search(/[\) ](then|AND|OR)/i);
                var ifString1 = ifString.substring(0, ifend1);//1つ目の条件文
                if (ifString1.search(/( \<| \>| \=)/) != -1 && ifString1.search(/true/i) === -1) {//選択肢を書き換える
                    var Abegin = ifString1.search(/(\< |\> |\= )/);
                    A = ifString1.substring(Abegin + 2);
                    A = A.replace(')', "");
                    A = A.replace('then', "");
                    B = "?";
                    if (ifString1.search(/false/i) != -1) {
                        B = "True";
                    }
                }
                //以下2つ目の条件判定
                if (ifString.search(/[\) ](AND|OR)/i) != -1) {//ANDかORが含まれていた場合
                    if (ifString.search(/[\) ](AND)/i) != -1)
                    C = "<br> かつ<br>";
                    if (ifString.search(/[\) ](OR)/i) != -1)
                    C = "<br> または<br>";
                    D = "True";//左側
                    E = "False";//右側の選択肢
                    F = "XXXの値が（" + D + "," + E + "）";
                }
                var KaKuNiN_child2 = document.createElement('li');//確認要素二行目
                KaKuNiN_child2.className = "KaKuNiN_child2";
                KaKuNiN_child2.contentEditable = true;
                KaKuNiN_child2.innerHTML = XXX + "の値が（" + A + "," + B + "）"+ C+F+"で分岐" ;
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
function KakuninYazirushi(i) {
    var KaKuNiN_list_i = document.getElementById("KaKuNiN_list" + (i + 1));
    var KaKuNiN_count = KaKuNiN_list_i.childElementCount;
    console.log("確認の数" + KaKuNiN_count);
    for (var a = 0; a < KaKuNiN_count; a++) {//確認リストの中の個数だけ繰り返す
        var KaKuNiN_id = KaKuNiN_list_i.children[a].id;
        var Line_id = KaKuNiN_id.replace(/確認/, "");//行IDは確認ＩＤから確認という文字を消したＩＤと合致する
        //行IDと一致する要素を
        new LeaderLine(
            KaKuNiN_list_i.children[a],
            document.getElementById(Line_id),
            {
                size: 2,
                path: "straight",
                color: 'red'
            }
        );
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

