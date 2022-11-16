//*************************************************************************
//  System      :   Galileopt債務管理
//  Program     :　	支払通知書情報印刷処理
//  ProgramID   :	PAY500100
//  Name        :   K.IKEMURA (RIT)
//  Create      :	2002 / 01 / 16
//  Comment     :   XXXX注意事項等XXXXXXXXXXXXX
//              :   XXXXXXXXXXXXXXXXXXXXXXXXX
//	History	  	:	2005/07/28	イワムラ
//								FX対応
//				:	2005/11/08	Y.Kabashima(MSI)
//						<#001>	連想順対応
//					2005/11/11	Y.Kabashima(MSI)
//						<#002>	MLからのバグ修正
//				: 	2006/03/22	H.Kawato (MSI)
//						<#003>	集金/送付区分に「その他」を追加
//								MICSでの「ﾊｶﾞｷ」に相当（評価レポートNo T-2219）
//				:   2006/04/03  H.Kawato (MSI)
//						<#004>	連想順選択時、同一連想の範囲指定が
//								正しく動作しないのを修正
//				:   2006/05/10  H.Kawato (MSI)
//						<#005>	郵送区分「する」「しない」を「郵送する」「郵送しない」に変更
//              :   2006/07/21  Y.Naganuma(MSI)
//                      <#006>  手形連動対応
//              :   2006/07/27  Y.Naganuma(MSI)
//                      <#007>  スピードアップ対応
//				:	2006/09/25	Y.Kabashima (MSI)
//						<#008>	AnsiQuotedStr対応
//              :   2007/01/10  Y.Kabashima (MSI)
//                      <#009>  プロジェクト別支払対応
//              :   2007/05/08  Y.Naganuma (MSI)
//                      <#010>	支払方法で相殺を選択できない不具合を修正
//              :   2007/05/21  Y.Naganuma(MSI)
//                      <#011>  スピードアップ対応
//              :   2007/06/05  H.Kawato(MSI)
//                      <#012>  支払出力範囲に「0:諸口」の入力ができるよう修正
//              :   2007/09/11  H.Kawato(MSI)
//                      <#013>  預かり源泉税・支払調書対応
//              :   2008/02/29  H.Kawato(MSI)
//                      <#014>  通知書名寄せ対応
//					2008/11/17  イワムラ
//						<#015>	工事関連支払対応
//					2008/12/22  T.SATOH(IDC)
//						<#016>	発行年月日の空Enter対応
//					2008/12/25  T.SATOH(IDC)
//						<#017>	連想順の場合、そのままＯＫボタンを押せない事があった
//					2009/01/19  T.SATOH(IDC)
//						<#018>	手形送付案内改良(GBY-0034)
//					2009/06/30  T.SATOH(IDC)
//						<#019>	支払先名称に長体(デザインのみ)
//					2009/07/08  T.SATOH(IDC)
//						<#020>	タックシール対応
//				:	2010/11/22  T.SATOH(GSOL)
//						<#021>	支払通知書メール配信対応
//				:	2011/05/10  T.SATOH(GSOL)
//						<#022>	印刷・プレビュー後、発行年月日が初期値に戻る点を修正
//                  2012/02/07  T.SATOH(GSOL)
//                      <KDS>   ShiftState対応
//                  2014/06/25  T.SATOH(GSOL)
//                      <#C16>  取引先コード16桁対応(デザインのみ)
//                  2016/10/28  KUMO
//                      <#023>  メール配信ＰＤＦファイル保存対応
//				:	2020/06/11  T.SATOH(GSOL)
//						<#ERW>	支払方法指定電子記録債権対応
//					2022/11/07  T.Wakasugi
//					    <#024>	タックシール印刷郵便記号印字有無チェックボックス追加
//
//*************************************************************************
unit Pay510100Dlgu;

interface

uses
  Windows, Messages, SysUtils, Classes, VCL.Graphics, VCL.Controls, VCL.Forms, VCL.Dialogs, MJSCommonDialogs,
  VCL.StdCtrls, MJSCheckBox, VCL.ExtCtrls, MJSPanel, MJSEdits, MJSLabel, Buttons,
  MJSBitBtn, MJSComboBox, MJSGroupBox, MJSQuery, FireDAC.Comp.Client,
  MjsCommonu,MasComu, MasMonth,MjsMsgstdu, MjsDateCtrl,
  MjsDBModuleu,MjsDispCtrl, MjsStrCtrl,MasWndIFu,
  MjsCoReportsPrint, MjsCoReportsProperty, MjsCoReportsData,
  MjsCommon3u,
  MJSKeyDataState,		// <KDS> ADD
  CoReports_TLB,PAY510100Comu, Db, dxmdaset, MJSRadioButton,
  Variants;

type
  {$I ActionInterface.inc}
  {$include PAYBaseInfo_h.inc} 			 		// 支払情報管理

  TFileType = (	ftNoticeDoc, 	//	支払通知書
				ftTegata,		//	手形送付案内
				ftKakitome,		//	書留郵便物受領証
				ftTackSeal,		//	タックシール <#020> ADD

				ftBasicLayout,	//	基本レイアウト
				ftToriDtl,		//	取引明細
				ftTegataDtl,	//	手形明細
				ftKoujoDtl,		//	控除明細
				ftKijitsuDtl	//	期日取引明細
  				);

// 2007/01/10 Y.Kabashima Add <#009>
	PMasterInfoRecord = ^ TMasterInfoRecord;
	TMasterInfoRecord = record
		MasterKbn  : Integer;
		CodeDigit  : Integer;
		CodeAttr   : Integer;
		JHojyoName : String;
		UseKbn     : Integer;
	end;
// 2007/01/10 Y.Kabashima Add <#009>

  TPAY510100Dlgf = class(TForm)
    FootPPanel: TMPanel;
    SB_OK: TMBitBtn;
    SB_CANCEL: TMBitBtn;
    MPanel_NoticeDoc: TMPanel;
    MGroupBox1: TMGroupBox;
    MLabel9: TMLabel;
    MCombo_LetterKbn: TMComboBox;
    BCheckChangePage: TMCheckBox;
    PPayWay: TMPanel;
    MLabel11: TMLabel;
    MLabel12: TMLabel;
    MLabel13: TMLabel;
    MLabel14: TMLabel;
    MCombo_PayCond: TMComboBox;
    MCombo_PayWay1: TMComboBox;
    MCombo_PayWay2: TMComboBox;
    MCombo_PayWay3: TMComboBox;
    MCombo_YusouKbn: TMComboBox;
    LYusouKbn: TMLabel;
    MGroupBox2: TMGroupBox;
    EDPrnt: TMDateEdit;
    LPrintDate: TMLabel;
    MLabel10: TMLabel;
    MCombo_LayoutPtn: TMComboBox;
    ETxtLayout: TMTxtEdit;
    MGroupBox3: TMGroupBox;
    MCombo_Layout: TMComboBox;
    MGroupBox4: TMGroupBox;
    EStHojTxt: TMTxtEdit;
    LStHoj: TMLabel;
    MLabel3: TMLabel;
    EEdHojNum: TMNumEdit;
    LEdHoj: TMLabel;
    EStHojNum: TMNumEdit;
    EEdHojTxt: TMTxtEdit;
    MGroupBox5: TMGroupBox;
    PMCombo: TMComboBox;
    MCombo_LayoutPtnTeg: TMComboBox;
    LYusouFutan: TMLabel;
    MCombo_YusouFutan: TMComboBox;
    SB_PRINT: TMBitBtn;
    SB_MAIL: TMBitBtn;
    SB_SAVE: TMBitBtn;
 	YubinMarkChkbox: TMCheckBox;
	procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure EStHojNumArrowClick(Sender: TObject);
    procedure MCombo_LayoutChange(Sender: TObject);
    procedure EStHojTxtArrowClick(Sender: TObject);
    procedure MCombo_LayoutKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MCombo_LayoutPtnKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MCombo_LetterKbnKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure MCombo_PayCondKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EStHojNumExit(Sender: TObject);
    procedure EEdHojNumExit(Sender: TObject);
    procedure EStHojTxtExit(Sender: TObject);
    procedure EEdHojTxtExit(Sender: TObject);
    procedure EDPrntExit(Sender: TObject);
    procedure MCombo_PayCondChange(Sender: TObject);
    procedure SB_OKClick(Sender: TObject);
    procedure MCombo_PayWay1Exit(Sender: TObject);
    procedure MCombo_PayWay2Exit(Sender: TObject);
    procedure MCombo_PayWay3Exit(Sender: TObject);
    procedure PMComboKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PMComboChange(Sender: TObject);
    procedure MCombo_LayoutPtnTegKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MCombo_YusouFutanKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);


  private
    { Private 宣言 }
	m_pRec			:	^TMjsAppRecord;
	m_DataModule	:	TMDataModulef;

	m_DBCorp		:	TFDConnection;

	m_Wnd			:	TMasWndIF;
    m_DBCtrl		:	TFDConnection;

	m_PayBaseInfo	:	TPayBaseInfo;		   	   	// 支払情報管理
	PNoticeDoc		:	array [0..6] of TMPayNoticeDoc;	//通知書レイアウト

    TegFilePath		:	String;						//手形送付案内レイアウトパス
    TegBunsho		:	String;						//手形送付案内 文書
// <#018> ADD-STR
	TegPtnName		:   String;
    m_bTegFile2	    :	Boolean;					//手形送付案内②区分
    TegFilePath2	:	String;						//手形送付案内レイアウトパス②
    TegBunsho2		:	String;						//手形送付案内 文書②
	TegPtnName2		:   String;
// <#018> ADD-END

    KakitomeFilePath:	String;						//書留郵便物受領証レイアウトパス

    TackSealFilePath:	String;						//タックシールレイアウトパス <#020>

    gsExePath       :   String;

	StListPayWay	: TStringList;

    m_Query			:	TMQuery;		            // 2005/11/08 <#001> Y.Kabashima Add

// 2006/07/27 <#007> Y.Naganuma Add
	m_iSystemCode	:	Integer;					//システムコード
	m_iFuncNo		:	Integer;					//処理No
// 2006/07/27 <#007> Y.Naganuma Add

// 2006/07/21 <#006> Y.Naganuma Add
	m_iDataNo		:	Integer;					// データNo
	m_iBilRendoNo	:	Integer;					// 手形連動NO
// 2006/07/21 <#006> Y.Naganuma Add

// 2007/01/10 Y.Kabashima Add <#009>
	MasterInfoList	: TList;
	m_pMasterInfoRec: PMasterInfoRecord;

	m_iProjectKbn	:	Integer;
	m_iProjectSubKbn:	Integer;

	m_Pay510Com		:	TPAY510100Com;
// 2007/01/10 Y.Kabashima Add <#009>
//2007/05/21 <#011> Y.Naganuma Add
	m_sStRenso		:	String;
	m_sEdRenso		:	String;
//2007/05/21 <#011> Y.Naganuma Add

    m_DefPrnDate    :   TDateTime;      // <#016> ADD

// <#021> ADD-STR
    m_bMailUse      :   Boolean;
    m_bMailSend     :   Boolean;
// <#021> ADD-END
    m_iMailPDFSaveMode : Integer;       // <#023> ADD    

	function Init(var Param: TPay510100DlgParam;var LayoutCtrl :TMPayBaseLayoutInfo ): Boolean;
	procedure InitParam(var Param: TPay510100DlgParam);
    procedure BeforeOutput;
    procedure InitLayInfo(var LayoutCtrl :TMPayBaseLayoutInfo);
    procedure InitPayNoticeDoc;

	procedure Term;

//2007/05/21 <#011> Y.Naganuma Mod
//	function CallHojExp(var NCode, Code, SimpleName: String): Boolean;
	function CallHojExp(var NCode, Code, SimpleName, Renso: String): Boolean;
//2007/05/21 <#011> Y.Naganuma Mod
    procedure CallErrorMessageDsp(Msg : String);

	procedure SetParam(var Param: TPay510100DlgParam);

	procedure CMChildKey(var Msg: TWMKey); message CM_CHILDKEY;

	procedure GetParam(var Param: TPay510100DlgParam);
    function Get_SysDate(Query: TMQuery):TDateTime;

//2007/05/21 <#011> Y.Naganuma Mod
//	function GetDefaultHoj(Kbn: Byte; var Code, SimpleName: String): Boolean;
	function GetDefaultHoj(Kbn: Byte; var Code, SimpleName, Renso: String): Boolean;
//2007/05/21 <#011> Y.Naganuma Mod
//	function GetInputHoj(var Code, SimpleName: String): Boolean;		// 2005/11/08 <#001> Y.Kabashima Del
//2007/05/21 <#011> Y.Naganuma Mod
//	function GetInputPayHoj(var Code, SimpleName: String): Boolean;
	function GetInputPayHoj(var Code, SimpleName, Renso: String): Boolean;
//2007/05/21 <#011> Y.Naganuma Mod

//	function GetWhereHoj: String;										//2006/07/27 <#007> Y.Naganuma Del
	function GetWherePayHoj: String;

	procedure SetCodeAttr(CodeDigit, CodeAttr: Integer);

	function GetPayBaseInfo(var LayoutCtrl:TMPayBaseLayoutInfo): Boolean;
	function GetLayoutPtnInfo(var LayoutCtrl:TMPayBaseLayoutInfo): Boolean;
	procedure GetTegataRendoInfo();	// 2006/07/21 <#006> Y.Naganuma Add
	function GetLayout(): Boolean;
	function SetNoticeDoc: Boolean;
	procedure GetNoticeDoc;
	procedure GetTegFile;
	procedure GetTegBunsho;
	procedure GetKakitomeFile;
    function GetPtnName(iIdx : Integer):String;
    function GetDefaultFile(iCount : Integer;fType : TFileType):String;
    function GetDefaultTegataFile:String;
    function GetDefaultKakitomeFile:String;

	function SetDefPayWay(var StList : TStringList): Boolean;
	function SetPtnInfo: Boolean;
	procedure SetPayWay(var Param: TPay510100DlgParam);

	procedure SetPanelVisible();
    procedure SetPayWayEnable(blnValue:Boolean);

	procedure SetHojo(pKbn: Integer; pHojCode: String; pSimpleName: String);

	procedure SetItemTable(var ItemTbl: array  of integer;intIndex:Integer);
    procedure SetLayoutInfo(var Param: TMPayNoticeDoc);
	function CodeEditToDB(Code: String): String;

	procedure MakeLayoutCombo();
	procedure MakeLayoutPtnCombo;
	procedure MakeLetterCombo;
	procedure MakeYusouKbnCombo;
	procedure MakePayWayCombo(StList:TStringList);

    function ValueCheck: Boolean;
    function CheckFileExist : Boolean;
    function CheckTegataExist : Boolean;
    function CheckKakitomeExist : Boolean;

	procedure ErrorMessageDsp(Query: TMQuery);
    procedure ErrorMsgDsp(pFileType : TFileType);

	procedure ValueError(pMsgRec: TMjsMsgRec; Ctrl: TWinControl);

// 2007/01/10 Y.Kabashima Add <#009>
	procedure GetProjectInfo();

	procedure GetMasterInfo(p_Query: TMQuery);
	function GetUseKbn(sMasterKbn: Integer): Integer;
// 2007/01/10 Y.Kabashima Add <#009>

    procedure MakeLayoutPtnTegCombo;                                // <#018> ADD

// <#020> ADD-STR
    function GetDefaultTackSealFile:String;
	procedure GetTackSealFile;
    function CheckTackSealExist : Boolean;
// <#020> ADD-END

  public
    { Public 宣言 }
    m_DTMAIN		:	TDTMAIN;	//	会社基本情報
    m_MasterInfo	:	TMasterInfo;//	マスタ基本情報

	function DoDlg(pRec: Pointer; DataModule: TMDataModulef; DBCorp, DBCtrl: TFDConnection;
     var Param: TPay510100DlgParam;var LayoutCtrl :TMPayBaseLayoutInfo ;
     var LayoutInfo : TMPayNoticeDoc): Integer;

  end;


implementation


const
// <#ERW> MOD-STR
//	MAX_PAYBASE_CNT	= 20;					// PayBaseInfo情報最大項目数
	MAX_PAYBASE_CNT	= 21;					// PayBaseInfo情報最大項目数
// <#ERW> MOD-END
    PAY_TITLE		= '支払通知書情報印刷処理';

    NOTICEDOC		= '支払通知書';       // 帳票種類ｺﾝﾎﾞ
    TEGATA			= '手形送付案内';     // 帳票種類ｺﾝﾎﾞ
    KAKITOME		= '書留郵便物受領証'; // 帳票種類ｺﾝﾎﾞ
    TACKSEAL		= 'タックシール';     // 帳票種類ｺﾝﾎﾞ <#020> ADD

    HAKKOUDATE		= '発行年月日';		  // 帳票出力ﾗﾍﾞﾙ
    SENDDATE		= '送付年月日';		  // 帳票出力ﾗﾍﾞﾙ
    TEISYUTSUDATE	= '提出年月日';		  // 帳票出力ﾗﾍﾞﾙ

    LETTERKBN0		= '全て';      		  // 集金/送付ｺﾝﾎﾞ
    LETTERKBN1		= '標準';    		  // 集金/送付ｺﾝﾎﾞ
    LETTERKBN2		= '送付用';           // 集金/送付ｺﾝﾎﾞ
    LETTERKBN3		= '集金用';    	      // 集金/送付ｺﾝﾎﾞ
    LETTERKBN4		= 'その他';    	      // 集金/送付ｺﾝﾎﾞ		// <#003> Add

// 2006/05/10 H.Kawato Mod St <#005>
//    YUSOUKBN0       =  'する';		  // 郵送区分
//    YUSOUKBN1       =  'しない';		  // 郵送区分
    YUSOUKBN0       =  '郵送する';		  // 郵送区分
    YUSOUKBN1       =  '郵送しない';	  // 郵送区分
// 2006/05/10 H.Kawato Mod Ed <#005>

    YUSOUKBN2       =  '全て';			  // 郵送区分

    PAYCOND0		= '全て';    	      // 支払条件ｺﾝﾎﾞ
    PAYCOND1		= '指定';    	      // 支払条件ｺﾝﾎﾞ

    PAYWAY0			= 'なし';    	      // 支払方法ｺﾝﾎﾞ
    PAYWAY1			= '振込';    	      // 支払方法ｺﾝﾎﾞ
    PAYWAY2			= '期日指定振込';     // 支払方法ｺﾝﾎﾞ
    PAYWAY3			= '手形';    	      // 支払方法ｺﾝﾎﾞ
    PAYWAY3E		= '電子債権';  	      // 支払方法ｺﾝﾎﾞ <#ERW> ADD
    PAYWAY4			= '小切手';    	      // 支払方法ｺﾝﾎﾞ
    PAYWAY5			= '現金';    	      // 支払方法ｺﾝﾎﾞ
    PAYWAY6			= '相殺（共通１）';   // 支払方法ｺﾝﾎﾞ
    PAYWAY7			= '相殺（共通２）';   // 支払方法ｺﾝﾎﾞ
    PAYWAY8			= '相殺（共通３）';   // 支払方法ｺﾝﾎﾞ
    PAYWAY9			= '相殺（共通４）';   // 支払方法ｺﾝﾎﾞ
    PAYWAY10		= '相殺（個別）';     // 支払方法ｺﾝﾎﾞ

    SHIIREMAXLEN	= 10;

    //デフォルト(画面)
    LAYOUTNAME1		= '支払通知書';       			//  レイアウト名称デフォルト値(6111)
    LAYOUTNAME2		= '支払通知書(送付)';       	//  レイアウト名称デフォルト値(6121)
    LAYOUTNAME3		= '支払通知書(簡略)';       	//  レイアウト名称デフォルト値(6131)
    LAYOUTNAME4		= '支払通知書(手形あり)';       //  レイアウト名称デフォルト値(6141)
    LAYOUTNAME5		= '支払通知書(手形なし)';       //  レイアウト名称デフォルト値(6151)
    LAYOUTNAME6		= '支払通知書(期日指定振込)';   //  レイアウト名称デフォルト値(6161)
    LAYOUTNAME7		= '支払通知書(名寄せ用)';       //  レイアウト名称デフォルト値(6171)

    DEFBASIC1			= 'PAY510100_01';			//	デフォルトファイル名
    DEFBASIC2			= 'PAY510100_02';    		//	デフォルトファイル名
    DEFBASIC3			= 'PAY510100_03';    		//	デフォルトファイル名
    DEFBASIC4			= 'PAY510100_04';    		//	デフォルトファイル名
    DEFBASIC5			= 'PAY510100_05';			//	デフォルトファイル名
    DEFBASIC6			= 'PAY510100_06';			//	デフォルトファイル名
    DEFBASIC7			= 'PAY510100_07';			//	デフォルトファイル名
    DEFTORIDETAIL		= 'PAY510100_11';     		//	デフォルトファイル名
    DEFTEGATADETAIL		= 'PAY510100_12';     		//	デフォルトファイル名
    DEFKOUJYODETAIL		= 'PAY510100_13';     		//	デフォルトファイル名
    DEFJIGYODETAIL		= 'PAY510100_14';     		//	デフォルトファイル名
    DEFKIJITSUDETAIL	= 'PAY510100_15';			//	デフォルトファイル名
    DEFTEGATA			= 'PAY510100_91';			//	デフォルトファイル名
    DEFKAKITOME			= 'PAY510100_92';			//	デフォルトファイル名
    DEFTACKSEAL		    = 'PAY510100_TS11';			//	デフォルトファイル名 <#020> ADD

{$R *.DFM}

{$include payBaseInfo_b.inc} // 支払情報管理


//**************************************************************************
//  Component   :   Form
//  Event       :	OnCreate
//  Name        :   A.TAKARA
//**************************************************************************
procedure TPAY510100Dlgf.FormCreate(Sender: TObject);
begin
	with PMCombo do
	begin
		Items.Clear;
		Items.Add('支払先順');
		Items.Add('連想順');

	    ItemIndex := 0;
    end;

    StListPayWay := TStringList.Create;
	with StListPayWay do
	begin
		Add(PAYWAY0);
    	Add(PAYWAY1);
	    Add(PAYWAY2);
    	Add(PAYWAY3);
	    Add(PAYWAY4);
    	Add(PAYWAY5);
	    Add(PAYWAY6);
    	Add(PAYWAY7);
	    Add(PAYWAY8);
    	Add(PAYWAY9);
	    Add(PAYWAY10);
	    Add(PAYWAY3E);      // <#ERW> ADD
	end;
//2007/05/21 <#011> Y.Naganuma Add
	m_sStRenso		:= '';
	m_sEdRenso		:= '';
//2007/05/21 <#011> Y.Naganuma Add

    m_bMailSend := False;           // <#021> ADD
end;

//**************************************************************************
//  Component   :   Form
//  Event       :	OnDestroy
//  Name        :   K.IKEMURA (RIT)
//**************************************************************************
procedure TPAY510100Dlgf.FormDestroy(Sender: TObject);
begin
	if StListPayWay <> nil then
	    StListPayWay.Free;

// 2005/11/08 <#001> Y.Kabashima Add
	if Assigned(m_Query) then
    begin
    	m_Query.Free;
        m_Query := nil;
    end;
// 2005/11/08 <#001> Y.Kabashima Add
end;

//**************************************************************************
//  Component   :   MCombo_Layout
//  Event       :	OnChange
//  Name        :   K.IKEMURA (RIT)
//**************************************************************************
procedure TPAY510100Dlgf.MCombo_LayoutChange(Sender: TObject);
begin
    // 初期化
   	BeforeOutput;

	SetPanelVisible;
end;

//**************************************************************************
//  Component   :   ENoticeDoc_StHojNum,ENoticeDoc_EdHojNum
//  Event       :	OnArrowClick
//  Name        :   K.IKEMURA (RIT)
//**************************************************************************
procedure TPAY510100Dlgf.EStHojNumArrowClick(Sender: TObject);
var
//2007/05/21 <#011> Y.Naganuma Mod
//	NCode, Code, SimpleName: String;
	NCode, Code, SimpleName, Renso: String;
//2007/05/21 <#011> Y.Naganuma Mod
begin
//2007/05/21 <#011> Y.Naganuma Mod
//	if CallHojExp(NCode, Code, SimpleName) = True then
	if CallHojExp(NCode, Code, SimpleName, Renso) = True then
//2007/05/21 <#011> Y.Naganuma Mod
	begin
    	case TMNumEdit(Sender).Tag of
        	0://支払先開始
            begin
                EStHojNum.Value		:= StrToInt64Def(Code, 0);
                EStHojNum.InputFlag	:= False;
                LStHoj.Caption		:= SimpleName;
				m_sStRenso			:= Renso;		//2007/05/21 <#011> Y.Naganuma Mod
            end;
        	1://支払先終了
            begin
                EEdHojNum.Value		:= StrToInt64Def(Code, 0);
                EEdHojNum.InputFlag	:= False;   
                LEdHoj.Caption		:= SimpleName;
				m_sEdRenso			:= Renso;		//2007/05/21 <#011> Y.Naganuma Mod
            end;
        end;
	end;
end;

//**************************************************************************
//  Component   :   MCombo_PayCond
//  Event       :	OnChange
//  Name        :   K.IKEMURA (RIT)
//**************************************************************************
procedure TPAY510100Dlgf.MCombo_PayCondChange(Sender: TObject);
begin
   	SetPayWayEnable(not (MCombo_PayCond.Text = PAYCOND0))
end;

//**************************************************************************
//  Component   :   ENoticeDoc_StHojTxt,ENoticeDoc_EdtHojTxt
//  Event       :	OnArrowClick
//  Name        :   K.IKEMURA (RIT)
//**************************************************************************
procedure TPAY510100Dlgf.EStHojTxtArrowClick(Sender: TObject);
var
//2007/05/21 <#011> Y.Naganuma Mod
//	NCOde, Code, SimpleName: String;
	NCode, Code, SimpleName, Renso: String;
//2007/05/21 <#011> Y.Naganuma Mod
begin
//2007/05/21 <#011> Y.Naganuma Mod
//	if CallHojExp(NCode, Code, SimpleName) = True then
	if CallHojExp(NCode, Code, SimpleName, Renso) = True then
//2007/05/21 <#011> Y.Naganuma Mod
	begin
    	case TMTxtEdit(Sender).Tag of
        	0://支払先開始
            begin
                EStHojTxt.Text	:= Code;
                LStHoj.Caption	:= SimpleName;
				m_sStRenso			:= Renso;		//2007/05/21 <#011> Y.Naganuma Mod
            end;
        	1://支払先終了
            begin
                EEdHojTxt.Text	:= Code;
                LEdHoj.Caption	:= SimpleName;
				m_sEdRenso			:= Renso;		//2007/05/21 <#011> Y.Naganuma Mod
            end;
        	else
        		Exit;
        end;
	end;
end;

//**************************************************************************
//  Component   :   MCombo_Layout
//  Event       :	OnKeyDown
//  Name        :   K.IKEMURA (RIT)
//**************************************************************************
procedure TPAY510100Dlgf.MCombo_LayoutKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	with MCombo_Layout do
	begin
		if (DroppedDown = True) and (Key = VK_RETURN) then
			MjsNextCtrl(Self);
	end;
end;

//**************************************************************************
//  Component   :   MCombo_LayoutPtn
//  Event       :	OnKeyDown
//  Name        :   K.IKEMURA (RIT)
//**************************************************************************
procedure TPAY510100Dlgf.MCombo_LayoutPtnKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
	with MCombo_LayoutPtn do
	begin
		if (DroppedDown = True) and (Key = VK_RETURN) then
			MjsNextCtrl(Self);
	end;
end;

//**************************************************************************
//  Component   :   MCombo_NoticeDocLetterKbn
//  Event       :	OnKeyDown
//  Name        :   K.IKEMURA (RIT)
//**************************************************************************
procedure TPAY510100Dlgf.MCombo_LetterKbnKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
	with MCombo_LetterKbn do
	begin
		if (DroppedDown = True) and (Key = VK_RETURN) then
			MjsNextCtrl(Self);
	end;
end;

//**************************************************************************
//  Component   :   MCombo_PayCond
//  Event       :	OnKeyDown
//  Name        :   K.IKEMURA (RIT)
//**************************************************************************
procedure TPAY510100Dlgf.MCombo_PayCondKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
	wkMCombo : TMComboBox;
begin
	case TMComboBox(Sender).Tag of
    	0:		wkMCombo := MCombo_PayCond;//支払条件
    	1:		wkMCombo := MCombo_PayWay1;//支払方法１
    	2:		wkMCombo := MCombo_PayWay2;//支払方法２
    	3:		wkMCombo := MCombo_PayWay3;//支払方法３
	    else	Exit;
    end;

    with wkMCombo do
    begin
        if (DroppedDown = True) and (Key = VK_RETURN) then
            MjsNextCtrl(Self);
    end;
end;

//**************************************************************************
//  Component   :   MDateEHakkou
//  Event       :	OnExit
//  Name        :   K.IKEMURA (RIT)
//**************************************************************************
procedure TPAY510100Dlgf.EDPrntExit(Sender: TObject);
var
    iInputYmd	:	Integer;
begin
	if Screen.ActiveControl = SB_CANCEL then Exit;

    begin
        iInputYmd := StrToInt(FormatDateTime('yyyymmdd', EDPrnt.AsDateTime));
// <#016> MOD-STR
//      if (EDPrnt.Value = 0) then Exit;
        if (EDPrnt.Value = 0) then
        begin
			EDPrnt.AsDateTime := m_DefPrnDate;
            Exit;
        end;
// <#016> MOD-END

        if (MjsDateCtrl.MjsIntYMDChk(iInputYmd) = False) then
        begin
            beep;
            EDPrnt.SelectAll;
            EDPrnt.SetFocus;
            Abort;
        end;
    end;
end;

//**************************************************************************
//  Component   :   ENoticeDoc_StHojNum
//  Event       :	OnExit
//  Name        :   K.IKEMURA (RIT)
//**************************************************************************
procedure TPAY510100Dlgf.EStHojNumExit(Sender: TObject);
var
//2007/05/21 <#011> Y.Naganuma Mod
//	Code, SimpleName: String;
	Code, SimpleName, Renso: String;
//2007/05/21 <#011> Y.Naganuma Mod
	Ret         :   Boolean;
begin
	if Screen.ActiveControl = SB_CANCEL then Exit;

	Code := EStHojNum.Text;

	if Code = '' then
//2007/05/21 <#011> Y.Naganuma Mod
//		Ret := GetDefaultHoj(0, Code, SimpleName)
		Ret := GetDefaultHoj(0, Code, SimpleName, Renso)
//2007/05/21 <#011> Y.Naganuma Mod
	else
//2007/05/21 <#011> Y.Naganuma Mod
//		Ret := GetInputPayHoj(Code, SimpleName);
		Ret := GetInputPayHoj(Code, SimpleName, Renso);
//2007/05/21 <#011> Y.Naganuma Mod

	if Ret then
	begin
		EStHojNum.Value		:= StrToInt64Def(Code, 0);
		EStHojNum.Zero      := True;        // <#012> Add
		EStHojNum.InputFlag	:= False;
		LStHoj.Caption		:= SimpleName;
		m_sStRenso			:= Renso;		//2007/05/21 <#011> Y.Naganuma Add
	end
	else
	begin
        //	エラー時
        Beep;
        LStHoj.Caption := '';
        EStHojNum.SelectAll;
        EStHojNum.SetFocus;
        Abort;
	end;
end;

//**************************************************************************
//  Component   :   ENoticeDoc_EdHojNum
//  Event       :	OnExit
//  Name        :   K.IKEMURA (RIT)
//**************************************************************************
procedure TPAY510100Dlgf.EEdHojNumExit(Sender: TObject);
var
	Code, SimpleName: String;
	Renso			: String;	//2007/05/21 <#011> Y.Naganuma Add
	Ret             : Boolean;
// 2006/04/03 <#004> H.Kawato Add
    sPayCodeStart   : String;
    sPayCodeEnd     : String;
    sRenCharStart   : String;
    sRenCharEnd     : String;
// 2006/04/03 <#004> H.Kawato Add
begin
	if Screen.ActiveControl = SB_CANCEL then Exit;

	Code := EEdHojNum.Text;

	if Code = '' then
//2007/05/21 <#011> Y.Naganuma Mod
//		Ret := GetDefaultHoj(1, Code, SimpleName)
		Ret := GetDefaultHoj(1, Code, SimpleName, Renso)
//2007/05/21 <#011> Y.Naganuma Mod
	else
//2007/05/21 <#011> Y.Naganuma Mod
//		Ret := GetInputPayHoj(Code, SimpleName);
		Ret := GetInputPayHoj(Code, SimpleName, Renso);
//2007/05/21 <#011> Y.Naganuma Mod

	if Ret then
	begin
		EEdHojNum.Value		:= StrToInt64Def(Code, 0);
		EEdHojNum.Zero      := True;        // <#012> Add
		EEdHojNum.InputFlag	:= False;
		LEdHoj.Caption		:= SimpleName;
		m_sEdRenso			:= Renso;		//2007/05/21 <#011> Y.Naganuma Add
	end
	else
	begin
        //	エラー時
        Beep;
        LEdHoj.Caption := '';
        EEdHojNum.SelectAll;
        EEdHojNum.SetFocus;
        Abort;
	end;

	//	範囲チェック
	if not (Screen.ActiveControl = EStHojNum) then
	begin
// 2005/11/08 <#001> Y.Kabashima Mod
//		if EEdHojNum.Value < EStHojNum.Value then
//		begin
//			Beep;
//			EStHojNum.SelectAll;
//			EStHojNum.SetFocus;
//			Abort;
//		end;
		if PMCombo.Items[PMCombo.ItemIndex] = '支払先順' then
        begin
			if EEdHojNum.Value < EStHojNum.Value then
			begin
				Beep;
				EStHojNum.SelectAll;
				EStHojNum.SetFocus;
				Abort;
			end;
        end
        else if PMCombo.Items[PMCombo.ItemIndex] = '連想順' then
        begin
// 2006/04/03 <#004> H.Kawato Mod Start
{			if TPAY510100Com.GetRenso(m_Query, FloatToStr(EEdHojNum.Value)) <
            	TPAY510100Com.GetRenso(m_Query, FloatToStr(EStHojNum.Value)) then
			begin
				Beep;
				EStHojNum.SelectAll;
				EStHojNum.SetFocus;
				Abort;
			end;
}
            if	(m_MasterInfo.CodeAttr <= 1) then		// ｺｰﾄﾞ属性: 数字
            begin
                // コード属性＝「0:数字」、「1:数字(前ゼロあり)」の場合、前ゼロを補完
                sPayCodeStart := FormatCurr('0000000000000000', EStHojNum.Value); // 開始支払先コード
                sPayCodeEnd   := FormatCurr('0000000000000000', EEdHojNum.Value); // 終了支払先コード
            end;

//2007/05/21 <#011> Y.Naganuma Mod
//          sRenCharStart := m_Pay510Com.GetRenso(m_Query, sPayCodeStart);
//          sRenCharEnd   := m_Pay510Com.GetRenso(m_Query, sPayCodeEnd);
			sRenCharStart := m_sStRenso;
            sRenCharEnd   := m_sEdRenso;
//2007/05/21 <#011> Y.Naganuma Mod

			if (sRenCharEnd < sRenCharStart) or
               ((sRenCharStart = sRenCharEnd) and (sPayCodeStart > sPayCodeEnd)) then
			begin
				Beep;
				EStHojNum.SelectAll;
				EStHojNum.SetFocus;
				Abort;
			end;
// 2006/04/03 <#004> H.Kawato Mod End
        end;
// 2005/11/08 <#001> Y.Kabashima Mod
	end;
end;

//**************************************************************************
//  Component   :   ENoticeDoc_StHojTxt
//  Event       :	OnExit
//  Name        :   K.IKEMURA (RIT)
//**************************************************************************
procedure TPAY510100Dlgf.EStHojTxtExit(Sender: TObject);
var
//2007/05/21 <#011> Y.Naganuma Mod
//	Code, SimpleName: String;
	Code, SimpleName, Renso: String;
//2007/05/21 <#011> Y.Naganuma Mod
	Ret         :   Boolean;
begin
	if Screen.ActiveControl = SB_CANCEL then Exit;

	Code := EStHojTxt.Text;

	if Code = '' then
//2007/05/21 <#011> Y.Naganuma Mod
//		Ret := GetDefaultHoj(0, Code, SimpleName)
		Ret := GetDefaultHoj(0, Code, SimpleName, Renso)
//2007/05/21 <#011> Y.Naganuma Mod
	else
//2007/05/21 <#011> Y.Naganuma Mod
//		Ret := GetInputPayHoj(Code, SimpleName);
		Ret := GetInputPayHoj(Code, SimpleName, Renso);
//2007/05/21 <#011> Y.Naganuma Mod

	if Ret then
	begin
		EStHojTxt.Text	:= Code;
		LStHoj.Caption	:= SimpleName;
		m_sStRenso		:= Renso;		//2007/05/21 <#011> Y.Naganuma Add
	end
	else
	begin
        //	エラー時
        Beep;
        LStHoj.Caption := '';
        EStHojTxt.SelectAll;
        EStHojTxt.SetFocus;
        Abort;
	end;
end;

//**************************************************************************
//  Component   :   ENoticeDoc_EdHojTxt
//  Event       :	OnExit
//  Name        :   K.IKEMURA (RIT)
//**************************************************************************
procedure TPAY510100Dlgf.EEdHojTxtExit(Sender: TObject);
var
	Code, SimpleName: String;
	Renso			: String;		//2007/05/21 <#011> Y.Naganuma Add
	Ret             :   Boolean;
// 2006/04/03 <#004> H.Kawato Add
    sRenCharStart   : String;
    sRenCharEnd     : String;
// 2006/04/03 <#004> H.Kawato Add
begin
	if Screen.ActiveControl = SB_CANCEL then Exit;

	Code := EEdHojTxt.Text;

	if Code = '' then
//2007/05/21 <#011> Y.Naganuma Mod
//		Ret := GetDefaultHoj(1, Code, SimpleName)
		Ret := GetDefaultHoj(1, Code, SimpleName, Renso)
//2007/05/21 <#011> Y.Naganuma Mod
	else
//2007/05/21 <#011> Y.Naganuma Mod
//		Ret := GetInputPayHoj(Code, SimpleName);
		Ret := GetInputPayHoj(Code, SimpleName, Renso);
//2007/05/21 <#011> Y.Naganuma Mod

	if Ret then
	begin
		EEdHojTxt.Text	:= Code;
		LEdHoj.Caption	:= SimpleName;
		m_sEdRenso		:= Renso;		//2007/05/21 <#011> Y.Naganuma Add
	end
	else
	begin
        //	エラー時
        Beep;
        LEdHoj.Caption := '';
        EEdHojTxt.SelectAll;
        EEdHojTxt.SetFocus;
        Abort;
	end;

	//	範囲チェック
	if not (Screen.ActiveControl = EStHojTxt) then
	begin
// 2005/11/08 <#001> Y.Kabashima Mod
//		if EEdHojTxt.Text < EStHojTxt.Text then
//		begin
//			Beep;
//			EStHojTxt.SelectAll;
//			EStHojTxt.SetFocus;
//			Abort;
//		end;
		if PMCombo.Items[PMCombo.ItemIndex] = '支払先順' then
        begin
			if EEdHojTxt.Text < EStHojTxt.Text then
			begin
				Beep;
				EStHojTxt.SelectAll;
				EStHojTxt.SetFocus;
				Abort;
			end;
        end
        else if PMCombo.Items[PMCombo.ItemIndex] = '連想順' then
        begin
// 2006/04/03 <#004> H.Kawato Mod Start
{
			if TPAY510100Com.GetRenso(m_Query, EEdHojTxt.Text) <
            	TPAY510100Com.GetRenso(m_Query, EStHojTxt.Text) then
			begin
				Beep;
				EStHojTxt.SelectAll;
				EStHojTxt.SetFocus;
				Abort;
			end;
}
//2007/05/21 <#011> Y.Naganuma Mod
//          sRenCharStart := m_Pay510Com.GetRenso(m_Query, EStHojTxt.Text);
//          sRenCharEnd   := m_Pay510Com.GetRenso(m_Query, EEdHojTxt.Text);
			sRenCharStart := m_sStRenso;
			sRenCharEnd   := m_sEdRenso;
//2007/05/21 <#011> Y.Naganuma Mod

			if (sRenCharEnd < sRenCharStart) or
               ((sRenCharStart = sRenCharEnd) and (EStHojTxt.Text > EEdHojTxt.Text)) then
			begin
				Beep;
				EStHojTxt.SelectAll;
				EStHojTxt.SetFocus;
				Abort;
			end;
// 2006/04/03 <#004> H.Kawato Mod End
        end;
// 2005/11/08 <#001> Y.Kabashima Mod
	end;
end;

//**************************************************************************
//  Component   :   MCombo_PayWay1
//  Event       :	OnExit
//  Name        :   K.IKEMURA (RIT)
//**************************************************************************
procedure TPAY510100Dlgf.MCombo_PayWay1Exit(Sender: TObject);
var
	MsgRec      :   TMjsMsgRec;
begin
	if MCombo_PayWay1.Text = PAYWAY0 then Exit;
	if MCombo_PayWay1.ItemIndex = -1 then Exit;

    if ((MCombo_PayWay1.ItemIndex = MCombo_PayWay2.ItemIndex) or
        (MCombo_PayWay1.ItemIndex = MCombo_PayWay3.ItemIndex)) then
        ValueError(MsgRec, MCombo_PayWay1);
end;

//**************************************************************************
//  Component   :   MCombo_PayWay2
//  Event       :	OnExit
//  Name        :   K.IKEMURA (RIT)
//**************************************************************************
procedure TPAY510100Dlgf.MCombo_PayWay2Exit(Sender: TObject);
var
	MsgRec      :   TMjsMsgRec;
begin
	if MCombo_PayWay2.Text = PAYWAY0 then Exit;
	if MCombo_PayWay2.ItemIndex = -1 then Exit;

    if ((MCombo_PayWay2.ItemIndex = MCombo_PayWay1.ItemIndex) or
        (MCombo_PayWay2.ItemIndex = MCombo_PayWay3.ItemIndex)) then
        ValueError(MsgRec, MCombo_PayWay2);
end;

//**************************************************************************
//  Component   :   MCombo_PayWay3
//  Event       :	OnExit
//  Name        :   K.IKEMURA (RIT)
//**************************************************************************
procedure TPAY510100Dlgf.MCombo_PayWay3Exit(Sender: TObject);
var
	MsgRec      :   TMjsMsgRec;
begin
	if MCombo_PayWay3.Text = PAYWAY0 then Exit;
	if MCombo_PayWay3.ItemIndex = -1 then Exit;

    if ((MCombo_PayWay3.ItemIndex = MCombo_PayWay1.ItemIndex) or
        (MCombo_PayWay3.ItemIndex = MCombo_PayWay2.ItemIndex)) then
        ValueError(MsgRec, MCombo_PayWay3);
end;

//**************************************************************************
//  Component   :   SB_OK
//  Event       :	OnSB_OKClick
//  Name        :   K.IKEMURA (RIT)
//**************************************************************************
procedure TPAY510100Dlgf.SB_OKClick(Sender: TObject);
begin
	if ValueCheck = False then
		ModalResult := mrNone;

    m_bMailSend := ((Sender as TMBitBtn).Name = 'SB_MAIL');     // <#021> ADD

// <#023> ADD-STR
    m_iMailPDFSaveMode := 0;

    //フォルダ保存ボタンが押されたとき
    if ((Sender as TMBitBtn).Name = 'SB_SAVE') then
    begin
        m_bMailSend := True;        //メール送信
        m_iMailPDFSaveMode := 1;    //メール送信なしで保存のみ
    end;
// <#023> ADD-END    
end;

//**************************************************************************
//  Proccess    :   ダイアログ入り口
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :	pRec		TMjsAppRecord
//				:	DataModule	MDataModule
//				:	DBCorp		会社DB (トランあり)
//				:	Param		パラメータ (in→out)
//  Return      :	ModalResult
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPAY510100Dlgf.DoDlg(pRec: Pointer; DataModule: TMDataModulef;
  DBCorp, DBCtrl: TFDConnection; var Param: TPay510100DlgParam;
  var LayoutCtrl :TMPayBaseLayoutInfo;
  var LayoutInfo : TMPayNoticeDoc): Integer;
var
	wCommon : ^rcCOMMONAREA;			//	共通ﾒﾓﾘ ﾎﾟｲﾝﾀ
    gsProgramPath : String;
begin
   	Result := mrNo;

	m_pRec		 := pRec;
	m_DataModule := DataModule;
	m_DBCorp	 := DBCorp;
    m_DBCtrl	 := DBCtrl;
	m_iDataNo	 := Param.DataNo;		//2006/07/21 <#006> Y.Naganuma Add
//2006/07/27 <#007> Y.Naganuma Add
	m_iSystemCode:=	Param.SystemCode;	//	システムコード
	m_iFuncNo	 := Param.FuncNo;		//	処理NO
//2006/07/27 <#007> Y.Naganuma Add

// 2005/11/08 <#001> Y.Kabashima Add
    m_Query := TMQuery.Create(Self);
    m_DataModule.SetDBInfoToQuery(m_DBCorp, m_Query);
// 2005/11/08 <#001> Y.Kabashima Add

	//	共通ﾒﾓﾘより取得
   	wCommon := TMjsAppRecord(pRec^).m_pCommonArea; 	//	共通ｴﾘｱ		ﾎﾟｲﾝﾀ	取得
	gsProgramPath	:= wCommon^.SysRoot;			//	'\\ｻｰﾊﾞ名\共有名'	取得
    //起動パス
    gsExePath	    := gsProgramPath + '\' + TMASCom(m_pRec^.m_pSystemArea^).SystemArea.SysPrefix + '\Prg\';

    m_bMailUse  := Param.MailUse;                   // <#021> ADD

// <#023> ADD-STR
    // メール配信ありの場合、ＡＰＧファイルを読み込んで「ＰＤＦファイル保存」の有無をチェック
    // ＰＤＦファイル保存である場合は「ファイル保存」ボタンを表示
    if m_bMailUse then
    begin
        if (Param.MailPDFSave = 1) then
            SB_Save.Visible := True;
    end;
// <#023> ADD-END
    
	m_PayBaseInfo := TPayBaseInfo.Create(m_pRec);
	try
		if Init(Param, LayoutCtrl) = False then Exit;

		Result := ShowModal;
		if Result = mrOk then
        begin
        	//条件設定
        	SetParam(Param);

            //レイアウトパターン（CoFilePath）
            SetLayoutInfo(LayoutInfo);
        end;
	finally
		Term;
	end;
end;

//**************************************************************************
//  Proccess    :   初期処理
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :	Param	パラメータ
//  Return      :	True or False
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPAY510100Dlgf.Init(var Param: TPay510100DlgParam;
var LayoutCtrl :TMPayBaseLayoutInfo ): Boolean;
var
	Query : TMQuery;
    DateValue:TDateTime;
    Gengou : Char;
    StList : TStringList;
// <#021> ADD-STR
    function fnIsExistMailSendInfo(): Boolean;
    begin
        with Query do
        begin
            // システム日付を取得
            Close;
            SQL.Clear;
            SQL.Add('SELECT COUNT(*) CNT FROM PayMailSendInfo WHERE SystemCode = ' + IntToStr(m_iSystemCode));
            if Open = False then
                ErrorMessageDsp(Query);
            Result := (GetFld('CNT').AsInteger <> 0);
            Close;
        end;
    end;
// <#021> ADD-END
begin
	Result	:= False;

	{ 初期化 }
	//通知書レイアウト制御用情報
    InitLayInfo(LayoutCtrl);

// 2007/01/10 Y.Kabashima Add <#009>
	GetMasterInfo(m_Query);

	m_Pay510Com := TPAY510100Com.Create;

	m_Pay510Com.fnGetRenso(m_Query);
// 2007/01/10 Y.Kabashima Add <#009>

	//通知書レイアウト
    InitPayNoticeDoc;

	//画面設定
    MjsCompoColorSet(
                    TPAY510100Dlgf(Self),
                    TMASCom(m_pRec^.m_pSystemArea^).SystemArea.SysBaseColorB,
                    TMASCom(m_pRec^.m_pSystemArea^).SystemArea.SysBaseColorD
                    );

    MjsColorChange(TPAY510100Dlgf(Self),
                   TMASCom(m_pRec^.m_pSystemArea^).SystemArea.SysColorB,
                   TMASCom(m_pRec^.m_pSystemArea^).SystemArea.SysColorD,
                   TMASCom(m_pRec^.m_pSystemArea^).SystemArea.SysBaseColorB,
                   TMASCom(m_pRec^.m_pSystemArea^).SystemArea.SysBaseColorD,
                   rcCOMMONAREA(m_pRec^.m_pCommonArea^).SysFocusColor);

    MjsFontResize(Self, Pointer(m_pRec));

    try
        m_Wnd		:= TMasWndIF.Create;

        if m_Wnd.Init(Self, m_pRec) <> 0 then Exit;

        Query := TMQuery.Create(Self);
        try
            m_DataModule.SetDBInfoToQuery(m_DBCorp, Query);

            // システム日付取得
            DateValue := Get_SysDate(Query);
            if DateValue <> null then
            begin
// <#022> ADD-STR
                if (Param.PrnDate <> '') and MjsDateCtrl.MjsIntYMDChk(StrToInt(FormatDateTime('yyyymmdd', StrToDate(Param.PrnDate)))) then
                    // 既にセット済みの場合はその値(発行年月日)を使用する
                else
// <#022> ADD-END
    	            Param.PrnDate := DateToStr(DateValue);
                case m_DTMAIN.YearKbn of
                  0:
                    begin	//	和暦
                        Gengou	:= MjsGetGengou(DateValue, MdtCMP_YM);
                        EDPrnt.DateFormat := dfEMD;
                        EDPrnt.Gengou     := Gengou;
                    end;
                  1:
                    begin	//	西暦
                        EDPrnt.DateFormat := dfYMD;
                    end;
                end;
            end;

            // 仕入先コード最大入力10桁
            EStHojTxt.MaxLength := SHIIREMAXLEN;
            EStHojNum.DMaxLength := SHIIREMAXLEN;

            EEdHojTxt.MaxLength := SHIIREMAXLEN;
            EEdHojNum.DMaxLength := SHIIREMAXLEN;

            // コード属性取得
			SetCodeAttr(m_MasterInfo.CodeDigit, m_MasterInfo.CodeAttr);

            // 情報種別ｺﾝﾎﾞﾎﾞｯｸｽ内容設定
            MakeLayoutCombo();

            // レイアウトパターン取得
            if not GetPayBaseInfo(LayoutCtrl) then Exit
            else
                //ｺﾝﾎﾞﾎﾞｯｸｽ内容設定
            	MakeLayoutPtnCombo;

            MakeLayoutPtnTegCombo;                  // <#018> ADD

            // 集金/送付ｺﾝﾎﾞﾎﾞｯｸｽ内容取得
           	MakeLetterCombo;

            // 郵送 ｺﾝﾎﾞﾎﾞｯｸｽ内容取得
           	MakeYusouKbnCombo;

            // 支払方法の取得
            if SetDefPayWay(StList) then
                MakePayWayCombo(StList)
            else
            begin
                CallErrorMessageDsp('支払方法の取得に失敗しました。');
                Exit;
            end;

            PMCombo.ItemIndex := Param.Order;		// 2005/11/08 <#001> Y.Kabashima Add

            // 以下パラメータ取得情報を初期セット
            GetParam(Param);

// <#021> ADD-STR
            // メール採用可否によるボタン制御
            if m_bMailUse and fnIsExistMailSendInfo then
            begin
                with SB_OK do
                begin
                    Enabled := False;
                    Visible := False;
                end;

                with SB_PRINT do
                begin
                    Enabled := True;
                    Left := SB_OK.Left;
                    Visible := True;
                end;

                with SB_MAIL do
                begin
                    Enabled := True;
                    Left := (SB_PRINT.Left - (SB_CANCEL.Left - SB_OK.Left));
                    Visible := True;
                end;
            end;
// <#021> ADD-END

            // 帳票設定パネルの表示切替
            SetPanelVisible;
        finally
            Query.Free;
        end;
    except
    	Exit;
    end;

	Result := True;
end;

//**************************************************************************
//  Proccess    :   帳票種別変更前処理
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :
//  Return      :	True or False
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPAY510100Dlgf.BeforeOutput;
var
	Param : TPay510100DlgParam;
begin
	InitParam(Param);

    Param.Layout := MCombo_Layout.ItemIndex;

	GetParam(Param);
end;

//**************************************************************************
//  Proccess    :   継承パラメータ情報初期
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :
//  Return      :	True or False
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPAY510100Dlgf.InitParam(var Param: TPay510100DlgParam);
var
	NowDate	: String;
	Query	:	TMQuery;
    DateValue: TDateTime;
begin
    Query := TMQuery.Create(Self);
    m_DataModule.SetDBInfoToQuery(m_DBCorp, Query);

    DateValue := Get_SysDate(Query);
	NowDate := FormatDateTime('yyyy"/"mm"/"dd',DateValue);

	with Param do
    begin
        Layout		:=	0;			//	出力形式
        PrnDate		:=	NowDate;	//  印刷年月日

        LayoutPtn	:=	0;			//	レイアウト名称
        StrHojCd	:=	'';			//	開始支払先コード
        EndHojCd	:=	'';			//	終了支払先コード
//2007/05/21 <#011> Y.Naganuma Add
        StrRenso	:=	'';			//	開始支払先連想
        EndRenso	:=	'';			//	終了支払先連想
//2007/05/21 <#011> Y.Naganuma Add
        							//	集金/送付
                                    //  0:全て(Default) 1:標準 2:送付用 3:集金用
        LetterKbn	:=  MCombo_LetterKbn.Items.IndexOf(LETTERKBN0);
        							//  郵送区分
        							//	0:する(Default) 1:全て
        							//	0:する(Default) 1:しない 2:全て
		YusouKbn	:=  MCombo_YusouKbn.Items.IndexOf(YUSOUKBN2);
        PayCond		:=	0;			//	支払条件
        PayWay[0]	:=	0;			//	支払方法
        PayWay[1]	:=	0;			//	支払方法
        PayWay[2]	:=	0;			//	支払方法

        PayWayIndex[0] := 0;        //	支払方法（コンボボックスのインデックス格納用）
        PayWayIndex[1] := 0;        //	支払方法（コンボボックスのインデックス格納用）
		PayWayIndex[2] := 0;        //	支払方法（コンボボックスのインデックス格納用）

        PageChangChk:=	0;			//	改頁チェック(Default:OFF)

// <#018> ADD-STR
        LayoutPtnTeg:= 0;			//	手形送付案内レイアウト名称
                                    //	手形郵送料負担区分
        YusouFutan	:= MCombo_YusouFutan.Items.IndexOf('全て');
// <#018> ADD-END
    end;
end;

//**************************************************************************
//  Proccess    :   支払通知書格納変数の初期化
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :   Nothing
//  Return      :   Nothing
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPAY510100Dlgf.InitLayInfo(var LayoutCtrl :TMPayBaseLayoutInfo);
begin
	with LayoutCtrl do
    begin
        KanriNoUseKbn[0]:=	0;
        KanriNoUseKbn[1]:=	0;
        KanriNoUseKbn[2]:=	0;
	    NamePrintKbn	:=	0;
        Foldline		:=	1;
        Koujokouprintkbn:=	0;
        Tekioutkbn		:=	0;
        Tekipayprintkbn	:=	0;
        Tashatskoujokbn	:=	0;
        Jishabushoname	:=	'';
//2007/05/10 <#008> Y.Naganuma Add
		PrjSaiyoKbn		:= 0;
		PrjKbn			:= 0;
		PjsSaiyoKbn		:= 0;
//2007/05/10 <#008> Y.Naganuma Add
		GensenSaiyoKbn	:= 0;   // <#013> Add
//<#015> Add Start
		KojName[0]		:=	'';
		KojName[1]		:=	'';
		KojName[2]		:=	'';
//<#015> Add End
    end;
end;

//**************************************************************************
//  Proccess    :   支払通知書格納変数の初期化
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :   Nothing
//  Return      :   Nothing
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPAY510100Dlgf.InitPayNoticeDoc;
var
	iIdx	:	Integer;
begin
	for iIdx := 0 to High(PNoticeDoc) do
		FillChar(PNoticeDoc[iIdx], SizeOf(PNoticeDoc[iIdx]), 0);
end;

//**************************************************************************
//  Proccess    :   終了処理
//  Name        :   J.Kobashigawa
//  Date        :	2001/12/14
//  Parameter   :
//  Return      :
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPAY510100Dlgf.Term;
begin
	m_PayBaseInfo.Term;
	m_PayBaseInfo.Free;
    m_PayBaseInfo := nil;

	m_Wnd.Free;
end;

//**************************************************************************
//  Proccess    :   パラメータセット処理
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :	Param	パラメータ (in->out)
//  Return      :
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPAY510100Dlgf.SetParam(var Param: TPay510100DlgParam);
var
//2007/05/21 <#011> Y.Naganuma Mod
//	sHojCode, sSimpleName	: String;
//	eHojCode, eSimpleName	: String;
	sHojCode, sSimpleName, sRenso	: String;
	eHojCode, eSimpleName, erenso	: String;
//2007/05/21 <#011> Y.Naganuma Mod
begin
	//	パラメータクリア
	DlgParamClear(Param);

    // 帳票
	Param.Layout := MCombo_Layout.ItemIndex;

    // 印刷年月日
    if (EDPrnt.Value <> 0) then
    	Param.PrnDate := FormatDateTime('yyyy"/"mm"/"dd', EDPrnt.AsDateTime);

	// 補助出力範囲
	if EStHojTxt.Visible then
	begin
		sHojCode		:= EStHojTxt.Text;
		eHojCode		:= EEdHojTxt.Text;

//2007/05/21 <#011> Y.Naganuma Mod
//		if sHojCode = '' then GetDefaultHoj(0, sHojCode, sSimpleName);
//		if eHojCode = '' then GetDefaultHoj(1, eHojCode, eSimpleName);
		if sHojCode = '' then GetDefaultHoj(0, sHojCode, sSimpleName, sRenso);
		if eHojCode = '' then GetDefaultHoj(1, eHojCode, eSimpleName, eRenso);
//2007/05/21 <#011> Y.Naganuma Mod
	end
	else
	begin
		sHojCode		:= CodeEditToDB(EStHojNum.Text);
		eHojCode		:= CodeEditToDB(EEdHojNum.Text);

//2007/05/21 <#011> Y.Naganuma Mod
//		if sHojCode = '' then GetDefaultHoj(0, sHojCode, sSimpleName);
//		if eHojCode = '' then GetDefaultHoj(1, eHojCode, eSimpleName);
		if sHojCode = '' then GetDefaultHoj(0, sHojCode, sSimpleName, sRenso);
		if eHojCode = '' then GetDefaultHoj(1, eHojCode, eSimpleName, eRenso);
//2007/05/21 <#011> Y.Naganuma Mod
	end;

	Param.StrHojCd	:= ShortString(sHojCode);
	Param.EndHojCd	:= ShortString(eHojCode);
//2007/05/21 <#011> Y.Naganuma Add
    Param.StrRenso	:= ShortString(sRenso);			//	開始支払先連想
    Param.EndRenso	:= ShortString(eRenso);			//	終了支払先連想
//2007/05/21 <#011> Y.Naganuma Add

	// 集金/送付区分
	Param.LetterKbn	:= MCombo_LetterKbn.ItemIndex;

	// 郵送区分
	Param.YusouKbn	:= MCombo_YusouKbn.ItemIndex;

// <#018> ADD-STR
	// 郵送料負担区分
	Param.YusouFutan:= MCombo_YusouFutan.ItemIndex;
// <#018> ADD-END

// <#020> MOD-STR
//  if (MCombo_Layout.ItemIndex = 0) then
    if (MCombo_Layout.ItemIndex = 0) or (MCombo_Layout.ItemIndex = 3) then
// <#020> MOD-END
    begin
		// レイアウトパターン
        Param.LayoutPtn := MCombo_LayoutPtn.ItemIndex;
        //詳細はSetLayoutInfo関数での取得

		// 支払条件
        Param.PayCond := MCombo_PayCond.ItemIndex;

        // 支払方法
        if (MCombo_PayCond.Text = PAYCOND1) then
            SetPayWay(Param);
    end;
    
// <#024> ADD-STR
	//タックシール郵便マーク出力判定
    if (MCombo_Layout.ItemIndex = 3)then
	begin
        if (YubinMarkChkbox.Checked = True) then
            Param.YubinMarkChk := 0
        else
            Param.YubinMarkChk := 1;
    end;
// <#024> ADD-END

// <#018> ADD-STR
    if (MCombo_Layout.ItemIndex = 1) then
    begin
		// 手形送付案内レイアウトパターン
        if m_bTegFile2 then
            Param.LayoutPtnTeg := MCombo_LayoutPtnTeg.ItemIndex;
    end;
// <#018> ADD-END

	//改頁
    if (MCombo_Layout.ItemIndex = 1) then
    begin
        if (BCheckChangePage.Checked = True) then
        	Param.PageChangChk := 1
        else
        	Param.PageChangChk := 0;
    end;

    Param.Order := PMCombo.ItemIndex;	// 連想順
    Param.BilRendoNo := m_iBilRendoNo;	// 2006/07/21 <#006> Y.Naganuma Add

    Param.MailSend := m_bMailSend;      // <#021> ADD

// <#023> ADD-STR
    // 親画面に「ファイル保存」「メール」のいずれが押されたかを追加で返却
    Param.MailPDFSaveMode := m_iMailPDFSaveMode;
// <#023> ADD-END    
end;

//**************************************************************************
//  Proccess    :   CMChildKey手続き
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :	Msg
//  Return      :
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPAY510100Dlgf.CMChildKey(var Msg: TWMKey);
var
	ShiftState : TShiftState;
begin
	ShiftState := MJSKeyDataToShiftState(Msg.KeyData);		// <KDS> MOD

	if (Screen.ActiveControl is TMComboBox)	or
       (Screen.ActiveControl is TMTxtEdit)	then
	begin
		//	←キーでカーソルが先頭でない、→キーでカーソルが末尾でない … そのままぬける
		if (Msg.CharCode = VK_LEFT)  and (MjsChkCurTop(Screen.ActiveControl) = False) or
		   (Msg.CharCode = VK_RIGHT) and (MjsChkCurEnd(Screen.ActiveControl) = False) then
		   Exit;
	end;

	if Screen.ActiveControl is TCustomMEdit then
	begin
		//	TCustomMEditの派生コンポーネント
		if (Screen.ActiveControl as TCustomMEdit).ArrowDisp <> adNone then
		begin
			//	検索ｴｸｽﾌﾟﾛｰﾗ出す？
			if (GetKeyState(VK_MENU) < 0) and (Msg.CharCode = VK_DOWN) then
				Exit;
		end;
	end;

	case Msg.CharCode of
	  VK_LEFT:
		begin
			MjsPrevCtrl(Self);
			Abort;
		end;
	  VK_RIGHT:
		begin
			MjsNextCtrl(Self);
			Abort;
		end;
	  VK_UP:
		begin
			if not (Screen.ActiveControl is TMComboBox) then
			begin
				MjsPrevCtrl(Self);
				Abort;
			end;
		end;
	  VK_DOWN:
		begin
			if not (Screen.ActiveControl is TMComboBox) then
			begin
				MjsNextCtrl(Self);
				Abort;
			end;
		end;
	  VK_RETURN:
		begin
			if not (Screen.ActiveControl is TMBitBtn) then
			begin
				MjsNextCtrl(Self);
				Abort;
			end;
		end;
	  VK_END:
		begin
// <#021> ADD-STR
            if (SB_MAIL.Visible) then
            begin
                if (SB_MAIL.Enabled) then
                    SB_MAIL.SetFocus
                else
                    SB_PRINT.SetFocus;
            end
            else
// <#021> ADD-END
    			SB_OK.SetFocus;
			Abort;
		end;
	  VK_ESCAPE:
		begin
			ModalResult := mrCancel;
			Abort;
		end;
	end;

	inherited;
end;

//**************************************************************************
//  Proccess    :   パラメータ取得
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :	Param	ダイアログパラメータ
//  Return      :   Nathing
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPAY510100Dlgf.GetParam(var Param: TPay510100DlgParam);
var
	strpCode		:	String;
	EndpCode		:	String;
	strSimpleName	:	String;
    iKbn			:	Integer;
begin
	// 情報種別の設定
    iKbn := Param.Layout;
// <#020> MOD-STR
//	if (iKbn >= 0) and (iKbn <= 2) then
	if (iKbn >= 0) and (iKbn <= 3) then
// <#020> MOD-STR
    else
    	iKbn := 0;
   	MCombo_Layout.ItemIndex := iKbn;

    if Trim(Param.PrnDate) <> '' then
    begin
	    try
            m_DefPrnDate := StrToDate(Param.PrnDate);       // <#016> ADD
			EDPrnt.AsDateTime := StrToDate(Param.PrnDate);
    	except
    		EDPrnt.Value := 0;
    	end;
    end;

    // レイアウトパターン（支払通知書のみ）
    if MCombo_Layout.ItemIndex = 0 then
    begin
        iKbn := Param.LayoutPtn;
        if (iKbn >= 0) and (iKbn <= 7) then
        else
            iKbn := 0;
        MCombo_LayoutPtn.ItemIndex := iKbn;
    end;
// <#018> ADD-STR
    // レイアウトパターン（手形送付案内）
    if MCombo_Layout.ItemIndex = 1 then
    begin
        if m_bTegFile2 then
        begin
            iKbn := Param.LayoutPtnTeg;
            if (iKbn >= 0) and (iKbn <= 1) then
            else
                iKbn := 0;
            MCombo_LayoutPtnTeg.ItemIndex := iKbn;
        end;
    end;
// <#018> ADD-END

    strpCode := String(Param.StrHojCd);
    EndpCode := String(Param.EndHojCd);

    if ((strpCode = '') or (EndpCode = '')) then
    begin
        SetHojo(0, strpCode,  strSimpleName);
        SetHojo(1, EndpCode,  strSimpleName);
    end;

    //集金/送付区分
    MCombo_LetterKbn.ItemIndex := Param.LetterKbn;

    //郵送区分
    MCombo_YusouKbn.ItemIndex := Param.YusouKbn;

// <#018> ADD-STR
    //郵送料負担区分
    MCombo_YusouFutan.ItemIndex := Param.YusouFutan;
// <#018> ADD-END

// <#020> MOD-STR
//  //支払条件、支払方法（支払通知書のみ）
//  if MCombo_Layout.ItemIndex = 0 then
    //支払条件、支払方法（支払通知書、タックシールのみ）
    if (MCombo_Layout.ItemIndex = 0) or (MCombo_Layout.ItemIndex = 3) then
// <#020> MOD-END
    begin
	    MCombo_PayCond.ItemIndex := 0;
	   	SetPayWayEnable(False);
    end;

    //支払先ごとに改頁（手形のみ）
    if MCombo_Layout.ItemIndex = 1 then
    begin
	    if Param.PageChangChk = 1 then
        	BCheckChangePage.Checked := True
        else
        	BCheckChangePage.Checked := False;
    end;
// <#024> ADD-STR
	//印字有無チェックボックス初期化（タックシールのみ）
    if MCombo_Layout.ItemIndex = 3 then
    begin
	    if Param.YubinMarkChk = 1 then
        	YubinMarkChkbox.Checked := False
        else
        	YubinMarkChkbox.Checked := True;
    end;
// <#024> ADD-END
	//条件を再入力する時、前回の条件を残す
    if EStHojNum.Visible then
	begin
// 2005/11/11 <#002> Y.Kabashima Mod MLからのバグ
//    	EStHojNum.Value := StrToIntDef(Param.StrHojCd,0);
		if (Param.StrHojCd <> '') then EStHojNum.Value := StrToInt64(String(Param.StrHojCd));
// 2005/11/11 Y.Kabashima <#002>
	    if (Param.StrHojCd <> '') then EStHojNumExit(EStHojNum);
    end
    else
    begin
	    EStHojTxt.Text 	:= String(Param.StrHojCd);
	    if (Param.StrHojCd <> '') then EStHojTxtExit(EStHojTxt);
    end;

    if (EEdHojNum.Visible) then
	begin
// 2005/11/11 Y.Kabashima <#002> Mod MLからのバグ
//	    EEdHojNum.Value := StrToIntDef(Param.EndHojCd,0);
    	if (Param.EndHojCd <> '') then EEdHojNum.Value := StrToInt64(String(Param.EndHojCd));
// 2005/11/11 Y.Kabashima <#002>
	    if (Param.EndHojCd <> '') then EEdHojNumExit(EEdHojNum);
    end
    else
    begin
	    EEdHojTxt.Text 	:= String(Param.EndHojCd);
	    if (Param.EndHojCd <> '') then EEdHojTxtExit(EEdHojTxt);
    end;

    MCombo_PayCond.ItemIndex := Param.PayCond;

    MCombo_PayWay1.ItemIndex := Param.PayWayIndex[0];
    MCombo_PayWay2.ItemIndex := Param.PayWayIndex[1];
	MCombo_PayWay3.ItemIndex := Param.PayWayIndex[2];

    MCombo_PayCondChange(MCombo_PayCond);
end;

//**********************************************************************
//	Proccess	:	サーバー日付取得処理
// 	Name        :	K.IKEMURA (RIT)
// 	Date	    :	2002 / 01 / 16
//	Parameter   :	Nothing
//	Return		:	TDateTime
//  History     :	9999 / 99 / 99  X.Xxxxxx
//               	XXXXXXXX修正内容
//**********************************************************************
function TPAY510100Dlgf.Get_SysDate(Query: TMQuery): TDateTime;
begin
	with Query do
	begin
	    // システム日付を取得
	   	Close;
		SQL.Clear;
		SQL.Add('SELECT GETDATE(*) AS SYSDATE ');
	    if Open = False then
            ErrorMessageDsp(Query);

	    if eof then Result := Null
        else Result := GetFld('SYSDATE').AsDateTime;
	    Close;
    end;
end;

//**************************************************************************
//  Proccess    :   補助デフォルト取得処理	(支払管理の設定されている補助)
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :	Kbn			取得区分 (0:開始コード 1:終了コード)
//				:	Code		コード	(out)
//				:	SimpleName	簡略名称(out)
//  Return      :	True or False
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPAY510100Dlgf.GetDefaultHoj(Kbn: Byte; var Code,
//2007/05/21 <#011> Y.Naganuma Mod
//SimpleName: String): Boolean;
	SimpleName, Renso: String): Boolean;
//2007/05/21 <#011> Y.Naganuma Mod
var
	Query : TMQuery;
    sSql : String;
begin
	Result := False;

	Query := TMQuery.Create(Self);

	try
		m_DataModule.SetDBInfoToQuery(m_DBCorp, Query);

		with Query do
		begin
			//支払先の範囲にて、0,マイナス金額の支払先は選択できないようにする
			Close;
			SQL.Clear;

			sSql := '';
			sSql := sSql + 'SELECT ';
			sSql := sSql + 'TOP 1 ';
			sSql := sSql + 'MV_MAS_HojyoMA22.GCode, ';
			sSql := sSql + 'MV_MAS_HojyoMA22.Renso, ';
			sSql := sSql + 'MV_MAS_HojyoMA22.SimpleName ';
			sSql := sSql + 'FROM ';
			sSql := sSql + 'MV_MAS_HojyoMA22, ';
//			sSql := sSql + 'MasterInfo, ';
			sSql := sSql + 'MasterInfo ';       // <#014> Mod
// 2006/07/27 <#007> Y.Naganuma Mod
//			sSql := sSql + 'PayStatusData, ';
//			sSql := sSql + 'PayActionInfo ';
//			sSql := sSql + 'PayStatusData ';    // <#014> Del ※条件文内に移動
// 2006/07/27 <#007> Y.Naganuma Mod
			sSql := sSql + 'WHERE ';
			sSql := sSql + GetWherePayHoj;
			sSql := sSql + 'ORDER BY ';

			//	終了？
			if Kbn = 0 then
            begin
				if PMCombo.Items[PMCombo.ItemIndex] = '連想順' Then
					sSql := sSql + 'MV_MAS_HojyoMA22.Renso, ';

				sSql := sSql + 'MV_MAS_HojyoMA22.GCode ';
            end
			else
            begin
				if PMCombo.Items[PMCombo.ItemIndex] = '連想順' Then
					sSql := sSql + 'MV_MAS_HojyoMA22.Renso DESC, ';

				sSql := sSql + 'MV_MAS_HojyoMA22.GCode DESC ';
            end;

            ParamCheck := False;	//2006/07/27 <#007> Y.Naganuma Add
			SQL.Add( sSql );

			try
	            Prepare;			//2006/07/27 <#007> Y.Naganuma Add
				Open(True);
			except
				ErrorMessageDsp(Query);
				Exit;
			end;

			if Eof = True then Exit;

			Code		:= GetFld('GCode'     ).AsString;
			SimpleName	:= GetFld('SimpleName').AsString;
			Renso		:= GetFld('Renso'     ).AsString;	//2007/05/21 <#011> Y.Naganuma Mod
		end;

	finally
		Query.Free;
	end;

	Result := True;
end;

// 2005/11/08 <#001> Y.Kabashima Del 使用していない関数の為、削除
(*//**************************************************************************
//  Proccess    :   補助入力処理
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :	Code		コード	(in→out)
//				:	SimpleName	簡略名称(out)
//  Return      :	True or False
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPAY510100Dlgf.GetInputHoj(var Code, SimpleName: String): Boolean;
var
	Query : TMQuery;
	wkCode : String;
    sSql : String;
begin
	Result := False;

	wkCode := CodeEditToDB(Code);

	Query := TMQuery.Create(Self);

	try
		m_DataModule.SetDBInfoToQuery(m_DBCorp, Query);

		with Query do
		begin
			Close;
			SQL.Clear;
			sSql := '';
			sSql := sSql + 'SELECT ';
			sSql := sSql + 'TOP 1 ';
			sSql := sSql + 'MV_MAS_HojyoMA22.GCode, ';
			sSql := sSql + 'MV_MAS_HojyoMA22.SimpleName ';
			sSql := sSql + 'FROM ';
			sSql := sSql + 'MV_MAS_HojyoMA22, ';
			sSql := sSql + 'MasterInfo ';
			sSql := sSql + 'WHERE ';
			sSql := sSql + GetWhereHoj;
			sSql := sSql + 'AND MV_MAS_HojyoMA22.GCode = :w_GCode ';

			SQL.Add( sSql );

			ParamByName('w_GCode').AsString := wkCode;

			try
				Open(True);

			except
				ErrorMessageDsp(Query);
				Exit;
			end;

			if Eof = True then Exit;

			Code		:= GetFld( 'GCode'		).AsString;
			SimpleName	:= GetFld( 'SimpleName'	).AsString;
		end;

	finally
		Query.Free;
	end;

	Result := True;

end;
*)

//**************************************************************************
//  Proccess    :   補助入力処理	(支払管理の設定されている補助)
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :	Code		コード	(in→out)
//				:	SimpleName	簡略名称(out)
//				:	Renso		連想(out)
//  Return      :	True or False
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPAY510100Dlgf.GetInputPayHoj(var Code,
//2007/05/21 <#011> Y.Naganuma Mod
//SimpleName: String): Boolean;
	SimpleName, Renso: String): Boolean;
//2007/05/21 <#011> Y.Naganuma Mod
var
	Query : TMQuery;
	wkCode : String;
    sSql : String;
begin
	Result := False;

	wkCode := CodeEditToDB(Code);

	Query := TMQuery.Create(Self);

	try
		m_DataModule.SetDBInfoToQuery(m_DBCorp, Query);

		with Query do
		begin
			//支払先の範囲にて、0,マイナス金額の支払先は選択できないようにする
			Close;
			SQL.Clear;

			sSql := '';
			sSql := sSql + 'SELECT ';
//2006/07/27 <#007> Y.Naganuma Mod
{			sSql := sSql + 'TOP 1 ';
			sSql := sSql + 'MV_MAS_HojyoMA22.GCode, ';
			sSql := sSql + 'MV_MAS_HojyoMA22.SimpleName ';
			sSql := sSql + 'FROM ';
			sSql := sSql + 'MV_MAS_HojyoMA22, ';
			sSql := sSql + 'MasterInfo, ';
			sSql := sSql + 'PayStatusData, ';
			sSql := sSql + 'PayActionInfo ';
			sSql := sSql + 'WHERE ';
			sSql := sSql + GetWhereHoj;
			sSql := sSql + 'AND MV_MAS_HojyoMA22.GCode = :w_GCode ';
}
			sSql := sSql + 'MV22.GCode, ';
			sSql := sSql + 'MV22.Renso, ';			//2007/05/21 <#011> Y.Naganuma Mod
			sSql := sSql + 'MV22.SimpleName ';
			sSql := sSql + 'FROM ';
			sSql := sSql + 'MV_MAS_HojyoMA22 MV22, ';
// <#014> 2008/02/29 H.Kawato Mod
//			sSql := sSql + 'MasterInfo MI, ';
//			sSql := sSql + 'PayStatusData PS ';
			sSql := sSql + 'MasterInfo MI ';
// <#014> 2008/02/29 H.Kawato Mod
			sSql := sSql + 'WHERE ';
			sSql := sSql + 'MV22.MasterKbn = MI.MasterKbn ';
			sSql := sSql + 'AND MV22.RDelKbn = 0 ';
			sSql := sSql + 'AND MV22.HojyoKbn2 = 1 ';				//支入先採用
			sSql := sSql + 'AND MI.UseKbn = 1 ';
// <#014> 2008/02/29 H.Kawato Mod Start
{
			sSql := sSql + 'AND MV22.NCode = PS.PayNCode ';
			sSql := sSql + 'AND PS.SystemCode = ' + IntToStr(m_iSystemCode) + ' ';
			sSql := sSql + 'AND PS.FuncNo = ' + IntToStr(m_iFuncNo) + ' ';
			sSql := sSql + 'AND PS.NayoseKbn IN (0,2) ';
			sSql := sSql + 'AND PS.ProgKbn >= 4 ';
			sSql := sSql + 'AND PS.SiharaiKin > 0 ';
}
			sSql := sSql + 'AND ( ';
			sSql := sSql + '(MV22.NCode IN ( ';
			sSql := sSql + ' SELECT PayNCode FROM PayStatusData ';
			sSql := sSql + ' WHERE SystemCode = ' + IntToStr(m_iSystemCode) + ' ';
			sSql := sSql + ' AND FuncNo = ' + IntToStr(m_iFuncNo) + ' ';
			sSql := sSql + ' AND ProgKbn >= 4 ';
			sSql := sSql + ' AND SiharaiKin > 0 ';
			sSql := sSql + ' AND ( NayoseKbn = 0 OR NayoseKbn = 2 ) ';
			sSql := sSql + ' AND PayNCode NOT IN ( ';
			sSql := sSql + ' SELECT PayNCode FROM PayNayoseInfo ';
			sSql := sSql + ' WHERE MasterKbn = MV22.MasterKbn ';
			sSql := sSql + ' AND NayoseSyu = 2 ';
			sSql := sSql + ' AND NayoseKbn = 1 ';
			sSql := sSql + ' AND RDelKbn = 0))) ';
			sSql := sSql + 'OR ';
			sSql := sSql + '(MV22.NCode IN ( ';
			sSql := sSql + ' SELECT NayoseOyaNCode FROM PayNayoseInfo ';
			sSql := sSql + ' WHERE MasterKbn = MV22.MasterKbn ';
			sSql := sSql + ' AND NayoseSyu = 2 ';
			sSql := sSql + ' AND NayoseKbn = 1 ';
			sSql := sSql + ' AND RDelKbn = 0 ';
			sSql := sSql + ' AND PayNCode IN ( ';
			sSql := sSql + ' SELECT PayNCode FROM PayStatusData ';
			sSql := sSql + ' WHERE SystemCode = ' + IntToStr(m_iSystemCode) + ' ';
			sSql := sSql + ' AND FuncNo = ' + IntToStr(m_iFuncNo) + ' ';
			sSql := sSql + ' AND ProgKbn >= 4 ';
			sSql := sSql + ' AND SiharaiKin > 0 ';
			sSql := sSql + ' AND ( NayoseKbn = 0 OR NayoseKbn = 1 ))';
			sSql := sSql + '))) ';
// <#014> 2008/02/29 H.Kawato Mod End
// 2006/09/25 Y.Kabashima Mod <#008>
//			sSql := sSql + 'AND MV22.GCode = ' + QuotedStr(wkCode);
			sSql := sSql + 'AND MV22.GCode = ' + AnsiQuotedStr(wkCode, '''');
// 2006/09/25 Y.Kabashima Mod <#008>
//2006/07/27 <#007> Y.Naganuma Mod

            ParamCheck := False;	//2006/07/27 <#007> Y.Naganuma Add
			SQL.Add( sSql );

//			ParamByName('w_GCode').AsString := wkCode;	//2006/07/27 <#007> Y.Naganuma Del

			try
	            Prepare;			//2006/07/27 <#007> Y.Naganuma Add
				Open(True);
			except
				ErrorMessageDsp(Query);
				Exit;
			end;

			if Eof = True then Exit;

			Code		:= GetFld( 'GCode'		).AsString;
			SimpleName	:= GetFld( 'SimpleName'	).AsString;
			Renso		:= GetFld( 'Renso'		).AsString;	//2007/05/21 <#011> Y.Naganuma Add
		end;
	finally
		Query.Free;
	end;

	Result := True;
end;

//2006/07/27 <#007> Y.Naganuma Del
{//**************************************************************************
//  Proccess    :   SQL文のWHERE句取得 (補助取得)
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :
//  Return      :	WHERE句
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPAY510100Dlgf.GetWhereHoj: String;
var
	strWhere	:	String;
begin
	Result := '';
	strWhere := '';
	strWhere := strWhere + 'MV_MAS_HojyoMA22.MasterKbn = MasterInfo.MasterKbn ';
	strWhere := strWhere + 'AND MV_MAS_HojyoMA22.RDelKbn = 0 ';
	strWhere := strWhere + 'AND MV_MAS_HojyoMA22.HojyoKbn2 = 1 ';	//支入先採用
	strWhere := strWhere + 'AND MasterInfo.UseKbn = 1 ';

    Result := strWhere;
end;
}
//2006/07/27 <#007> Y.Naganuma Del

//**************************************************************************
//  Proccess    :   SQL文のWHERE句取得 (支払管理の設定されている補助取得)
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :
//  Return      :	WHERE句
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPAY510100Dlgf.GetWherePayHoj: String;
var
	strWhere	:	String;
begin
	Result := '';

	strWhere := '';
    strWhere := strWhere + 'MasterInfo.MasterKbn = MV_MAS_HojyoMA22.MasterKbn ';
//    strWhere := strWhere + 'AND PayStatusData.PayNCode = MV_MAS_HojyoMA22.NCode ';    // <#014> Del
    strWhere := strWhere + 'AND MasterInfo.UseKbn = 1 ';
    strWhere := strWhere + 'AND MV_MAS_HojyoMA22.HojyoKbn2 = 1 ';				// <#014> 支入先採用
	strWhere := strWhere + 'AND MV_MAS_HojyoMA22.RDelKbn = 0 ';
// <#014> 2008/02/29 H.Kawato Mod Start
{
// 2006/07/27 <#007> Y.Naganuma Mod
//	strWhere := strWhere + 'AND PayStatusData.SystemCode = 1 ';	//支払管理
    strWhere := strWhere + 'AND PayStatusData.SystemCode = ' + IntToStr(m_iSystemCode) + ' ';	//支払管理
    strWhere := strWhere + 'AND PayStatusData.FuncNo = '     + IntToStr(m_iFuncNo) + ' ';
    strWhere := strWhere + 'AND PayStatusData.ProgKbn >= 4 ';
// 2006/07/27 <#007> Y.Naganuma Mod
    strWhere := strWhere + 'AND PayStatusData.SiharaiKin > 0 ';	//総支払金額
// 2006/07/27 <#007> Y.Naganuma Del
//	strWhere := strWhere + 'AND PayActionInfo.Condition = 0 ';	//処理状況
//	strWhere := strWhere + 'AND PayActionInfo.FuncNo = PayStatusData.FuncNo ';
// 2006/07/27 <#007> Y.Naganuma Del
    strWhere := strWhere + 'AND ( ';
// 2006/07/27 <#007> Y.Naganuma Mod
//	strWhere := strWhere + '(PayStatusData.NayoseKbn = 0) or ';
//	strWhere := strWhere + '(PayStatusData.NayoseKbn = 2 and ';
//	strWhere := strWhere + ' PayStatusData.PayNCode IN (Select NayoseOyaNCode from PayStatusData where NayoseKbn = 1)) ';
	strWhere := strWhere + 'PayStatusData.NayoseKbn = 0 OR PayStatusData.NayoseKbn = 2';
// 2006/07/27 <#007> Y.Naganuma Mod
    strWhere := strWhere + ') ';
}
    strWhere := strWhere + 'AND ( ';
    strWhere := strWhere + '(MV_MAS_HojyoMA22.NCode IN ( ';
    strWhere := strWhere + ' SELECT PayNCode FROM PayStatusData ';
    strWhere := strWhere + ' WHERE SystemCode = ' + IntToStr(m_iSystemCode) + ' ';
    strWhere := strWhere + ' AND FuncNo = ' + IntToStr(m_iFuncNo) + ' ';
	strWhere := strWhere + ' AND ProgKbn >= 4 ';
    strWhere := strWhere + ' AND SiharaiKin > 0 ';
    strWhere := strWhere + ' AND ( NayoseKbn = 0 OR NayoseKbn = 2 ) ';
    strWhere := strWhere + ' AND PayNCode NOT IN ( ';
    strWhere := strWhere + ' SELECT PayNCode FROM PayNayoseInfo ';
    strWhere := strWhere + ' WHERE MasterKbn = MV_MAS_HojyoMA22.MasterKbn ';
    strWhere := strWhere + ' AND NayoseSyu = 2 ';
	strWhere := strWhere + ' AND NayoseKbn = 1 ';
    strWhere := strWhere + ' AND RDelKbn = 0))) ';
    strWhere := strWhere + 'OR ';
    strWhere := strWhere + '(MV_MAS_HojyoMA22.NCode IN ( ';
    strWhere := strWhere + ' SELECT NayoseOyaNCode FROM PayNayoseInfo ';
    strWhere := strWhere + ' WHERE MasterKbn = MV_MAS_HojyoMA22.MasterKbn ';
    strWhere := strWhere + ' AND NayoseSyu = 2 ';
	strWhere := strWhere + ' AND NayoseKbn = 1 ';
    strWhere := strWhere + ' AND RDelKbn = 0 ';
    strWhere := strWhere + ' AND PayNCode IN ( ';
    strWhere := strWhere + ' SELECT PayNCode FROM PayStatusData ';
    strWhere := strWhere + ' WHERE SystemCode = ' + IntToStr(m_iSystemCode) + ' ';
    strWhere := strWhere + ' AND FuncNo = ' + IntToStr(m_iFuncNo) + ' ';
    strWhere := strWhere + ' AND ProgKbn >= 4 ';
	strWhere := strWhere + ' AND SiharaiKin > 0 ';
    strWhere := strWhere + ' AND ( NayoseKbn = 0 OR NayoseKbn = 1 ))';
    strWhere := strWhere + '))) ';
// <#014> 2008/02/29 H.Kawato Mod End

// 2006/09/25 Y.Kabashima Mod <#008>
//// 2005/11/11 <#002> Y.Kabashima Add
//	if PMCombo.Items[PMCombo.ItemIndex] = '支払先順' Then
//	begin
//	    if (EEdHojNum.Focused) and (EStHojNum.Text <> '') then
//		    strWhere := strWhere + 'AND MV_MAS_HojyoMA22.GCode >= ''' + TPAY510100Com.Replace(EStHojNum.Text, 0) + ''' '
//	    else if (EEdHojTxt.Focused) and (EStHojTxt.Text <> '') then
//		    strWhere := strWhere + 'AND MV_MAS_HojyoMA22.GCode >= ''' + TPAY510100Com.Replace(EStHojTxt.Text, 1) + ''' ';
//	end
//    else if PMCombo.Items[PMCombo.ItemIndex] = '連想順' Then
//	begin
//	    if (EEdHojNum.Focused) and (EStHojNum.Text <> '') then
//        begin
//		    strWhere := strWhere + 'AND ((MV_MAS_HojyoMA22.Renso >= ''' + TPAY510100Com.GetRenso(m_Query, TPAY510100Com.Replace(EStHojNum.Text, 0)) + ''') ';
//		    strWhere := strWhere + 'AND NOT (MV_MAS_HojyoMA22.Renso = ''' + TPAY510100Com.GetRenso(m_Query, TPAY510100Com.Replace(EStHojNum.Text, 0)) + ''' ';
//		    strWhere := strWhere + 'AND MV_MAS_HojyoMA22.GCode < ''' + TPAY510100Com.Replace(EStHojNum.Text, 0) + ''')) ';
//        end
//	    else if (EEdHojTxt.Focused) and (EStHojTxt.Text <> '') then
//		begin
//		    strWhere := strWhere + 'AND ((MV_MAS_HojyoMA22.Renso >= ''' + TPAY510100Com.GetRenso(m_Query, TPAY510100Com.Replace(EStHojTxt.Text, 1)) + ''') ';
//		    strWhere := strWhere + 'AND NOT (MV_MAS_HojyoMA22.Renso = ''' + TPAY510100Com.GetRenso(m_Query, TPAY510100Com.Replace(EStHojTxt.Text, 1)) + ''' ';
//		    strWhere := strWhere + 'AND MV_MAS_HojyoMA22.GCode < ''' + TPAY510100Com.Replace(EStHojTxt.Text, 1) + ''')) ';
//        end;
//	end;
//// 2005/11/11 <#002> Y.Kabashima Add
	if PMCombo.Items[PMCombo.ItemIndex] = '支払先順' Then
	begin
	    if (EEdHojNum.Focused) and (EStHojNum.Text <> '') then
		    strWhere := strWhere + 'AND MV_MAS_HojyoMA22.GCode >= ' + AnsiQuotedStr(m_Pay510Com.Replace(EStHojNum.Text, 0), '''') + ' '
	    else if (EEdHojTxt.Focused) and (EStHojTxt.Text <> '') then
		    strWhere := strWhere + 'AND MV_MAS_HojyoMA22.GCode >= ' + AnsiQuotedStr(m_Pay510Com.Replace(EStHojTxt.Text, 1), '''') + ' ';
	end
    else if PMCombo.Items[PMCombo.ItemIndex] = '連想順' Then
	begin
	    if (EEdHojNum.Focused) and (EStHojNum.Text <> '') then
        begin
		    strWhere := strWhere + 'AND ((MV_MAS_HojyoMA22.Renso >= ' + AnsiQuotedStr(m_Pay510Com.GetRenso(m_Query, m_Pay510Com.Replace(EStHojNum.Text, 0)), '''') + ') ';
		    strWhere := strWhere + 'AND NOT (MV_MAS_HojyoMA22.Renso = ' + AnsiQuotedStr(m_Pay510Com.GetRenso(m_Query, m_Pay510Com.Replace(EStHojNum.Text, 0)), '''') + ' ';
		    strWhere := strWhere + 'AND MV_MAS_HojyoMA22.GCode < ' + AnsiQuotedStr(m_Pay510Com.Replace(EStHojNum.Text, 0), '''') + ')) ';
        end
	    else if (EEdHojTxt.Focused) and (EStHojTxt.Text <> '') then
		begin
		    strWhere := strWhere + 'AND ((MV_MAS_HojyoMA22.Renso >= ' + AnsiQuotedStr(m_Pay510Com.GetRenso(m_Query, m_Pay510Com.Replace(EStHojTxt.Text, 1)), '''') + ') ';
		    strWhere := strWhere + 'AND NOT (MV_MAS_HojyoMA22.Renso = ' + AnsiQuotedStr(m_Pay510Com.GetRenso(m_Query, m_Pay510Com.Replace(EStHojTxt.Text, 1)), '''') + ' ';
		    strWhere := strWhere + 'AND MV_MAS_HojyoMA22.GCode < ' + AnsiQuotedStr(m_Pay510Com.Replace(EStHojTxt.Text, 1), '''') + ')) ';
        end;
	end;
// 2006/09/25 Y.Kabashima Mod <#008>

    Result := strWhere;
end;

//**************************************************************************
//  Proccess    :   補助ｴｸｽﾌﾟﾛｰﾗ呼び出し処理
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :	Code		コード	(out)
//				:	SimpleName	簡略名称(out)
//  Return      :	True or False
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
//2007/05/21 <#011> Y.Naganuma Mod
//function TPAY510100Dlgf.CallHojExp(var NCode, Code, SimpleName: String): Boolean;
function TPAY510100Dlgf.CallHojExp(var NCode, Code, SimpleName, Renso: String): Boolean;
//2007/05/21 <#011> Y.Naganuma Mod
var
	Param: TMasWndParam;
begin
	Result	:= False;

	Param	:= TMasWndParam.CreateParam;
	try
		with Param do
		begin
			m_iParamType	:= 0;
			m_pApRec		:= m_pRec;

// 2005/11/08 <#001> Y.Kabashima Mod
{			m_NCodeFD		:= 'MV_MAS_HojyoMA.NCode';
			m_GCodeFD		:= 'MV_MAS_HojyoMA.GCode';
			m_RenCharFD		:= 'MV_MAS_HojyoMA.RenChar';
			m_SimpleNameFD	:= 'MV_MAS_HojyoMA.SimpleName';
			m_TableName		:= 'MV_MAS_HojyoMA,MasterInfo,PayStatusData,PayActionInfo';
			m_iCodeLength	:= m_MasterInfo.CodeDigit;
			m_iCodeAttr		:= m_MasterInfo.CodeAttr;
			m_SQL_where		:= GetWherePayHoj;

            if PMCombo.ItemIndex = 0 Then
				m_SQL_Order := 'MV_MAS_HojyoMA.GCode'
			else if PMCombo.ItemIndex = 1 Then
				m_SQL_Order := 'MV_MAS_HojyoMA.Renso';
}
			m_GCodeFD		:= 'MV_MAS_HojyoMA22.GCode ';
			m_RenCharFD		:= 'MV_MAS_HojyoMA22.Renso ';
			m_SimpleNameFD	:= 'MV_MAS_HojyoMA22.SimpleName ';
// 2006/07/27 <#007> Y.Naganuma Mod
//			m_TableName		:= 'MV_MAS_HojyoMA22, MasterInfo, PayStatusData, PayActionInfo ';
//			m_TableName		:= 'MV_MAS_HojyoMA22, MasterInfo, PayStatusData ';
			m_TableName		:= 'MV_MAS_HojyoMA22, MasterInfo '; // <#014> Mod ※PayStatusDataは条件文内に記述
// 2006/07/27 <#007> Y.Naganuma Mod
			m_iCodeLength	:= m_MasterInfo.CodeDigit;
			m_iCodeAttr		:= m_MasterInfo.CodeAttr;
			m_SQL_where		:= GetWherePayHoj;
            if PMCombo.Items[PMCombo.ItemIndex] = '支払先順' Then
				m_SQL_Order := 'MV_MAS_HojyoMA22.GCode'
			else if PMCombo.Items[PMCombo.ItemIndex] = '連想順' Then
				m_SQL_Order := 'MV_MAS_HojyoMA22.Renso, MV_MAS_HojyoMA22.GCode';
// 2005/11/08 <#001> Y.Kabashima Mod

			if m_Wnd.DoDlg(Param) = mrOk then
			begin
            	NCode		:= m_ExpRetNCode;
				Code 		:= m_ExpRetCode;
//2007/05/21 <#011> Y.Naganuma Mod
//				SimpleName	:= m_ExpRetText;
				GetInputPayHoj(Code, SimpleName, Renso);
//2007/05/21 <#011> Y.Naganuma Mod
				Result		:= True;
			end
			else
			begin
				Code		:= '';
				SimpleName	:= '';
				Renso		:= '';			//2007/05/21 <#011> Y.Naganuma Add
			end;
		end;

	finally
		Param.Free;
	end;
end;

//**************************************************************************
//  Proccess    :   コード属性をコンポーネントにセット
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :	CodeDigit	コード桁数
//				:	CodeAttr	コード属性
//  Return      :
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPAY510100Dlgf.SetCodeAttr(CodeDigit, CodeAttr: Integer);
var
	Fmt : String;
begin
	case CodeAttr of
	0,1:
		begin
			if CodeAttr = 0 then
				Fmt := ''
			else
				Fmt := StringOfChar('0', CodeDigit);

			EStHojTxt.Visible	:= False;
			EEdHojTxt.Visible	:= False;
			EStHojNum.FormatStr:= Fmt;
			EEdHojNum.FormatStr:= Fmt;
			EStHojNum.Digits	:= CodeDigit;
			EEdHojNum.Digits	:= CodeDigit;
			EStHojNum.Visible	:= True;
			EEdHojNum.Visible	:= True;
		end;
	  2:
		begin
			EStHojNum.Visible	:= False;
			EEdHojNum.Visible	:= False;
			EStHojTxt.MaxLength:= CodeDigit;
			EEdHojTxt.MaxLength:= CodeDigit;
			EStHojTxt.Visible	:= True;
			EEdHojTxt.Visible	:= True;
		end;
	end;
end;

//**************************************************************************
//  Proccess    :   支払管理情報取得処理
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :
//  Return      :	True or False
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPAY510100Dlgf.GetPayBaseInfo(var LayoutCtrl:TMPayBaseLayoutInfo): Boolean;
begin
	Result := False;

    if SetNoticeDoc then
	begin
    	//	レイアウトファイル情報
	    if not GetLayout then
        	Exit;
	end;

    if SetPtnInfo then
    begin
        //	レイアウトパターン制御情報
        if not GetLayoutPtnInfo(LayoutCtrl) then
        begin
            CallErrorMessageDsp('通知書基本情報がありません。'+ #13 +
                        '基本情報登録画面で登録を行ってください。');
            Exit;
        end;

// 2006/07/21 <#005> Y.Naganuma Add
		//手形連動情報取得
        GetTegataRendoInfo();
// 2006/07/21 <#006> Y.Naganuma Add

// 2007/01/10 Y.Kabashima Add <#009>
		// プロジェクト別支払情報取得
        GetProjectInfo();
// 2007/01/10 Y.Kabashima Add <#009>
	    Result := True;
    end;
end;

//**************************************************************************
//  Proccess    :   支払管理情報取得処理
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :
//  Return      :	True or False
//  Comment     :	一つでも登録情報があればTrueを返す
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPAY510100Dlgf.GetLayoutPtnInfo(var LayoutCtrl:TMPayBaseLayoutInfo): Boolean;
	function CheckData(Str: String):Integer;
    var
    	int : Integer;
    begin
    	try
    	int := StrToInt(Str);

        if (int <> 0) and (int <> 1) then
            Result := 0	//	6002:科目名　6003～6005:印刷する
        else
        	Result := int;
        except
        	Result := 0;
        end;
    end;
var
    strDataStr : String;
    wkInt : Integer;
begin
	Result := False;

// <#021> ADD-STR
    if (not m_PayBaseInfo.GetBaseInfoStr(strDataStr,FOLDLINE)) then
    begin
        Exit;
    end;
// <#021> ADD-END

	//KFKANRIUSEKBN = 2214;			//期日指定振込管理NO採用区分
    strDataStr := '';
    if ((m_PayBaseInfo.GetBaseInfoStr(strDataStr,KFKANRIUSEKBN)) and
        (strDataStr <> '')) then
    begin
    	LayoutCtrl.KanriNoUseKbn[0]		:= CheckData(strDataStr);
        Result := True;
    end;

	//BILLKANRIUSEKBN = 2301;    	//手形管理NO採用区分
    strDataStr := '';
    if ((m_PayBaseInfo.GetBaseInfoStr(strDataStr,BILLKANRIUSEKBN)) and
        (strDataStr <> '')) then
    begin
    	LayoutCtrl.KanriNoUseKbn[1]		:= CheckData(strDataStr);
        Result := True;
    end;

	//CHECKKANRIUSEKBN = 2401;    	//小切手管理NO採用区分
    strDataStr := '';
    if ((m_PayBaseInfo.GetBaseInfoStr(strDataStr,CHECKKANRIUSEKBN)) and
        (strDataStr <> '')) then
    begin
    	LayoutCtrl.KanriNoUseKbn[2]		:= CheckData(strDataStr);
        Result := True;
    end;

// <#013> 2007/09/11 H.Kawato Add Start
	//GENSENSAIYOKBN = 2621;   		//預かり源泉税採用区分
    strDataStr := '';
    if ((m_PayBaseInfo.GetBaseInfoStr(strDataStr,GENSENSAIYOKBN)) and
        (strDataStr <> '')) then
    begin
    	LayoutCtrl.GensenSaiyoKbn	:= CheckData(strDataStr);
        Result := True;
    end;
// <#013> 2007/09/11 H.Kawato Add End

// <#015> Add Start ↓↓↓
	//KOJONAME1	= 2652;   			//工事業控除1名称
    strDataStr := '';
    if ((m_PayBaseInfo.GetBaseInfoStr(strDataStr,KOJONAME1)) and
        (strDataStr <> '')) then
    begin
    	LayoutCtrl.KojName[0]	:= strDataStr;
        Result := True;
    end;
	//KOJONAME2	= 2682;   			//工事業控除2名称
    strDataStr := '';
    if ((m_PayBaseInfo.GetBaseInfoStr(strDataStr,KOJONAME2)) and
        (strDataStr <> '')) then
    begin
    	LayoutCtrl.KojName[1]	:= strDataStr;
        Result := True;
    end;
	//KOJONAME3	= 2712;   			//工事業控除3名称
    strDataStr := '';
    if ((m_PayBaseInfo.GetBaseInfoStr(strDataStr,KOJONAME3)) and
        (strDataStr <> '')) then
    begin
    	LayoutCtrl.KojName[2]	:= strDataStr;
        Result := True;
    end;
// <#015> Add End ↑↑↑

	//NAMEPRINTKBN = 4012;    		//受取人名印刷区分
    strDataStr := '';
    if ((m_PayBaseInfo.GetBaseInfoStr(strDataStr,NAMEPRINTKBN)) and
        (strDataStr <> '')) then
    begin
    	LayoutCtrl.NamePrintKbn		:= CheckData(strDataStr);
        Result := True;
    end;

//2007/05/21 <#011> Y.Naganuma Add
    strDataStr := '';
	//PRJSAIYOKBN	= 4021;				//プロジェクト別支払採用区分
    if ((m_PayBaseInfo.GetBaseInfoStr(strDataStr,PRJSAIYOKBN)) and
        (strDataStr <> '')) then
    begin
    	LayoutCtrl.PrjSaiyoKbn		:= CheckData(strDataStr);
        Result := True;
    end;
	//プロジェクト支払採用があり
	if LayoutCtrl.PrjSaiyoKbn <> 0 then
	begin
	    strDataStr := '';
		//PRJKBN			= 4022;		//プロジェクト区分
	    if ((m_PayBaseInfo.GetBaseInfoStr(strDataStr,PRJKBN)) and
	   	    (strDataStr <> '')) then
	    begin
    		LayoutCtrl.PrjKbn		:= StrToInt(strDataStr);
	        Result := True;
	    end;

		//PRJSUBSAIYOKBN	= 4023;		//プロジェクトサブ別支払採用区分
	    if ((m_PayBaseInfo.GetBaseInfoStr(strDataStr,PRJSUBSAIYOKBN)) and
    	    (strDataStr <> '')) then
	    begin
    		LayoutCtrl.PjsSaiyoKbn		:= CheckData(strDataStr);
        	Result := True;
	    end;
    end
	else
	begin
		LayoutCtrl.PrjKbn		:= 0;
		LayoutCtrl.PjsSaiyoKbn	:= 0;
	end;
//2007/05/21 <#011> Y.Naganuma Add

	//FOLDLINE = 6001;    			//折り目区切り線
    strDataStr := '';
    if ((m_PayBaseInfo.GetBaseInfoStr(strDataStr,FOLDLINE)) and
        (strDataStr <> '')) then
    begin
    	wkInt := StrToInt(strDataStr);

        if (wkInt <> 0) and (wkInt <> 1) then
            LayoutCtrl.Foldline		:= 1	//	あり
        else
            LayoutCtrl.Foldline		:= wkInt;

        Result := True;
    end;

	//KOUJOKOUPRINTKBN = 6002;		//控除項目印刷区分
    strDataStr := '';
    if ((m_PayBaseInfo.GetBaseInfoStr(strDataStr,KOUJOKOUPRINTKBN)) and
        (strDataStr <> '')) then
    begin
    	LayoutCtrl.Koujokouprintkbn		:= CheckData(strDataStr);
        Result := True;
    end;

    //TEKIOUTKBN = 6003;    		//摘要欄出力区分
    strDataStr := '';
    if ((m_PayBaseInfo.GetBaseInfoStr(strDataStr,TEKIOUTKBN)) and
        (strDataStr <> '')) then
    begin
    	LayoutCtrl.Tekioutkbn		:= CheckData(strDataStr);
        Result := True;
    end;

    //TEKIPAYPRINTKBN = 6004;    	//摘要欄の支払先名印刷区分
    strDataStr := '';
    if ((m_PayBaseInfo.GetBaseInfoStr(strDataStr,TEKIPAYPRINTKBN)) and
        (strDataStr <> '')) then
    begin
    	LayoutCtrl.Tekipayprintkbn		:= CheckData(strDataStr);
        Result := True;
    end;

    //TASHATSKOUJOKBN = 6005;    	//他社負担手数料控除区分
    strDataStr := '';
    if ((m_PayBaseInfo.GetBaseInfoStr(strDataStr,TASHATSKOUJOKBN)) and
        (strDataStr <> '')) then
    begin
    	LayoutCtrl.Tashatskoujokbn		:= CheckData(strDataStr);
        Result := True;
    end;

    //JISHABUSHONAME = 6007;    	//自社　部署名
    strDataStr := '';
    if ((m_PayBaseInfo.GetBaseInfoStr(strDataStr,JISHABUSHONAME)) and
        (strDataStr <> '')) then
    begin
    	LayoutCtrl.Jishabushoname		:= strDataStr;
        Result := True;
    end;
end;

// 2006/07/21 <#006> Y.Naganuma Add
//**************************************************************************
//  Proccess    :	手形連動情報取得処理
//  Name        :   Y.Naganuma (MSI)
//  Date	    :	2006 / 07 / 21
//  Parameter   :
//  Return      :	True or False
//  Comment     :	一つでも登録情報があればTrueを返す
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPAY510100Dlgf.GetTegataRendoInfo();
var
	strDataStr	: String;
	iRCd		: Integer;
	iBilDataNo	: Integer;
begin
    //支払管理基本情報より手形連動採用区分(ITEMID=BILSAIKBN)を取得
   	if not m_PayBaseInfo.GetBaseInfoStr(strDataStr, BILSAIKBN) then
		strDataStr   := '0';

   	if strDataStr = '' then
    	iRCd := 0
   	else
    	iRCd := StrToInt(strDataStr);

	if iRCd = 1 then
    begin
	    //支払管理基本情報より並行支払採用区分(ITEMID=SONOTAUSEKBN)を取得
   		if not m_PayBaseInfo.GetBaseInfoStr(strDataStr, SONOTAUSEKBN) then
			strDataStr   := '0';
	    if strDataStr = '' then
   			iRCd := 0
	   	else
			iRCd := StrToInt(strDataStr);

	    //支払管理基本情報より手形連動NO(ITEMID=BILSAINO)を取得
    	if not m_PayBaseInfo.GetBaseInfoStr(strDataStr, BILSAINO) then
			strDataStr   := '0';
	    if strDataStr = '' then
    		m_iBilRendoNo := 0
    	else
   			m_iBilRendoNo := StrToInt(strDataStr);

	    //支払管理基本情報より手形連動支払データ(ITEMID=BILDATANO)を取得
    	if not m_PayBaseInfo.GetBaseInfoStr(strDataStr, BILDATANO) then
			strDataStr   := '0';
	    if strDataStr = '' then
    		iBilDataNo := 0
    	else
   			iBilDataNo := StrToInt(strDataStr);
		if	(iRCd = 0) then						//並行支払採用なし
			iBilDataNo := 1;

		if m_iDataNo <> iBilDataNo then			// 今回データNOと手形連動データNoが違う
			m_iBilRendoNo := 0;
    end
   	else
		m_iBilRendoNo	:= 0;
end;
// 2006/07/21 <#006> Y.Naganuma Add

// 2007/01/10 Y.Kabashima Add <#009>
//**************************************************************************
//  Proccess    :	プロジェクト別支払情報取得処理
//  Name        :   Y.Kabashima (MSI)
//  Date	    :	2007/01/10
//  Parameter   :
//  Return      :
//  Comment     :
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPAY510100Dlgf.GetProjectInfo();
var
	strDataStr	: String;
	iRCd		: Integer;
begin
    //支払管理基本情報よりプロジェクト別支払採用区分(ITEMID=PRJSAIYOKBN)を取得
   	if not m_PayBaseInfo.GetBaseInfoStr(strDataStr, PRJSAIYOKBN) then
		strDataStr   := '0';

   	if strDataStr = '' then
    	iRCd := 0
   	else
    	iRCd := StrToInt(strDataStr);

	m_iProjectKbn := 0;
	if iRCd = 1 then
    begin
	    //支払管理基本情報よりプロジェクト区分(ITEMID=PRJKBN)を取得
   		if not m_PayBaseInfo.GetBaseInfoStr(strDataStr, PRJKBN) then
			strDataStr   := '0';
	    if strDataStr = '' then
   			iRCd := 0
	   	else
			iRCd := StrToInt(strDataStr);

		if GetUseKbn(iRCd) <> 0 then
			m_iProjectKbn := 1;
    end;

	m_iProjectSubKbn := 0;
	if m_iProjectKbn = 1 then
	begin
	    //支払管理基本情報よりプロジェクトサブ別支払採用区分(ITEMID=PRJSAIYOKBN)を取得
	   	if not m_PayBaseInfo.GetBaseInfoStr(strDataStr, PRJSUBSAIYOKBN) then
			strDataStr   := '0';

	   	if strDataStr = '' then
	    	iRCd := 0
	   	else
	    	iRCd := StrToInt(strDataStr);

		if iRCd = 1 then
	    begin
		    //支払管理基本情報よりプロジェクト区分(ITEMID=PRJKBN)を取得
	   		if not m_PayBaseInfo.GetBaseInfoStr(strDataStr, PRJKBN) then
				strDataStr   := '0';
		    if strDataStr = '' then
	   			iRCd := 0
		   	else
				iRCd := StrToInt(strDataStr) + 100;

			if GetUseKbn(iRCd) <> 0 then
				m_iProjectSubKbn := 1;
		end;
	end;
end;
// 2007/01/10 Y.Kabashima Add <#009>

//**************************************************************************
//  Proccess    :   支払管理情報取得処理
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :
//  Return      :	True or False
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPAY510100Dlgf.GetLayout(): Boolean;
begin
	Result := False;

    //支払通知書
    GetNoticeDoc;
    //ファイルチェック
    if not CheckFileExist then
    begin
        ErrorMsgDsp(ftNoticeDoc);
        Exit;
    end;

    //手形送付案内レイアウトパス取得
    GetTegFile;
    if not CheckTegataExist then
    begin
        ErrorMsgDsp(ftTegata);
        Exit;
    end;

    //手形送付案内文書取得
    GetTegBunsho;

    //書留レイアウトパス取得
    GetKakitomeFile;
    if not CheckKakitomeExist then
    begin
        ErrorMsgDsp(ftKakitome);
        Exit;
    end;

// <#020> ADD-STR
    //タックシールレイアウトパス取得
    GetTackSealFile;
    if not CheckTackSealExist then
    begin
        ErrorMsgDsp(ftTackSeal);
        Exit;
    end;
// <#020> ADD-END

	Result := True;
end;

//**************************************************************************
//  Proccess    :   支払管理情報取得処理
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :
//  Return      :	True or False
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPAY510100Dlgf.SetNoticeDoc: Boolean;
begin
// <#020> MOD-STR
//	//	通知書パターン名称　～　書留郵便物受領証まで
//	m_PayBaseInfo.SetBaseInfo(TUTIPATNNAME1,KAKITOMERECEIPT);
	//	通知書パターン名称　～　タックシールレイアウトまで
	m_PayBaseInfo.SetBaseInfo(TUTIPATNNAME1,TACKSEALLAYOUT);
// <#020> MOD-END
    Result := (m_PayBaseInfo.PBaseInfoRecArray <> nil) ;
end;

//**************************************************************************
//  Proccess    :   支払管理情報取得処理
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :
//  Return      :	True or False
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPAY510100Dlgf.SetDefPayWay(var StList :TStringList): Boolean;
var
	iIdx : integer;
    strDataStr : String;
    sErSaiyo : String;      // <#ERW> ADD
begin
	Result := False;

// <#ERW> ADD-STR
    strDataStr := '';
    m_PayBaseInfo.GetBaseInfoStr(strDataStr, ERSAIYO);
    sErSaiyo := strDataStr;
// <#ERW> ADD-END

    StList := TStringList.Create;

    m_PayBaseInfo.Free_BaseInfoRec;

    //	(支払方法1～支払方法5)
    m_PayBaseInfo.SetBaseInfo(PAYFLG1,PAYFLG5);

    if m_PayBaseInfo.PBaseInfoRecArray <> nil then
    begin
        for iIdx := 0 to High(m_PayBaseInfo.PBaseInfoRecArray) do
        begin
            strDataStr := '';

            if m_PayBaseInfo.GetBaseInfoStr(strDataStr,
                m_PayBaseInfo.PBaseInfoRecArray[iIdx].iItemID) then
            begin
                //支払方法に"0:なし"が設定されている場合は抜ける
				try
                    if StrToInt(strDataStr) = 0 then
                    begin
                        //支払方法[0]に0:"なし"であればエラー
                        if iIdx = 0 then
                            Exit
                        else
                        begin
                            Result := True;
                            Exit;
                        end;
                    end
                    else
                    begin
//2007/05/08 <#010> Y.Naganuma Del
//						if StrToInt(strDataStr) <= 5 then		// 2005/12/	09 Y.Kabashima Add
	                        StList.Add(StListPayWay[StrToInt(strDataStr)]);
// <#ERW> ADD-STR
                        if (strDataStr = '3') and (sErSaiyo = '1') then
                        begin
                            StList.Add(PAYWAY3E);
                        end;
// <#ERW> ADD-END
                    end;
                except
                	Exit;
                end;
            end
            else
                Exit;
        end;
        Result := True;
    end;
end;

//**************************************************************************
//  Proccess    :   支払管理情報取得処理
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :
//  Return      :	True or False
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPAY510100Dlgf.SetPtnInfo: Boolean;
const
// <#015> Mod
{// 2007/01/10 Y.Kabashima Mod <#009>
////2006/07/21 <#006> Y.Naganuma Mod
////	GETBASEINFO: array[0..9] of Integer=
//	GETBASEINFO: array[0..13] of Integer=
////2006/07/21 <#006> Y.Naganuma Mod
//	GETBASEINFO: array[0..16] of Integer=
// 2007/01/10 Y.Kabashima Mod <#009>
	GETBASEINFO: array[0..17] of Integer=       // <#013> Mod
}
	GETBASEINFO: array[0..MAX_PAYBASE_CNT] of Integer=
// <#015> Mod
	(
	//レイアウト情報
	        KFKANRIUSEKBN       //期日指定振込 管理NO採用区分
        ,	BILLKANRIUSEKBN     //手形管理NO採用区分
        ,	CHECKKANRIUSEKBN    //小切手管理NO採用区分
		,   NAMEPRINTKBN		//受取人名印刷区分
        ,	FOLDLINE            //折り目区切り線
        ,	KOUJOKOUPRINTKBN    //控除項目印刷区分
        ,	TEKIOUTKBN          //摘要欄出力区分
		,	TEKIPAYPRINTKBN		//摘要欄の支払先名印刷区分
        ,	TASHATSKOUJOKBN     //他社負担手数料控除区分
        ,	JISHABUSHONAME      //自社　部署名

//2006/07/21 <#006> Y.Naganuma Add
	    ,	SONOTAUSEKBN        //並行支払採用
        ,   BILSAIKBN           //手形連動採用区分
        ,	BILSAINO            //手形連動NO
        ,	BILDATANO           //手形連動支払データ
//2006/07/21 <#006> Y.Naganuma Add

// 2007/01/10 Y.Kabashima Add <#009>
	    ,	PRJSAIYOKBN         //プロジェクト別支払採用区分
        ,	PRJKBN              //プロジェクト区分
        ,	PRJSUBSAIYOKBN      //プロジェクトサブ別支払採用区分
// 2007/01/10 Y.Kabashima Add <#009>
	    ,	GENSENSAIYOKBN      //預かり源泉税採用区分 <#013> Add
// <#015> Add Start
	    ,	KOJONAME1      		//工事業控除1名称
	    ,	KOJONAME2      		//工事業控除2名称
	    ,	KOJONAME3      		//工事業控除3名称
// <#015> Add End
	    ,	ERSAIYO             // <#ERW> ADD
	);
begin
    m_PayBaseInfo.Free_BaseInfoRec;

    m_PayBaseInfo.SetBaseInfo(GETBASEINFO);
    Result := (m_PayBaseInfo.PBaseInfoRecArray <> nil) ;
end;

//**************************************************************************
//  Proccess    :   支払方法をパラメータへセット
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :
//  Return      :	True or False
//  History     :   2002 / 01 / 16  K.IKEMURA (RIT)
//                  ・支払方法１から支払方法３まで設定可
//**************************************************************************
procedure TPAY510100Dlgf.SetPayWay(var Param: TPay510100DlgParam);
var
	iIdx : Integer;
	WKCombo : TMComboBox;
begin
	for iIdx := 0 to 2 do
    begin
		WKCombo := nil;

    	case iIdx of
        	0: WKCombo := MCombo_PayWay1;
        	1: WKCombo := MCombo_PayWay2;
        	2: WKCombo := MCombo_PayWay3;
        end;

        if ((WKCombo.ItemIndex = -1) or (WKCombo.ItemIndex = 0)) then
            Param.PayWay[iIdx] := 0
        else
        begin
			Param.PayWay[iIdx] := StListPayWay.IndexOf(WKCombo.Text);

			Param.PayWayIndex[iIdx] := WKCombo.ItemIndex;
    	end;
    end;
end;

//**************************************************************************
//  Proccess    :   支払管理情報取得処理
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :   通知書名称 + COファイルパスの取得
//  Return      :	True or False
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPAY510100Dlgf.GetNoticeDoc;
var
	iIdx,iCount : integer;
    strDataStr : String;
    ItemTbl : array [0..8] of Integer;
begin
    // 通知書レイアウト（１～７まで）
    for iCount := 0 to High(PNoticeDoc) do
    begin
	    SetItemTable(ItemTbl,iCount);

        for iIdx := 0 to High(ItemTbl) do
        begin
            strDataStr := '';

            if ((m_PayBaseInfo.GetBaseInfoStr(strDataStr,ItemTbl[iIdx])) and
            	(strDataStr <> '')) then
            begin
                case iIdx of
                    0:PNoticeDoc[iCount].PtnName 	:= strDataStr ;
                    1:PNoticeDoc[iCount].BasicLayout:= strDataStr ;
                    2:PNoticeDoc[iCount].ToriDtl	:= strDataStr ;
                    3:PNoticeDoc[iCount].TegataDtl 	:= strDataStr ;
                    4:PNoticeDoc[iCount].KoujoDtl  	:= strDataStr ;
                    5:PNoticeDoc[iCount].KijitsuDtl := strDataStr ;
                    6:PNoticeDoc[iCount].Bunsho1	:= strDataStr ;
                    7:PNoticeDoc[iCount].Bunsho2	:= strDataStr ;
                    8:PNoticeDoc[iCount].Bunsho3	:= strDataStr ;
                end;
            end
            else
            begin
                case iIdx of
					//該当レコードが無い場合はデフォルトのCOReportsファイルパスを設定
                    0:PNoticeDoc[iCount].PtnName	:= GetPtnName(iCount);
                    1:PNoticeDoc[iCount].BasicLayout:= GetDefaultFile(iCount,ftBasicLayout);
                    2:PNoticeDoc[iCount].ToriDtl    := GetDefaultFile(iCount,ftToriDtl);
                    3:PNoticeDoc[iCount].TegataDtl 	:= GetDefaultFile(iCount,ftTegataDtl);
                    4:PNoticeDoc[iCount].KoujoDtl  	:= GetDefaultFile(iCount,ftKoujoDtl);
                    5:PNoticeDoc[iCount].KijitsuDtl := GetDefaultFile(iCount,ftKijitsuDtl);
                    6:PNoticeDoc[iCount].Bunsho1	:= '' ;
                    7:PNoticeDoc[iCount].Bunsho2	:= '' ;
                    8:PNoticeDoc[iCount].Bunsho3	:= '' ;
                end;
            end;
        end;
    end;
end;

//**************************************************************************
//  Proccess    :   支払管理情報取得処理
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :   COファイルパスの取得 （手形送付案内）
//  Return      :	True or False
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPAY510100Dlgf.GetTegFile;
var
	strDataStr : String;
begin
	strDataStr := '';

    if (m_PayBaseInfo.PBaseInfoRecArray = nil) then Exit;

    if ((m_PayBaseInfo.GetBaseInfoStr(strDataStr,BILLGUIDLAYOUT)) and
        (strDataStr <> ''))then
		TegFilePath := strDataStr
    else
        TegFilePath	:= GetDefaultTegataFile;

// <#018> ADD-STR
    m_bTegFile2 := False;
    TegFilePath2 := '';

    if (m_PayBaseInfo.GetBaseInfoStr(strDataStr,BILLGUIDLAYOUT2)) then
    begin
        m_bTegFile2 := True;

        if (strDataStr <> '')then
            TegFilePath2 := strDataStr
        else
            TegFilePath2 := GetDefaultTegataFile;
    end;

	TegPtnName  := '手形送付案内';
	TegPtnName2 := '手形送付案内２';

    // パターン名取得
    if m_bTegFile2 then
    begin
        if (m_PayBaseInfo.GetBaseInfoStr(strDataStr,BILLGUIDNAME1)) then
        begin
            if (strDataStr <> '')then
                TegPtnName := strDataStr;
        end;

        if (m_PayBaseInfo.GetBaseInfoStr(strDataStr,BILLGUIDNAME2)) then
        begin
            if (strDataStr <> '')then
                TegPtnName2 := strDataStr;
        end;
    end;
// <#018> ADD-END
end;

//**************************************************************************
//  Proccess    :   支払管理情報取得処理
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :   文書取得 （手形送付案内）
//  Return      :	True or False
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPAY510100Dlgf.GetTegBunsho;
var
	strDataStr : String;
begin
    strDataStr := '';

    if (m_PayBaseInfo.PBaseInfoRecArray = nil) then Exit;

    if m_PayBaseInfo.GetBaseInfoStr(strDataStr,BILL_BUNSHO1) then
        TegBunsho := strDataStr
    else
        TegBunsho := '';

// <#018> ADD-STR
    TegBunsho2 := '';

    if m_bTegFile2 then
    begin
        if m_PayBaseInfo.GetBaseInfoStr(strDataStr,BILL_BUNSYO2) then
            TegBunsho2 := strDataStr;
    end;
// <#018> ADD-END
end;

//**************************************************************************
//  Proccess    :   支払管理情報取得処理
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :   COファイルパスの取得 （書留）
//  Return      :	True or False
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPAY510100Dlgf.GetKakitomeFile;
var
	strDataStr : String;
begin
	strDataStr := '';

    if (m_PayBaseInfo.PBaseInfoRecArray = nil) then Exit;

    if ((m_PayBaseInfo.GetBaseInfoStr(strDataStr,KAKITOMERECEIPT)) and
        (strDataStr <> ''))then
		KakitomeFilePath := strDataStr
    else
		KakitomeFilePath := GetDefaultKakitomeFile;
end;

//**************************************************************************
//  Proccess    :   支払通知書デフォルト名称の取得
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 02 / 11
//  Parameter   :   通知書パターン
//  Return      :
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPAY510100Dlgf.GetPtnName(iIdx: Integer): String;
begin
	case iIdx of
    	0:Result := LAYOUTNAME1;
    	1:Result := LAYOUTNAME2;
    	2:Result := LAYOUTNAME3;
    	3:Result := LAYOUTNAME4;
    	4:Result := LAYOUTNAME5;
    	5:Result := LAYOUTNAME6;
    	6:Result := LAYOUTNAME7;
	    else Result := '';
    end;
end;

//**************************************************************************
//  Proccess    :   デフォルトファイル取得
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 02 / 11
//  Parameter   :   iCount : 通知書パターン
//  Return      :	COファイルパス
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPAY510100Dlgf.GetDefaultFile(iCount: Integer;fType : TFileType): String;
const
	StrExtension = '.crf';
begin
	case fType of
    	ftBasicLayout://基本レイアウト
        begin
            case iCount of
                0:Result := gsExePath + DEFBASIC1 + StrExtension;
                1:Result := gsExePath + DEFBASIC2 + StrExtension;
                2:Result := gsExePath + DEFBASIC3 + StrExtension;
                3:Result := gsExePath + DEFBASIC4 + StrExtension;
                4:Result := gsExePath + DEFBASIC5 + StrExtension;
                5:Result := gsExePath + DEFBASIC6 + StrExtension;
                6:Result := gsExePath + DEFBASIC7 + StrExtension;
                else Result := '';
            end;
        end;

        //通知書取引明細
        ftToriDtl:
        begin
        	Result := gsExePath + DEFTORIDETAIL + StrExtension;
        end;

        //通知書手形明細
        ftTegataDtl:
        begin
        	Result := gsExePath + DEFTEGATADETAIL + StrExtension;
        end;

        //通知書控除明細 OR 通知書事業所内訳明細
        ftKoujoDtl:
        begin
        	if iCount <> 5 then
	        	Result := gsExePath + DEFKOUJYODETAIL + StrExtension
            else
            	Result := gsExePath + DEFJIGYODETAIL  + StrExtension;
        end;

        //期日指定振込残高明細
        ftKijitsuDtl:
        begin
        	Result := gsExePath + DEFKIJITSUDETAIL + StrExtension
        end;

        // その他
	    else
        	Exit;
    end;
end;

//**************************************************************************
//  Proccess    :   デフォルトファイル取得
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 02 / 11
//  Parameter   :   手形送付案内
//  Return      :	COファイルパス
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPAY510100Dlgf.GetDefaultTegataFile: String;
const
	StrExtension = '.crf';
begin
    Result := gsExePath + DEFTEGATA + StrExtension;
end;

//**************************************************************************
//  Proccess    :   デフォルトファイル取得
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 02 / 11
//  Parameter   :   書留郵便物受領証
//  Return      :	COファイルパス
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPAY510100Dlgf.GetDefaultKakitomeFile: String;
const
	StrExtension = '.crf';
begin
    Result := gsExePath + DEFKAKITOME + StrExtension;
end;

//**************************************************************************
//  Proccess    :   情報種別毎の可視画面設定処理
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :	Nathing
//  Return      :   Nathing
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPAY510100Dlgf.SetPanelVisible;
begin
	PPayWay.Visible := (MCombo_Layout.Text = NOTICEDOC);

    if MCombo_Layout.Text = NOTICEDOC then//支払通知書
    begin
    	LPrintDate.Caption := HAKKOUDATE;	//日付
        MCombo_LayoutPtn.Visible := True;	//ﾚｲｱｳﾄ選択
        ETxtLayout.Visible := False;		//ﾚｲｱｳﾄﾗﾍﾞﾙ
        LYusouKbn.Visible := False;			//郵送区分ﾗﾍﾞﾙ
    	MCombo_YusouKbn.Visible := False;	//郵送区分入力
        BCheckChangePage.Visible := False;	//改頁ﾁｪｯｸ
// <#018> ADD-STR
        MCombo_LayoutPtnTeg.Visible := False;	//手形送付案内ﾚｲｱｳﾄ選択
        LYusouFutan.Visible := False;			//郵送料負担区分ﾗﾍﾞﾙ
    	MCombo_YusouFutan.Visible := False;	    //郵送料負担区分入力
// <#018> ADD-END
		YubinMarkChkbox .Visible := False;		//郵便記号出力チェックボックス // <#024> ADD-STR
    end;

    if MCombo_Layout.Text = TEGATA then	  //手形送付案内
    begin
    	LPrintDate.Caption := SENDDATE;		//日付
        MCombo_LayoutPtn.Visible := False;	//ﾚｲｱｳﾄ選択
        ETxtLayout.Visible := True;			//ﾚｲｱｳﾄ名称
        ETxtLayout.Text := TEGATA;			//ﾚｲｱｳﾄﾗﾍﾞﾙ
        LYusouKbn.Visible := True;			//郵送区分ﾗﾍﾞﾙ
    	MCombo_YusouKbn.Visible := True;	//郵送区分入力
        BCheckChangePage.Visible := True;	//改頁ﾁｪｯｸ
// <#018> ADD-STR
        if m_bTegFile2 then
            MCombo_LayoutPtnTeg.Visible := True;	//手形送付案内ﾚｲｱｳﾄ選択
        LYusouFutan.Visible := True;			    //郵送料負担区分ﾗﾍﾞﾙ
    	MCombo_YusouFutan.Visible := True;	        //郵送料負担区分入力
// <#018> ADD-END
// <#024> ADD-STR
		YubinMarkChkbox .Visible := False;		//郵便記号出力チェックボックス
    end;
// <#024> ADD-END

    if MCombo_Layout.Text = KAKITOME then //書留郵便受領書
    begin
    	LPrintDate.Caption := TEISYUTSUDATE;//日付
        MCombo_LayoutPtn.Visible := False;	//ﾚｲｱｳﾄ選択
        ETxtLayout.Visible := True;			//ﾚｲｱｳﾄﾗﾍﾞﾙ
        ETxtLayout.Text := KAKITOME;		//ﾚｲｱｳﾄﾗﾍﾞﾙ
        LYusouKbn.Visible := True;			//郵送区分ﾗﾍﾞﾙ
    	MCombo_YusouKbn.Visible := True;	//郵送区分入力
        BCheckChangePage.Visible := False;	//改頁ﾁｪｯｸ
// <#018> ADD-STR
        MCombo_LayoutPtnTeg.Visible := False;	//手形送付案内ﾚｲｱｳﾄ選択
        LYusouFutan.Visible := False;			//郵送料負担区分ﾗﾍﾞﾙ
    	MCombo_YusouFutan.Visible := False;	    //郵送料負担区分入力
// <#018> ADD-END
// <#024> ADD-STR
		YubinMarkChkbox .Visible := False;		//郵便記号出力チェックボックス
// <#024> ADD-END
    end;

// <#020> ADD-STR
    EDPrnt.Enabled := True;

    if MCombo_Layout.Text = TACKSEAL then //タックシール
    begin
    	LPrintDate.Caption := HAKKOUDATE;	//日付
        EDPrnt.Enabled := False;            //日付
        MCombo_LayoutPtn.Visible := False;	//ﾚｲｱｳﾄ選択
        ETxtLayout.Visible := True;			//ﾚｲｱｳﾄﾗﾍﾞﾙ
        ETxtLayout.Text := TACKSEAL;		//ﾚｲｱｳﾄﾗﾍﾞﾙ
        LYusouKbn.Visible := True;			//郵送区分ﾗﾍﾞﾙ
    	MCombo_YusouKbn.Visible := True;	//郵送区分入力
        BCheckChangePage.Visible := False;	//改頁ﾁｪｯｸ
        MCombo_LayoutPtnTeg.Visible := False;	//手形送付案内ﾚｲｱｳﾄ選択
        LYusouFutan.Visible := False;			//郵送料負担区分ﾗﾍﾞﾙ
    	MCombo_YusouFutan.Visible := False;	    //郵送料負担区分入力
    	PPayWay.Visible := True;
// <#024> ADD-STR
		YubinMarkChkbox .Visible := True;		//郵便記号出力チェックボックス
    end;
// <#024> ADD-END
// <#020> ADD-END

// <#021> ADD-STR
    // メール採用可否によるボタン制御
    if m_bMailUse then
    begin                                                       // <#023> ADD
        SB_MAIL.Enabled := (MCombo_Layout.Text = NOTICEDOC);
        SB_SAVE.Enabled := (MCombo_Layout.Text = NOTICEDOC);    // <#023> ADD
    end;                                                        // <#023> ADD
// <#021> ADD-END
end;

//**************************************************************************
//  Proccess    :   支払条件によって支払方法のコンボを選択可否にする
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :	Nathing
//  Return      :   Nathing
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPAY510100Dlgf.SetPayWayEnable(blnValue: Boolean);
begin
    if not blnValue then
    begin
		MCombo_PayWay1.ItemIndex := -1;
		MCombo_PayWay2.ItemIndex := -1;
		MCombo_PayWay3.ItemIndex := -1;
    end;

	MCombo_PayWay1.Enabled := blnValue;
	MCombo_PayWay2.Enabled := blnValue;
	MCombo_PayWay3.Enabled := blnValue;
end;

//**************************************************************************
//  Proccess    :   補助ｺｰﾄﾞ設定処理
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :	Kbn			取得区分 (0:開始コード 1:終了コード)
//				:	Code		コード
//				:	SimpleName	簡略名称
//  Return      :
//  History     :   9999/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPAY510100Dlgf.SetHojo(pKbn: Integer; pHojCode,
  pSimpleName: String);
begin
	case pKbn of
		0:
		begin
			if EStHojTxt.Visible = True then
			begin
				EStHojTxt.Text := pHojCode;
			end
			else
			begin
            	if (pHojCode = '') then
                	pHojCode := '0';
				EStHojNum.Value := StrToInt64Def(pHojCode, 0);
// <#012> 2007/06/05 H.Kawato Mod Start
//				EStHojNum.InputFlag	:= False;
                EStHojNum.Zero      := True;
                EStHojNum.InputFlag	:= True;
// <#012> 2007/06/05 H.Kawato Mod End
			end;
			LStHoj.Caption := pSimpleName;
		end;
		1:
		begin
			if EEdHojTxt.Visible = True then
			begin
				EEdHojTxt.Text := pHojCode;
			end
			else
			begin
            	if (pHojCode = '') then
                	pHojCode := '0';
				EEdHojNum.Value		:= StrToInt64Def(pHojCode, 0);
// <#012> 2007/06/05 H.Kawato Mod Start
//				EEdHojNum.InputFlag	:= False;
                EEdHojNum.Zero      := True;
                EEdHojNum.InputFlag	:= True;
// <#012> 2007/06/05 H.Kawato Mod End
			end;
			LEdHoj.Caption := pSimpleName;
		end;
    end;

end;

//**************************************************************************
//  Proccess    :   支払基本情報から取得したいItemTble(項目ID)のセット
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :
//  Return      :
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPAY510100Dlgf.SetItemTable(var ItemTbl: array of integer;intIndex:Integer);
begin
	FillChar(ItemTbl, SizeOf(ItemTbl), 0);

	case intIndex of
    	0:
        begin
            ItemTbl[0] := TUTIPATNNAME1;
            ItemTbl[1] := BASICLAYOUT1;
            ItemTbl[2] := TORILAYOUT1;
            ItemTbl[3] := BILLLAYOUT1;
            ItemTbl[4] := KOUJOLAYOUT1;
            ItemTbl[5] := KFLAYOUT1;
            ItemTbl[6] := PTRN1_BUNSHO1;
            ItemTbl[7] := PTRN1_BUNSHO2;
            ItemTbl[8] := PTRN1_BUNSHO3;
        end;
    	1:
        begin
            ItemTbl[0] := TUTIPATNNAME2;
            ItemTbl[1] := BASICLAYOUT2;
            ItemTbl[2] := TORILAYOUT2;
            ItemTbl[3] := BILLLAYOUT2;
            ItemTbl[4] := KOUJOLAYOUT2;
            ItemTbl[5] := KFLAYOUT2;
            ItemTbl[6] := PTRN2_BUNSHO1;
            ItemTbl[7] := PTRN2_BUNSHO2;
            ItemTbl[8] := PTRN2_BUNSHO3;
        end;
    	2:
        begin
            ItemTbl[0] := TUTIPATNNAME3;
            ItemTbl[1] := BASICLAYOUT3;
            ItemTbl[2] := TORILAYOUT3;
            ItemTbl[3] := BILLLAYOUT3;
            ItemTbl[4] := KOUJOLAYOUT3;
            ItemTbl[5] := KFLAYOUT3;
            ItemTbl[6] := PTRN3_BUNSHO1;
            ItemTbl[7] := PTRN3_BUNSHO2;
            ItemTbl[8] := PTRN3_BUNSHO3;
        end;
    	3:
        begin
            ItemTbl[0] := TUTIPATNNAME4;
            ItemTbl[1] := BASICLAYOUT4;
            ItemTbl[2] := TORILAYOUT4;
            ItemTbl[3] := BILLLAYOUT4;
            ItemTbl[4] := KOUJOLAYOUT4;
            ItemTbl[5] := KFLAYOUT4;
            ItemTbl[6] := PTRN4_BUNSHO1;
            ItemTbl[7] := PTRN4_BUNSHO2;
            ItemTbl[8] := PTRN4_BUNSHO3;
       end;
    	4:
        begin
            ItemTbl[0] := TUTIPATNNAME5;
            ItemTbl[1] := BASICLAYOUT5;
            ItemTbl[2] := TORILAYOUT5;
            ItemTbl[3] := BILLLAYOUT5;
            ItemTbl[4] := KOUJOLAYOUT5;
            ItemTbl[5] := KFLAYOUT5;
            ItemTbl[6] := PTRN5_BUNSHO1;
            ItemTbl[7] := PTRN5_BUNSHO2;
            ItemTbl[8] := PTRN5_BUNSHO3;
        end;
    	5:
        begin
            ItemTbl[0] := TUTIPATNNAME6;
            ItemTbl[1] := BASICLAYOUT6;
            ItemTbl[2] := TORILAYOUT6;
            ItemTbl[3] := BILLLAYOUT6;
            ItemTbl[4] := KOUJOLAYOUT6;
            ItemTbl[5] := KFLAYOUT6;
            ItemTbl[6] := PTRN6_BUNSHO1;
            ItemTbl[7] := PTRN6_BUNSHO2;
            ItemTbl[8] := PTRN6_BUNSHO3;
        end;
    	6:
        begin
            ItemTbl[0] := TUTIPATNNAME7;
            ItemTbl[1] := BASICLAYOUT7;
            ItemTbl[2] := TORILAYOUT7;
            ItemTbl[3] := BILLLAYOUT7;
            ItemTbl[4] := KOUJOLAYOUT7;
            ItemTbl[5] := KFLAYOUT7;
            ItemTbl[6] := PTRN7_BUNSHO1;
            ItemTbl[7] := PTRN7_BUNSHO2;
            ItemTbl[8] := PTRN7_BUNSHO3;
        end;
    else
    	Exit;
    end;
end;

//**************************************************************************
//  Proccess    :   通知書情報をセット
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :
//  Return      :
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPAY510100Dlgf.SetLayoutInfo(var Param: TMPayNoticeDoc);
const
	iIndx = 0;
var
	iIdx : Integer;
begin
	LayoutInfoClear(Param);

	case MCombo_Layout.ItemIndex of
    	0:
        begin
            for iIdx := 0 to High(PNoticeDoc) do
			begin
				//レイアウト名称リスト：MAX１５文字(全角)で表示
                if MCombo_LayoutPtn.Text = MJSHanCopy(PNoticeDoc[iIdx].PtnName,1,30) then
                	Break;
			end;
            with Param do
            begin
                PtnName	  	:= PNoticeDoc[iIdx].PtnName;
                BasicLayout	:= PNoticeDoc[iIdx].BasicLayout;
                ToriDtl	  	:= PNoticeDoc[iIdx].ToriDtl;
                TegataDtl 	:= PNoticeDoc[iIdx].TegataDtl;
                KoujoDtl  	:= PNoticeDoc[iIdx].KoujoDtl;
                KijitsuDtl	:= PNoticeDoc[iIdx].KijitsuDtl;
                Bunsho1	  	:= PNoticeDoc[iIdx].Bunsho1;
                Bunsho2	  	:= PNoticeDoc[iIdx].Bunsho2;
                Bunsho3	  	:= PNoticeDoc[iIdx].Bunsho3;
            end;

            Exit;
        end;
        1:
        begin
            with Param do
            begin
                BasicLayout := TegFilePath;
                Bunsho1	  := TegBunsho;
// <#018> ADD-STR
                if (MCombo_LayoutPtnTeg.ItemIndex = 1) then
                begin
                    BasicLayout := TegFilePath2;
                    Bunsho1	  := TegBunsho2;
                end;
// <#018> ADD-END
            end;
        end;
        2:
        begin
            Param.BasicLayout := KakitomeFilePath;
        end;
// <#020> ADD-STR
        3:
        begin
            Param.BasicLayout := TackSealFilePath;
        end;
// <#020> ADD-END
        //その他
    	else
    		Exit;
    end;
end;

//**************************************************************************
//  Proccess    :   DBの形式にコード編集
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :	Code	コード
//  Return      :	変換後のコード
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPAY510100Dlgf.CodeEditToDB(Code: String): String;
var
	IsChar: Boolean;
begin
	IsChar := EStHojTxt.Visible;

	Result := TMASCom(m_pRec^.m_pSystemArea^).SetCodeAttr(Code, 16, IsChar);
end;

//**************************************************************************
//  Proccess    :   情報種別コンボのアイテム作成
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :	Nothing
//  Return      :	Nothing
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPAY510100Dlgf.MakeLayoutCombo;
begin
	with MCombo_Layout do
	begin
		Items.Clear;
		ItemIndex	:= -1;
		Items.BeginUpdate;

		Items.Add( NOTICEDOC	);
		Items.Add( TEGATA		);
		Items.Add( KAKITOME	);
		Items.Add( TACKSEAL	);              // <#020> ADD

		Items.EndUpdate;

		ItemIndex	:= 0;
	end;
end;

//**************************************************************************
//  Proccess    :   レイアウトパターンコンボのアイテム作成
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :
//  Return      :	True or False
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPAY510100Dlgf.MakeLayoutPtnCombo;
var
	iIdx	:	Integer;
begin
	with MCombo_LayoutPtn do
	begin
		Items.Clear;
		ItemIndex	:= -1;
		Items.BeginUpdate;

		for iIdx := 0 to High(PNoticeDoc) do
    	begin
    		//名称が取得できていない場合は詰めて次の名称をｾｯﾄ
		    if (PNoticeDoc[iIdx].PtnName <> '') then
				Items.Add( MJSHanCopy(PNoticeDoc[iIdx].PtnName,1,30) );
	    end;
		Items.EndUpdate;
		ItemIndex	:= 0;
	end;
end;

//**************************************************************************
//  Proccess    :   集金/送付 コンボのアイテム作成
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :
//  Return      :	True or False
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPAY510100Dlgf.MakeLetterCombo;
begin
	with MCombo_LetterKbn do
	begin
		Items.Clear;
		ItemIndex	:= -1;
		Items.BeginUpdate;

		Items.Add( LETTERKBN0	);
		Items.Add( LETTERKBN1	);
		Items.Add( LETTERKBN2	);
		Items.Add( LETTERKBN3	);
		Items.Add( LETTERKBN4	);		// <#003> Add

		Items.EndUpdate;
	end;
end;

//**************************************************************************
//  Proccess    :   郵送区分 コンボのアイテム作成
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :
//  Return      :	True or False
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPAY510100Dlgf.MakeYusouKbnCombo;
begin
	with MCombo_YusouKbn do
	begin
		Items.Clear;
		ItemIndex	:= -1;
		Items.BeginUpdate;

		Items.Add( YUSOUKBN0	);
		Items.Add( YUSOUKBN1	);
		Items.Add( YUSOUKBN2	);

		Items.EndUpdate;
	end;

// <#018> ADD-STR
	with MCombo_YusouFutan do
	begin
		Items.Clear;
		ItemIndex	:= -1;
		Items.BeginUpdate;

		Items.Add( '自社負担'	);
		Items.Add( '他社負担'	);
		Items.Add( '全て'	    );

		Items.EndUpdate;
	end;
// <#018> ADD-END
end;

//**************************************************************************
//  Proccess    :   支払方法 コンボのアイテム作成
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :
//  Return      :	True or False
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPAY510100Dlgf.MakePayWayCombo(StList:TStringList);
var
	iIdx,iCount : Integer;
	WKMCombo : TMComboBox;
begin
    try
       	for iIdx := 0 to 2 do
        begin
   	        case iIdx of
       	        0: WKMCombo := MCombo_PayWay1 ;
           	    1: WKMCombo := MCombo_PayWay2 ;
               	2: WKMCombo := MCombo_PayWay3 ;
            else
   	            Exit;
       	    end;

			with WKMCombo do
			begin
            	Items.BeginUpdate;

	            Items.Clear;
    	        Items.Add(PAYWAY0);

	            for iCount := 0 to StList.Count -1 do
    	        	Items.Add(StList[iCount]);

        	    Items.EndUpdate;
	            ItemIndex := -1;
    	    end;	//end with
		end;		//end for
    finally
    	StList.Free;
    end;
end;

//**************************************************************************
//  Proccess    :   入力値が正しいかチェック
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :
//  Return      :	True or False
//	Memo		:
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPAY510100Dlgf.ValueCheck: Boolean;
var
	HojCode, SimpleName	: String;
	Renso				: String;	//2007/05/21 <#011> Y.Naganuma Add
    iInputYmd			: Integer;
	MsgRec      		: TMjsMsgRec;
    sRenso, eRenso		: String;
begin
	Result := False;

    // 帳票種別
// <#020> MOD-STR
//  if not MCombo_Layout.ItemIndex in [0..2] then
    if not MCombo_Layout.ItemIndex in [0..3] then
// <#020> MOD-END
    begin
        ValueError(MsgRec, MCombo_Layout);
        Exit;
    end;

	// 出力月ﾁｪｯｸ
    if Trim(EDPrnt.Text) <> '' then
    begin
		iInputYmd := StrToInt(FormatDateTime('yyyymmdd', EDPrnt.AsDateTime));
		if (MjsDateCtrl.MjsIntYMDChk(iInputYmd) = False) then
    	begin
        	ValueError(MsgRec, EDPrnt);
        	Exit;
    	end;
    end;

    if MCombo_Layout.Text = NOTICEDOC then
    begin
    	//ﾚｲｱｳﾄﾊﾟﾀｰﾝのﾁｪｯｸ
        if (MCombo_LayoutPtn.ItemIndex = -1) then
        begin
            ValueError(MsgRec,MCombo_LayoutPtn);
            Exit;
        end;
    end;

    // 仕入先ﾁｪｯｸ
    if EStHojTxt.Visible = True then
        HojCode				:= EStHojTxt.Text
    else
    begin
//        EStHojNum.InputFlag	:= False;   // <#012> Del
    	HojCode 			:= EStHojNum.Text;
   		HojCode				:= CodeEditToDB(HojCode);
    end;

//2007/05/21 <#011> Y.Naganuma Mod
//	if HojCode = '' then GetDefaultHoj(0, HojCode, SimpleName);
//	if GetInputPayHoj(HojCode, SimpleName) = False then
	if HojCode = '' then
	    GetDefaultHoj(0, HojCode, SimpleName, sRenso)
	else if GetInputPayHoj(HojCode, SimpleName, sRenso) = False then
//2007/05/21 <#011> Y.Naganuma Mod
    begin
        if EStHojTxt.Visible = True then
            ValueError(MsgRec, EStHojTxt)
        else
            ValueError(MsgRec, EStHojNum);
        Exit;
    end;

    if EEdHojTxt.Visible = True then
        HojCode	:= EEdHojTxt.Text
    else
    begin
//        EEdHojNum.InputFlag	:= False;   // <#012> Del
        HojCode				:= EEdHojNum.Text;
   		HojCode				:= CodeEditToDB(HojCode);
    end;

//2007/05/21 <#011> Y.Naganuma Mod
//	if HojCode = '' then GetDefaultHoj(1, HojCode, SimpleName);
//  if GetInputPayHoj(HojCode, SimpleName) = False then
	if HojCode = '' then
// <#017> MOD-STR
//		GetDefaultHoj(1, HojCode, SimpleName, Renso)
		GetDefaultHoj(1, HojCode, SimpleName, eRenso)
// <#017> MOD-END
	else if GetInputPayHoj(HojCode, SimpleName, eRenso) = False then
//2007/05/21 <#011> Y.Naganuma Mod
    begin
        if EEdHojTxt.Visible = True then
            ValueError(MsgRec, EEdHojTxt)
        else
            ValueError(MsgRec, EEdHojNum);
        Exit;
    end;

// 2005/11/08 <#001> Y.Kabashima Mod
{    //コード逆転のチェック
    if EStHojTxt.Visible = True then
    begin
        if (EStHojTxt.Text <> '') and
           (EEdHojTxt.Text <> '') and
           (EEdHojTxt.Text < EStHojTxt.Text) then
        begin
            ValueError(MsgRec, EStHojTxt);
            Exit;
        end;
    end
    else
    begin
        if (EStHojNum.Value <> 0) and
           (EEdHojNum.Value <> 0) and
           (EEdHojNum.Value < EStHojNum.Value) then
        begin
            ValueError(MsgRec, EStHojNum);
            Exit;
        end;
    end;
}
	if PMCombo.Items[PMCombo.ItemIndex] = '支払先順' then
    begin
	    //コード逆転のチェック
	    if EStHojTxt.Visible = True then
	    begin
	        if (EStHojTxt.Text <> '') and
	           (EEdHojTxt.Text <> '') and
	           (EEdHojTxt.Text < EStHojTxt.Text) then
	        begin
	            ValueError(MsgRec, EStHojTxt);
	            Exit;
	        end;
	    end
		else
	    begin
	        if (EStHojNum.Value <> 0) and
	           (EEdHojNum.Value <> 0) and
	           (EEdHojNum.Value < EStHojNum.Value) then
	        begin
	            ValueError(MsgRec, EStHojNum);
	            Exit;
	        end;
	    end;
    end
    else if PMCombo.Items[PMCombo.ItemIndex] = '連想順' then
    begin
//2007/05/21 <#011> Y.Naganuma Del
{	    if EStHojTxt.Visible = True then
	    begin
        	HojCode := EStHojTxt.Text;
			if HojCode = '' then GetDefaultHoj(0, HojCode, SimpleName);
	    	sRenso := m_Pay510Com.GetRenso(m_Query, HojCode);

        	HojCode := EEdHojTxt.Text;
			if HojCode = '' then GetDefaultHoj(1, HojCode, SimpleName);
	    	eRenso := m_Pay510Com.GetRenso(m_Query, HojCode);
        end
        else
        begin
        	HojCode := EStHojNum.Text;
   			HojCode := CodeEditToDB(HojCode);
			if HojCode = '' then GetDefaultHoj(0, HojCode, SimpleName);
			sRenso := m_Pay510Com.GetRenso(m_Query, HojCode);

        	HojCode := EEdHojNum.Text;
   			HojCode := CodeEditToDB(HojCode);
			if HojCode = '' then GetDefaultHoj(1, HojCode, SimpleName);
	    	eRenso := m_Pay510Com.GetRenso(m_Query, HojCode);
        end;
}
//2007/05/21 <#011> Y.Naganuma Del
        if (eRenso < sRenso) then
        begin
            ValueError(MsgRec, EStHojNum);
            Exit;
//2007/05/21 <#011> Y.Naganuma Add
		end
		else if eRenso = sRenso then
		begin
		    //コード逆転のチェック
		    if EStHojTxt.Visible = True then
	    	begin
	        	if (EStHojTxt.Text <> '') and
		           (EEdHojTxt.Text <> '') and
		           (EEdHojTxt.Text < EStHojTxt.Text) then
	    	    begin
	        	    ValueError(MsgRec, EStHojTxt);
	            	Exit;
		        end;
		    end
			else
		    begin
		        if (EStHojNum.Value <> 0) and
	    	       (EEdHojNum.Value <> 0) and
	        	   (EEdHojNum.Value < EStHojNum.Value) then
		        begin
		            ValueError(MsgRec, EStHojNum);
	    	        Exit;
	        	end;
		    end;
//2007/05/21 <#011> Y.Naganuma Add
        end;
    end;
// 2005/11/08 <#001> Y.Kabashima Mod

    //支払方法のﾁｪｯｸ
// <020> MOD-STR
//  if MCombo_Layout.Text = NOTICEDOC then
    if (MCombo_Layout.Text = NOTICEDOC) or (MCombo_Layout.Text = TACKSEAL) then
// <020> MOD-END
    begin
        if MCombo_PayCond.Text = PAYCOND1 then
        begin
            if (((MCombo_PayWay1.ItemIndex = -1) or (MCombo_PayWay1.ItemIndex = 0))  and
                ((MCombo_PayWay2.ItemIndex = -1) or (MCombo_PayWay2.ItemIndex = 0))  and
                ((MCombo_PayWay3.ItemIndex = -1) or (MCombo_PayWay3.ItemIndex = 0))) then
            begin
                ValueError(MsgRec, MCombo_PayWay1);
                Exit;
            end;
        end;
    end;
//2007/05/21 <#011> Y.Naganuma Add
	m_sStRenso	:= sRenso;
	m_sEdRenso	:= eRenso;
//2007/05/21 <#011> Y.Naganuma Add
	Result := True;
end;

//**************************************************************************
//  Proccess    :   設定されたファイルのチェック
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 02 / 10
//  Parameter   :
//  Return      :
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPAY510100Dlgf.CheckFileExist: Boolean;
var
	iIdx : Integer;
    sFileName : String;
begin
    Result := False;

    for iIdx := 0 to High(PNoticeDoc) do
    begin
		//	基本レイアウト
        if not FileExists(PNoticeDoc[iIdx].BasicLayout) then
        begin
        	sFileName := GetDefaultFile(iIdx,ftBasicLayout);

        	if FileExists(sFileName) then
                PNoticeDoc[iIdx].BasicLayout := sFileName
            else
            	Exit;
        end;

		//	取引明細
        if PNoticeDoc[iIdx].ToriDtl <> ' ' then
		begin
			if not FileExists(PNoticeDoc[iIdx].ToriDtl) then
			begin
				sFileName := GetDefaultFile(iIdx,ftToriDtl);

				if FileExists(sFileName) then
					PNoticeDoc[iIdx].ToriDtl := sFileName
				else
					Exit;
			end;
		end;

		//	手形明細
        if PNoticeDoc[iIdx].TegataDtl <> ' ' then
		begin
			if not FileExists(PNoticeDoc[iIdx].TegataDtl) then
			begin
				sFileName := GetDefaultFile(iIdx,ftTegataDtl);

				if FileExists(sFileName) then
					PNoticeDoc[iIdx].TegataDtl := sFileName
				else
					Exit;
			end;
		end;

		//	控除明細 OR 事業所内訳
        if PNoticeDoc[iIdx].KoujoDtl <> ' ' then
		begin
			if not FileExists(PNoticeDoc[iIdx].KoujoDtl) then
			begin
				sFileName := GetDefaultFile(iIdx,ftKoujoDtl);

				if FileExists(sFileName) then
					PNoticeDoc[iIdx].KoujoDtl := sFileName
				else
					Exit;
			end;
		end;

		//	期日明細
        if PNoticeDoc[iIdx].KijitsuDtl <> ' ' then
		begin
			if not FileExists(PNoticeDoc[iIdx].KijitsuDtl) then
			begin
				sFileName := GetDefaultFile(iIdx,ftKijitsuDtl);

				if FileExists(sFileName) then
					PNoticeDoc[iIdx].KijitsuDtl := sFileName
				else
					Exit;
			end;
		end;
	end;
    Result := True;
end;

//**************************************************************************
//  Proccess    :   設定されたファイルのチェック
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 02 / 10
//  Parameter   :
//  Return      :
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPAY510100Dlgf.CheckTegataExist: Boolean;
var
	sFileName : String;
begin
	Result := False;

    //	手形送付案内
    if not FileExists(TegFilePath) then
    begin
        sFileName := GetDefaultTegataFile;

        if FileExists(sFileName) then
            TegFilePath := sFileName
        else
            Exit;
    end;

// <#018> ADD-STR
    if m_bTegFile2 then
    begin
        // 手形送付案内②
        if not FileExists(TegFilePath2) then
        begin
            sFileName := GetDefaultTegataFile;

            if FileExists(sFileName) then
                TegFilePath2 := sFileName
            else
                Exit;
        end;
    end;
// <#018> ADD-END

	Result := True;
end;

//**************************************************************************
//  Proccess    :   設定されたファイルのチェック
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 02 / 10
//  Parameter   :
//  Return      :
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPAY510100Dlgf.CheckKakitomeExist: Boolean;
var
	sFileName : String;
begin
	Result := False;

    //	基本レイアウト
    if not FileExists(KakitomeFilePath) then
    begin
        sFileName := GetDefaultKakitomeFile;

        if FileExists(sFileName) then
            KakitomeFilePath := sFileName
        else
            Exit;
    end;
	Result := True;
end;

//**************************************************************************
//  Proccess    :   エラーメッセージ表示処理
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :	Query	エラーになったクエリ
//  Return      :
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPAY510100Dlgf.ErrorMessageDsp(Query: TMQuery);
var
	MsgRec	: TMjsMsgRec;
begin
	TMASCom(m_pRec^.m_pSystemArea^).m_MsgStd.GetMsgDB(MsgRec, Query);
	MjsMessageBoxEx(Self, MsgRec.sMsg, MsgRec.sTitle, MsgRec.icontype ,MsgRec.btntype ,MsgRec.btndef, FALSE);
end;

//**************************************************************************
//  Proccess    :   エラー処理 (メッセージを表示して移動)
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :   pMsgRec
//              :   Ctrl
//  Return      :   Nathing
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPAY510100Dlgf.ValueError(pMsgRec: TMjsMsgRec; Ctrl: TWinControl);
begin
	Beep;
	Ctrl.SetFocus;
end;

//**************************************************************************
//  Proccess    :   エラーメッセージ表示処理
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :	Msg
//  Return      :
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPAY510100Dlgf.CallErrorMessageDsp(Msg : String);
begin
    MjsMessageBoxEx(Self, Msg,
                     m_pRec^.m_ProgramName,
                     mjError,
                     mjOk,
                     mjDefOk);
end;

//**************************************************************************
//  Proccess    :   エラーメッセージ表示処理
//  Name        :   K.IKEMURA (RIT)
//  Date	    :	2002 / 01 / 16
//  Parameter   :	Msg
//  Return      :
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPAY510100Dlgf.ErrorMsgDsp(pFileType : TFileType);
var
	MsgRec      :   TMjsMsgRec;
begin
    with TMasCom(m_pRec^.m_pSystemArea^), MsgRec do
    begin
        m_MsgStd.GetMsg(MsgRec, 30,18);

        case pFileType of
            ftNoticeDoc	:sMsg :='通知書ファイルが無い為,印刷' + sMsg;
            ftTegata 	:sMsg :='手形送付案内ファイルが無い為,印刷' + sMsg;
            ftKakitome	:sMsg :='書留郵便物受領証ファイルが無い為,印刷' + sMsg;
            ftTackSeal	:sMsg :='タックシールファイルが無い為,印刷' + sMsg;     // <#020> ADD
        end;

	    MjsMessageBoxEx(Self, sMsg, sTitle, icontype, btntype, btndef, LogType);
    end;
end;

procedure TPAY510100Dlgf.PMComboKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	with PMCombo do
	begin
		if (DroppedDown = True) and (Key = VK_RETURN) then
			MjsNextCtrl(Self);
	end;
end;

// 2005/11/11 <#002> Y.Kabashima Add
procedure TPAY510100Dlgf.PMComboChange(Sender: TObject);
begin
	EStHojTxt.Text := '';
    EStHojNum.Value := 0;
    EStHojNum.Zero := False;
	EStHojNum.Clear;
    LStHoj.Caption := '';

	EEdHojTxt.Text := '';
    EEdHojNum.Value := 0;
    EEdHojNum.Zero := False;
	EEdHojNum.Clear;
    LEdHoj.Caption := '';
end;
// 2005/11/11 <#002> Y.Kabashima Add

// 2007/01/10 Y.Kabashima Add <#009>
procedure TPAY510100Dlgf.GetMasterInfo(p_Query: TMQuery);
	procedure ClearItems();
	var
	    i: Integer;
	    pRec: PMasterInfoRecord;
	begin
	    for i := 0 to MasterInfoList.Count -1 do
	    begin
	        pRec := MasterInfoList[i];
	        Dispose(pRec);
	    end;

	    MasterInfoList.Clear;
	end;

var
	sSQL : String;
begin
	MasterInfoList := TList.Create;

	ClearItems();

	with p_Query do
	begin
		Close;
		UnPrepare;
		Errors.Clear;
		SQL.Clear;

		sSQL := '';
		sSQL := sSQL + 'SELECT MasterKbn, ';
		sSQL := sSQL +        'CodeDigit, ';
		sSQL := sSQL +        'CodeAttr, ';
		sSQL := sSQL +        'JHojyoName, ';
		sSQL := sSQL +        'UseKbn ';
		sSQL := sSQL +   'FROM MasterInfo ';

		ParamCheck := False;
		SQL.Add(sSQL);
		Prepare;

		Open;
		if not Eof then
		begin
			First;

			while not Eof do
			begin
				new(m_pMasterInfoRec);

				m_pMasterInfoRec^.MasterKbn  := FieldByName('MasterKbn').AsInteger;
				m_pMasterInfoRec^.CodeDigit  := FieldByName('CodeDigit').AsInteger;
				m_pMasterInfoRec^.CodeAttr   := FieldByName('CodeAttr').AsInteger;
				m_pMasterInfoRec^.JHojyoName := FieldByName('JHojyoName').AsString;
				m_pMasterInfoRec^.UseKbn     := FieldByName('UseKbn').AsInteger;

				MasterInfoList.Add(m_pMasterInfoRec);

				Next;
			end;
		end;
	end;
end;

function TPAY510100Dlgf.GetUseKbn(sMasterKbn: Integer): Integer;
var
	iLoop : Integer;
	pRec : PMasterInfoRecord;
begin
	Result  := 0;

	for iLoop := 0 to MasterInfoList.Count - 1 do
	begin
		pRec := MasterInfoList[iLoop];

		if pRec^.MasterKbn = sMasterKbn then
		begin
			Result := pRec^.UseKbn;

			break;
		end;
	end;
end;
// 2007/01/10 Y.Kabashima Add <#009>

// <#018> ADD-STR
procedure TPAY510100Dlgf.MCombo_LayoutPtnTegKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
	with MCombo_LayoutPtnTeg do
	begin
		if (DroppedDown = True) and (Key = VK_RETURN) then
			MjsNextCtrl(Self);
	end;
end;

procedure TPAY510100Dlgf.MCombo_YusouFutanKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
	with MCombo_YusouFutan do
	begin
		if (DroppedDown = True) and (Key = VK_RETURN) then
			MjsNextCtrl(Self);
	end;
end;

//**************************************************************************
//  Proccess    :   手形送付案内レイアウトパターンコンボのアイテム作成
//  Name        :   T.SATOH(IDC)
//  Date	    :	2009 / 01 / 19
//  Parameter   :
//  Return      :	True or False
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPAY510100Dlgf.MakeLayoutPtnTegCombo;
var
	iIdx	:	Integer;
begin
	with MCombo_LayoutPtnTeg do
	begin
		Items.Clear;
		ItemIndex	:= -1;
		Items.BeginUpdate;

        Items.Add( MJSHanCopy(TegPtnName,1,30) );
        if m_bTegFile2 then
            Items.Add( MJSHanCopy(TegPtnName2,1,30) );

		Items.EndUpdate;
		ItemIndex	:= 0;
	end;
end;
// <#018> ADD-END

// <#020> ADD-STR
//**************************************************************************
//  Proccess    :   デフォルトファイル取得
//  Name        :   T.SATOH(IDC)
//  Date	    :	2009 / 07 / 08
//  Parameter   :   タックシール
//  Return      :	COファイルパス
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPAY510100Dlgf.GetDefaultTackSealFile: String;
const
	StrExtension = '.crf';
begin
    Result := gsExePath + DEFTACKSEAL + StrExtension;
end;

//**************************************************************************
//  Proccess    :   支払管理情報取得処理
//  Name        :   T.SATOH(IDC)
//  Date	    :	2009 / 07 / 08
//  Parameter   :   COファイルパスの取得 （タックシール）
//  Return      :	True or False
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPAY510100Dlgf.GetTackSealFile;
var
	strDataStr : String;
begin
	strDataStr := '';

    if ((m_PayBaseInfo.GetBaseInfoStr(strDataStr,TACKSEALLAYOUT)) and
        (strDataStr <> ''))then
		TackSealFilePath := strDataStr
    else
        TackSealFilePath	:= GetDefaultTackSealFile;
end;

//**************************************************************************
//  Proccess    :   設定されたファイルのチェック
//  Name        :   T.SATOH(IDC)
//  Date	    :	2009 / 07 / 08
//  Parameter   :
//  Return      :
//  History     :   9999 / 99 / 99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPAY510100Dlgf.CheckTackSealExist: Boolean;
var
	sFileName : String;
begin
	Result := False;

    //	タックシール
    if not FileExists(TackSealFilePath) then
    begin
        sFileName := GetDefaultTackSealFile;

        if FileExists(sFileName) then
            TegFilePath := sFileName
        else
            Exit;
    end;
	Result := True;
end;
// <#020> ADD-END

end.
