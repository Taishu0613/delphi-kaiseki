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
            CBunseki(ContentB);
            a++;
        }
        else if (i % 2 == 1) {
            Expalin[b] = cut1[i];
            Expalin[b] = Expalin[b].replace(/[//]/g, '');
            Expalin[b] = Expalin[b].replace(/[//*]/g, '');
            Expalin[b] = Expalin[b].replace(/[//**]/g, '');

            //console.log(b, "個目");
            ExplainB = Expalin[b];
            Bunseki(ExplainB);

            b++;
        }
    }
};

function CBunseki(ContentB) {
    var ContentChild = [];
    ContentChild = ContentB.split("\n");
    if(a==0)//最初のコンテンツのみ、宣言分析関数を使う。
     SengenBunseki(ContentChild);
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
    AllLineCnt = AllLineCnt + (ExplainChild.length + LineCnt[b] + 2);
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

    //console.log(RESULT[i]); 

};

function SengenBunseki(ContentChild){
    var SENGENcheck;
    for(var i =0 ;i < ContentChild.length;i++)
    {
        ContentChild[i]=ContentChild[i].trim();
        if(ContentChild[i].toUpperCase().startsWith('CONST')=== true)
        {
            SENGENcheck="Const";
        }
        else if(ContentChild[i].toUpperCase().startsWith('TYPE')=== true)
        {
            SENGENcheck="Type";
        }
        else if(ContentChild[i].toUpperCase().startsWith('PUBLIC')=== true)
        {
            SENGENcheck="Public";
        }
        else if(ContentChild[i].toUpperCase().startsWith('PRIVATE')=== true)
        {
            SENGENcheck="Private";
        }
        else if(ContentChild[i].toUpperCase().startsWith('FUNCTION')=== true)
        {
            SENGENcheck="Function";
        }
        else if(ContentChild[i].toUpperCase().startsWith('PROCEDURE')=== true)
        {
            SENGENcheck="Procedure";
        }
        console.log(ContentChild[i]);//確認
        if (SENGENcheck==="Const"){
            ContentChild[i]
            var Const_listCreate = document.createElement('li');//li要素作成
            Const_listCreate.textContent = ContentChild[i];//表示文字列を指定
            Const_list.appendChild(Const_listCreate);//配置場所を指定
        }
        if (SENGENcheck==="Type"){
            ContentChild[i]
            var Type_listCreate = document.createElement('li');//li要素作成
            Type_listCreate.textContent = ContentChild[i];//表示文字列を指定
            Type_list.appendChild(Type_listCreate);//配置場所を指定
        }
        if (SENGENcheck==="Public"){
            ContentChild[i]
            var Public_listCreate = document.createElement('li');//li要素作成
            Public_listCreate.textContent = ContentChild[i];//表示文字列を指定
            Public_list.appendChild(Public_listCreate);//配置場所を指定
        }
        if (SENGENcheck==="Private"){
            ContentChild[i]
            var Private_listCreate = document.createElement('li');//li要素作成
            Private_listCreate.textContent = ContentChild[i];//表示文字列を指定
            Private_list.appendChild(Private_listCreate);//配置場所を指定
        }
        if (SENGENcheck==="Function"){
            ContentChild[i]
            var Function_listCreate = document.createElement('li');//li要素作成
            Function_listCreate.textContent = ContentChild[i];//表示文字列を指定
            Function_list.appendChild(Function_listCreate);//配置場所を指定
        }
        if (SENGENcheck==="Procedure"){
            ContentChild[i]
            var Procedure_listCreate = document.createElement('li');//li要素作成
            Procedure_listCreate.textContent = ContentChild[i];//表示文字列を指定
            Procedure_list.appendChild(Procedure_listCreate);//配置場所を指定
        }
    }
  
}

