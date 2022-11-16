//*************************************************************************
//  System      :   Galileopt債務管理
//  Program     :　	支払通知書情報印刷処理
//  ProgramID   :	PAY500100
//  Name        :   K.IKEMURA (RIT)
//  Create      :	2002 / 01 / 16
//  Comment     :   支払通知書の印刷を行う。
//              :   画面はプレビューのみ
//	History	  	:	2005/07/28	Y.Kabashima (MSI)
//								FX対応
//					2005/11/02 	Y.Kabashima (MSI)
//						<#001>	仕様変更対応
//				:	2005/11/24 	Y.Kabashima (MSI)
//						<#002>	次回残高出力対応
//				:	2005/11/25 	Y.Kabashima (MSI)
//						<#003>	他社手数料控除区分判定変更
//              :   2006/01/25  H.Kawato(MSI)
//                      <#004>  権限管理対応
//				:	2005/01/25 	Y.Kabashima (MSI)
//						<#005>	メッセージタイトルが'支払管理'となっているのを
//								'債務管理'に変更
//              :   2006/07/21  Y.Naganuma(MSI)
//                      <#006>   手形連動対応
//              :   2006/07/24  Y.Naganuma(MSI)
//                      <#007>   スピードアップ対応
//              :   2006/08/01  Y.Naganuma(MSI)
//                      <#008>   △１円が出てしまう不具合対応
//              :   2007/01/10  Y.Kabashima (MSI)
//                      <#009>   プロジェクト別支払対応
//              :   2007/05/21  Y.Naganuma(MSI)
//                      <#010>   スピードアップ対応
//              :   2007/09/11  H.Kawato(MSI)
//                      <#011>   預かり源泉税・支払調書対応
//              :   2008/03/26  T.Kawahata (MSI)
//                  	<#012>  支払通知書番号出力対応
//              :   2008/06/06  T.SATOH(IDC)
//                  	<#013>  印刷履歴対応
//              :   2008/08/04	T.SATOH(IDC)
//                      <#014>  口座前０対応(強制8桁フォーマットを廃止)
//              :   2008/08/21	T.SATOH(IDC)
//                      <#015>  書留郵便物受領証の摘要(手形枚数)に「枚」を追加(GBC-0018)
//              :   2008/09/16	T.SATOH(IDC)
//                      <#016>  連想順で出力するとエラーが発生する
//              :   2008/09/26  T.SATOH(IDC)
//                      <#017>  印刷履歴スプール名改良
//              :   2008/10/10  T.SATOH(IDC)
//                      <#018>  印刷履歴スプール名改良
//				:	2008/10/21	T.SATOH(IDC)
//                      <#019>  プログレスバー対応
//				:	2008/10/21	T.SATOH(IDC)
//                  	<#020>  支払通知書番号出力時の今回取引計出力対応
//					2008/11/17  イワムラ
//						<#021>	工事関連支払対応
//				:	2009/01/19  T.SATOH(IDC)
//						<#022>	手形送付案内改良(GBY-0034)
//				:	2009/03/27  T.SATOH(IDC)
//						<#023>	スポット支払対応
//				:	2009/07/08  T.SATOH(IDC)
//						<#024>	タックシール対応
//				:	2010/05/21  T.SATOH(IDC)
//						<LPH>	MLBplLoader対応
//				:	2010/11/22  T.SATOH(GSOL)
//						<#025>	支払通知書メール配信対応
//		  	  	: 	2011/05/19	T.SATOH(GSOL)
//                              ＭＬで修正済み不具合の取り込み
//						<#026>	手形明細のデータ６件以上の時、表示個所が６件以上あっても別紙レイアウトに出力されてしまう。
//								（手形あり、期日指定振込のイアウトのみ）
//						<#027>	事業所明細の摘要欄に「※※　今回取引計　※※」を出力すると
//								次以降の取引先の事業所明細の該当行がセンタリングのままになってしまう件を修正
//				:	2011/06/21  T.SATOH(GSOL)
//						<#028>	支払通知書メール配信時のクライアント名称取得方法を変更
//				:	2011/09/14  T.SATOH(GSOL)
//						<#029>	SA12対応(SUBSTR→RIGHTへ変更)
//				:	2011/12/15  T.SATOH(GSOL)
//						<#030>	通知書内訳欄出力名称変更対応
//				:	2012/02/10  T.SATOH(GSOL)
//						<#031>	通知書内訳欄出力名称変更対応(メール配信)
//              :   2012/04/12  T.SATOH(GSOL)
//                      <#032>  電子債権対応
//              :   2012/10/04  T.SATOH(GSOL)
//                      <#033>  相手科目・部門、事業所の取引明細出力対応
//              :   2014/01/20  T.SATOH(GSOL)
//                      <#034>  手形明細小計変数のクリア漏れを修正
//              :   2014/06/16  T.SATOH(GSOL)
//                      <#DCH>  日付コントロール改修対応
//				:	2014/08/08  T.SATOH(GSOL)
//						<#035>	パスワードＰＤＦメール配信対応
//				:	2014/12/05  T.SATOH(GSOL)
//						<#036>	通知書内訳欄出力名称変更電債対応
//				:	2014/12/10  T.SATOH(GSOL)
//						<#037>	手形支払日変更対応
//				:	2015/10/08  T.SATOH(GSOL)
//						<#038>	他社負担郵送料出力対応
//              :   2016/10/28  KUMO
//                      <#039>  メール配信ＰＤＦファイル保存対応
//				:	2017/07/28  T.SATOH(GSOL)
//						<#040>	<#034>の修正により、直前の支払先と手形種別が異なった続紙出力時に
//                              １行空白行が出力されてしまった点を修正
//              :   2019/01/16  KIM/ADACHI(ADMAX)
//                      <#NGEN> 元号対応
//              :   2019/10/30  M.Nishioka(PRIME)
//                      <#041>  郵便番号の枝番が「0000」の時に、枝番が空で出力される不具合を修正
//								SRB No:XZC-1497
//				:	2020/06/11  T.SATOH(GSOL)
//						<#ERW>	支払方法指定電子記録債権対応
//				:	2021/03/24  M.Tsuta
//						<#042>  日付前ゼロ不具合修正<SRB:HAY-0399>MLから横展開
//				:	2021/11/17  D.Eguchi
//					    <MTA>   複数振込先口座対応（Pay510100Calcu.pas,Pay510CalcCtrlu.pas）
//					2022/11/07  T.Wakasugi
//					    <#043>	タックシール印刷郵便記号印字有無チェックボックス追加
//
//*************************************************************************
unit Pay510100u;

interface

uses
  Windows, Messages, SysUtils, Classes, VCL.Graphics, VCL.Controls, VCL.Forms, VCL.Dialogs, MJSCommonDialogs,
  ComCtrls, MJSStatusBar, DBCtrls, MJSEdits, VCL.StdCtrls, MJSLabel, Buttons,
  MJSSpeedButton, VCL.ExtCtrls, MJSPanel, MjsCommonu, MasComu,
  MjsMsgstdu, MjsDBModuleu, FireDAC.Comp.Client, MjsQuery, MjsDispCtrl, MjsStrCtrl,
  Db,dxmdaset,MjsDateCtrl,
  PAY510100Comu, OleCtrls, CoReports_TLB,Activex,
  MjsCommon3u,

  FileCtrl, // <#039> ADD

  MjsCoReportsPrint3,
  MjsCoReportsProperty3,
  MjsCoReportsData3,

  MjsPrnSupportu,               // <#013>
  MjsPreviewIF3u,
  MjsPrnSupport3u,
  MJSPrnDlg3u,

  MLManageru, 		            // 2005/11/02 <#001> Y.Kabashima Add
  FXPerms,                      // 2006/01/25 H.Kawato Add <#004>

  Inifiles,                     // <#017> ADD
  MLBplLoaderU,	                // <LPH> ADD
// <#025> ADD-STR
  FXLicense,
  PAYTrnServiceClientu,
  ShellAPI,
// <#025> ADD-END
  MetaSpt,                      // <#028> ADD
  Pay510100Dlgu,
  Pay510OrderCtrlu, Pay510Orderu,
  MasDateCtrl,    // <#NGEN>
  Pay510100Calcu, Grids, DBGrids,
  Variants,
  FireDAC.Stan.Param;

const
  WM_DISPRUN = WM_APP + 2;

type
    {$I PayComCallInfo.inc}
    {$I PayComH.inc}
    {$I PAYProgressDlg.inc}
    {$I PAYExclusiveH.inc}
    {$I PAYExclusiveInfo.inc}
    {$I ActionInterface.inc}
	{$I PayDataSelectDlg.inc}   // 支払データ選択ダイアログ　パラメータ構造体
    {$i MasPermsH.inc}          // 2006/01/25 H.Kawato(MSI) <#004>  Add 権限管理対応
    {$I MasSetPrnInfo3H.inc}    // <#013>
    {$I PAYCommon_H.inc}        // 債務共通 <#017> ADD

  TLayoutType = (ltBasic, 		//	基本レイアウト
				ltToriDtl,		//	取引明細
				ltTegataDtl,	//	手形明細
				ltKoujyoDtl,	//	控除明細
				ltJigyou,		//	事業所明細
				ltKijitsuDtl	//	期日取引明細
  				);

// <#025> ADD-STR
  TPAYExecute = function(AOwner:     TComponent;
                         pRec:       Pointer;
                         JobNo:      Currency;
                         PayNCode:   Currency
                        ): Currency;
// <#025> ADD-END

  TPay510100f = class(TForm)
	PToolBar: TMPanel;
	BExit: TMSpeedButton;
	BPrint: TMSpeedButton;
	BChange: TMSpeedButton;
	BJoken: TMSpeedButton;
	PHead: TMPanel;
	PChild: TMPanel;
    LCaption: TMLabel;
    CrDraw1: TCrDraw;
    DMem_Uchiwake: TdxMemData;
    DMem_UchiwakeRecSyubetu: TIntegerField;
    DMem_UchiwakeShiharaiKin: TCurrencyField;
    DMem_UchiwakeBankName: TStringField;
    DMem_UchiwakeBkBraName: TStringField;
    DMem_UchiwakeAccKbn: TIntegerField;
    DMem_UchiwakeAccNo: TStringField;
    DMem_UchiwakeLongName: TStringField;
    DMem_UchiwakeBunkatusuu: TIntegerField;
    DMem_UchiwakeKoujyoKamoku: TIntegerField;
    DMem_UchiwakeKoujyoKin: TIntegerField;
    DMem_UchiwakePayPrice: TIntegerField;
    DMem_CSInfo: TdxMemData;
    DMem_CSInfoGCode: TStringField;
    DMem_CSInfoNayoseKbn: TIntegerField;
    DMem_CSInfoNayoseOya: TStringField;
    DMem_CSInfoZipCode1: TIntegerField;
    DMem_CSInfoZipCode2: TIntegerField;
    DMem_CSInfoAddress1: TStringField;
    DMem_CSInfoAddress2: TStringField;
    DMem_CSInfoSectionName: TStringField;
    DMem_CSInfoPersonName: TStringField;
    DMem_CSInfoTitleKbn: TIntegerField;
    DMem_Koujyo: TdxMemData;
    DMem_KoujyoSimpleName: TStringField;
	DMem_PayPlanData: TdxMemData;
    DMem_PayPlanDataGCode: TStringField;
    DMem_Tori: TdxMemData;
    DMem_ToriHasseiDay: TDateField;
    DMem_ToriTekiyou: TStringField;
    DMem_Teg: TdxMemData;
    DMem_TegBankSqNo: TStringField;
    DMem_KoujyoSousaiKin: TCurrencyField;
    DMem_ToriTHasseiKin: TCurrencyField;
    DMem_TegSiharaiKin: TCurrencyField;
    DMem_PayPlanDataZenkaiKin: TCurrencyField;
    DMem_PayPlanDataToukaiKin: TCurrencyField;
    DMem_PayPlanDataSateiKin: TCurrencyField;
    DMem_PayPlanDataKoujyoKin: TCurrencyField;
    DMem_PayPlanDataPayPrice: TCurrencyField;
    DMem_PayPlanDataSousaiKin: TCurrencyField;
    DMem_UchiwakeTashaFee: TCurrencyField;
    DMem_Jigyousho: TdxMemData;
    DMem_Kijitsu: TdxMemData;
    DMem_JigyoushoSateiKin: TCurrencyField;
    DMem_JigyoushoSousaiKin: TCurrencyField;
    DMem_KijitsuSiharaiKin: TCurrencyField;
    DMem_KijitsuTashaFee: TCurrencyField;
    DMem_KijitsuTKanriNo: TStringField;
    DMem_Kakitome: TdxMemData;
    DMem_KakitomeBunkatusuu: TIntegerField;
    DMem_KakitomeLongName: TStringField;
    DMem_UchiwakeMankibi: TIntegerField;
    DMem_TegGCode: TStringField;
    DMem_CSInfoSateiPos: TIntegerField;
	DMem_KakitomeGCode: TStringField;
    DMem_KoujyoGCode: TStringField;
    DMem_ToriGCode: TStringField;
    DMem_JigyoushoGCode: TStringField;
    DMem_KijitsuGCode: TStringField;
    DMem_UchiwakeGCode: TStringField;
    DMem_CSInfoPayDay: TIntegerField;
    DMem_UchiwakePayDay: TIntegerField;
    DMem_KoujyoItemNo: TIntegerField;
    DMem_TegMankibi: TIntegerField;
    DMem_TegFridasibi: TIntegerField;
    DMem_KijitsuMankibi: TIntegerField;
    DMem_JigyoushoLongName: TStringField;
    DMem_PayPlanDataSumTori: TCurrencyField;
    DMem_PayPlanDataSumNote: TCurrencyField;
    DMem_PayPlanDataSumDed: TCurrencyField;
    DMem_PayPlanDataSumBmnSatei: TCurrencyField;
    DMem_PayPlanDataSumBmnSousai: TCurrencyField;
    DMem_PayPlanDataSumKijSatei: TCurrencyField;
    DMem_PayPlanDataSumKijFee: TCurrencyField;
    DMem_CSInfoTitleName: TStringField;
    DMem_CSInfoLongName: TStringField;
    DMem_TegLongName: TStringField;
    DMem_CSInfoTegYusouKbn: TIntegerField;
    DMem_UchiwakeSite: TIntegerField;
    DMem_KijitsuMankiKenNo: TIntegerField;
    DMem_KijitsuFeePayKbn: TIntegerField;
    DMem_UchiwakeFeePayKbn: TIntegerField;
    DMem_KijitsuFeeSwkKbn: TIntegerField;
    DMem_CSInfoTelNo: TStringField;
    EPayDataName: TMTxtEdit;
    DMem_PayPlanDataJikaiKin: TCurrencyField;
    DMem_TegKaisuu: TIntegerField;
    DMem_TegRecSyubetu: TSmallintField;
    DMem_CSInfoNCode: TFloatField;
    DMem_CSInfoNayoseNCode: TFloatField;
    DMem_KoujyoSortNo: TIntegerField;
    DMem_TegBunkatuNo: TIntegerField;
    DMem_UchiwakeBkBraNCode: TCurrencyField;
    DMem_UchiwakeAccNCode: TCurrencyField;
    DMem_ToriCNumValue1: TStringField;
    DMem_ToriCNumValue2: TStringField;
    MBottomPanel: TMPanel;
    SStatusBar: TMStatusBar;
    Prog1: TProgressBar;
    DMem_CSInfoTegYusouFutan: TIntegerField;
    DMem_CSInfoSpotInfoNo: TFloatField;
    DMem_UchiwakeSpotInfoNo: TFloatField;
    DMem_KoujyoSpotInfoNo: TFloatField;
    DMem_PayPlanDataSpotInfoNo: TFloatField;
    DMem_ToriSpotInfoNo: TFloatField;
    DMem_JigyoushoSpotInfoNo: TFloatField;
    DMem_CSInfoLetterMailKbn: TIntegerField;
    DMem_CSInfoMailAddress: TStringField;
    DMem_CSInfoZipPass: TStringField;
    DMem_CSInfoMailSendKbn: TIntegerField;
    DMem_CSInfoMailCount: TIntegerField;
    DMem_CSInfoKM1100020: TStringField;
    DMem_CSInfoKM1100140: TStringField;
    DMem_CSInfoKM1100150: TStringField;
    DMem_CSInfoKM1200021: TStringField;
    DMem_CSInfoKM1200050: TStringField;
    DMem_CSInfoKM1200060: TStringField;
    DMem_CSInfoKM1200070: TStringField;
    DMem_CSInfoKM1200100: TStringField;
    DMem_CSInfoKM1200110: TStringField;
    DMem_CSInfoKM1200120: TStringField;
    DMem_CSInfoKM1200230: TStringField;
    DMem_CSInfoKM1410061: TIntegerField;
    DMem_CSInfoKM1410062: TStringField;
    DMem_CSInfoKM1410063: TStringField;
    DMem_CSInfoKM1410064: TIntegerField;
    DMem_CSInfoKM1410065: TStringField;
    DMem_CSInfoKM1410066: TStringField;
    DMem_CSInfoKM1410080: TStringField;
    DMem_CSInfoKM1410100: TStringField;
    DMem_CSInfoKM1410110: TStringField;
    DMem_CSInfoKM1410150: TStringField;
    DMem_CSInfoKM1410160: TStringField;
    DMem_CSInfoKM1410170: TStringField;
    DMem_CSInfoKM1420061: TIntegerField;
    DMem_CSInfoKM1420062: TStringField;
    DMem_CSInfoKM1420063: TStringField;
    DMem_CSInfoKM1420064: TIntegerField;
    DMem_CSInfoKM1420065: TStringField;
    DMem_CSInfoKM1420066: TStringField;
    DMem_CSInfoKM1420080: TStringField;
    DMem_CSInfoKM1420100: TStringField;
    DMem_CSInfoKM1420110: TStringField;
    DMem_CSInfoKM1420150: TStringField;
    DMem_CSInfoKM1420160: TStringField;
    DMem_CSInfoKM1420170: TStringField;
    DMem_CSInfoRenso: TStringField;
    DMem_UchiwakeERKbn: TBooleanField;
    DMem_TegTegKbn: TIntegerField;
    DMem_ToriDKmkGCode: TStringField;
    DMem_ToriDKmkLongName: TStringField;
    DMem_ToriDBmnGCode: TStringField;
    DMem_ToriDBmnLongName: TStringField;
    DMem_ToriJigyoushoLongName: TStringField;
    DMem_UchiwakeTegYusouKbn: TSmallintField;
    DMem_UchiwakeTegYusouFutan: TSmallintField;

	procedure FormCreate(Sender: TObject);
	procedure FormDestroy(Sender: TObject);
	procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
	procedure FormClose(Sender: TObject; var Action: TCloseAction);
	procedure FormActivate(Sender: TObject);
	procedure FormShow(Sender: TObject);
	procedure FormHide(Sender: TObject);
	procedure BExitClick(Sender: TObject);
	procedure BPrintClick(Sender: TObject);
	procedure BChangeClick(Sender: TObject);
	procedure BJokenClick(Sender: TObject);
    procedure AbortingPrint();

  private
	{ Private 宣言 }
	m_pRec			:	^TMjsAppRecord;
	m_DataModule	:	TMDataModulef;
	m_DBCorp		:	TFDConnection;
    m_DBCtrl		:	TFDConnection;
	m_ACControl		:	TWinControl;
	m_DlgParam		:	TPay510100DlgParam;
	m_LayoutInfo	:	TMPayNoticeDoc;
	m_LayoutCtrl	:	TMPayBaseLayoutInfo;
	m_Calc			:	TPay510100Calc;
// 2006/07/24 <#007> Y.Naganuma Add
	m_iSystemCode	:	Integer;				//システムコード
	m_iFuncNo		:	Integer;				//処理No
    m_iDataNo		:	Integer;				//データNo
	m_iPayDate		:	Integer;				//支払日
// 2006/07/24 <#007> Y.Naganuma Add

	m_PrnSupport    :	TMjsPrnSupport3;
	m_PrnDlg        :	TMJSPrnDlg3f;
	m_Preview		:	TMjsPreviewIF3;

    m_DTMAIN		:	TDTMAIN;	//	会社基本情報
	m_MasterInfo	:	TMasterInfo;//
	m_BmnInfo	    :	TMasterInfo;// <#033> ADD

    m_cSystemCom 	: 	TPAYCom;        //進捗ﾁｪｯｸｸﾗｽ
    m_cExcluseive   :   TPAYExclusive;  //  支払管理排他

    bPrintCancel 		: 	boolean;
    CoReportsPrintObj	: 	TMjsCoReportsPrint;
    CoRepData    	    : 	TMjsCoReportsData;
    CoRepDataTori 	    : 	TMjsCoReportsData;
    CoRepDataTeg 	    : 	TMjsCoReportsData;
    CoRepDataKoujyo	    : 	TMjsCoReportsData;
    CoRepDataJigyou	    : 	TMjsCoReportsData;
    CoRepDataKijitsu    : 	TMjsCoReportsData;

	PropertyObj 	    : 	array [0..4] of TMjsCoReportsProperty;
    iFormIndex			:	array [0..4] of Integer;	//	{支払通知書}
    												//0	:標準フォームのIDX
												    //1	:取引明細フォームのIDX
												    //2	:手形明細フォームのIDX
												    //3	:控除明細フォームのIDX
                                                    //	通知書(控除なし)のみ1,3入替
												    //1	:事業所明細フォームのIDX
												    //3	:期日明細フォームのIDX

                                                    //	{手形送付案内}
    												//0	:標準フォームのIDX
                                                    //	{書留郵便物受領証}
    												//0	:標準フォームのIDX
	//===========================
	// １枚目の基本レイアウト
	//===========================
    // 0・・・未使用
    // 1・・・取引明細
    // 2・・・手形明細
    // 3・・・控除明細 or 事業所内訳
    // 4・・・期日指定振込残高
	bFirstFormMaxLineGetFlg		:	array [0..4] of Boolean;	//	{支払通知書}
	iFirstFormMaxLine			:	array [0..4] of Integer;	//	{支払通知書}

	//===========================
	// ２枚目以降のレイアウト
	//===========================
    // 0・・・未使用
    // 1・・・取引明細
    // 2・・・手形明細
    // 3・・・控除明細 or 事業所内訳
    // 4・・・期日指定振込残高
	bSecondFormMaxLineGetFlg	:	array [0..4] of Boolean;	//	{支払通知書}
	iSecondFormMaxLine			:	array [0..4] of Integer;	//	{支払通知書}

    iPageCnt			:	Integer;	//	現在の頁
    iOutPutLastRow		:	Integer;	//	手形送付案内の最終行

    m_RenCnt			:	Integer;	//  手形送付案内の連続出力時、折線出力判定
    m_GnPuKbn_10	    :   Integer;    //手形管理ＮＯ属性 0:数値 1:フリー(左寄せ) 2:フリー(右寄せ)
    m_GnPuKbn_12	    :   Integer;    //番号管理採用区分		<#012> 2008/03/26 T.Kawahata Add
    m_GnPuKbn_13	    :   Integer;    //番号1桁数             <#012> 2008/03/26 T.Kawahata Add
    m_GnPuKbn_14	    :   Integer;    //番号1属性             <#012> 2008/03/26 T.Kawahata Add
    m_GnPuKbn_15	    :   Integer;    //番号2桁数             <#012> 2008/03/26 T.Kawahata Add
    m_GnPuKbn_16	    :   Integer;    //番号2属性             <#012> 2008/03/26 T.Kawahata Add

    m_bPriKengenFlag    : Boolean;      // 印刷権限判定用フラグ // 2006/01/25 H.Kawato <#004> Add

	m_bFirstERR			: 	Boolean;	// 初期処理ﾌﾗｸﾞ
	m_sFirstMSG			: 	String;		// 初期処理MSG

	CalcParam			: TPayCalcParam;

    m_rPrintDocName     : TRPrintDocName;                     // <#017> ADD

    m_iKStDate          : Integer;                            // <#025> ADD

// <#036> MOD-STR
//	m_sNotice_PayName	:	array [1..5] of String;	          // <#030> ADD
	m_sNotice_PayName	:	array [1..6] of String;
// <#036> MOD-END

    m_MailPDFSave       :   Integer;                          // <#039> ADD

// <#032> ADD-STR
    m_iCurrTegKbn       : Integer;
    m_nTegSubTotal      : Currency;
// <#032> ADD-END

// <#036> ADD-STR
	TOTAL_PRICE		    : 	String;
	TOTAL_ER_PRICE	    : 	String;
// <#036> ADD-END

    m_iTegSitKijun      : Integer;      // 手形 サイト基準日 <#037> ADD
	m_sTegataExistGCode : String;       // <#037> ADD

	procedure CMChildKey(var Msg: TWMKey); message CM_CHILDKEY;
	procedure WMDispRun(var Msg: TMessage); message WM_DISPRUN;

	procedure PrintCtl();

	function Init: Boolean;

	{ 条件設定画面呼出処理 }
	function CallDlg: Integer;

	procedure ErrorMessageDsp(Query: TMQuery);

	{ 集計処理 }
	function DoCalc(): Boolean;

	procedure SetParam(var CalcParam: TPayCalcParam);
	procedure ParamClear(pParam: PPayCalcParam);

	procedure CalcErrorDsp;

	{ MemData初期化 }
	procedure SetMemData;
	procedure MemDataInit;


	{ 印刷処理 }
	procedure SetPageCnt(CoData: TMjsCoReportsData);

	procedure SetData_PayPrice(pIndex: Integer);
	procedure SetData_DTMAIN(CoData: TMjsCoReportsData);
	procedure SetData_CSInfo(CoData: TMjsCoReportsData);
	procedure SetData_CSInfo2(var CoData: TMjsCoReportsData; iObjNumber: Integer);  // <#024> ADD
	//	基本レイアウト---内訳
	procedure SetData_Uchiwake(pIndex: Integer);
	//	基本レイアウト---控除
	function SetData_Koujyo(pIndex: Integer):Boolean;
	procedure SetData_Bunsho(pIndex: Integer);
	//	基本レイアウト---折り目区切り線
	procedure SetFoldLine(CoData: TMjsCoReportsData);

	//	書留郵便物受領証
	function SetData_Kakitome(pIndex: Integer):Boolean;

	// PayPlanData支払先レコード検索
	function FindPayPlan(pGcode: String):Boolean;
	function NextPayPlan(pGcode: String):Boolean;
	// 内訳支払先レコード検索
	function FindUchiwake(pGcode: String):Boolean;
	function NextUchiwake(pGcode: String):Boolean;
	// 取引明細支払先レコード検索
	function FindTori(pGcode: String):Boolean;
	function NextTori(pGcode: String):Boolean;
	// 控除支払先レコード検索
	function FindKoujyo(pGcode: String):Boolean;
	function NextKoujyo(pGcode: String):Boolean;
	// 事業所明細支払先レコード検索
	function FindJigyo(pGcode: String):Boolean;
	function NextJigyo(pGcode: String):Boolean;
	// 期日指定振込内訳支払先レコード検索
	function FindKijitsu(pGcode: String):Boolean;
	function NextKijitsu(pGcode: String):Boolean;
	// 手形明細支払先レコード検索
	function FindTegata(pGcode: String):Boolean;
	function NextTegata(pGcode: String):Boolean;

	//	基本レイアウト---取引　
	function SetData_ToriDetail(pIndex: Integer):Boolean;
	//	基本レイアウト---手形明細
	function SetData_TegataDetail(pIndex: Integer):Boolean;
	//	基本レイアウト---事業所内訳
	function SetData_Jigyosho(pIndex: Integer):Boolean;
	//	基本レイアウト---期日指定振込内訳
	function SetData_Kijitsu(pIndex: Integer):Boolean;


	//	取引明細レイアウト　
	function SetData_ToriDetailAdd(pIndex: Integer): Boolean;
	//	手形明細レイアウト　
	function SetData_TegDetailAdd(pIndex: Integer): Boolean;
	//	控除明細レイアウト　
	function SetData_KoujyoDetailAdd(pIndex: Integer): Boolean;
	//	事業所明細レイアウト　
	function SetData_JigyouDetailAdd(pIndex: Integer): Boolean;
	//	期日指定振込残高明細レイアウト　
	function SetData_KijitsuDetailAdd(pIndex: Integer): Boolean;


    { 合計出力 }
    procedure SetTotalLine(MaxLine,RecCount:Integer;Lt:TLayoutType;
// <#032> MOD-STR
//  CoData: TMjsCoReportsData);
    CoData: TMjsCoReportsData;bAddPage:Boolean=True);
// <#032> MOD-END
    procedure OutPutTotal(pLeyoutType:TLayoutType;sField: String;
    CoData: TMjsCoReportsData);
    procedure OutPutSum(pLeyoutType:TLayoutType;idx: integer;
    CoData: TMjsCoReportsData);

    //	手形送付案内　合計出力
    function GetOutputLine(RecCount,MaxLine:Integer;var iOutputLine:Integer):Boolean;

	procedure DoPrint();
	procedure CreatePropertyObj;
	procedure SetFormFile ;
	procedure CreateCoRepData(pLayoutType: TLayoutType);

	function GetActionInfo: Boolean;

	function GetDTMAIN(Query: TMQuery): Boolean;
	function GetMasterInfo(Query: TMQuery): Boolean;
    function GetKbnInfo(Query: TMQuery): Boolean;

    //	行数取得
	function GetLineCount_ToriDetail(var iCount,pIndex : Integer):Boolean;
    function GetLineCount_TegDetail(var iCount,pIndex : Integer):Boolean;
    function GetLineCount_KoujyoDetail(var iCount,pIndex : Integer):Boolean;
    function GetLineCount_JigyoushoDetail(var iCount,pIndex : Integer):Boolean;
    function GetLineCount_Kijitsu(var iCount,pIndex : Integer):Boolean;
// <#032> MOD-STR
//  function GetSyubetsu(iIdx:Integer):String;
    function GetSyubetsu(iIdx:Integer; bIsER:Boolean=False):String;
// <#032> MOD-END
    function GetAccKbn(iIdx:Integer):String;
    function GetAccNo(sNo: String):String;
    function GetBunkatusuu(iBunkatusuu : Integer):String;
    function GetBasicLayout():String;

    function SetFormatHasseiDay(pData : TDateTime):String;
    function SetFormatInt(pData : Integer;IsOn : Boolean):String;overload;
    function SetFormatInt(pData : Integer):String;overload;
    function SetFormatMankibi(pData : Integer):String;

	{ Event }
    procedure SetPayData(pIndex: Integer);
    procedure SetTegataData(pIndex: Integer);
    procedure SetKakitomeCSVData(pIndex: Integer);

    { 手形送付案内 }
    //	連続印刷
    procedure PrintTegata_Contenue(pIndex : Integer);
    //	支払先ごと改頁
	procedure PrintTegata_PageChange(pIndex : Integer);

    procedure SetTackSealCSVData(pIndex : Integer);         // <#024> ADD

    function Edit_Kingaku(pKingaku: Currency): String;
    function DelSpace(pString: String): String;
	procedure CoRep_FontRatio(wCoRepData : TMjsCoReportsData;pIndex: Integer);
    procedure CoRep_AlignCenter(wCoRepData : TMjsCoReportsData;pIndex: Integer);
	procedure CoRep_AlignLeft(wCoRepData : TMjsCoReportsData;pIndex: Integer);
// <#012> 2008/03/26 T.Kawahata Add
	procedure CoRep_AlignRight(wCoRepData : TMjsCoReportsData;pIndex: Integer);
// <#012> 2008/03/26 T.Kawahata Add
	procedure CoRep_AlignEven(wCoRepData : TMjsCoReportsData;pIndex: Integer);					// <#027> ADD

    procedure CoRep_KanriNo(wCoRepData : TMjsCoReportsData;pIndex: Integer);
//	procedure CodeEdit(var Code: String);	// 2005/11/02 <#001> Y.Kabashima Del 未使用の為
	procedure BankSqNoEdit(var Code: String);
    function CheckFieldOnReport(pIndex : Integer;pString : String):Boolean;
	procedure CoRep_TorihikiNo(wCoRepData : TMjsCoReportsData;pIndex: Integer);
	function Edit_Code(pAttr: Integer; pDigit: Integer; pCode: String; pCodeType: Integer): String;
// <#012> 2008/03/26 T.Kawahata Add
	procedure EditNumValue1(var pNumValue: String; var pAlignment: TAlignment);
	procedure EditNumValue2(var pNumValue: String; var pAlignment: TAlignment);
// <#012> 2008/03/26 T.Kawahata Add
// <#025> ADD-STR
	procedure DoSendMail();
    procedure PAYCallProgram(aHandle: HWND; const aFileName: String; const aParam: String; const aFilePath: String);
// <#025> ADD-END

  public
	{ Public 宣言 }

	constructor CreateForm(pRec: Pointer);
  end;


const
    // COReportsレイヤ名
    BASICLAYOUT1	= '支払通知書';
    BASICLAYOUT2	= '支払通知書(送付)';
    BASICLAYOUT3	= '支払通知書(簡略)';
    BASICLAYOUT4	= '支払通知書(手形あり)';
	BASICLAYOUT5	= '支払通知書(手形なし)';
    BASICLAYOUT6	= '支払通知書(期日指定振込)';
	BASICLAYOUT7	= '支払通知書(名寄せ用)';
	TORIDETAIL		= '通知書取引明細';
	TEGDETAIL		= '通知書手形明細';
	KOUJYOIDETAIL	= '通知書控除明細';
	JIGYOUDETAIL	= '事業所内訳明細';
	KIJITSUDETAIL	= '期日指定振込残高明細';
	TEGSENDINFO 	= '手形送付案内';
	KAKITOME		= '書留郵便物受領証';
    TACKSEALLAYOUT  = 'タックシール';       // <#024> ADD

	//	取引、手形明細、控除、事業所内訳のカウント最大値
	DETAILCOUNT			= 200;

	TEGATAROWCOUNT	=  3;			// 	手形送付案内の分割行数

	KOUJYO			=  5;			//	(基本レイアウト)控除明細の最大行数
	KAKITOMELINE	=  20;			//	(基本レイアウト)書留受領証の最大行数

	TOTAL_TORI		=	'※※　今回取引計　※※';
// <#036> DEL-STR
//	TOTAL_PRICE		=	'※※　手形金額計　※※';
//	TOTAL_ER_PRICE	=	'※※　電子記録債権金額計　※※';       // <#032> ADD
// <#036> DEL-END
	TOTAL_DED		=	'※ 控除計 ※';

	TOTAL			=	'※※　合計　※※';
    ATTR_FREE        		=	2;  // ｺｰﾄﾞ属性: フリー
    ATTR_MAEZERO        	=	1;  // ｺｰﾄﾞ属性: 数字(前ｾﾞﾛあり)
    ATTR_MAEZERONASHI   	=	0;  // ｺｰﾄﾞ属性: 数字
    DB_TYPE  				=	0;  // 補助コード：DB書込
	DISPLAY_TYPE   			=	1;  // 補助コード：画面表示

    CORPNM_GCode			=	'支払先コード';
    CORPNM_PayZipCode		=	'支払先郵便番号';
    CORPNM_PayAdress1		=	'支払先住所上段';
    CORPNM_PayAdress2		=	'支払先住所下段';
    CORPNM_PayLongName		=	'支払先名称';
    CORPNM_PaySectionName	=	'送付先部署';
    CORPNM_PayPersonName	=	'担当者名';
    CORPNM_PayDay			=	'支払日';
    CORPNM_Souhubi			=	'送付日';
    CORPNM_Lbl_Bunsho1		=	'文書1';
    CORPNM_KoumokName		=	'項目名';
    CORPNM_Site				=	'サイト';
    CORPNM_Kin				=	'支払金額';
    CORPNM_TashaFee			=	'他社負担手数料';
    CORPNM_TashaFeeYusouKin	=	'他社負担手数料／郵送料';       // <#038> ADD
    CORPNM_Tekiyou			=	'摘要';
    CORPNM_AccNo			=	'口座情報';
    CORPNM_ZenkaiKin		=	'前回繰越額';
    CORPNM_ToukaiKin		=	'今回取引額';
    CORPNM_SateiKin			=	'今回合計額';
    CORPNM_JikaiKin			=	'次回繰越額';					// 2005/11/24 <#002> Y.Kabashima Add
    CORPNM_KoujyoKin		=	'控除金額計';
    CORPNM_SousaiKin		=	'相殺金額計';
    CORPNM_PayPrice			=	'今回支払金額';
    CORPNM_Page				=	'頁';
	CORPNM_Lbl_Bunsho2		=	'文書2';
    CORPNM_Lbl_Bunsho3		=	'文書3';
    CORPNM_ZipCode			=	'自社郵便番号';
    CORPNM_Adress1			=	'自社住所上段';
    CORPNM_Adress2			=	'自社住所下段';
    CORPNM_CompName			=	'会社名';
    CORPNM_JisyaBumon		=	'自社部署名';
    CORPNM_TelNo			=	'自社電話番号';
    CORPNM_Koujyo			=	'控除科目';
    CORPNM_Fee				=	'控除金額';
    CORPNM_HasseiDay  		=	'取引明細発生日';
    CORPNM_ToriTekiyou		=	'取引明細摘要';
// <#033> ADD-STR
    CORPNM_ToriKmkGCodeD	=	'取引明細相手科目コード';
    CORPNM_ToriKmkLNameD	=	'取引明細相手科目名称';
    CORPNM_ToriBmnGCodeD	=	'取引明細相手部門コード';
    CORPNM_ToriBmnLNameD	=	'取引明細相手部門名称';
    CORPNM_ToriJigyoushoLName =	'取引明細事業所名';
// <#033> ADD-END
// <#012> 2008/03/26 T.Kawahata Add
    CORPNM_ToriNumValue1	=	'取引明細番号1';
    CORPNM_ToriNumValue2	=	'取引明細番号2';
// <#012> 2008/03/26 T.Kawahata Add
    CORPNM_HasseiKin		=	'取引明細金額';
    CORPNM_BankSqNo			=	'手形番号';
    CORPNM_Fridasibi		=	'手形振出日';
    CORPNM_Mankibi			=	'手形満期日';
	CORPNM_ShiharaiKin		=	'手形金額';
    CORPNM_PayPlace			=	'手形支払場所';
    CORPNM_BumonName		=	'事業所名';
    CORPNM_BumonSateiKin	=	'事業所支払金額';
    CORPNM_BumonSousaiKin	=	'事業所相殺金額';
    CORPNM_KijituMankibi	=	'期日指定残高満期日';
    CORPNM_KijituShiharaiKin=	'期日指定残高金額';
    CORPNM_KijituTashaFee	=	'期日指定残高他社負担手数料';
    CORPNM_KanriNo			=	'期日指定残高管理ＮＯ';
    CORPNM_Bunkatusuu		=	'手形枚数';
    CORPNM_Line_Orime1_1	=	'折目線左上';
    CORPNM_Line_Orime2_1	=	'折目線右上';
    CORPNM_Line_Orime1_2	=	'折目線左下';
    CORPNM_Line_Orime2_2	=	'折目線右下';

function AppEntry(pPar: Pointer): Integer;

exports
	AppEntry;

implementation
    {$I PayComCallU.inc}
    {$I PayProgCheckU.inc}
    {$I PAYExclusiveB.inc}
    {$i MasPermsB.inc}              // 2006/01/25 H.Kawato <#004> Add
    {$I MasSetPrnInfo3B.inc}        // <#013>
    {$I PAYCommon_B.inc}            // 債務共通 <#017> ADD

{$R *.DFM}

//**************************************************************************
//  Proccess    :   AppEntry関数
//  Name        :   K.IKEMURA
//  Date        :	2002 / 01 / 24
//  Parameter   :	pPar	TAppParam
//  Return      :	ACTID_RET_OK or ACTID_RET_NG
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function AppEntry(pPar: Pointer) : Integer;
var
	pFrm	: ^TPay510100f;
	pRec	: ^TMjsAppRecord;
begin
	result	:=	ACTID_RET_OK;

	pRec	:=	Pointer(TAppParam(pPar^).pRecord);

	case TAppParam(pPar^).iAction of
		ACTID_FORMCREATESTART		:		//	Form Create要求
		begin
			new(pFrm);

			try
				pFrm^	:=	TPay510100f.CreateForm(pRec);
				pRec^.m_pChildForm	:=	pFrm;
			except
				Dispose(pFrm);
				Result	:=	ACTID_RET_NG;
			end;
		end;

		ACTID_FORMCREATESHOWSTART	:		//	Form Create&Show要求
		begin
			new(pFrm);

			try
				pFrm^	:=	TPay510100f.CreateForm(pRec);
				pFrm^.Show();
				pRec^.m_pChildForm	:=	pFrm;
			except
				Dispose(pFrm);
				Result	:=	ACTID_RET_NG;
			end;
		end;

		ACTID_FORMCLOSESTART		:		//	Form Close要求
		begin
			pFrm	:=	Pointer(pRec^.m_pChildForm);
			pFrm^.Close();
			pFrm^.Free();
			Dispose(pFrm);
		end;

		ACTID_FORMCANCLOSESTART		:		//	Form CanClose要求
		begin
			pFrm	:=	Pointer(pRec^.m_pChildForm);
			if pFrm^.CloseQuery() = False then
				result := ACTID_RET_NG;
		end;

		ACTID_SHOWSTART				:	    //	Show要求
		begin
			pFrm	:=	Pointer(pRec^.m_pChildForm);
			pFrm^.Show();
		end;

		ACTID_HIDESTART				:		//	Hide要求
        begin
			pFrm	:=	Pointer(pRec^.m_pChildForm);
			if pFrm^.Parent <> nil then
				pFrm^.Hide();
        end;
	end;
end;

//**************************************************************************
//  Proccess    :   コンストラクタ
//  Name        :   K.IKEMURA
//  Date        :	2001/12/14
//  Parameter   :	pRec	TMjsAppRecord
//  Return      :	エラー時は例外を発生させる (OnCreateで例外を発生さしてもダメ)
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
constructor TPay510100f.CreateForm(pRec: Pointer);
var
	pOwnerForm : ^TControl;
	ComArea		: 	TMasCom;
	MsgRec		: TMjsMsgRec;
	DmqPrint	:	TMQuery;    // <#013>
begin
	//
	m_pRec			:= pRec;
	m_DataModule 	:= TMDataModulef(m_pRec^.m_pDBModule^);
	ComArea	 		:= TMasCom(m_pRec^.m_pSystemArea^);

    try
        m_DBCorp := m_DataModule.COPDBOpen(1, ComArea.m_iCopNo);
        if m_DBCorp = nil then
        begin
            ComArea.m_MsgStd.GetMsg(MsgRec,10000,m_DataModule.GetStatus);
            with MsgRec do
                MjsMessageBoxEx(Self, sMsg,sTitle,icontype,btntype,btndef,LogType);
            raise Exception.Create(MsgRec.sMsg);
        end;

        m_DBCtrl := m_DataModule.CTLDBOpen;
        if m_DBCtrl = nil then
        begin
            ComArea.m_MsgStd.GetMsg(MsgRec,10000,m_DataModule.GetStatus);
            with MsgRec do
                MjsMessageBoxEx(Self, sMsg,sTitle,icontype,btntype,btndef,LogType);
            raise Exception.Create(MsgRec.sMsg);
        end;

        //進捗区分チェック関係
        m_cSystemCom 	:= TPAYCom.Create;

        //排他制御チェック関係
        m_cExcluseive 	:= TPAYExclusive.Create;

        //印刷関係
        m_Preview	 	:= TMJSPreviewIF3.Create;
        m_PrnSupport 	:= TMJSPrnSupport3.Create;
        m_PrnDlg	 	:= TMJSPrnDlg3f.Create(Self);

// <#013> ADD-STR
    	DmqPrint	:= TMQuery.Create(Nil);
	    m_DataModule.SetDBInfoToQuery(m_DBCorp, DmqPrint);
    	gfnMasSetPrnInfo3(m_PrnSupport, DmqPrint);
        DmqPrint.Free;
// <#013> ADD-END

      	m_Preview.Init(m_pRec);

		m_bFirstERR 	:= False;
		m_sFirstMSG		:= '支払予定データ作成を実行してください。';

		if not Init then
        	m_bFirstERR := True;

// 2006/01/25 H.Kawato <#004> Add
		// 印刷権限判定フラグ
    	m_bPriKengenFlag    := False;       // False:権限なし
// 2006/01/25 H.Kawato <#004> Add
    except
    	//	初期処理エラー
    	FormDestroy(Self);
        raise;
    end;

	pOwnerForm := m_pRec^.m_pOwnerForm;
	inherited Create(pOwnerForm^);
end;

//**************************************************************************
//  Proccess    :   区分報取得処理
//  Name        :   J.Kobashigawa
//  Date        :	2002/01/21
//  Parameter   :	Query
//  Return      :	True or False
//  History     :   9999/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPay510100f.GetKbnInfo(Query: TMQuery): Boolean;
var
	sSql	:	String;
begin
	Result := False;

// <#012> 2008/03/26 T.Kawahata Add
	//初期化
    m_GnPuKbn_10 := 0;   //手形管理NO属性
    m_GnPuKbn_12 := 0;   //番号管理採用区分
    m_GnPuKbn_13 := 0;   //番号1桁数
    m_GnPuKbn_14 := 0;   //番号1属性
    m_GnPuKbn_15 := 0;   //番号2桁数
    m_GnPuKbn_16 := 0;   //番号2属性
// <#012> 2008/03/26 T.Kawahata Add

	with Query do
	begin
		Close;
//2006/07/24 <#007> Y.Naganuma Add
		UnPrepare;
		Errors.Clear;
//2006/07/24 <#007> Y.Naganuma Add
		SQL.Clear;

        sSql := 'SELECT ';
// <#012> 2008/03/26 T.Kawahata Mod
//		sSql := sSql + 'GnPuKbn10 ';	//手形管理ＮＯ属性
		sSql := sSql + 'GnPuKbn10, ';	//手形管理ＮＯ属性
		sSql := sSql + 'GnPuKbn12, ';	//番号管理採用区分
		sSql := sSql + 'GnPuKbn13, ';	//番号1桁数
		sSql := sSql + 'GnPuKbn14, ';	//番号1属性
		sSql := sSql + 'GnPuKbn15, ';	//番号2桁数
		sSql := sSql + 'GnPuKbn16 ';	//番号2属性
// <#012> 2008/03/26 T.Kawahata Mod
		sSql := sSql + 'FROM ';
		sSql := sSql + ' KbnInfo ';
		sSql := sSql + 'WHERE ';
		sSql := sSql + ' RecKbn = 1	';	//レコード区分(1:採用区分)

//2006/07/24 <#007> Y.Naganuma Mod
//		SQL.Add(sSql);
        ParamCheck := False;
		SQL.Add(sSql);
		Prepare;
//2006/07/24 <#007> Y.Naganuma Mod

		try
			Open(True);
		except
			ErrorMessageDsp(Query);
			Exit;
		end;

// <#012> 2008/03/26 T.Kawahata Mod
//        if not Eof then
//	        m_GnPuKbn_10 := GetFld('GnPuKbn10').AsInteger;   //0:数値 1:フリー(左寄せ) 2:フリー(右寄せ)
        if not Eof then
        begin
	        m_GnPuKbn_10 := GetFld('GnPuKbn10').AsInteger;   //0:数値 1:フリー(左寄せ) 2:フリー(右寄せ)
	        m_GnPuKbn_12 := GetFld('GnPuKbn12').AsInteger;   //番号管理採用区分
	        m_GnPuKbn_13 := GetFld('GnPuKbn13').AsInteger;   //番号1桁数
	        m_GnPuKbn_14 := GetFld('GnPuKbn14').AsInteger;   //番号1属性
	        m_GnPuKbn_15 := GetFld('GnPuKbn15').AsInteger;   //番号2桁数
	        m_GnPuKbn_16 := GetFld('GnPuKbn16').AsInteger;   //番号2属性
        end;
// <#012> 2008/03/26 T.Kawahata Mod
	end;
	Result := True;
end;

//**********************************************************************
//*		Proccess	:  取引明細行数取得
//*		Name		:  K.Ikemura
//*		Create		:  2001/12/14
//*		Parameter   :  iCount,pIndex
//*		Return		:  True : 行数取得　False : 行数取得エラー
//*		History		:  9999/99/99	X.Xxxx
//*									XXXXXXXXXXXXXXXXXX
//**********************************************************************
function TPay510100f.GetLineCount_ToriDetail(var iCount,pIndex: Integer): Boolean;
var
    //CoReportsフィールド
    sField_HasseDay		:	String;
    sField_Tekiyo		:	String;
    sField_THasseiKin	:	String;

    i : Integer;
begin
    Result := False;
	iCount := 0;

    for	i := 1 to DETAILCOUNT do
    begin
        try
            sField_HasseDay		:=	Format( CORPNM_HasseiDay   + '%-d', [i] );	//	発生日
            sField_Tekiyo		:=	Format( CORPNM_ToriTekiyou + '%-d', [i] );	//	摘要
            sField_THasseiKin	:=	Format( CORPNM_HasseiKin   + '%-d', [i] );	//	金額

            // 取引明細---発生日
            try
                if ((CheckFieldOnReport(pIndex,sField_HasseDay)) and
                    (CheckFieldOnReport(pIndex,sField_Tekiyo)) and
                    (CheckFieldOnReport(pIndex,sField_THasseiKin))) then
	                    Continue;
            Except
                // 取引明細---摘要
                try
                    if CheckFieldOnReport(pIndex,sField_Tekiyo) then
                        Continue;
                Except
                    // 取引明細---金額
                    try
                        if CheckFieldOnReport(pIndex,sField_THasseiKin) then
                            Continue;
                    Except
                    	iCount := i - 1;
                        Result := True;
                        Exit;
                    end;
                end;
            end;
        except
        end;
	end;
end;

//**********************************************************************
//*		Proccess	:  手形明細行数取得
//*		Name		:  K.Ikemura
//*		Create		:  2001/12/14
//*		Parameter   :  iCount,pIndex
//*		Return		:  True : 行数取得　False : 行数取得エラー
//*		History		:  9999/99/99	X.Xxxx
//*									XXXXXXXXXXXXXXXXXX
//**********************************************************************
function TPay510100f.GetLineCount_TegDetail(var iCount,pIndex: Integer): Boolean;
var
    //CoReportsフィールド
    sField_BankSqNo		:	String;
    sField_Mankibi		:	String;
    sField_SiharaiKin	:	String;
    sField_PayPlace		:	String;

    i : Integer;
begin
    Result := False;
	iCount := 0;

    for	i := 1 to DETAILCOUNT do
    begin
        try
			sField_BankSqNo		:=	Format( CORPNM_BankSqNo 	+ 	'%-d', [i] );	//	手形NO.
            sField_Mankibi		:=	Format( CORPNM_Mankibi  	+ 	'%-d', [i] );	//	支払日
            sField_SiharaiKin	:=	Format( CORPNM_ShiharaiKin 	+ 	'%-d', [i] );	//	金額
            sField_PayPlace		:=	Format( CORPNM_PayPlace		+	'%-d', [i] );	//	支払場所

            // 手形明細---手形NO.
            try
                if ((CheckFieldOnReport(pIndex,sField_BankSqNo)) and
                	(CheckFieldOnReport(pIndex,sField_Mankibi)) and
                    (CheckFieldOnReport(pIndex,sField_SiharaiKin)) and
                    (CheckFieldOnReport(pIndex,sField_PayPlace))) then
	                    Continue;
            Except
	            // 手形明細---支払期日
                try
	                if CheckFieldOnReport(pIndex,sField_Mankibi) then
                        Continue;
                Except

		            // 手形明細---金額
                    try
		                if CheckFieldOnReport(pIndex,sField_SiharaiKin) then
                            Continue;
                    Except
                        // 手形明細---支払場所
                        try
                            if CheckFieldOnReport(pIndex,sField_PayPlace) then
	                            Continue;
                        Except
                            iCount := i - 1;
                            Result := True;
                            Exit;
                        end;
                    end;
                end;
            end;
        except
        end;
	end;
end;

//**********************************************************************
//*		Proccess	:  控除明細行数取得
//*		Name		:  K.Ikemura
//*		Create		:  2001/12/14
//*		Parameter   :  iCount,pIndex
//*		Return		:  True : 行数取得　False : 行数取得エラー
//*		History		:  9999/99/99	X.Xxxx
//*									XXXXXXXXXXXXXXXXXX
//**********************************************************************
function TPay510100f.GetLineCount_KoujyoDetail(var iCount,
  pIndex: Integer): Boolean;
var
	i : Integer;

    //CoReportsフィールド
    sField_KoujyoKamoku	:	String;
    sField_KoujyoKin	:	String;
begin
    Result := False;
	iCount := 0;

    for	i := 1 to DETAILCOUNT do
    begin
        try
           	sField_KoujyoKamoku := Format( CORPNM_Koujyo 	+ 	'%-d', [i] );
           	sField_KoujyoKin 	:= Format( CORPNM_Fee		+	'%-d', [i] );

            // 控除内訳---項目名
            try
                if ((CheckFieldOnReport(pIndex,sField_KoujyoKamoku)) and
                    (CheckFieldOnReport(pIndex,sField_KoujyoKin))) then
					Continue;
            Except

                // 控除内訳---金額
                try
                    if CheckFieldOnReport(pIndex,sField_KoujyoKin) then
	                    Continue;
                Except
					iCount := i - 1;
                    Result := True;
					Exit;
                end;
            end;
        except
        end;
	end;
end;

//**********************************************************************
//*		Proccess	:  事業所内訳行数取得
//*		Name		:  K.Ikemura
//*		Create		:  2001/12/14
//*		Parameter   :  iCount,pIndex
//*		Return		:  True : 行数取得　False : 行数取得エラー
//*		History		:  9999/99/99	X.Xxxx
//*									XXXXXXXXXXXXXXXXXX
//**********************************************************************
function TPay510100f.GetLineCount_JigyoushoDetail(var iCount,
  pIndex: Integer): Boolean;
var
	i : Integer;

    //CoReportsフィールド
    sField_BumonName		:	String;
    sField_BumonSateiKin	:	String;
    sField_BumonSousaiKin	:	String;
begin
    Result := False;
	iCount := 0;

    for	i := 1 to DETAILCOUNT do
    begin
        try
            sField_BumonName		:= Format( CORPNM_BumonName		+	'%-d', [i] );
            sField_BumonSateiKin	:= Format( CORPNM_BumonSateiKin	+	'%-d', [i] );
            sField_BumonSousaiKin	:= Format( CORPNM_BumonSousaiKin+	'%-d', [i] );

            // 事業所内訳---項目名
            try
                if ((CheckFieldOnReport(pIndex,sField_BumonName)) and
                    (CheckFieldOnReport(pIndex,sField_BumonSateiKin)) and
                    (CheckFieldOnReport(pIndex,sField_BumonSousaiKin))) then
                    Continue;
            Except
                // 事業所内訳---支払金額
                try
                    if CheckFieldOnReport(pIndex,sField_BumonSateiKin) then
                        Continue;
                Except
                    // 事業所内訳---相殺金額
                    try
                        if CheckFieldOnReport(pIndex,sField_BumonSousaiKin) then
	                        Continue;
                    Except
                    	iCount := i - 1;
                        Result := True;
                        Exit;
                    end;
                end;
            end;
        except
        end;
	end;
end;

//**********************************************************************
//*		Proccess	:  期日指定振込行数取得
//*		Name		:  K.Ikemura
//*		Create		:  2001/12/14
//*		Parameter   :  iCount,pIndex
//*		Return		:  True : 行数取得　False : 行数取得エラー
//*		History		:  9999/99/99	X.Xxxx
//*									XXXXXXXXXXXXXXXXXX
//**********************************************************************
function TPay510100f.GetLineCount_Kijitsu(var iCount,
  pIndex: Integer): Boolean;
var
	i : Integer;

    //CoReportsフィールド
    sField_Mankibi		:	String;
    sField_SiharaiKin	:	String;
    sField_TashaFee		:	String;
    sField_TKanriNo		:	String;
begin
    Result := False;
	iCount := 0;

    for	i := 1 to DETAILCOUNT do
    begin
        try
            sField_Mankibi		:=	Format( CORPNM_KijituMankibi	+	'%-d', [i] );
            sField_SiharaiKin	:=	Format( CORPNM_KijituShiharaiKin+	'%-d', [i] );
            sField_TashaFee		:=	Format( CORPNM_KijituTashaFee	+	'%-d', [i] );
            sField_TKanriNo		:=	Format( CORPNM_KanriNo			+	'%-d', [i] );

            // 期日指定振込残高---支払期日
            try
                if ((CheckFieldOnReport(pIndex,sField_Mankibi)) and
                    (CheckFieldOnReport(pIndex,sField_SiharaiKin)) and
                    (CheckFieldOnReport(pIndex,sField_TashaFee)) and
                    (CheckFieldOnReport(pIndex,sField_TKanriNo))) then
                    Continue;
            except
                // 期日指定振込残高---金額
                try
                    if CheckFieldOnReport(pIndex,sField_SiharaiKin) then
                        Continue;
                except
                    // 期日指定振込残高---手数料
                    try
                        if CheckFieldOnReport(pIndex,sField_TashaFee) then
	                        Continue;
                    except
                        // 期日指定振込残高---管理NO.
                        try
                            if CheckFieldOnReport(pIndex,sField_TKanriNo) then
	                        Continue;
                        except
                            iCount := i - 1;
                            Result := True;
	                        Exit;
                        end;
                    end;
                end;
            end;
        except
        end;
	end;
end;

//**********************************************************************
//*		Proccess	:  支払方法名取得処理
//*		Name		:  K.Ikemura
//*		Create		:  2002/02/08
//*		Parameter   :  支払種別
//*		Return		:  支払方法名
//*		History		:  9999/99/99	X.Xxxx
//*									XXXXXXXXXXXXXXXXXX
//**********************************************************************
// <#032> MOD-STR
//  function GetSyubetsu(iIdx:Integer):String;
function TPay510100f.GetSyubetsu(iIdx: Integer; bIsER:Boolean=False):String;
// <#032> MOD-END
begin
	Result := '';

// <#032> ADD-STR
    //電子債権の場合は強制的に「電子記録債権」
    if (bIsER) then
    begin
// <#036> MOD-STR
//    	Result := '電子記録債権';
    	Result := m_sNotice_PayName[6];
// <#036> MOD-END
	    Exit;
    end;
// <#032> ADD-END

	case iIdx of
    	0:		Exit;
// <#030> MOD-STR
//    	1:		Result := '振　込';
//    	2:		Result := '期日指定振込';
//    	3:		Result := '手　形';
//    	4:		Result := '小　切　手';
//    	5:		Result := '現　金';
        1..5:   Result := m_sNotice_PayName[iIdx];
// <#030> MOD-STR
    	6..9:	Result := '譲渡手形';	// 2006/07/21 <#006> Y.Naganuma Add
	    else	Exit;
    end;
end;

//**********************************************************************
//*		Proccess	:  預金種別取得処理
//*		Name		:  K.Ikemura
//*		Create		:  2002/02/08
//*		Parameter   :  預金種別区分
//*		Return		:  預金種別
//*		History		:  9999/99/99	X.Xxxx
//*									XXXXXXXXXXXXXXXXXX
//**********************************************************************
function TPay510100f.GetAccKbn(iIdx: Integer): String;
begin
	Result := '';

	case iIdx of
    	0:	Exit;
    	1:	Result := '普通';
    	2:	Result := '当座';
    	4:	Result := '貯蓄';
    	9:	Result := 'その他';
	    else Exit;
    end;
end;

//**********************************************************************
//*		Proccess	:  口座番号
//*		Name		:  K.Ikemura
//*		Create		:  2002/02/08
//*		Parameter   :  sNo
//*		Return		:
//*		History		:  9999/99/99	X.Xxxx
//*									XXXXXXXXXXXXXXXXXX
//**********************************************************************
function TPay510100f.GetAccNo(sNo: String):String;
var
	ino : Integer;
begin
	Result := '';

	//口座番号：前ゼロありの場合は出力しない
	if sNo <> '' then
    begin
    	ino := StrToIntDef(sNo,-1);
        if ino = -1 then
        	Result := sNo
        else
// <#014> MOD-STR
//			Result := Format('%.7d',[ino]);          //	該当口座番号
        begin
            if (Length(Trim(sNo)) < 7) then
			    Result	:= Format('%.7d',[ino])
            else
    			Result	:= sNo;
        end;
// <#014> MOD-END
    end;
end;

//**********************************************************************
//*		Proccess	:  手形分割枚数
//*		Name		:  K.Ikemura
//*		Create		:  2002/02/08
//*		Parameter   :  sNo
//*		Return		:
//*		History		:  9999/99/99	X.Xxxx
//*									XXXXXXXXXXXXXXXXXX
//**********************************************************************
function TPay510100f.GetBunkatusuu(iBunkatusuu : Integer): String;
begin
	if iBunkatusuu >= 0 then
    	Result := IntToStr(iBunkatusuu) + '枚'
    else
    	Result := '' + '枚'
end;

//**********************************************************************
//*		Proccess	:  基本レイアウト
//*		Name		:  K.Ikemura
//*		Create		:  2002/02/08
//*		Parameter   :  sNo
//*		Return		:
//*		History		:  9999/99/99	X.Xxxx
//*									XXXXXXXXXXXXXXXXXX
//**********************************************************************
function TPay510100f.GetBasicLayout: String;
begin
	case m_DlgParam.LayoutPtn of
    	0: Result := BASICLAYOUT1;
    	1: Result := BASICLAYOUT2;
    	2: Result := BASICLAYOUT3;
    	3: Result := BASICLAYOUT4;
    	4: Result := BASICLAYOUT5;
    	5: Result := BASICLAYOUT6;
    	6: Result := BASICLAYOUT7;
	    else Exit;
    end;
end;

//**********************************************************************
//*		Proccess	:  日付編集処理
//*		Name		:  K.Ikemura
//*		Create		:  2002/02/08
//*		Parameter   :  Integer
//*		Return		:
//*		History		:  9999/99/99	X.Xxxx
//*									XXXXXXXXXXXXXXXXXX
//**********************************************************************
function TPay510100f.SetFormatInt(pData: Integer): String;
var
	iDateValue : Longint;
	dtDateValue: TDateTime;	// 日付取得用
begin
	Result := '';

    if pData <= 0 then Exit;
	try
// <#DCH> DEL	MjsDateCtrl.MHokanFromDate := 0;    // 基準日（年度の開始日）なし

        iDateValue := MjsDateCtrl.MjsIntDateHokan8(pData);
        // TDateTime　←　Integer
		dtDateValue := MjsDateCtrl.MjsIntToDate(iDateValue, #0);
        if (m_DTMAIN.YearKbn = 0) then
            Result := FormatDateTime('e"/"m"/"d',dtDateValue)
        else// 西暦
            Result := FormatDateTime('yyyy"/"m"/"d',dtDateValue);
    except
    	Result := '';
    end;
end;

//**********************************************************************
//*		Proccess	:  日付編集処理
//*		Name		:  K.Ikemura
//*		Create		:  2002/02/08
//*		Parameter   :  TDateTime
//*		Return		:
//*		History		:  9999/99/99	X.Xxxx
//*									XXXXXXXXXXXXXXXXXX
//**********************************************************************
function TPay510100f.SetFormatHasseiDay(pData: TDateTime): String;
var
    Year, Month, Day : Word;
    sYear, sMonth, sDay : String;
begin
	Result := '';

	if DateTimeToStr(pData) = '' then
    	Exit;

    DecodeDate(pData, Year, Month, Day);

    if (m_DTMAIN.YearKbn = 0) then
    begin
		//	元号なし
       	sYear := FormatDateTime('e',pData);		// 和暦
	    sYear := Format('%2d',[StrToInt(sYear)]);
    end
    else
    begin
       	sYear := FormatDateTime('yyyy',pData);	// 西暦
	    sYear := Format('%4d',[StrToInt(sYear)]);
    end;

    sMonth := Format('%2d',[Month]);
    sDay := Format('%2d',[Day]);

   	Result := sYear + '.' + sMonth + '.' + sDay;
end;

//**********************************************************************
//*		Proccess	:  支払日編集処理
//*		Name		:  K.Ikemura
//*		Create		:  2002/02/08
//*		Parameter   :  Integer
//*					:  IsOn : 元号付加（True）
//*		Return		:
//*		History		:  9999/99/99	X.Xxxx
//*									XXXXXXXXXXXXXXXXXX
//**********************************************************************
function TPay510100f.SetFormatInt(pData: Integer;IsOn : Boolean): String;
var
	iDateValue : Longint;
	dtDateValue: TDateTime;	// 日付取得用

    sGGG	: String;
    sEE		: String;
    sYYYY 	: String;
    sMM		: String;
    sDD 	: String;
begin
	Result := '';

	try
// <#DCH> DEL	MjsDateCtrl.MHokanFromDate := 0;    // 基準日（年度の開始日）なし

        iDateValue := MjsDateCtrl.MjsIntDateHokan8(pData);
        // TDateTime　←　Integer
		dtDateValue := MjsDateCtrl.MjsIntToDate(iDateValue, #0);

		//  半角１９文字に統一
        sGGG 	:= FormatDateTime('ggg',dtDateValue);
        sEE  	:= FormatDateTime('ee',dtDateValue);
        sYYYY  	:= FormatDateTime('yyyy',dtDateValue);
        sMM  	:= FormatDateTime('mm',dtDateValue);
        sDD  	:= FormatDateTime('dd',dtDateValue);

        //接頭が０ならｽﾍﾟｰｽに設定
        if '0' = Copy(sEE,1,1) then  sEE := ' ' + Copy(sEE,2,1);//<#042>add
        if '0' = Copy(sMM,1,1) then  sMM := ' ' + Copy(sMM,2,1);
        if '0' = Copy(sDD,1,1) then  sDD := ' ' + Copy(sDD,2,1);

        if (m_DTMAIN.YearKbn = 0) then  // 和暦
		begin
			if IsOn then	//元号あり
			   	Result := sGGG + ' ' + sEE + '年 ' +  sMM + '月 ' + sDD + '日'
            else
			   	Result := sEE + '年 ' +  sMM + '月 ' + sDD + '日';
        end
        else							// 西暦
		   	Result := sYYYY + '年 ' +  sMM + '月 ' + sDD + '日';
    except
    	Result := '';
    end;
end;

//**********************************************************************
//*		Proccess	:  満期日編集処理
//*		Name		:  K.Ikemura
//*		Create		:  2002/02/08
//*		Parameter   :  Integer
//*					:
//*		Return		:
//*		History		:  9999/99/99	X.Xxxx
//*									XXXXXXXXXXXXXXXXXX
//**********************************************************************
function TPay510100f.SetFormatMankibi(pData: Integer): String;
var
	iDateValue : Longint;
	dtDateValue: TDateTime;	// 日付取得用

    sGGG	: String;
    sEE		: String;
    sYYYY 	: String;
    sMM		: String;
    sDD 	: String;
begin
	Result := '';

    if pData <= 0 then Exit;
	try
// <#DCH> DEL	MjsDateCtrl.MHokanFromDate := 0;

        iDateValue := MjsDateCtrl.MjsIntDateHokan8(pData);
		dtDateValue := MjsDateCtrl.MjsIntToDate(iDateValue, #0);

		//  半角１９文字に統一
        sGGG 	:= FormatDateTime('ggg',dtDateValue);
        sEE  	:= FormatDateTime('ee',dtDateValue);
        sYYYY  	:= FormatDateTime('yyyy',dtDateValue);
        sMM  	:= FormatDateTime('mm',dtDateValue);
        sDD  	:= FormatDateTime('dd',dtDateValue);

        //接頭が０ならｽﾍﾟｰｽに設定
        if '0' = Copy(sEE,1,1) then  sEE := ' ' + Copy(sEE,2,1);//<#042>add
        if '0' = Copy(sMM,1,1) then  sMM := ' ' + Copy(sMM,2,1);
        if '0' = Copy(sDD,1,1) then  sDD := ' ' + Copy(sDD,2,1);

        if (m_DTMAIN.YearKbn = 0) then  // 和暦
		   	Result := sGGG + ' ' + sEE + '年 ' +  sMM + '月 ' + sDD + '日'
        else							// 西暦
		   	Result := sYYYY + '年 ' +  sMM + '月 ' + sDD + '日';
    except
    	Result := '';
    end;
end;

//**************************************************************************
//  Proccess    :   初期処理
//  Name        :   K.IKEMURA
//  Date        :	2001/12/14
//  Parameter   :
//  Return      :	True or False
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPay510100f.Init: Boolean;
var
	Query : TMQuery;
begin
	Result := False;

    try
        Query := TMQuery.Create(Self);
        try
            m_DataModule.SetDBInfoToQuery(m_DBCorp, Query);

            //	会社情報
            if GetDTMAIN(Query) = False then Exit;

            //マスタ基本情報
            if GetMasterInfo(Query) = False then Exit;

            //区分情報
            if (GetKbnInfo(Query) = False) then Exit;

            //	集計モジュール
            m_Calc := TPay510100Calc.Create;
            if m_Calc.Init(Self, m_pRec, m_iFuncNo) = False then Exit;

        finally
        	Query.Close;
			Query.UnPrepare;	//2006/07/24 <#007> Y.Naganuma Add
            Query.Free;
        end;
    except
    	Exit;
    end;
	Result := True;
end;

//**************************************************************************
//  Component   :   Form
//  Event       :	OnCreate
//  Name        :   K.IKEMURA
//**************************************************************************
procedure TPay510100f.FormCreate(Sender: TObject);
var
	ComArea		: 	TMasCom;
    perms       :   TMASSetFXAccessType;      // 2006/01/25 H.Kawato <#004> Add
// <#030> ADD-STR
    iLoop       :   Integer;
    sRet        :   String;
// <#030> ADD-END
begin
// 2006/01/25 H.Kawato <#004> Add
    perms := getMasPerms(m_pRec,0);

    if (atPrint in perms) then
        m_bPriKengenFlag := True;
// 2006/01/25 H.Kawato <#004> Add

	Parent		:= TMPanel(m_pRec^.m_pOwnerPanel^);
	Align		:= alClient;

	ComArea	 := TMasCom(m_pRec^.m_pSystemArea^);

	MjsCompoColorSet(
					TPay510100f(Self),
					ComArea.SystemArea.SysBaseColorB,
					ComArea.SystemArea.SysBaseColorD
					);

	MjsColorChange(TPay510100f(Self),
				   ComArea.SystemArea.SysColorB,
				   ComArea.SystemArea.SysColorD,
				   ComArea.SystemArea.SysBaseColorB,
				   ComArea.SystemArea.SysBaseColorD,
				   rcCOMMONAREA(m_pRec^.m_pCommonArea^).SysFocusColor);

	MjsFontResize(TPay510100f(Self), Pointer(m_pRec));

	m_ACControl := PChild;

// <#030> ADD-STR
    // 内訳欄支払方法名称規定値
    m_sNotice_PayName[1] := '振　込';
    m_sNotice_PayName[2] := '期日指定振込';
    m_sNotice_PayName[3] := '手　形';
    m_sNotice_PayName[4] := '小　切　手';
    m_sNotice_PayName[5] := '現　金';
// <#036> ADD-STR
    m_sNotice_PayName[6] := '電子記録債権';
	TOTAL_PRICE		     :=	'※※　手形金額計　※※';
	TOTAL_ER_PRICE	     :=	'※※　電子記録債権金額計　※※';
// <#036> ADD-END

    // 内訳欄支払方法変更名称取得
	for iLoop := Low(m_sNotice_PayName) to High(m_sNotice_PayName) do
    begin
        sRet := GetPayCommonValue(Pointer(m_pRec), 'Shiharai', 'NOTICE_PAYNAME_' + IntToStr(iLoop));
        if (sRet <> '') then
            m_sNotice_PayName[iLoop] := sRet;
// <#036> ADD-STR
        if (iLoop = 3) and (sRet <> '') then
        	TOTAL_PRICE	    :=	'※※　' + sRet + '金額計　※※';
        if (iLoop = 6) and (sRet <> '') then
        	TOTAL_ER_PRICE	:=	'※※　' + sRet + '金額計　※※';
// <#036> ADD-END
    end;
// <#030> ADD-END
    m_MailPDFSave := StrToInt('0' + GetPayCommonValue(Pointer(m_pRec), 'Shiharai', 'MAIL_PDF_SAVE1'));  // <#039> ADD

	PostMessage(Handle, WM_DISPRUN, 0, 0);
end;

//**************************************************************************
//  Component   :   Form
//  Event       :	OnDestroy
//  Name        :   K.IKEMURA
//**************************************************************************
procedure TPay510100f.FormDestroy(Sender: TObject);
begin
	if m_Calc <> nil then
    	m_Calc.Free;

	if m_DBCorp <> nil then
    	m_DataModule.COPDBClose(m_DBCorp);

	if m_DBCtrl <> nil then
     	m_DataModule.CTLDBClose(m_DBCtrl);

	if m_Preview <> nil then
    	m_Preview.Term();

    //進捗区分チェック関係
    if m_cSystemCom <> nil then
    	m_cSystemCom.Free;

	if m_cExcluseive <> nil then
    begin
		m_cExcluseive.Term();
    	m_cExcluseive.Free;
    end;
end;
//**************************************************************************
//  Component   :   Form
//  Event       :	OnCloseQuery
//  Name        :   K.IKEMURA
//**************************************************************************
procedure TPay510100f.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
	MsgRec: TMjsMsgRec;
begin
	if m_Preview.IsPreView then
	begin
		TMASCom(m_pRec^.m_pSystemArea^).m_MsgStd.GetMsg(MsgRec,10040,2);
		MjsMessageBoxEx(Self, MsgRec.sMsg,MsgRec.sTitle,MsgRec.icontype,
						MsgRec.btntype,MsgRec.btndef,MsgRec.LogType);
		CanClose	:= False;
	end
	else
		CanClose	:= True;
end;

//**************************************************************************
//  Component   :   Form
//  Event       :	OnClose
//  Name        :   K.IKEMURA
//**************************************************************************
procedure TPay510100f.FormClose(Sender: TObject; var Action: TCloseAction);
var
	AppPrm	:	TAppParam;
begin
	Action				:=	caFree;
	m_pRec^.m_iDelete	:=	1;
	AppPrm.iAction		:=	ACTID_FORMCLOSEEND;			//	呼出区分設定
	AppPrm.pRecord		:=	Pointer(m_pRec);			//	管理構造体ﾎﾟｲﾝﾀ設定
	AppPrm.pActionParam	:=	nil;						//	予備ﾎﾟｲﾝﾀ設定
	TMjsAppRecord(m_pRec^).m_pOwnerEntry(@AppPrm);

	inherited;
end;
//**************************************************************************
//  Component   :   Form
//  Event       :	OnActivate
//  Name        :   K.IKEMURA
//**************************************************************************
procedure TPay510100f.FormActivate(Sender: TObject);
var
	AppPrm : TAppParam;
begin
	AppPrm.iAction		:=	ACTID_ACTIVEEND;
	AppPrm.pRecord		:=	Pointer(m_pRec);
	AppPrm.pActionParam	:=	nil;
	TMjsAppRecord(m_pRec^).m_pOwnerEntry(@AppPrm);
end;

//**************************************************************************
//  Component   :   Form
//  Event       :	OnShow
//  Name        :   K.IKEMURA
//**************************************************************************
procedure TPay510100f.FormShow(Sender: TObject);
begin
	//	ｷｬﾌﾟｼｮﾝをｾｯﾄ
	MasSetCaption(m_pRec);
	//	ｱｸｾﾗﾚｰﾀの不具合を回避する関数
	MJSBtnVisible (TPay510100f( Self ),TRUE);

	if	(m_Preview.IsPreView ()) then
		m_Preview.Show ()
	else
        m_ACControl.SetFocus;  //　初期カーソル設定
end;

//**************************************************************************
//  Component   :   Form
//  Event       :	OnHide
//  Name        :   K.IKEMURA
//**************************************************************************
procedure TPay510100f.FormHide(Sender: TObject);
begin
    MjsBtnVisible(TPay510100f(Self),FALSE);

	if	(m_Preview.IsPreView ()) then
		m_Preview.Hide ();
end;

//**************************************************************************
//  Component   :   BExit
//  Event       :	OnClick
//  Name        :   K.IKEMURA
//**************************************************************************
procedure TPay510100f.BExitClick(Sender: TObject);
begin
	Close();
end;

//**************************************************************************
//  Component   :   BChange
//  Event       :	OnClick
//  Name        :   K.IKEMURA
//**************************************************************************
procedure TPay510100f.BChangeClick(Sender: TObject);
var
	AppPrm	:	TAppParam;
begin
    // 切り出し
    if CompareStr((Sender as TMSpeedButton).Caption,'切出(&G)') = 0 then
    begin
        (Sender as TMSpeedButton).Caption := '埋込(&G)';

        ClientHeight := Trunc(622 * rcCOMMONAREA(m_pRec^.m_pCommonArea^).ZoomRatio / 100);
        ClientWidth := Trunc(945 * rcCOMMONAREA(m_pRec^.m_pCommonArea^).ZoomRatio / 100);

        AppPrm.iAction := ACTID_DOCKINGOUTEND;
    end
    // 埋め込み
    else
    begin
        (Sender as TMSpeedButton).Caption := '切出(&G)';
        AppPrm.iAction := ACTID_DOCKINGINEND;
    end;

    AppPrm.pRecord := Pointer(m_pRec);
    AppPrm.pActionParam := nil;
    TMjsAppRecord(m_pRec^).m_pOwnerEntry(@AppPrm);
end;

//**************************************************************************
//  Component   :   BJoken
//  Event       :	OnClick
//  Name        :   K.IKEMURA
//**************************************************************************
procedure TPay510100f.BJokenClick(Sender: TObject);
begin
	PrintCtl();
end;

//**************************************************************************
//  Proccess    :   CMChildKey手続き
//  Name        :   K.IKEMURA
//  Date        :	2001/12/14
//  Parameter   :	Msg
//  Return      :
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPay510100f.CMChildKey(var Msg: TWMKey);
begin
	case Msg.CharCode of
		VK_ESCAPE:
		begin
        	Close;
            Abort;
        end;
		VK_TAB:
        	Abort;
    end;
	inherited;
end;

//**************************************************************************
//  Proccess    :   WMDispRun手続き
//  Name        :   K.IKEMURA
//  Date        :	2001/12/14
//  Parameter   :	Msg
//  Return      :
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPay510100f.WMDispRun(var Msg: TMessage);
begin
// 2006/01/25 <#004> H.Kawato Add
	// 印刷権限が無い場合、メッセージを出力し処理を終了する
    if (not m_bPriKengenFlag) then
    begin
        MjsMessageBoxEx(Self, '現在ログインしている担当者には印刷権限がありません。' + #13#10 + '処理を終了します。',
			                '権限', mjInformation, mjOk, mjDefOk);
	    Self.Close;
		Exit;
    end;
// 2006/01/25 <#004> H.Kawato Add

    if m_bFirstERR then
    begin
	 	beep;
  		MjsMessageBoxEx(Self, m_sFirstMSG,m_pRec^.m_ProgramName,mjInformation,MjOk,MjDefOk);
        Close();
		Exit;
    end
    else					//正常
    	m_bFirstERR := False;

    //	進捗チェック & 排他チェック
    if not GetActionInfo then
    begin
//		Close();		// 2005/11/02 <#001> Y.Kabashima Del
        Exit;
    end;
    PrintCtl();
end;

//**************************************************************************
//  Proccess    :   条件画面呼出、集計、印刷処理
//  Name        :   K.IKEMURA
//  Date        :	2001/12/14
//  Parameter   :	Msg
//  Return      :
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPay510100f.PrintCtl();
begin
	if CallDlg = mrOk then
	begin
		//	集計処理
		if DoCalc() then
        begin
            try
			    CoReportsPrintObj  := MjsCoReportsPrint3.TMjsCoReportsPrint.Create;

// <#025> ADD-STR
                if (m_DlgParam.MailSend) then
                    //メール送信処理
                    DoSendMail()
                else
// <#025> ADD-END
                    //印刷処理
                    DoPrint();

			    CoReportsPrintObj.Free;
			except
              on E: Exception do Application.Messagebox(PChar(E.Message),'Message',MB_OK);  // <#025> ADD
			end;
        end;
		PrintCtl();
	end
    else
		Close();
end;

//**************************************************************************
//  Proccess    :   ダイアログ呼び出し処理
//  Name        :   K.IKEMURA
//  Date        :	2001/12/14
//  Parameter   :
//  Return      :	ModalResult
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPay510100f.CallDlg: Integer;
var
	Dlg : TPAY510100Dlgf;
begin
	Result := mrNone;

	Dlg := TPAY510100Dlgf.Create(Self);
// <#NGEN> ADD start
    MasSetFormDateIni(Dlg,m_DTMAIN.YearKbn);
// <#NGEN> ADD end

    try
		try
			Dlg.m_DTMAIN 			:= m_DTMAIN;
			Dlg.m_MasterInfo 		:= m_MasterInfo;
//2006/07/24 <#007> Y.Naganuma Add
			m_DlgParam.SystemCode	:= m_iSystemCode;
			m_DlgParam.FuncNo		:= m_iFuncNo;
//2006/07/24 <#007> Y.Naganuma Add
			m_DlgParam.DataNo		:= m_iDataNo;	//2006/07/21 <#006> Y.Naganuma Add

// <#025> ADD-STR
            // メール配信採用区分
//            m_DlgParam.MailUse      := CheckModuleLicense(m_pRec, 260020);  //MAS_STM
            m_DlgParam.MailUse      := CheckModuleLicense(m_pRec, 270020);  //MAS_STM
// <#025> ADD-END

            m_DlgParam.MailPDFSave := m_MailPDFSave;    // <#039> ADD

			Result := Dlg.DoDlg(m_pRec,
                                m_DataModule,
                                m_DBCorp,
                                m_DBCtrl,
                                m_DlgParam,
                                m_LayoutCtrl,
                                m_LayoutInfo);
		finally

			Dlg.Release;
        end;
    except
        Exit;
	end;
end;

//**************************************************************************
//  Proccess    :   Queryのエラー表示処理
//  Name        :   K.IKEMURA
//  Date        :	2001/12/14
//  Parameter   :	Query
//  Return      :
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPay510100f.ErrorMessageDsp(Query: TMQuery);
var
	MsgRec	: TMjsMsgRec;
begin
	TMASCom(m_pRec^.m_pSystemArea^).m_MsgStd.GetMsgDB(MsgRec, Query);
	with MsgRec do
    	MjsMessageBoxEx(Self, sMsg, sTitle, icontype ,btntype ,btndef, FALSE);
end;

//**************************************************************************
//  Proccess    :   該当データがありません
//  Name        :   K.IKEMURA
//  Date        :	2001/12/14
//  Parameter   :
//  Return      :
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPay510100f.CalcErrorDsp;
var
	MsgRec : TMjsMsgRec;
begin
	TMASCom(m_pRec^.m_pSystemArea^).m_MsgStd.GetMsg(MsgRec,40,3);
	with MsgRec do
		MjsMessageBoxEx(Self, sMsg, sTitle, icontype ,btntype ,btndef, FALSE);
end;

//**************************************************************************
//  Proccess    :   集計パラメータセット処理
//  Name        :   K.IKEMURA
//  Date        :	2001/12/14
//  Parameter   :	CalcParam	集計パラメータ(in->out)
//  Return      :
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPay510100f.SetParam(var CalcParam: TPayCalcParam);
var
	iOutputNo	:	Byte;
begin
	case m_DlgParam.Layout of
        0:		iOutputNo := m_DlgParam.LayoutPtn;
        1:		iOutputNo := 7;				//	手形送付案内
        2:		iOutputNo := 8;				//	書留郵便物受領証
        3:		iOutputNo := 9;				//	タックシール <#024> ADD
    	else	Exit;
    end;

	with CalcParam, m_DlgParam do
	begin
       	OutputNo	 :=	iOutputNo;			//	0:支払通知書（通常）
                                            //	1:支払通知書（送付）
                                            //	2:支払通知書（簡略）
                                            //	3:支払通知書（手形あり）
                                            //	4:支払通知書（手形なし）
                                            //	5:支払通知書（期日指定振込）
                                            //	6:支払通知書（名寄せ用）
                                            //	7:手形送付案内
                                            //	8:書留郵便物受領証
                                            //	9.タックシール <#024> ADD

// 2006/07/24 <#007> Y.Naganuma Mod
//		SystemCode		 :=	 0;				//	システムコード
//		FuncNo			 :=  0;				//	処理NO
		SystemCode		 :=	 m_iSystemCode;	//	システムコード
		FuncNo			 :=  m_iFuncNo;		//	処理NO
		DataNo			 :=	 m_iDataNo;		//	データNo
		PayDate			 :=	 m_iPayDate;	//	支払日
// 2006/07/24 <#007> Y.Naganuma Mod

        StHojyoCode		 :=  String(StrHojCd);		//	開始支払先コード
        EnHojyoCode		 :=  String(EndHojCd);		//	終了支払先コード
//2007/05/21 <#010> Y.Naganuma Add
        StRenso			 :=  String(StrRenso);		//	開始支払先連想
        EdRenso			 :=  String(EndRenso);		//	終了支払先連想
//2007/05/21 <#010> Y.Naganuma Add

        CalcParam.LetterKbn	:=	m_DlgParam.LetterKbn;			//	集金/送付
                                                                //  0:全て
	                    	                        			//  1:標準
    	            	                            			//  2:送付用
        	    	        			                        //  3:集金用
        CalcParam.YusouKbn	:=	m_DlgParam.YusouKbn;			//	手形郵送区分
        CalcParam.PayCond 	:=	m_DlgParam.PayCond;				//	支払条件

        CalcParam.PayWay[0] :=	m_DlgParam.PayWay[0];			//	支払方法1
        CalcParam.PayWay[1] :=	m_DlgParam.PayWay[1];			//	支払方法2
        CalcParam.PayWay[2] :=	m_DlgParam.PayWay[2];			//	支払方法3

        CalcParam.PayWayIndex[0] :=	m_DlgParam.PayWayIndex[0];	//	支払方法1（コンボボックスのインデックス格納用）
        CalcParam.PayWayIndex[1] :=	m_DlgParam.PayWayIndex[1];	//	支払方法2（コンボボックスのインデックス格納用）
        CalcParam.PayWayIndex[2] :=	m_DlgParam.PayWayIndex[2];	//	支払方法3（コンボボックスのインデックス格納用）

        BaseInfo2214    :=   m_LayoutCtrl.KanriNoUseKbn[0];	   	//管理NO.採用区分
        BaseInfo2301    :=   m_LayoutCtrl.KanriNoUseKbn[1];
        BaseInfo2401    :=   m_LayoutCtrl.KanriNoUseKbn[2];

        BaseInfo2621    :=   m_LayoutCtrl.GensenSaiyoKbn;		//預かり源泉税採用区分 <#011> Add
// <#021> Add Start
		KojName[0]		:=	m_LayoutCtrl.KojName[0];			//工事業控除1名称
		KojName[1]		:=	m_LayoutCtrl.KojName[1];			//工事業控除2名称
		KojName[2]		:=	m_LayoutCtrl.KojName[2];			//工事業控除3名称
// <#021> Add End


        BaseInfo4012    :=   m_LayoutCtrl.NamePrintKbn;			//受取人印刷区分
//2007/05/21 <#010> Y.Naganuma Add
	    BaseInfo4021    :=   m_LayoutCtrl.PrjSaiyoKbn;			//プロジェクト別支払採用区分
    	BaseInfo4022    :=   m_LayoutCtrl.PrjKbn;				//プロジェクト区分
	    BaseInfo4023    :=   m_LayoutCtrl.PjsSaiyoKbn;			//プロジェクトサブ別支払採用区分
//2007/05/21 <#010> Y.Naganuma Add
        BaseInfo6002    :=   m_LayoutCtrl.Koujokouprintkbn;		//控除項目印刷区分
        BaseInfo6003    :=   m_LayoutCtrl.Tekioutkbn;			//摘要欄出力区分
        BaseInfo6004	:=   m_LayoutCtrl.Tekipayprintkbn;		//摘要欄の支払先名印刷区分
        BaseInfo6005	:=   m_LayoutCtrl.Tashatskoujokbn;		//他社負担手数料控除区分

        CalcParam.Order		:= m_DlgParam.Order;				//連想順
		CalcParam.BilRendoNo:= m_DlgParam.BilRendoNo;			//手形連動No 2006/07/21 <#006> Y.Naganuma Add
// 2006/07/24 <#007> Y.Naganuma Add
		CalcParam.SystemCode:= m_iSystemCode;					//システムコード
		CalcParam.FuncNo	:= m_iFuncNo;						//処理NO
		CalcParam.DataNo	:= m_iDataNo;						//データNo
		CalcParam.PayDate	:= m_iPayDate;						//支払日
// 2006/07/24 <#007> Y.Naganuma Add

        CalcParam.YusouFutan:=	m_DlgParam.YusouFutan;			//手形郵送料負担区分 <#022> ADD

        CalcParam.MailSend	:=	m_DlgParam.MailSend;			//メール区分 <#025> ADD
	end;
end;

//**************************************************************************
//  Proccess    :	ﾊﾟﾗﾒｰﾀ構造体ｸﾘｱ処理
//  Name        :   A.Takara(RIT)
//  Create      :	2001/12/14
//  Parameter   :	pParam	集計パラメータ構造体
//  Return      :	なし
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPay510100f.ParamClear(pParam: PPayCalcParam);
begin
	with pParam^ do
	begin
        PayDate		:= 0;
       	OutputNo	:= 0;
        SystemCode	:= 0;
        FuncNo		:= 0;
        StHojyoCode := '';
        EnHojyoCode	:= '';
//2007/05/21 <#010> Y.Naganuma Add
        StRenso		:= '';					// 開始支払先連想
        EdRenso		:= '';					// 終了支払先連想
//2007/05/21 <#010> Y.Naganuma Add

        LetterKbn	:= 0;
        YusouKbn	:= 2;
        PayCond		:= 0;

       	PayWay[0]	:= 0;
       	PayWay[1]	:= 0;
       	PayWay[2]	:= 0;

       	PayWayIndex[0]	:= 0;
       	PayWayIndex[1]	:= 0;
       	PayWayIndex[2]	:= 0;

        BaseInfo2214    := 0;
        BaseInfo2301    := 0;
	    BaseInfo2401    := 0;
	    BaseInfo2621    := 0;               // <#011> Add
//<#021> Add Start
		KojName[0]		:= '';
		KojName[1]		:= '';
		KojName[2]		:= '';
//<#021> Add End
//2007/05/21 <#010> Y.Naganuma Add
	    BaseInfo4021    := 0;               // プロジェクト別支払採用区分
    	BaseInfo4022    := 0;				// プロジェクト区分
	    BaseInfo4023    := 0;			    // プロジェクトサブ別支払採用区分
//2007/05/21 <#010> Y.Naganuma Add
        BaseInfo6002    := 0;
        BaseInfo6003    := 0;
        BaseInfo6004	:= 0;
        BaseInfo6005	:= 0;

        ErrQuery	:= nil;

        MailSend        := False;           // メール区分 <#025> ADD
	end;
end;

//**************************************************************************
//  Proccess    :   集計処理
//  Name        :   A.TAKARA
//  Date        :	2001/12/14
//  Parameter   :
//  Return      :	MemData
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPay510100f.DoCalc(): Boolean;
begin
	Result := False;

    m_iCurrTegKbn := 0;             // <#032> ADD

    ParamClear(@CalcParam);

    SetParam(CalcParam);

    MemDataInit;
    SetMemData;

    if not m_Calc.GetPayData(Self, @CalcParam) then
    begin
		CalcErrorDsp;
        Exit;
    end;

	Result := True;
end;

//**************************************************************************
//  Proccess    :   MemDataセット
//  Name        :   A.Takara(RIT)
//  Date        :	2001/12/05
//  Parameter   :
//  Return      :
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPay510100f.SetMemData;
begin
    with m_Calc do
    begin
    	DMemCSInfo			:= DMem_CSInfo;
        DMemPayPlanData		:= DMem_PayPlanData;
        DMemUchiwake 		:= DMem_Uchiwake;	// 内訳
        DMemDedUchiwake		:= DMem_Koujyo;		// 控除内訳
        DMemDetail			:= DMem_Tori;		// 取引明細
        DMemNoteDetail		:= DMem_Teg;		// 手形明細
        DMemBmnDetail		:= DMem_Jigyousho;	// 事業所内訳
        DMemKijituDetail	:= DMem_Kijitsu;	// 期日振込残高
        DMemMailDetail		:= DMem_Kakitome;	// 書留郵便物受領証
    end;
end;

//**************************************************************************
//  Proccess    :   MemData初期化
//  Name        :   A.Takara(RIT)
//  Date        :	2001/12/05
//  Parameter   :
//  Return      :
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPay510100f.MemDataInit;
	procedure SetInit(MemData:TdxMemData);
    begin
        with MemData do
        begin
            Close;
            Open;
            SortedField := '';
            SortOptions := [];
        end;
    end;
begin
	SetInit(DMem_CSInfo);
	SetInit(DMem_PayPlanData);
	SetInit(DMem_Uchiwake);
	SetInit(DMem_Koujyo);
	SetInit(DMem_Tori);
	SetInit(DMem_Teg);
	SetInit(DMem_Jigyousho);
	SetInit(DMem_Kijitsu);
	SetInit(DMem_Kakitome);
end;

//**************************************************************************
//  Proccess    :   頁設定
//  Name        :   K.IKEMURA
//  Date        :	2001/02/06
//  Parameter   :
//  Return      :
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPay510100f.SetPageCnt(CoData: TMjsCoReportsData);
var
    pIndex : Integer;
	sPageCnt : String;
begin
	pIndex := CoData.FormIndex;
    try
        if CheckFieldOnReport(pIndex, CORPNM_Page) then
        begin
            Inc(iPageCnt);

            sPageCnt := IntToStr(iPageCnt);

            CoData.AddData(CORPNM_Page ,sPageCnt + 'ページ');
        end;
    Except
    end;
end;

//**************************************************************************
//	Proccess  :	PayPlanData(支払先レコード検索処理)
//	Name	  :	K.Ikemura
//	Date	  :	2001/12/14
//	Parameter : pIndex (標準レイアウトのFormIdx)
//	Retrun	  :
//	History	　:	9999/99/99
//**************************************************************************
function TPay510100f.FindPayPlan(pGcode: String):Boolean;
begin
   	Result := False;
	with DMem_PayPlanData do
    begin
    	First;
        while (Eof <> True) do
        begin
// <#023> MOD-STR
//			if FieldByName('GCode').AsString = pGcode then
			if (FieldByName('GCode').AsString = pGcode) and
               (FieldByName('SpotInfoNo').AsString = DMem_CSInfo.FieldByName('SpotInfoNo').AsString) then
// <#023> MOD-END
            begin
            	Result := True;
            	Exit;
            end;
        	Next;
        end;
    end;
end;

//**************************************************************************
//	Proccess  :	PayPlanData(支払先レコード検索処理)
//	Name	  :	K.Ikemura
//	Date	  :	2001/12/14
//	Parameter : pIndex (標準レイアウトのFormIdx)
//	Retrun	  :
//	History	　:	9999/99/99
//**************************************************************************
function TPay510100f.NextPayPlan(pGcode: String):Boolean;
begin
   	Result := False;
	with DMem_PayPlanData do
    begin
        Next;

        while (Eof <> True) do
        begin
// <#023> MOD-STR
//			if FieldByName('GCode').AsString = pGcode then
			if (FieldByName('GCode').AsString = pGcode) and
               (FieldByName('SpotInfoNo').AsString = DMem_CSInfo.FieldByName('SpotInfoNo').AsString) then
// <#023> MOD-END
            begin
            	Result := True;
            	Exit;
            end;
        	Next;
        end;
    end;
end;

//**************************************************************************
//	Proccess  :	取引明細(支払先レコード検索処理)
//	Name	  :	K.Ikemura
//	Date	  :	2001/12/14
//	Parameter : pIndex (標準レイアウトのFormIdx)
//	Retrun	  :
//	History	　:	9999/99/99
//**************************************************************************
function TPay510100f.FindTori(pGcode: String): Boolean;
begin
   	Result := False;
	with DMem_Tori do
    begin
    	First;
        while (Eof <> True) do
        begin
// <#023> MOD-STR
//			if FieldByName('GCode').AsString = pGcode then
			if (FieldByName('GCode').AsString = pGcode) and
               (FieldByName('SpotInfoNo').AsString = DMem_CSInfo.FieldByName('SpotInfoNo').AsString) then
// <#023> MOD-END
            begin
            	Result := True;
            	Exit;
            end;
        	Next;
        end;
    end;
end;

//**************************************************************************
//	Proccess  :	取引明細(支払先レコード検索処理)
//	Name	  :	K.Ikemura
//	Date	  :	2001/12/14
//	Parameter : pIndex (標準レイアウトのFormIdx)
//	Retrun	  :
//	History	　:	9999/99/99
//**************************************************************************
function TPay510100f.NextTori(pGcode: String): Boolean;
begin
   	Result := False;
	with DMem_Tori do
    begin
        Next;

        while (Eof <> True) do
        begin
// <#023> MOD-STR
//			if FieldByName('GCode').AsString = pGcode then
			if (FieldByName('GCode').AsString = pGcode) and
               (FieldByName('SpotInfoNo').AsString = DMem_CSInfo.FieldByName('SpotInfoNo').AsString) then
// <#023> MOD-END
            begin
            	Result := True;
            	Exit;
            end;
        	Next;
        end;
    end;
end;

//**************************************************************************
//	Proccess  :	控除明細(支払先レコード検索処理)
//	Name	  :	K.Ikemura
//	Date	  :	2001/12/14
//	Parameter : pIndex (標準レイアウトのFormIdx)
//	Retrun	  :
//	History	　:	9999/99/99
//**************************************************************************
function TPay510100f.FindKoujyo(pGcode: String): Boolean;
begin
   	Result := False;
	with DMem_Koujyo do
    begin
    	First;
        while (Eof <> True) do
        begin
// <#023> MOD-STR
//			if FieldByName('GCode').AsString = pGcode then
			if (FieldByName('GCode').AsString = pGcode) and
               (FieldByName('SpotInfoNo').AsString = DMem_CSInfo.FieldByName('SpotInfoNo').AsString) then
// <#023> MOD-END
            begin
            	Result := True;
            	Exit;
            end;
        	Next;
        end;
    end;
end;

//**************************************************************************
//	Proccess  :	控除明細(支払先レコード検索処理)
//	Name	  :	K.Ikemura
//	Date	  :	2001/12/14
//	Parameter : pIndex (標準レイアウトのFormIdx)
//	Retrun	  :
//	History	　:	9999/99/99
//**************************************************************************
function TPay510100f.NextKoujyo(pGcode: String): Boolean;
begin
   	Result := False;
	with DMem_Koujyo do
    begin
        Next;

        while (Eof <> True) do
        begin
// <#023> MOD-STR
//			if FieldByName('GCode').AsString = pGcode then
			if (FieldByName('GCode').AsString = pGcode) and
               (FieldByName('SpotInfoNo').AsString = DMem_CSInfo.FieldByName('SpotInfoNo').AsString) then
// <#023> MOD-END
            begin
            	Result := True;
            	Exit;
            end;
        	Next;
        end;
    end;
end;

//**************************************************************************
//	Proccess  :	事業所明細(支払先レコード検索処理)
//	Name	  :	K.Ikemura
//	Date	  :	2001/12/14
//	Parameter : pIndex (標準レイアウトのFormIdx)
//	Retrun	  :
//	History	　:	9999/99/99
//**************************************************************************
function TPay510100f.FindJigyo(pGcode: String): Boolean;
begin
   	Result := False;

	with DMem_Jigyousho do
    begin
    	First;
        while (Eof <> True) do
        begin
// <#023> MOD-STR
//			if FieldByName('GCode').AsString = pGcode then
			if (FieldByName('GCode').AsString = pGcode) and
               (FieldByName('SpotInfoNo').AsString = DMem_CSInfo.FieldByName('SpotInfoNo').AsString) then
// <#023> MOD-END
            begin
            	Result := True;
            	Exit;
            end;
        	Next;
        end;
    end;
end;

//**************************************************************************
//	Proccess  :	事業所明細(支払先レコード検索処理)
//	Name	  :	K.Ikemura
//	Date	  :	2001/12/14
//	Parameter : pIndex (標準レイアウトのFormIdx)
//	Retrun	  :
//	History	　:	9999/99/99
//**************************************************************************
function TPay510100f.NextJigyo(pGcode: String): Boolean;
begin
   	Result := False;
	with DMem_Jigyousho do
    begin
        Next;

        while (Eof <> True) do
        begin
// <#023> MOD-STR
//			if FieldByName('GCode').AsString = pGcode then
			if (FieldByName('GCode').AsString = pGcode) and
               (FieldByName('SpotInfoNo').AsString = DMem_CSInfo.FieldByName('SpotInfoNo').AsString) then
// <#023> MOD-END
            begin
            	Result := True;
            	Exit;
            end;
        	Next;
        end;
    end;
end;

//**************************************************************************
//	Proccess  :	期日指定振込内訳(支払先レコード検索処理)
//	Name	  :	K.Ikemura
//	Date	  :	2001/12/14
//	Parameter : pIndex (標準レイアウトのFormIdx)
//	Retrun	  :
//	History	　:	9999/99/99
//**************************************************************************
function TPay510100f.FindKijitsu(pGcode: String): Boolean;
begin
   	Result := False;
	with DMem_Kijitsu do
    begin
    	First;
        while (Eof <> True) do
        begin
			if FieldByName('GCode').AsString = pGcode then
            begin
            	Result := True;
            	Exit;
            end;
        	Next;
        end;
    end;
end;

//**************************************************************************
//	Proccess  :	期日指定振込内訳(支払先レコード検索処理)
//	Name	  :	K.Ikemura
//	Date	  :	2001/12/14
//	Parameter : pIndex (標準レイアウトのFormIdx)
//	Retrun	  :
//	History	　:	9999/99/99
//**************************************************************************
function TPay510100f.NextKijitsu(pGcode: String): Boolean;
begin
   	Result := False;
	with DMem_Kijitsu do
    begin
        Next;

        while (Eof <> True) do
        begin
			if FieldByName('GCode').AsString = pGcode then
            begin
            	Result := True;
            	Exit;
            end;
        	Next;
        end;
    end;
end;

//**************************************************************************
//  Proccess    :   支払情報設定
//  Name        :   K.IKEMURA
//  Date        :	2001/02/06
//  Parameter   :
//  Return      :
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPay510100f.SetData_PayPrice(pIndex: Integer);
var
    sZenkaiKin	 	: 	String;
    sToukaiKin	 	: 	String;
    sSateiKin 		: 	String;
    sJikaiKin 		: 	String;			// 2005/11/24 <#002> Y.Kabashima Add
    sKoujyoKin 		: 	String;
    sPayPrice 		: 	String;
    sSousaiKin		:	String;

	//CoReportsで設定されている枠ｻｲｽﾞより文字数が超える場合,長体をかける
	FieldIndex 		: Integer;
begin
	with DMem_PayPlanData do
    begin
		if RecordCount = 0 then Exit;

		FindPayPlan(DMem_CSInfo.FieldByName('GCode').AsString);
        while Eof <> True do
        begin
            sZenkaiKin	 := Edit_Kingaku(FieldByName('ZenkaiKin').AsCurrency);
            sToukaiKin	 := Edit_Kingaku(FieldByName('ToukaiKin').AsCurrency);
            sSateiKin	 := Edit_Kingaku(FieldByName('SateiKin').AsCurrency);
            sJikaiKin	 := Edit_Kingaku(FieldByName('JikaiKin').AsCurrency);				// 2005/11/24 <#002> Y.KabashimaAdd
            sKoujyoKin	 := Edit_Kingaku(FieldByName('KoujyoKin').AsCurrency);
            sSousaiKin	 := Edit_Kingaku(FieldByName('SousaiKin').AsCurrency);
            sPayPrice	 := Edit_Kingaku(FieldByName('PayPrice').AsCurrency);

            // 支払金額---前回繰越額
            try
                if CheckFieldOnReport(pIndex, CORPNM_ZenkaiKin) then
                begin
                    FieldIndex := CoRepData.AddData(CORPNM_ZenkaiKin ,sZenkaiKin);
                    CoRep_FontRatio(CoRepData,FieldIndex);
                end;
            Except
            end;

            // 支払金額---当回取引額
            try
                if CheckFieldOnReport(pIndex, CORPNM_ToukaiKin) then
                begin
                    FieldIndex := CoRepData.AddData(CORPNM_ToukaiKin ,sToukaiKin);
                    CoRep_FontRatio(CoRepData,FieldIndex);
                end;
            Except
            end;

            // 支払金額---今回合計額
            try
                if CheckFieldOnReport(pIndex,CORPNM_SateiKin) then
                begin
                    FieldIndex := CoRepData.AddData(CORPNM_SateiKin ,sSateiKin);
                    CoRep_FontRatio(CoRepData,FieldIndex);
                end;
            Except
            end;

// 2005/11/24 <#002> Y.Kabashima Add ↓↓↓
            // 支払金額---次回繰越額
            try
                if CheckFieldOnReport(pIndex, CORPNM_JikaiKin) then
                begin
                    FieldIndex := CoRepData.AddData(CORPNM_JikaiKin ,sJikaiKin);
                    CoRep_FontRatio(CoRepData,FieldIndex);
                end;
            Except
            end;
// 2005/11/24 <#002> Y.Kabashima Add ↑↑↑

            // 支払金額---控除金額
            try
                if CheckFieldOnReport(pIndex,CORPNM_KoujyoKin) then
                begin
                    FieldIndex := CoRepData.AddData(CORPNM_KoujyoKin ,sKoujyoKin);
                    CoRep_FontRatio(CoRepData,FieldIndex);
                end;
            Except
            end;

            // 支払金額---相殺金額
            try
                if CheckFieldOnReport(pIndex,CORPNM_SousaiKin) then
                begin
                    FieldIndex := CoRepData.AddData(CORPNM_SousaiKin ,sSousaiKin);
                    CoRep_FontRatio(CoRepData,FieldIndex);
                end;
            Except
            end;
            // 今回支払額
            try
                if CheckFieldOnReport(pIndex,CORPNM_PayPrice) then
                begin
                    FieldIndex := CoRepData.AddData(CORPNM_PayPrice ,sPayPrice);
                    CoRep_FontRatio(CoRepData,FieldIndex);
                end;
            Except
            end;

			//次データ
			NextPayPlan(DMem_CSInfo.FieldByName('GCode').AsString);
        end;
	end;
end;

//**************************************************************************
//  Proccess    :   会社基本情報設定
//  Name        :   K.IKEMURA
//  Date        :	2001/02/06
//  Parameter   :
//  Return      :
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPay510100f.SetData_DTMAIN(CoData: TMjsCoReportsData);
var
    sPrtDate        	:   String;             // 印刷年月日
	FieldIndex			: Integer;
    pIndex				: integer;

    sGGG	: String;
    sEE		: String;
    sYYYY 	: String;
    sMM		: String;
    sDD 	: String;

	iCount				:	Integer;
	sField_PrtDate		:	String;
	sField_ZipCode		:	String;
	sField_Adress1		:	String;
	sField_Adress2		:	String;
	sField_CompName		:	String;
	sField_TelNo		:	String;
	sField_JisyaBumon	:	String;
begin
	pIndex := CoData.FormIndex;
	with m_DTMAIN do
    begin
		//  半角１９文字に統一
        if Trim(m_DlgParam.PrnDate) = '' Then
		begin
            sPrtDate:= '';
        	sGGG 	:= '';
        	sEE  	:= '';
        	sYYYY  	:= '';
        	sMM  	:= '';
        	sDD  	:= '';
        end
        else
        begin
            //日付設定 画面印刷年月日
        	sGGG 	:= FormatDateTime('ggg',StrToDate(m_DlgParam.PrnDate));
        	sEE  	:= FormatDateTime('ee',StrToDate(m_DlgParam.PrnDate));
        	sYYYY  	:= FormatDateTime('yyyy',StrToDate(m_DlgParam.PrnDate));
        	sMM  	:= FormatDateTime('mm',StrToDate(m_DlgParam.PrnDate));
        	sDD  	:= FormatDateTime('dd',StrToDate(m_DlgParam.PrnDate));

        	//接頭が０ならｽﾍﾟｰｽに設定
        	if '0' = Copy(sEE,1,1) then  sEE := ' ' + Copy(sEE,2,1);//<#042>add
        	if '0' = Copy(sMM,1,1) then  sMM := ' ' + Copy(sMM,2,1);
        	if '0' = Copy(sDD,1,1) then  sDD := ' ' + Copy(sDD,2,1);

        	if (YearKbn = 0) then  // 和暦
			   	sPrtDate := sGGG + ' ' + sEE + '年 ' +  sMM + '月 ' + sDD + '日'
    	    else							// 西暦
			   	sPrtDate := sYYYY + '年 ' +  sMM + '月 ' + sDD + '日';
        end;

        //	送付日
        try
			iCount := 0;
			sField_PrtDate	:=	CORPNM_Souhubi;
	        while CheckFieldOnReport(pIndex,sField_PrtDate) do
			begin
				CoData.AddData(sField_PrtDate ,sPrtDate);
				Inc(iCount);
	            sField_PrtDate		:=	Format( CORPNM_Souhubi   + '%-d', [iCount] );
			end;
        Except
        end;

        // 自社郵便番号
        try
			iCount := 0;
			sField_ZipCode	:=	CORPNM_ZipCode;
	        while CheckFieldOnReport(pIndex,sField_ZipCode) do
			begin
				FieldIndex := CoData.AddData(sField_ZipCode ,String(ZipCode));				// 会社基本情報(m_DTMAIN)郵便番号(基番+枝番)
				CoRep_FontRatio(CoData,FieldIndex);
				Inc(iCount);
	            sField_ZipCode		:=	Format( CORPNM_ZipCode   + '%-d', [iCount] );
			end;
        Except
        end;

        // 自社住所(上段)
        try
			iCount := 0;
			sField_Adress1	:=	CORPNM_Adress1;
	        while CheckFieldOnReport(pIndex,sField_Adress1) do
			begin
				FieldIndex := CoData.AddData(sField_Adress1 ,Address1);				// 会社基本情報(m_DTMAIN)住所（上段）
				CoRep_FontRatio(CoData,FieldIndex);
				Inc(iCount);
	            sField_Adress1		:=	Format( CORPNM_Adress1   + '%-d', [iCount] );
			end;
        Except
        end;

        // 自社住所(下段)
        try
			iCount := 0;
			sField_Adress2	:=	CORPNM_Adress2;
	        while CheckFieldOnReport(pIndex,sField_Adress2) do
			begin
				FieldIndex := CoData.AddData(sField_Adress2 ,Address2);				// 会社基本情報(m_DTMAIN)住所（下段）
				CoRep_FontRatio(CoData,FieldIndex);
				Inc(iCount);
	            sField_Adress2		:=	Format( CORPNM_Adress2   + '%-d', [iCount] );
			end;
        Except
        end;

        // 自社名
        try
			iCount := 0;
			sField_CompName	:=	CORPNM_CompName;
	        while CheckFieldOnReport(pIndex,sField_CompName) do
			begin
				FieldIndex := CoData.AddData(sField_CompName ,SComName);			// 会社基本情報(m_DTMAIN)正式会社名
				CoRep_FontRatio(CoData,FieldIndex);
				Inc(iCount);
	            sField_CompName		:=	Format( CORPNM_CompName   + '%-d', [iCount] );
			end;
        Except
        end;

        // 自社電話番号
        try
			iCount := 0;
			sField_TelNo	:=	CORPNM_TelNo;
	        while CheckFieldOnReport(pIndex,sField_TelNo) do
			begin
				CoData.AddData(sField_TelNo ,TelNo);				// 会社基本情報(m_DTMAIN)電話番号
				Inc(iCount);
	            sField_TelNo		:=	Format( CORPNM_TelNo   + '%-d', [iCount] );
			end;
        Except
        end;
	end;

     // 自社・部門名
    try
		iCount := 0;
        sField_JisyaBumon	:=	CORPNM_JisyaBumon;
        while CheckFieldOnReport(pIndex,sField_JisyaBumon) do
		begin
			FieldIndex := CoData.AddData(sField_JisyaBumon ,m_LayoutCtrl.Jishabushoname);
			CoRep_FontRatio(CoData,FieldIndex);
			Inc(iCount);
            sField_JisyaBumon		:=	Format( CORPNM_JisyaBumon   + '%-d', [iCount] );
		end;
     Except
     end;

    //	折り目区切り線
    SetFoldLine(CoData);

// <#025> ADD-STR
    // 文書エリアのセット(明細用)
    try
        if CheckFieldOnReport(pIndex,CORPNM_Lbl_Bunsho1) then
            CoData.AddData(CORPNM_Lbl_Bunsho1 ,m_LayoutInfo.Bunsho1);
    Except
    end;
    try
        if CheckFieldOnReport(pIndex,CORPNM_Lbl_Bunsho2) then
            CoData.AddData(CORPNM_Lbl_Bunsho2 ,m_LayoutInfo.Bunsho2);
    Except
    end;
    try
        if CheckFieldOnReport(pIndex,CORPNM_Lbl_Bunsho3) then
            CoData.AddData(CORPNM_Lbl_Bunsho3 ,m_LayoutInfo.Bunsho3);
    Except
    end;
// <#025> ADD-END
end;

//**************************************************************************
//  Proccess    :   Mem（支払先）にデータをセット
//  Name        :   K.IKEMURA
//  Date        :	2001/02/06
//  Parameter   :
//  Return      :
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPay510100f.SetData_CSInfo(CoData: TMjsCoReportsData);
var
	FieldIndex : Integer;
    pIndex : Integer;

    sPayDay 				: 	String;
    sGCode					:	String;
    sCSInfo         		:   TMasCSInfo;	// 取引先詳細ﾚｺｰﾄﾞ
	iZipCode1,iZipCode2		: Integer;
    sZipCode				:	String;
    sTitleName				:	String;
	iCount					:	Integer;
	sField_PayDay			:	String;
	sField_GCode			:	String;
	sField_PayZipCode		:	String;
	sField_PayAdress1		:	String;
	sField_PayAdress2		:	String;
	sField_PayLongName		:	String;
	sField_PaySectionName	:	String;
	sField_PersonName		:	String;
	sField_PayTelNo		    :	String;     // 支払先電話番号
begin
    pIndex := CoData.FormIndex;

	if DMem_CSInfo.RecordCount = 0 then Exit;

    with DMem_CSInfo do
    begin
        // お支払日
        sPayDay := SetFormatInt(FieldByName('PayDay').AsInteger,True);
// <#037> ADD-STR
        if (m_iTegSitKijun <> 0) and ((FieldByName('GCode').AsString = m_sTegataExistGCode) or FindTegata(FieldByName('GCode').AsString)) then
            sPayDay := SetFormatInt(m_iTegSitKijun, True);
// <#037> ADD-END
        try
			iCount := 0;
			sField_PayDay	:=	CORPNM_PayDay;
	        while CheckFieldOnReport(pIndex,sField_PayDay) do
			begin
				CoData.AddData(sField_PayDay ,sPayDay);
				Inc(iCount);
	            sField_PayDay		:=	Format( CORPNM_PayDay   + '%-d', [iCount] );
			end;
        Except
        end;

        // 得意先ｺｰﾄﾞ
        try
			iCount := 0;
			sField_GCode	:=	CORPNM_GCode;
	        while CheckFieldOnReport(pIndex,sField_GCode) do
			begin
				sGCode := Edit_Code(m_MasterInfo.CodeAttr,m_MasterInfo.CodeDigit,FieldByName('GCode').AsString,DISPLAY_TYPE);
				FieldIndex := CoData.AddData(sField_GCode ,sGCode);
				CoRep_TorihikiNo(CoData,FieldIndex);
				Inc(iCount);
	            sField_GCode		:=	Format( CORPNM_GCode   + '%-d', [iCount] );
			end;
        Except
        end;

        // 郵便番号
        iZipCode1 := FieldByName('ZipCode1').AsInteger;
        iZipCode2 := FieldByName('ZipCode2').AsInteger;
        if (iZipCode1 <> 0) then
        begin
            sZipCode := Format('%.3d', [iZipCode1]);
//            if (iZipCode2 <> 0) then          // <#041> del
                sZipCode := sZipCode + '-' + Format('%.4d', [iZipCode2]);
        end;
        try
			iCount := 0;
			sField_PayZipCode	:=	CORPNM_PayZipCode;
	        while CheckFieldOnReport(pIndex,sField_PayZipCode) do
			begin
				FieldIndex := CoData.AddData(sField_PayZipCode ,sZipCode);								// 取引先詳細情報(CSInfo)郵便番号(基番+枝番)
				CoRep_FontRatio(CoData,FieldIndex);
				Inc(iCount);
	            sField_PayZipCode		:=	Format( CORPNM_PayZipCode   + '%-d', [iCount] );
			end;
        Except
        end;

        // 住所(上段)
        try
			iCount := 0;
			sField_PayAdress1	:=	CORPNM_PayAdress1;
	        while CheckFieldOnReport(pIndex,sField_PayAdress1) do
			begin
				FieldIndex := CoData.AddData(sField_PayAdress1 ,FieldByName('Address1').AsString);				// 取引先詳細情報(CSInfo)住所（上段）
				CoRep_FontRatio(CoData,FieldIndex);
				Inc(iCount);
	            sField_PayAdress1		:=	Format( CORPNM_PayAdress1   + '%-d', [iCount] );
			end;
        Except
        end;

        // 住所(下段)
        try
			iCount := 0;
			sField_PayAdress2	:=	CORPNM_PayAdress2;
	        while CheckFieldOnReport(pIndex,sField_PayAdress2) do
			begin
				FieldIndex := CoData.AddData(sField_PayAdress2 ,FieldByName('Address2').AsString);				// 取引先詳細情報(CSInfo)住所（下段）
				CoRep_FontRatio(CoData,FieldIndex);
				Inc(iCount);
	            sField_PayAdress2		:=	Format( CORPNM_PayAdress2   + '%-d', [iCount] );
			end;
        Except
        end;

        // 支払先電話番号
        try
			iCount := 0;
			sField_PayTelNo	    :=	'支払先電話番号';
	        while CheckFieldOnReport(pIndex,sField_PayTelNo) do
			begin
				FieldIndex  := CoData.AddData(sField_PayTelNo ,FieldByName('TelNo').AsString);				// 取引先詳細情報(CSInfo)支払先電話番号
				CoRep_FontRatio(CoData,FieldIndex);
				Inc(iCount);
	            sField_PayTelNo		    :=	Format( '支払先電話番号'   + '%-d', [iCount] );
			end;
        Except
        end;

        // 取引先名称取得
        sCSInfo.LongName 	:= ShortString(DelSpace(FieldByName('LongName').AsString));
        // 部署名
        sCSInfo.SectionName := ShortString(FieldByName('SectionName').AsString);
        // 担当者
        sCSInfo.PersonName 	:= ShortString(FieldByName('PersonName').AsString);
        // 敬称
        sTitleName 		 	:= FieldByName('TitleName').AsString;

        if (trim(String(sCSInfo.LongName)) <> '') and (trim(String(sCSInfo.SectionName)) <> '') and (trim(String(sCSInfo.PersonName)) <> '') then
        begin
            try
            	sCSInfo.PersonName := ShortString(String(sCSInfo.PersonName) + '　' + sTitleName);
            Except
            end;
        end
        else if (trim(String(sCSInfo.LongName)) <> '') and (trim(String(sCSInfo.SectionName)) <> '') and (trim(String(sCSInfo.PersonName)) = '') then
        begin
            try
            	sCSInfo.SectionName := ShortString(String(sCSInfo.SectionName) + '　' + sTitleName);
            Except
            end;
        end
        else if (trim(String(sCSInfo.LongName)) <> '') and (trim(String(sCSInfo.SectionName)) = '') and (trim(String(sCSInfo.PersonName)) = '') then
        begin
            try
            	sCSInfo.LongName := ShortString(String(sCSInfo.LongName) + '　' + sTitleName);
            Except
            end;
        end
        else if (trim(String(sCSInfo.LongName)) <> '') and (trim(String(sCSInfo.SectionName)) = '') and (trim(String(sCSInfo.PersonName)) <> '') then
        begin
            try
            	sCSInfo.PersonName := ShortString(String(sCSInfo.PersonName) + '　' + sTitleName);
            Except
            end;
        end;

        // 取引先名称取得
        try
			iCount := 0;
			sField_PayLongName	:=	CORPNM_PayLongName;
	        while CheckFieldOnReport(pIndex,sField_PayLongName) do
			begin
				FieldIndex := CoData.AddData(sField_PayLongName ,String(sCSInfo.LongName));
				CoRep_FontRatio(CoData,FieldIndex);
				Inc(iCount);
	            sField_PayLongName		:=	Format( CORPNM_PayLongName   + '%-d', [iCount] );
			end;
        Except
        end;

        // 部署名
        try
			iCount := 0;
			sField_PaySectionName	:=	CORPNM_PaySectionName;
	        while CheckFieldOnReport(pIndex,sField_PaySectionName) do
			begin
				FieldIndex := CoData.AddData(sField_PaySectionName ,String(sCSInfo.SectionName));
				CoRep_FontRatio(CoData,FieldIndex);
				Inc(iCount);
	            sField_PaySectionName		:=	Format( CORPNM_PaySectionName   + '%-d', [iCount] );
			end;
        Except
        end;

        // 担当者
        try
			iCount := 0;
			sField_PersonName	:=	CORPNM_PayPersonName;
	        while CheckFieldOnReport(pIndex,sField_PersonName) do
			begin
				FieldIndex := CoData.AddData(sField_PersonName ,String(sCSInfo.PersonName));
				CoRep_FontRatio(CoData,FieldIndex);
				Inc(iCount);
	            sField_PersonName		:=	Format( CORPNM_PayPersonName   + '%-d', [iCount] );
			end;
        Except
        end;
    end;
end;

//**************************************************************************
//	Proccess  :	PayPlanData(支払先レコード検索処理)
//	Name	  :	K.Ikemura
//	Date	  :	2001/12/14
//	Parameter : pIndex (標準レイアウトのFormIdx)
//	Retrun	  :
//	History	　:	9999/99/99
//**************************************************************************
function TPay510100f.FindUchiwake(pGcode: String):Boolean;
begin
  	Result := False;
	with DMem_Uchiwake do
    begin
    	First;
        while (Eof <> True) do
        begin
// <#023> MOD-STR
//			if FieldByName('GCode').AsString = pGcode then
			if (FieldByName('GCode').AsString = pGcode) and
               (FieldByName('SpotInfoNo').AsString = DMem_CSInfo.FieldByName('SpotInfoNo').AsString) then
// <#023> MOD-END
            begin
            	Result := True;
            	Exit;
            end;
        	Next;
        end;
    end;
end;

//**************************************************************************
//	Proccess  :	PayPlanData(支払先レコード検索処理)
//	Name	  :	K.Ikemura
//	Date	  :	2001/12/14
//	Parameter : pIndex (標準レイアウトのFormIdx)
//	Retrun	  :
//	History	　:	9999/99/99
//**************************************************************************
function TPay510100f.NextUchiwake(pGcode: String):Boolean;
begin
   	Result := False;
	with DMem_Uchiwake do
    begin
        Next;

        while (Eof <> True) do
        begin
// <#023> MOD-STR
//			if FieldByName('GCode').AsString = pGcode then
			if (FieldByName('GCode').AsString = pGcode) and
               (FieldByName('SpotInfoNo').AsString = DMem_CSInfo.FieldByName('SpotInfoNo').AsString) then
// <#023> MOD-END
            begin
            	Result := True;
            	Exit;
            end;
        	Next;
        end;
    end;
end;

//**************************************************************************
//  Proccess    :   Mem（内訳）セット
//  Name        :   K.IKEMURA
//  Date        :	2001/02/06
//  Parameter   :
//  Return      :
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPay510100f.SetData_Uchiwake(pIndex: Integer);
var
	FieldIndex : Integer;
    i : Integer;

    sRecSyubetu 	: 	String;				//	支払方法（項目名）
    iRecSyubetu		:	Integer;            //	支払方法（index）

    sShiharaiKin 	: 	String;				//	金額

    sTashaFee		:	String;				//	手数料
    sTekiyou		:	String;				//	摘要（すべての情報をまとめたもの）
    sBankName 		: 	String;
    sBkBraName 		: 	String;

    sAccKbn 		: 	String;
    sAccNo 			: 	String;
    sMankibi 		: 	String;
	sPayDay			: 	String;				//	手形振出日
    sBunkatusuu 	: 	String;             //	手形枚数

    //CoReportsフィールド
	sField_KoumokName	:	String;
	sField_Kin		:	String;
	sField_TashaFee :	String;
	sField_Tekiyou	:	String;
	sField_AccNo	:	String;
	sField_TashaFeeYusouKin :	String;     // <#038> ADD

    sSite			:	String;
	sField_Site		:	String;
begin
    i := 0;

	with DMem_Uchiwake do
    begin
		if RecordCount = 0 then Exit;

		FindUchiwake(DMem_CSInfo.FieldByName('GCode').AsString);
        while Eof <> True do
        begin
            sTashaFee   := '';
            sTekiyou	:= '';
            sBankName	:= '';
            sBkBraName	:= '';
			sSite		:= '';
            sAccKbn		:= '';
            sAccNo		:= '';
            sMankibi	:= '';
            sPayDay		:= '';
            sBunkatusuu	:= '';

            Inc(i);

           	sField_KoumokName 	:= Format( CORPNM_KoumokName+	'%-d', [i] );
           	sField_Kin 			:= Format( CORPNM_Kin		+	'%-d', [i] );
           	sField_TashaFee 	:= Format( CORPNM_TashaFee	+	'%-d', [i] );
           	sField_Tekiyou 		:= Format( CORPNM_Tekiyou	+	'%-d', [i] );
           	sField_AccNo 		:= Format( CORPNM_AccNo		+	'%-d', [i] );
           	sField_Site 		:= Format( CORPNM_Site		+	'%-d', [i] );
	        sField_TashaFeeYusouKin := Format( CORPNM_TashaFeeYusouKin + '%-d', [i]);   // <#038> ADD

            // 内訳---項目名
            iRecSyubetu := FieldByName('RecSyubetu').AsInteger;
// <#032> MOD-STR
//          sRecSyubetu := GetSyubetsu(iRecSyubetu);
            sRecSyubetu := GetSyubetsu(iRecSyubetu, FieldByName('ERKbn').AsBoolean);
// <#032> MOD-END

            try
                if CheckFieldOnReport(pIndex,sField_KoumokName) then
                begin
                    FieldIndex := CoRepData.AddData(sField_KoumokName ,sRecSyubetu);
                    CoRep_FontRatio(CoRepData,FieldIndex);
                end;
            Except
            end;

            // 内訳---サイト
            try
    			if (FieldByName('Site').AsString <>  '') and
                   (StrToInt64Def(FieldByName('Site').AsString,-1) > 0) then
                begin
                	if CheckFieldOnReport(pIndex,sField_Site) then
                	begin
                    	sSite := FieldByName('Site').AsString + '日';
                    	FieldIndex := CoRepData.AddData(sField_Site ,sSite);
                    	CoRep_FontRatio(CoRepData,FieldIndex);
                	end;
                end;
            Except
            end;

            // 内訳---金額
            try
                if CheckFieldOnReport(pIndex,sField_Kin) then
                begin
                    sShiharaiKin := Edit_Kingaku(FieldByName('ShiharaiKin').AsCurrency);
                    FieldIndex := CoRepData.AddData(sField_Kin ,sShiharaiKin);
                    CoRep_FontRatio(CoRepData,FieldIndex);
                end;
            Except
            end;

            // 内訳---手数料
            try
				//他社手数料控除区分(0:控除する)　かつ 手数料負担区分(1:他社負担)
				if (CalcParam.BaseInfo6005 = 0) and (FieldByName('FeePayKbn').AsInteger = 1)then
               	begin
               		if CheckFieldOnReport(pIndex,sField_TashaFee) then
               		begin
                   		sTashaFee	:=	Edit_Kingaku(FieldByName('TashaFee').AsCurrency);
                   		FieldIndex	:=	CoRepData.AddData(sField_TashaFee ,sTashaFee);
                   		CoRep_FontRatio(CoRepData,FieldIndex);
               		end;
               	end;
            Except
            end;

// <#038> ADD-STR
            // 内訳---手数料/郵送料
            try
				//振込／期日(電債)の他社手数料控除区分(0:控除する)　かつ 手数料負担区分(1:他社負担)
				if ((FieldByName('RecSyubetu').AsInteger in [1, 2]) and (CalcParam.BaseInfo6005 = 0) and (FieldByName('FeePayKbn').AsInteger = 1)) or
				//手形／小切手の郵送区分(0:あり)　かつ郵送料負担区分(1:他社負担)
				   ((FieldByName('RecSyubetu').AsInteger in [3, 4]) and (FieldByName('TegYusouKbn').AsInteger = 0) and (FieldByName('TegYusouFutan').AsInteger = 1)) then
               	begin
               		if CheckFieldOnReport(pIndex,sField_TashaFeeYusouKin) then
               		begin
                   		sTashaFee	:=	Edit_Kingaku(FieldByName('TashaFee').AsCurrency);
                   		FieldIndex	:=	CoRepData.AddData(sField_TashaFeeYusouKin ,sTashaFee);
                   		CoRep_FontRatio(CoRepData,FieldIndex);
               		end;
               	end;
            Except
            end;
// <#038> ADD-END

            // 内訳---摘要
            case iRecSyubetu of
                1,2:	//---振込,期日指定振込---
                begin
                    sBankName 	:= FieldByName('BankName').AsString;
                    sBkBraName	:= FieldByName('BkBraName').AsString;
                    sTekiyou := sBankName;

                    if not ((trim(sBkBraName) = '') or (FieldByName('BkBraName').IsNull)) then
	                    sTekiyou := sTekiyou + '/' + sBkBraName;

                    sAccKbn := GetAccKbn(FieldByName('AccKbn').AsInteger);
                    sAccNo := GetAccNo(FieldByName('AccNo').AsString);

					if iRecSyubetu = 2 then
	                    sMankibi := SetFormatInt(FieldByName('Mankibi').AsInteger);

                    //	預金種別名称 + 口座番号 + 満期日　
                    sAccNo := sAccKbn + ' ' + sAccNo + ' ' + sMankibi;
                end;
                3,4://---手形、小切手---
                begin
                    sTekiyou := FieldByName('LongName').AsString;

					if iRecSyubetu = 3 then
                    begin
                        sPayDay := SetFormatInt(FieldByName('PayDay').AsInteger);
// <#037> ADD-STR
                        if (m_iTegSitKijun <> 0) then
                            sPayDay := SetFormatInt(m_iTegSitKijun);
// <#037> ADD-END
                        sBunkatusuu := GetBunkatusuu(FieldByName('Bunkatusuu').AsInteger);
                        //	手形振出日 + 手形枚数
                        sAccNo := sPayDay + ' ' + sBunkatusuu;
                    end;
                end;
                5:	//---現金---
                begin
                    sTekiyou := '';
                    sAccNo	 := '';
                end;
// 2006/07/21 <#006> Y.Naganuma Mod
//				else Exit;
				else
				begin
//					sTekiyou := FieldByName('LongName').AsString;

					sPayDay := SetFormatInt(FieldByName('PayDay').AsInteger);
					sBunkatusuu := GetBunkatusuu(FieldByName('Bunkatusuu').AsInteger);
					//	手形振出日 + 手形枚数
					sTekiyou := sPayDay + ' ' + sBunkatusuu;
                    sAccNo	 := '';
				end;
// 2006/07/21 <#006> Y.Naganuma Mod
            end;

            // 摘要
            try
                if CheckFieldOnReport(pIndex,sField_Tekiyou) then
                begin
                    FieldIndex := CoRepData.AddData(sField_Tekiyou ,sTekiyou);
                    CoRep_FontRatio(CoRepData,FieldIndex);
                end;
            Except
            end;

            // 口座番号他
            try
                if CheckFieldOnReport(pIndex,sField_AccNo) then
                begin
                    FieldIndex := CoRepData.AddData(sField_AccNo ,sAccNo);
                    CoRep_FontRatio(CoRepData,FieldIndex);
                end;
            Except
            end;

			NextUchiwake(DMem_CSInfo.FieldByName('GCode').AsString);
        end;
	end;
end;

//**************************************************************************
//  Proccess    :   Mem（控除）をセット
//  Name        :   K.IKEMURA
//  Date        :	2001/02/06
//  Parameter   :
//  Return      :
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPay510100f.SetData_Koujyo(pIndex: Integer):Boolean;
var
    i 			: 	Integer;
	FieldIndex 	: 	Integer;
    sKoujyoKamoku 	:	String;
    sKoujyoKin 	: 	String;

    //CoReportsフィールド
    sField_KoujyoKamoku	:	String;
    sField_KoujyoKin	:	String;

    iMaxRow		:	Integer;
    iRecNo	  	:   Integer;
begin
    Result := False;
    i := 0;
	//===========================================================
	// 既に一度件数チェックしているのであれば前回の内容から取得
	//===========================================================
	if ( bFirstFormMaxLineGetFlg[3] = False )then
    begin
		if (GetLineCount_KoujyoDetail(iMaxRow,pIndex) = True )then
        begin
        	bFirstFormMaxLineGetFlg[3] := True;
            iFirstFormMaxLine[3] := iMaxRow;
        end
        else
        	Exit;
    end
    else
    	iMaxRow := iFirstFormMaxLine[3];

	with DMem_Koujyo do
	begin
		if RecordCount <= 0 then Exit;

    	iRecNo	:=	RecNo;
		while Eof <> True do
		begin
			Inc(i);

			// 次回の支払先レコード検索
			NextKoujyo(DMem_CSInfo.FieldByName('GCode').AsString);
		end;
	    Edit;
    	RecNo := iRecNo;
	end;

	if i > iMaxRow then
	    Exit;

    i := 0;

	Result := True;

	with DMem_Koujyo do
	begin
		while Eof <> True do
		begin
			Inc(i);

			sKoujyoKamoku 		:= FieldByName('SimpleName').AsString;
			sKoujyoKin 			:= Edit_Kingaku(FieldByName('SousaiKin').AsCurrency);
			sField_KoujyoKamoku := Format( CORPNM_Koujyo+	'%-d', [i] );
			sField_KoujyoKin 	:= Format( CORPNM_Fee	+	'%-d', [i] );

			// 控除内訳---項目名
			try
				if CheckFieldOnReport(pIndex,sField_KoujyoKamoku) then
				begin
					FieldIndex := CoRepData.AddData(sField_KoujyoKamoku ,sKoujyoKamoku);
					CoRep_FontRatio(CoRepData,FieldIndex);
				end;
			Except
			end;

			// 控除内訳---金額
			try
				if CheckFieldOnReport(pIndex,sField_KoujyoKin) then
				begin
					FieldIndex := CoRepData.AddData(sField_KoujyoKin ,sKoujyoKin);
					CoRep_FontRatio(CoRepData,FieldIndex);
				end;
			Except
			end;

			// 次回の支払先レコード検索
			NextKoujyo(DMem_CSInfo.FieldByName('GCode').AsString);
		end;
	end;
end;

//**************************************************************************
//  Proccess    :   Mem（取引明細）をセット
//  Name        :   K.IKEMURA
//  Date        :	2001/02/06
//  Parameter   :   pIndex	: FormIndex
//				:	iCount	: 取引明細最大行数
//  Return      :   True	: 値をセット完了　
//					False	: 値があふれている場合
//
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPay510100f.SetData_ToriDetail(pIndex: Integer):Boolean;
var
	i : Integer;
	FieldIndex : Integer;
	iMaxRow : Integer;		//	取引明細行数

    sHasseDay	:	String;	//	発生日
    sTekiyo		:	String;	//	摘要
// <#012> 2008/03/26 T.Kawahata Add
    sNumValue1	:	String;	//	番号1
    sNumValue2	:	String;	//	番号2
// <#012> 2008/03/26 T.Kawahata Add
	sTHasseiKin	:	String;	//	金額
// <#033> ADD-STR
    sDKmkGCode          :	String;	//	相手科目コード
    sDKmkLongName       :	String;	//	相手科目正式名称
    sDBmnGCode          :	String;	//	相手部門コード
    sDBmnLongName       :	String;	//	相手部門正式名称
    sJigyoushoLongName  :	String;	//	事業所名
// <#033> ADD-END

    //CoReportsフィールド
    sField_HasseDay		:	String;
    sField_Tekiyo		:	String;
// <#012> 2008/03/26 T.Kawahata Add
    sField_NumValue1	:	String;
    sField_NumValue2	:	String;
// <#012> 2008/03/26 T.Kawahata Add
    sField_THasseiKin	:	String;
// <#033> ADD-STR
    sField_DKmkGCode          :	String;
    sField_DKmkLongName       :	String;
    sField_DBmnGCode          :	String;
    sField_DBmnLongName       :	String;
    sField_JigyoushoLongName  :	String;
// <#033> ADD-END

// <#012> 2008/03/26 T.Kawahata Add
    NumValue1Al	:	TAlignment;	//	番号1
    NumValue2Al	:	TAlignment;	//	番号2
// <#012> 2008/03/26 T.Kawahata Add
begin
     Result := False;

	//===========================================================
	// 既に一度件数チェックしているのであれば前回の内容から取得
	//===========================================================
	if ( bFirstFormMaxLineGetFlg[1] = False )then
    begin
		if (GetLineCount_ToriDetail(iMaxRow,pIndex) = True )then
        begin
        	bFirstFormMaxLineGetFlg[1] := True;
            iFirstFormMaxLine[1] := iMaxRow;
        end
        else
        	Exit;
    end
    else
    	iMaxRow := iFirstFormMaxLine[1];

	if DMem_Tori.RecordCount = 0 then Exit;

    i := 0;

	with DMem_Tori do
    begin
        while Eof <> True do
        begin
            Inc(i);

            if i = (iMaxRow + 1) then
				//	取引明細レイアウト
                Break;

			sHasseDay			:=	SetFormatHasseiDay(FieldByName( 'HasseiDay').AsDateTime);	//	発生日
			sTekiyo				:=	FieldByName( 'Tekiyou').AsString;							//	摘要
// <#012> 2008/03/26 T.Kawahata Add
            sNumValue1			:=	FieldByName('CNumValue1').AsString;	//	番号1
            sNumValue2			:=	FieldByName('CNumValue2').AsString;	//	番号2
            EditNumValue1(sNumValue1, NumValue1Al);						//	番号1
            EditNumValue2(sNumValue2, NumValue2Al);						//	番号2
// <#012> 2008/03/26 T.Kawahata Add
			sTHasseiKin			:=	Edit_Kingaku(FieldByName( 'THasseiKin').AsCurrency);		//	金額
// <#033> ADD-STR
            sDKmkGCode          :=	FieldByName('DKmkGCode').AsString;	        //	相手科目コード
            sDKmkLongName       :=	FieldByName('DKmkLongName').AsString;	    //	相手科目正式名称
            sDBmnGCode          :=	FieldByName('DBmnGCode').AsString;	        //	相手部門コード
            sDBmnGCode          :=  Edit_Code(m_BmnInfo.CodeAttr, m_BmnInfo.CodeDigit, sDBmnGCode, DISPLAY_TYPE);
            sDBmnLongName       :=	FieldByName('DBmnLongName').AsString;	    //	相手部門正式名称
            sJigyoushoLongName  :=	FieldByName('JigyoushoLongName').AsString;	//	事業所名
// <#033> ADD-END

			sField_HasseDay		:=	Format( CORPNM_HasseiDay 	+ '%-d', [i] );
			sField_Tekiyo		:=	Format( CORPNM_ToriTekiyou	+ '%-d', [i] );
// <#012> 2008/03/26 T.Kawahata Add
            sField_NumValue1	:=	Format( CORPNM_ToriNumValue1+ '%-d', [i] );	//	番号1
            sField_NumValue2	:=	Format( CORPNM_ToriNumValue2+ '%-d', [i] );	//	番号2
// <#012> 2008/03/26 T.Kawahata Add
			sField_THasseiKin	:=	Format( CORPNM_HasseiKin 	+ '%-d', [i] );
// <#033> ADD-STR
            sField_DKmkGCode          := Format( CORPNM_ToriKmkGCodeD 	+ '%-d', [i] );	    //	相手科目コード
            sField_DKmkLongName       := Format( CORPNM_ToriKmkLNameD 	+ '%-d', [i] );	    //	相手科目正式名称
            sField_DBmnGCode          := Format( CORPNM_ToriBmnGCodeD 	+ '%-d', [i] );	    //	相手部門コード
            sField_DBmnLongName       := Format( CORPNM_ToriBmnLNameD 	+ '%-d', [i] );	    //	相手部門正式名称
            sField_JigyoushoLongName  := Format( CORPNM_ToriJigyoushoLName 	+ '%-d', [i] );	//	事業所名
// <#033> ADD-END

			// 取引明細---発生日
			try
				if CheckFieldOnReport(pIndex,sField_HasseDay) then
				begin
					CoRepData.AddData(sField_HasseDay ,sHasseDay);
				end;
			Except
			end;

			// 取引明細---摘要
			try
				if CheckFieldOnReport(pIndex,sField_Tekiyo) then
				begin
					FieldIndex := CoRepData.AddData(sField_Tekiyo ,sTekiyo);
					CoRep_FontRatio(CoRepData,FieldIndex);
					CoRep_AlignLeft(CoRepData,FieldIndex);
				end;
			Except
            end;

// <#012> 2008/03/26 T.Kawahata Add
			// 取引明細---番号1
			try
				if CheckFieldOnReport(pIndex,sField_NumValue1) then
				begin
					FieldIndex := CoRepData.AddData(sField_NumValue1 ,sNumValue1);
					CoRep_FontRatio(CoRepData,FieldIndex);
                    if NumValue1Al = taLeftJustify then
						CoRep_AlignLeft(CoRepData,FieldIndex)
                    else
						CoRep_AlignRight(CoRepData,FieldIndex);
				end;
			Except
            end;

			// 取引明細---番号2
			try
				if CheckFieldOnReport(pIndex,sField_NumValue2) then
				begin
					FieldIndex := CoRepData.AddData(sField_NumValue2 ,sNumValue2);
					CoRep_FontRatio(CoRepData,FieldIndex);
                    if NumValue2Al = taLeftJustify then
						CoRep_AlignLeft(CoRepData,FieldIndex)
                    else
						CoRep_AlignRight(CoRepData,FieldIndex);
				end;
			Except
            end;
// <#012> 2008/03/26 T.Kawahata Add

            // 取引明細---金額
            try
                if CheckFieldOnReport(pIndex,sField_THasseiKin) then
                begin
                    FieldIndex := CoRepData.AddData(sField_THasseiKin ,sTHasseiKin);
                    CoRep_FontRatio(CoRepData,FieldIndex);
                end;
            Except
            end;

// <#033> ADD-STR
            // 取引明細---相手科目コード
            try
                if CheckFieldOnReport(pIndex,sField_DKmkGCode) then
                begin
                    FieldIndex := CoRepData.AddData(sField_DKmkGCode ,sDKmkGCode);
                    CoRep_FontRatio(CoRepData,FieldIndex);
                    CoRep_AlignRight(CoRepData,FieldIndex);
                end;
            Except
            end;

            // 取引明細---相手科目正式名称
            try
                if CheckFieldOnReport(pIndex,sField_DKmkLongName) then
                begin
                    FieldIndex := CoRepData.AddData(sField_DKmkLongName ,sDKmkLongName);
                    CoRep_FontRatio(CoRepData,FieldIndex);
					CoRep_AlignLeft(CoRepData,FieldIndex);
                end;
            Except
            end;

            // 取引明細---相手部門コード
            try
                if CheckFieldOnReport(pIndex,sField_DBmnGCode) then
                begin
                    FieldIndex := CoRepData.AddData(sField_DBmnGCode ,sDBmnGCode);
                    CoRep_FontRatio(CoRepData,FieldIndex);
                    if (m_BmnInfo.CodeAttr = ATTR_FREE) then
						CoRep_AlignLeft(CoRepData,FieldIndex)
                    else
						CoRep_AlignRight(CoRepData,FieldIndex);
                end;
            Except
            end;

            // 取引明細---相手部門正式名称
            try
                if CheckFieldOnReport(pIndex,sField_DBmnLongName) then
                begin
                    FieldIndex := CoRepData.AddData(sField_DBmnLongName ,sDBmnLongName);
                    CoRep_FontRatio(CoRepData,FieldIndex);
					CoRep_AlignLeft(CoRepData,FieldIndex);
                end;
            Except
            end;

            // 取引明細---事業所名
            try
                if CheckFieldOnReport(pIndex,sField_JigyoushoLongName) then
                begin
                    FieldIndex := CoRepData.AddData(sField_JigyoushoLongName ,sJigyoushoLongName);
                    CoRep_FontRatio(CoRepData,FieldIndex);
					CoRep_AlignLeft(CoRepData,FieldIndex);
                end;
            Except
            end;
// <#033> ADD-END

            // 次回の支払先レコード検索
			NextTori(DMem_CSInfo.FieldByName('GCode').AsString);
        end;

		{ 合計行出力 }
		//	レコード数=最大行数であれば次ページにて出力
		if (i < (iMaxRow)) and Eof then
		begin
	       	//	合計行設定
		    SetTotalLine(iMaxRow,i,ltToriDtl,CoRepData);
            Result := True;
        end;
	end;
end;

//**************************************************************************
//  Proccess    :   Mem（手形明細）をセット
//  Name        :   K.IKEMURA
//  Date        :	2001/02/06
//  Parameter   :
//  Return      :
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPay510100f.SetData_TegataDetail(pIndex: Integer):Boolean;
var
	iMaxRow : Integer;		//	手形明細行数
    i : Integer;
	FieldIndex : Integer;

    sBankSqNo	:	String;	//	手形NO.
    sMankibi	:	String;	//	支払期日
    sFridasibi	:	String;	//	振出日
    sSiharaiKin	:	String;	//	金額
    sPayPlace	:	String;	//	支払場所

    //CoReportsフィールド
    sField_BankSqNo		:	String;
    sField_Mankibi		:	String;
    sField_Fridasibi 	:	String;
    sField_SiharaiKin	:	String;
    sField_PayPlace		:	String;

    iRecNo		:	Integer;

// <#032> ADD-STR
    bJustInPage :   Boolean;
    iNext       :	Integer;
// <#032> ADD-END
begin
    i := 0;
    //	合計行出力なし
    Result := False;

	//===========================================================
	// 既に一度件数チェックしているのであれば前回の内容から取得
	//===========================================================
	if ( bFirstFormMaxLineGetFlg[2] = False )then
    begin
		if (GetLineCount_TegDetail(iMaxRow,pIndex) = True )then
        begin
        	bFirstFormMaxLineGetFlg[2] := True;
            iFirstFormMaxLine[2] := iMaxRow;
        end
        else
        	Exit;
    end
    else
    	iMaxRow := iFirstFormMaxLine[2];

	if DMem_Teg.RecordCount = 0 then Exit;

    iRecNo	:=	DMem_Teg.RecNo;

	with DMem_Teg do
	begin
		while Eof <> True do
		begin
			Inc(i);

			// 次回の支払先レコード検索
			NextTegata(DMem_CSInfo.FieldByName('GCode').AsString);
		end;
	end;

    DMem_Teg.Edit;
    DMem_Teg.RecNo := iRecNo;

 	if	((m_DlgParam.LayoutPtn = 3) or (m_DlgParam.LayoutPtn = 5)) and
// <#026> MOD-STR
//		 (i > KOUJYO) then
		 (i > iMaxRow) then
// <#026> MOD-END
		Exit;

// <#032> ADD-STR
    if (m_DlgParam.LayoutPtn <> 3) then
        bJustInPage := False
    else
        bJustInPage := (i = iMaxRow);   // ページちょうどにデータが収まるか？
// <#032> ADD-END

    i := 0;
	with DMem_Teg do
    begin
// <#032> ADD-STR
    	if (m_DlgParam.Layout = 0) then
        begin
            m_iCurrTegKbn := FieldByName('TegKbn').AsInteger;   // 処理中手形区分を保存
        end;
// <#032> ADD-END
        while Eof <> True do
        begin
            Inc(i);

            if i = (iMaxRow + 1) then
            	Break;

            sBankSqNo	:=	FieldByName( 'BankSqNo').AsString;						//	手形NO.
            sMankibi	:=	SetFormatMankibi(FieldByName( 'Mankibi').AsInteger);	//	満期日
            sFridasibi	:=	SetFormatMankibi(FieldByName( 'Fridasibi').AsInteger);	//	振出日
			//事業所内訳：合計値
            sSiharaiKin	:=	Edit_Kingaku(FieldByName( 'SiharaiKin').AsCurrency);		//	金額
            sPayPlace	:=	FieldByName( 'LongName').AsString;						//	支払場所

            m_nTegSubTotal := (m_nTegSubTotal + FieldByName( 'SiharaiKin').AsCurrency); // 小計セット <#032> ADD

            sField_BankSqNo		:=	Format( CORPNM_BankSqNo		+ '%-d' , [i] );
            sField_Mankibi		:=	Format( CORPNM_Mankibi		+ '%-d' , [i] );
            sField_Fridasibi	:=	Format( CORPNM_Fridasibi	+ '%-d' , [i] );
            sField_SiharaiKin	:=	Format( CORPNM_ShiharaiKin	+ '%-d' , [i] );
            sField_PayPlace		:=	Format( CORPNM_PayPlace		+ '%-d' , [i] );

            // 手形明細---手形NO.
            try
                if CheckFieldOnReport(pIndex,sField_BankSqNo) then
                begin
                    FieldIndex := CoRepData.AddData(sField_BankSqNo ,sBankSqNo);
                    CoRep_KanriNo(CoRepData,FieldIndex);
                end;
            Except
            end;

            // 手形明細---支払期日
			try
				if CheckFieldOnReport(pIndex,sField_Mankibi) then
                begin
                    FieldIndex := CoRepData.AddData(sField_Mankibi ,sMankibi);
                    CoRep_FontRatio(CoRepData,FieldIndex);
                end;
            Except
            end;

            // 手形明細---振出日
            try
                if CheckFieldOnReport(pIndex,sField_Fridasibi) then
                begin
                    FieldIndex := CoRepData.AddData(sField_Fridasibi ,sFridasibi);
                    CoRep_FontRatio(CoRepData,FieldIndex);
                end;
            Except
            end;

            // 手形明細---金額
            try
                if CheckFieldOnReport(pIndex,sField_SiharaiKin) then
                begin
                    FieldIndex := CoRepData.AddData(sField_SiharaiKin ,sSiharaiKin);
                    CoRep_FontRatio(CoRepData,FieldIndex);
                end;
            Except
            end;

            // 手形明細---支払場所
			try
				if CheckFieldOnReport(pIndex,sField_PayPlace) then
                begin
					FieldIndex := CoRepData.AddData(sField_PayPlace ,sPayPlace);
					CoRep_FontRatio(CoRepData,FieldIndex);
					CoRep_AlignLeft(CoRepData,FieldIndex);
				end;
			Except
            end;

            // 次回の支払先レコード検索
			NextTegata(DMem_CSInfo.FieldByName('GCode').AsString);
// <#032> ADD-STR
            if ((m_DlgParam.Layout = 0) and (not Eof) and (DMem_CSInfo.FieldByName('GCode').AsString = FieldByName( 'GCode').AsString)) then
            begin
                // 同一支払先のデータが存在し
                if (FieldByName('TegKbn').AsInteger <> m_iCurrTegKbn) then
                begin
                    // 手形区分が異なった場合は合計出力
                    if (m_DlgParam.LayoutPtn <> 3) then
                    begin
                        if GetOutputLine(i,iMaxRow,iNext) then
                        begin
                            // 現在ページに入らない場合は続紙へ
                            if (iNext = 1) then
                            	Break;

                            // 合計出力
                            SetTotalLine(iMaxRow,i,ltTegataDtl,CoRepData);

                            // 合計出力行をカウンタにセット
                            i := iNext;
                        end;
                    end;

                    // 出力行が最終行以外の場合は空白挿入
                    if ((not bJustInPage) and (i <> iMaxRow)) then
                        Inc(i);
                end;

                m_iCurrTegKbn := FieldByName('TegKbn').AsInteger;   // 処理中手形区分を保存
            end;
// <#032> ADD-END
        end;

		{ 合計行出力 }
        case m_DlgParam.Layout of
            0:
            begin
                //	レコード数=最大行数であれば次ページにて出力
                if (i < (iMaxRow)) and Eof then
                begin
                    //	通知書（手形あり）の手形明細には合計出力なし
                    if (m_DlgParam.LayoutPtn <> 3) then
						SetTotalLine(iMaxRow,i,ltTegataDtl,CoRepData);
                    Result := True;
                end;
            end;
            1:
            begin
				if Eof then
                begin
                    GetOutputLine(i,iMaxRow,iOutPutLastRow);
                    //	合計行出力あり
                    Result := True;
                end;
            end;
            else ;
        end;
	end;
end;

//**************************************************************************
//  Proccess    :   Mem（事業所内訳）をセット
//  Name        :   K.IKEMURA
//  Date        :	2001/02/06
//  Parameter   :
//  Return      :
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPay510100f.SetData_Jigyosho(pIndex: Integer):Boolean;
var
	i : Integer;
    iMaxRow : Integer;		//	事業所内訳行数

	FieldIndex : Integer;

    sBumonName	 		: 	String;
    sBumonSateiKin 		: 	String;
    sBumonSousaiKin		: 	String;

    //CoReportsフィールド
    sField_BumonName		:	String;
    sField_BumonSateiKin	:	String;
    sField_BumonSousaiKin	:	String;
begin
	Result := False;
	i := 0;

	//===========================================================
	// 既に一度件数チェックしているのであれば前回の内容から取得
	//===========================================================
	if ( bFirstFormMaxLineGetFlg[3] = False )then
    begin
		if (GetLineCount_JigyoushoDetail(iMaxRow,pIndex) = True )then
        begin
        	bFirstFormMaxLineGetFlg[3] := True;
            iFirstFormMaxLine[3] := iMaxRow;
        end
        else
        	Exit;
    end
    else
    	iMaxRow := iFirstFormMaxLine[3];

	with DMem_Jigyousho do
	begin
		while Eof <> True do
		begin
			Inc(i);

			if i = (iMaxRow + 1) then
				Break;

			//	事業所内訳レイアウト
			sBumonName	 		:= FieldByName('LongName').AsString;

			//事業所内訳
			sBumonSateiKin 		:= Edit_Kingaku(FieldByName('SateiKin').AsCurrency);
			sBumonSousaiKin		:= Edit_Kingaku(FieldByName('SousaiKin').AsCurrency);
			sField_BumonName		:= Format( CORPNM_BumonName		+	'%-d', [i] );
			sField_BumonSateiKin	:= Format( CORPNM_BumonSateiKin	+	'%-d', [i] );
			sField_BumonSousaiKin	:= Format( CORPNM_BumonSousaiKin+	'%-d', [i] );

			// 事業所内訳---項目名
			try
				if CheckFieldOnReport(pIndex,sField_BumonName) then
				begin
					FieldIndex := CoRepData.AddData(sField_BumonName ,sBumonName);
					CoRep_FontRatio(CoRepData,FieldIndex);
					CoRep_AlignEven(CoRepData,FieldIndex);					// <#027> ADD
				end;
			Except
			end;

			// 事業所内訳---支払金額
			try
				if CheckFieldOnReport(pIndex,sField_BumonSateiKin) then
				begin
					FieldIndex := CoRepData.AddData(sField_BumonSateiKin ,sBumonSateiKin);
					CoRep_FontRatio(CoRepData,FieldIndex);
				end;
			Except
			end;

			// 事業所内訳---相殺金額
			try
				if CheckFieldOnReport(pIndex,sField_BumonSousaiKin) then
				begin
					FieldIndex := CoRepData.AddData(sField_BumonSousaiKin ,sBumonSousaiKin);
					CoRep_FontRatio(CoRepData,FieldIndex);
                end;
            Except
            end;

            // 次回の支払先レコード検索
			NextJigyo(DMem_CSInfo.FieldByName('GCode').AsString);
        end;

		{ 合計行出力 }
		//	レコード数=最大行数であれば次ページにて出力
		if (i < (iMaxRow)) and Eof then
		begin
	       	//	合計行設定
			SetTotalLine(iMaxRow,i,ltJigyou,CoRepData);
            Result := True;
        end;
	end;
end;

//**************************************************************************
//  Proccess    :   Mem（期日指定振込残高）をセット
//  Name        :   K.IKEMURA
//  Date        :	2001/02/06
//  Parameter   :
//  Return      :
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPay510100f.SetData_Kijitsu(pIndex: Integer):Boolean;
var
	i : Integer;
    iMaxRow : Integer;		//	期日指定振込行数

	FieldIndex : Integer;

    sMankibi	 		: 	String;
    sSiharaiKin 		: 	String;
    sTashaFee			: 	String;
    sTKanriNo			:	String;

    //CoReportsフィールド
    sField_Mankibi		:	String;
	sField_SiharaiKin	:	String;
    sField_TashaFee		:	String;
    sField_TKanriNo		:	String;
begin
    Result := False;
    i := 0;

	//===========================================================
	// 既に一度件数チェックしているのであれば前回の内容から取得
	//===========================================================
	if ( bFirstFormMaxLineGetFlg[4] = False )then
    begin
		if (GetLineCount_Kijitsu(iMaxRow,pIndex) = True )then
        begin
        	bFirstFormMaxLineGetFlg[4] := True;
            iFirstFormMaxLine[4] := iMaxRow;
        end
        else
        	Exit;
    end
    else
    	iMaxRow := iFirstFormMaxLine[4];

	with DMem_Kijitsu do
	begin
		while Eof <> True do
		begin
			Inc(i);

			if i = (iMaxRow + 1) then
				Break;

			//	期日指定振込残高レイアウト
			sMankibi	 		:=	SetFormatMankibi(FieldByName( 'Mankibi').AsInteger);
			sSiharaiKin 		:=	Edit_Kingaku(FieldByName( 'SiharaiKin').AsCurrency);
			sTashaFee			:=	Edit_Kingaku(FieldByName( 'TashaFee').AsCurrency);
			sTKanriNo			:=  FieldByName('TKanriNo').AsString;
			BankSqNoEdit(sTKanriNo);

			sField_Mankibi		:=	Format( CORPNM_KijituMankibi	+	'%-d', [i] );
			sField_SiharaiKin	:=	Format( CORPNM_KijituShiharaiKin+	'%-d', [i] );
			sField_TashaFee		:=	Format( CORPNM_KijituTashaFee	+	'%-d', [i] );
			sField_TKanriNo		:=	Format( CORPNM_KanriNo			+	'%-d', [i] );

			// 期日指定振込残高---支払期日
			try
				if CheckFieldOnReport(pIndex,sField_Mankibi) then
				begin
					CoRepData.AddData(sField_Mankibi ,sMankibi);
				end;
			Except
			end;

			// 期日指定振込残高---金額
			try
				if CheckFieldOnReport(pIndex,sField_SiharaiKin) then
				begin
					FieldIndex := CoRepData.AddData(sField_SiharaiKin ,sSiharaiKin);
					CoRep_FontRatio(CoRepData,FieldIndex);
				end;
			Except
			end;

			// 期日指定振込残高---手数料
			try
				//手数料がゼロの場合、０を出力させない（空欄表示）
				//他社手数料控除区分(0:控除する)　かつ 手数料負担区分(1:他社負担) かつ 手数料仕訳起票区分（0:未済み）
				if (CalcParam.BaseInfo6005 = 0) and
				   (FieldByName('FeePayKbn').AsInteger = 1) and
				   (FieldByName('FeeSwkKbn').AsInteger = 0) then
				begin
					if CheckFieldOnReport(pIndex,sField_TashaFee) then
					begin
						FieldIndex := CoRepData.AddData(sField_TashaFee ,sTashaFee);
						CoRep_FontRatio(CoRepData,FieldIndex);
					end;
				end;
			Except
			end;

			// 期日指定振込残高---管理NO.
			try
				if CheckFieldOnReport(pIndex,sField_TKanriNo) then
				begin
					FieldIndex := CoRepData.AddData(sField_TKanriNo ,sTKanriNo);
					CoRep_FontRatio(CoRepData,FieldIndex);
					CoRep_KanriNo(CoRepData,FieldIndex);
				end;
			Except
			end;

			NextKijitsu(DMem_CSInfo.FieldByName('GCode').AsString);
		end;

		{ 合計行出力 }
		//	レコード数=最大行数であれば次ページにて出力
		if (i < (iMaxRow)) and Eof then
		begin
			//	合計行設定
			SetTotalLine(iMaxRow,i,ltKijitsuDtl,CoRepData);
			Result := True;
		end;
	end;
end;

//**************************************************************************
//  Proccess    :   値があふれている場合のMem（取引明細）をセット
//  Name        :   K.IKEMURA
//  Date        :	2001/02/06
//  Parameter   :
//
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPay510100f.SetData_ToriDetailAdd(pIndex: Integer): Boolean;
var
	i ,iMaxRow: Integer;
	FieldIndex : Integer;

    sHasseDay	:	String;	//	発生日
    sTekiyo		:	String;	//	摘要
// <#012> 2008/03/26 T.Kawahata Add
    sNumValue1	:	String;	//	番号1
    sNumValue2	:	String;	//	番号2
// <#012> 2008/03/26 T.Kawahata Add
    sTHasseiKin	:	String;	//	金額
// <#033> ADD-STR
    sDKmkGCode          :	String;	//	相手科目コード
    sDKmkLongName       :	String;	//	相手科目正式名称
    sDBmnGCode          :	String;	//	相手部門コード
    sDBmnLongName       :	String;	//	相手部門正式名称
    sJigyoushoLongName  :	String;	//	事業所名
// <#033> ADD-END

    //CoReportsフィールド
    sField_HasseDay		:	String;
    sField_Tekiyo		:	String;
// <#012> 2008/03/26 T.Kawahata Add
    sField_NumValue1	:	String;
    sField_NumValue2	:	String;
// <#012> 2008/03/26 T.Kawahata Add
    sField_THasseiKin	:	String;
// <#033> ADD-STR
    sField_DKmkGCode          :	String;
    sField_DKmkLongName       :	String;
    sField_DBmnGCode          :	String;
    sField_DBmnLongName       :	String;
    sField_JigyoushoLongName  :	String;
// <#033> ADD-END

// <#012> 2008/03/26 T.Kawahata Add
    NumValue1Al	:	TAlignment;	//	番号1
    NumValue2Al	:	TAlignment;	//	番号2
// <#012> 2008/03/26 T.Kawahata Add
begin
	Result := False;
	i := 0;

	//===========================================================
	// 既に一度件数チェックしているのであれば前回の内容から取得
	//===========================================================
	if ( bSecondFormMaxLineGetFlg[1] = False )then
    begin
		if (GetLineCount_ToriDetail(iMaxRow,pIndex) = True )then
        begin
        	bSecondFormMaxLineGetFlg[1] := True;
            iSecondFormMaxLine[1] := iMaxRow;
        end
        else
        	Exit;
    end
    else
    	iMaxRow := iSecondFormMaxLine[1];

	with DMem_Tori do
    begin
        while Eof <> True do
        begin
            Inc(i);

            sHasseDay	:=	SetFormatHasseiDay(FieldByName( 'HasseiDay').AsDateTime);	//	発生日
            sTekiyo		:=	FieldByName( 'Tekiyou').AsString;						//	摘要
// <#012> 2008/03/26 T.Kawahata Add
            sNumValue1	:=	FieldByName('CNumValue1').AsString;	//	番号1
            sNumValue2	:=	FieldByName('CNumValue2').AsString;	//	番号2
            EditNumValue1(sNumValue1, NumValue1Al);				//	番号1
            EditNumValue2(sNumValue2, NumValue2Al);				//	番号2
// <#012> 2008/03/26 T.Kawahata Add
			sTHasseiKin	:=	Edit_Kingaku(FieldByName( 'THasseiKin').AsCurrency);	//	金額
// <#033> ADD-STR
            sDKmkGCode          :=	FieldByName('DKmkGCode').AsString;	        //	相手科目コード
            sDKmkLongName       :=	FieldByName('DKmkLongName').AsString;	    //	相手科目正式名称
            sDBmnGCode          :=	FieldByName('DBmnGCode').AsString;	        //	相手部門コード
            sDBmnGCode          :=  Edit_Code(m_BmnInfo.CodeAttr, m_BmnInfo.CodeDigit, sDBmnGCode, DISPLAY_TYPE);
            sDBmnLongName       :=	FieldByName('DBmnLongName').AsString;	    //	相手部門正式名称
            sJigyoushoLongName  :=	FieldByName('JigyoushoLongName').AsString;	//	事業所名
// <#033> ADD-END

            //	通知書取引明細レイアウトにも同名称のフィールドを使用
            //	別ファイル別レイヤのため同名称が可能
            //	同ファイル別レイヤ時に名称を変更したものは使用しない。
			sField_HasseDay		:=	Format( CORPNM_HasseiDay	+	'%-d', [i] );
            sField_Tekiyo		:=	Format( CORPNM_ToriTekiyou	+	'%-d', [i] );
// <#012> 2008/03/26 T.Kawahata Add
            sField_NumValue1	:=	Format( CORPNM_ToriNumValue1+ 	'%-d', [i] );	//	番号1
            sField_NumValue2	:=	Format( CORPNM_ToriNumValue2+ 	'%-d', [i] );	//	番号2
// <#012> 2008/03/26 T.Kawahata Add
            sField_THasseiKin	:=	Format( CORPNM_HasseiKin	+	'%-d', [i] );
// <#033> ADD-STR
            sField_DKmkGCode          := Format( CORPNM_ToriKmkGCodeD 	+ '%-d', [i] );	    //	相手科目コード
            sField_DKmkLongName       := Format( CORPNM_ToriKmkLNameD 	+ '%-d', [i] );	    //	相手科目正式名称
            sField_DBmnGCode          := Format( CORPNM_ToriBmnGCodeD 	+ '%-d', [i] );	    //	相手部門コード
            sField_DBmnLongName       := Format( CORPNM_ToriBmnLNameD 	+ '%-d', [i] );	    //	相手部門正式名称
            sField_JigyoushoLongName  := Format( CORPNM_ToriJigyoushoLName 	+ '%-d', [i] );	//	事業所名
// <#033> ADD-END

		   // 取引明細---発生日
			try
				if CheckFieldOnReport(pIndex,sField_HasseDay) then
				begin
					CoRepDataTori.AddData(sField_HasseDay ,sHasseDay);
				end;
			Except
			end;

			// 取引明細---摘要
			try
				if CheckFieldOnReport(pIndex,sField_Tekiyo) then
				begin
					FieldIndex := CoRepDataTori.AddData(sField_Tekiyo ,sTekiyo);
					CoRep_FontRatio(CoRepDataTori,FieldIndex);
					CoRep_AlignLeft(CoRepDataTori,FieldIndex);
				end;
			Except
			end;

// <#012> 2008/03/26 T.Kawahata Add
			// 取引明細---番号1
			try
				if CheckFieldOnReport(pIndex,sField_NumValue1) then
				begin
					FieldIndex := CoRepDataTori.AddData(sField_NumValue1 ,sNumValue1);
					CoRep_FontRatio(CoRepDataTori,FieldIndex);
                    if NumValue1Al = taLeftJustify then
						CoRep_AlignLeft(CoRepDataTori,FieldIndex)
                    else
						CoRep_AlignRight(CoRepDataTori,FieldIndex);
				end;
			Except
            end;

			// 取引明細---番号2
			try
				if CheckFieldOnReport(pIndex,sField_NumValue2) then
				begin
					FieldIndex := CoRepDataTori.AddData(sField_NumValue2 ,sNumValue2);
					CoRep_FontRatio(CoRepDataTori,FieldIndex);
                    if NumValue2Al = taLeftJustify then
						CoRep_AlignLeft(CoRepDataTori,FieldIndex)
                    else
						CoRep_AlignRight(CoRepDataTori,FieldIndex);
				end;
			Except
            end;
// <#012> 2008/03/26 T.Kawahata Add

            // 取引明細---金額
            try
                if CheckFieldOnReport(pIndex,sField_THasseiKin) then
                begin
                    FieldIndex := CoRepDataTori.AddData(sField_THasseiKin ,sTHasseiKin);
                    CoRep_FontRatio(CoRepDataTori,FieldIndex);
                end;
            Except
            end;

// <#033> ADD-STR
            // 取引明細---相手科目コード
            try
                if CheckFieldOnReport(pIndex,sField_DKmkGCode) then
                begin
                    FieldIndex := CoRepDataTori.AddData(sField_DKmkGCode ,sDKmkGCode);
                    CoRep_FontRatio(CoRepDataTori,FieldIndex);
                    CoRep_AlignRight(CoRepDataTori,FieldIndex);
                end;
            Except
            end;

            // 取引明細---相手科目正式名称
            try
                if CheckFieldOnReport(pIndex,sField_DKmkLongName) then
                begin
                    FieldIndex := CoRepDataTori.AddData(sField_DKmkLongName ,sDKmkLongName);
                    CoRep_FontRatio(CoRepDataTori,FieldIndex);
					CoRep_AlignLeft(CoRepDataTori,FieldIndex);
                end;
            Except
            end;

            // 取引明細---相手部門コード
            try
                if CheckFieldOnReport(pIndex,sField_DBmnGCode) then
                begin
                    FieldIndex := CoRepDataTori.AddData(sField_DBmnGCode ,sDBmnGCode);
                    CoRep_FontRatio(CoRepDataTori,FieldIndex);
                    if (m_BmnInfo.CodeAttr = ATTR_FREE) then
						CoRep_AlignLeft(CoRepDataTori,FieldIndex)
                    else
						CoRep_AlignRight(CoRepDataTori,FieldIndex);
                end;
            Except
            end;

            // 取引明細---相手部門正式名称
            try
                if CheckFieldOnReport(pIndex,sField_DBmnLongName) then
                begin
                    FieldIndex := CoRepDataTori.AddData(sField_DBmnLongName ,sDBmnLongName);
                    CoRep_FontRatio(CoRepDataTori,FieldIndex);
					CoRep_AlignLeft(CoRepDataTori,FieldIndex);
                end;
            Except
            end;

            // 取引明細---事業所名
            try
                if CheckFieldOnReport(pIndex,sField_JigyoushoLongName) then
                begin
                    FieldIndex := CoRepDataTori.AddData(sField_JigyoushoLongName ,sJigyoushoLongName);
                    CoRep_FontRatio(CoRepDataTori,FieldIndex);
					CoRep_AlignLeft(CoRepDataTori,FieldIndex);
                end;
            Except
            end;
// <#033> ADD-END

            // 次回の支払先レコード検索
			NextTori(DMem_CSInfo.FieldByName('GCode').AsString);
            if i = iMaxRow then
			begin
				//	通知書取引明細行数まできたら出力
				SetData_DTMAIN(CoRepDataTori);
				SetData_CSInfo(CoRepDataTori);
				SetPageCnt(CoRepDataTori);
                CoReportsPrintObj.AddData(CoRepDataTori);

                CoRepDataTori := MjsCoReportsData3.TMjsCoReportsData.Create;
                CoRepDataTori.LayerNameList.Add(TORIDETAIL);
                CoRepDataTori.FormIndex := pIndex;
                i := 0;
            end;
        end;

		//	最終行に合計出力
        SetTotalLine(iMaxRow,i,ltToriDtl,CoRepDataTori);

        //	通知書取引明細にもデータがある場合は出力
        //	合計行出力のみの場合(i = 0)があるため
        if i <> 0 then
        begin
            SetData_DTMAIN(CoRepDataTori);
            SetData_CSInfo(CoRepDataTori);
            SetPageCnt(CoRepDataTori);
            CoReportsPrintObj.AddData(CoRepDataTori);
        end;
	end;
end;

//**************************************************************************
//  Proccess    :   値があふれている場合のMem（手形明細）をセット
//  Name        :   K.IKEMURA
//  Date        :	2001/02/06
//  Parameter   :
//
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPay510100f.SetData_TegDetailAdd(pIndex: Integer): Boolean;
var
	i : Integer;
	iMaxRow	:	Integer;	//	手形明細行数
	FieldIndex : Integer;

    sBankSqNo	:	String;	//	手形NO.
    sMankibi	:	String;	//	支払期日
    sFridasibi	:	String;	//	振出日
    sSiharaiKin	:	String;	//	金額
    sPayPlace	:	String;	//	支払場所

    //CoReportsフィールド
    sField_BankSqNo		:	String;
    sField_Mankibi		:	String;
    sField_Fridasibi 	:	String;
    sField_SiharaiKin	:	String;
    sField_PayPlace		:	String;

// <#032> ADD-STR
    bPutSubTotal:   Boolean;
    iNext       :	Integer;
// <#032> ADD-END
begin
	Result := False;
    i := 0;

	//===========================================================
	// 既に一度件数チェックしているのであれば前回の内容から取得
	//===========================================================
	if ( bSecondFormMaxLineGetFlg[2] = False )then
    begin
		if (GetLineCount_TegDetail(iMaxRow,pIndex) = True )then
        begin
        	bSecondFormMaxLineGetFlg[2] := True;
            iSecondFormMaxLine[2] := iMaxRow;
        end
        else
        	Exit;
    end
    else
    	iMaxRow := iSecondFormMaxLine[2];

	with DMem_Teg do
    begin
// <#032> ADD-STR
        bPutSubTotal := False;

    	if ((m_DlgParam.Layout = 0) and (m_nTegSubTotal <> 0)) then
        begin
            // １支払先データ出力中
            if (FieldByName('TegKbn').AsInteger <> m_iCurrTegKbn) then
                // 手形区分が異なった場合は合計出力
                bPutSubTotal := True;
        end;

        if (not bPutSubTotal) then
            m_iCurrTegKbn := FieldByName('TegKbn').AsInteger;   // 処理中手形区分を保存
// <#032> ADD-END
        while Eof <> True do
        begin
// <#032> ADD-STR
            // 合計出力
            if (bPutSubTotal) then
            begin
                if (m_DlgParam.LayoutPtn <> 3) then
                begin
                    if GetOutputLine(i,iMaxRow,iNext) then
                    begin
                        // 合計出力
                        SetTotalLine(iMaxRow,i,ltTegataDtl,CoRepDataTeg,False);

                        // 合計出力行をカウンタにセット
                        i := iNext;
                    end;
                end;

                // 出力行が最終行以外の場合は空白挿入
                if (i <> iMaxRow) then
                    Inc(i);

                // 通知書取引明細行数まできたら出力
                if i = iMaxRow then
                begin
                    SetData_DTMAIN(CoRepDataTeg);
                    SetData_CSInfo(CoRepDataTeg);
                    SetPageCnt(CoRepDataTeg);
                    CoReportsPrintObj.AddData(CoRepDataTeg);

                    CoRepDataTeg := MjsCoReportsData3.TMjsCoReportsData.Create;
                    CoRepDataTeg.LayerNameList.Add(TEGDETAIL);
                    CoRepDataTeg.FormIndex := pIndex;

                    i := 0;
                end;

                bPutSubTotal := False;

                m_iCurrTegKbn := FieldByName('TegKbn').AsInteger;   // 処理中手形区分を保存
            end;
// <#032> ADD-END
            Inc(i);

			sBankSqNo	:=	FieldByName( 'BankSqNo').AsString;						//	手形NO.
			sMankibi	:=	SetFormatMankibi(FieldByName( 'Mankibi').AsInteger);  	//	満期日
			sFridasibi	:=	SetFormatMankibi(FieldByName( 'Fridasibi').AsInteger);	//	振出日
			sSiharaiKin	:=	Edit_Kingaku(FieldByName( 'SiharaiKin').AsCurrency);		//	金額

			sPayPlace	:=	FieldByName( 'LongName').AsString;						//	支払場所

            m_nTegSubTotal := (m_nTegSubTotal + FieldByName( 'SiharaiKin').AsCurrency); // 小計セット <#032> ADD

            sField_BankSqNo		:=	Format( CORPNM_BankSqNo		+	'%-d', [i] );
            sField_Mankibi		:=	Format( CORPNM_Mankibi		+	'%-d', [i] );
            sField_Fridasibi	:=	Format( CORPNM_Fridasibi	+	'%-d', [i] );
            sField_SiharaiKin	:=	Format( CORPNM_ShiharaiKin	+	'%-d', [i] );
            sField_PayPlace		:=	Format(	CORPNM_PayPlace		+	'%-d', [i] );

            // 手形明細---手形NO.
            try
                if CheckFieldOnReport(pIndex,sField_BankSqNo) then
                begin
                    FieldIndex := CoRepDataTeg.AddData(sField_BankSqNo ,sBankSqNo);
                    CoRep_KanriNo(CoRepDataTeg,FieldIndex);
                end;
            Except
            end;

            // 手形明細---支払期日
            try
                if CheckFieldOnReport(pIndex,sField_Mankibi) then
                begin
                    CoRepDataTeg.AddData(sField_Mankibi ,sMankibi);
                end;
            Except
            end;

            // 手形明細---振出日
			try
                if CheckFieldOnReport(pIndex,sField_Fridasibi) then
                begin
                    CoRepDataTeg.AddData(sField_Fridasibi ,sFridasibi);
                end;
            Except
            end;

            // 手形明細---金額
            try
				//CoReportsで設定されている枠ｻｲｽﾞより文字数が超える場合,長体をかける
                if CheckFieldOnReport(pIndex,sField_SiharaiKin) then
                begin
                    FieldIndex := CoRepDataTeg.AddData(sField_SiharaiKin ,sSiharaiKin);
                    CoRep_FontRatio(CoRepDataTeg,FieldIndex);
                end;
            Except
			end;

            // 手形明細---支払場所
            try
                if CheckFieldOnReport(pIndex,sField_PayPlace) then
                begin
                    FieldIndex := CoRepDataTeg.AddData(sField_PayPlace ,sPayPlace);
                    CoRep_FontRatio(CoRepDataTeg,FieldIndex);
				    CoRep_AlignLeft(CoRepDataTeg,FieldIndex);
                end;
            Except
            end;

            // 次回の支払先レコード検索
			NextTegata(DMem_CSInfo.FieldByName('GCode').AsString);
			if i = iMaxRow then
            begin
            	//	通知書取引明細行数まできたら出力
				SetData_DTMAIN(CoRepDataTeg);
                SetData_CSInfo(CoRepDataTeg);
				SetPageCnt(CoRepDataTeg);
                CoReportsPrintObj.AddData(CoRepDataTeg);

                CoRepDataTeg := MjsCoReportsData3.TMjsCoReportsData.Create;
				CoRepDataTeg.LayerNameList.Add(TEGDETAIL);
				CoRepDataTeg.FormIndex := pIndex;

				i := 0;
			end;
// <#032> ADD-STR
            if ((m_DlgParam.Layout = 0) and (not Eof) and (DMem_CSInfo.FieldByName('GCode').AsString = FieldByName( 'GCode').AsString)) then
            begin
                // 同一支払先のデータが存在し
                if (FieldByName('TegKbn').AsInteger <> m_iCurrTegKbn) then
                begin
                    // 手形区分が異なった場合は合計出力
                    if (m_DlgParam.LayoutPtn <> 3) then
                    begin
                        if GetOutputLine(i,iMaxRow,iNext) then
                        begin
                            // 合計出力
                            SetTotalLine(iMaxRow,i,ltTegataDtl,CoRepDataTeg);

                            // 合計出力行をカウンタにセット
                            i := iNext;
                        end;
                    end;

                    // 出力行が最終行以外の場合は空白挿入
                    if (i <> iMaxRow) then
                        Inc(i);

                    // 通知書取引明細行数まできたら出力
                    if i = iMaxRow then
                    begin
                        SetData_DTMAIN(CoRepDataTeg);
                        SetData_CSInfo(CoRepDataTeg);
                        SetPageCnt(CoRepDataTeg);
                        CoReportsPrintObj.AddData(CoRepDataTeg);

                        CoRepDataTeg := MjsCoReportsData3.TMjsCoReportsData.Create;
                        CoRepDataTeg.LayerNameList.Add(TEGDETAIL);
                        CoRepDataTeg.FormIndex := pIndex;

                        i := 0;
                    end;
                end;

                m_iCurrTegKbn := FieldByName('TegKbn').AsInteger;   // 処理中手形区分を保存
            end;
// <#032> ADD-END
        end;

		//	最終行に合計出力
        //	通知書（手形あり）の手形明細には合計出力なし
        if (m_DlgParam.LayoutPtn <> 3) then
            SetTotalLine(iMaxRow,i,ltTegataDtl,CoRepDataTeg);

        //	通知書手形明細にもデータがある場合は出力
        //	合計行出力のみの場合(i = 0)があるため
        if i <> 0 then
        begin
            SetData_DTMAIN(CoRepDataTeg);
            SetData_CSInfo(CoRepDataTeg);
            SetPageCnt(CoRepDataTeg);
            CoReportsPrintObj.AddData(CoRepDataTeg);
        end;
	end;
end;

//**************************************************************************
//  Proccess    :   値があふれている場合のMem（控除明細）をセット
//  Name        :   K.IKEMURA
//  Date        :	2001/02/06
//  Parameter   :
//
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPay510100f.SetData_KoujyoDetailAdd(pIndex: Integer): Boolean;
var
	i,iMaxRow : Integer;

	FieldIndex : Integer;

    sKoujyoKamoku 	: 	String;
    sKoujyoKin 		: 	String;

    //CoReportsフィールド
    sField_KoujyoKamoku	:	String;
    sField_KoujyoKin	:	String;
begin
	Result := False;
	i := 0;

	//===========================================================
	// 既に一度件数チェックしているのであれば前回の内容から取得
	//===========================================================
	if ( bSecondFormMaxLineGetFlg[3] = False )then
    begin
		if (GetLineCount_KoujyoDetail(iMaxRow,pIndex) = True )then
        begin
        	bSecondFormMaxLineGetFlg[3] := True;
            iSecondFormMaxLine[3] := iMaxRow;
        end
        else
        	Exit;
    end
    else
    	iMaxRow := iSecondFormMaxLine[3];
        
	with DMem_Koujyo do
    begin
        while Eof <> True do
        begin
            Inc(i);

            sKoujyoKamoku := FieldByName('SimpleName').AsString;
            sKoujyoKin := Edit_Kingaku(FieldByName('SousaiKin').AsCurrency);

           	sField_KoujyoKamoku := Format( CORPNM_Koujyo + '%-d' , [i] );
           	sField_KoujyoKin 	:= Format( CORPNM_Fee	 + '%-d' , [i] );

            // 控除内訳---項目名
            try
				//CoReportsで設定されている枠ｻｲｽﾞより文字数が超える場合,長体をかける
                if CheckFieldOnReport(pIndex,sField_KoujyoKamoku) then
                begin
                    FieldIndex := CoRepDataKoujyo.AddData(sField_KoujyoKamoku ,sKoujyoKamoku);
                    CoRep_FontRatio(CoRepDataKoujyo,FieldIndex);
                end;
            Except
            end;

            // 控除内訳---金額
            try
				//CoReportsで設定されている枠ｻｲｽﾞより文字数が超える場合,長体をかける
                if CheckFieldOnReport(pIndex,sField_KoujyoKin) then
                begin
                    FieldIndex := CoRepDataKoujyo.AddData(sField_KoujyoKin ,sKoujyoKin);
                    CoRep_FontRatio(CoRepDataKoujyo,FieldIndex);
                end;
            Except
            end;

            // 次回の支払先レコード検索
			NextKoujyo(DMem_CSInfo.FieldByName('GCode').AsString);
            if i = iMaxRow  then
            begin
            	//	通知書控除明細行数まできたら出力
				SetData_DTMAIN(CoRepDataKoujyo);
                SetData_CSInfo(CoRepDataKoujyo);
				SetPageCnt(CoRepDataKoujyo);
                CoReportsPrintObj.AddData(CoRepDataKoujyo);

                CoRepDataKoujyo := MjsCoReportsData3.TMjsCoReportsData.Create;
                CoRepDataKoujyo.LayerNameList.Add(KOUJYOIDETAIL);
                CoRepDataKoujyo.FormIndex := iFormIndex[3];

                i := 0;
            end;
        end;

        //	通知書取引明細にもデータがある場合は出力
        //	合計行出力のみの場合(i = 0)があるため
        if i <> 0 then
        begin
            SetData_DTMAIN(CoRepDataKoujyo);
            SetData_CSInfo(CoRepDataKoujyo);
            SetPageCnt(CoRepDataKoujyo);
            CoReportsPrintObj.AddData(CoRepDataKoujyo);
        end;
	end;
end;

//**************************************************************************
//  Proccess    :   値があふれている場合のMem（事業所明細）をセット
//  Name        :   K.IKEMURA
//  Date        :	2001/02/06
//  Parameter   :
//
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPay510100f.SetData_JigyouDetailAdd(pIndex: Integer): Boolean;
var
	i : Integer;
	iMaxRow	:	Integer;			//	事業所内訳行数

	FieldIndex : Integer;

    sBumonName	 		: 	String;
    sBumonSateiKin 		: 	String;
    sBumonSousaiKin		: 	String;

    //CoReportsフィールド
    sField_BumonName		:	String;
    sField_BumonSateiKin	:	String;
    sField_BumonSousaiKin	:	String;
begin
	Result := False;
	i := 0;

	//===========================================================
	// 既に一度件数チェックしているのであれば前回の内容から取得
	//===========================================================
	if ( bSecondFormMaxLineGetFlg[3] = False )then
    begin
		if (GetLineCount_JigyoushoDetail(iMaxRow,pIndex) = True )then
        begin
        	bSecondFormMaxLineGetFlg[3] := True;
            iSecondFormMaxLine[3] := iMaxRow;
        end
        else
        	Exit;
    end
    else
    	iMaxRow := iSecondFormMaxLine[3];
        
	with DMem_Jigyousho do
    begin
        while Eof <> True do
        begin
            Inc(i);

			sBumonName	 		:= FieldByName('LongName').AsString;	//部門名

			//事業所内訳：合計値
            sBumonSateiKin 		:= Edit_Kingaku(FieldByName('SateiKin').AsCurrency);
            sBumonSousaiKin		:= Edit_Kingaku(FieldByName('SousaiKin').AsCurrency);

			sField_BumonName		:= Format( CORPNM_BumonName		+	'%-d', [i] );
			sField_BumonSateiKin	:= Format( CORPNM_BumonSateiKin	+	'%-d', [i] );
			sField_BumonSousaiKin	:= Format( CORPNM_BumonSousaiKin+	'%-d', [i] );

			// 事業所内訳---項目名
			try
				if CheckFieldOnReport(pIndex,sField_BumonName) then
				begin
					FieldIndex := CoRepDataJigyou.AddData(sField_BumonName ,sBumonName);
					CoRep_FontRatio(CoRepDataJigyou,FieldIndex);
					CoRep_AlignEven(CoRepDataJigyou,FieldIndex);					// <#027> ADD
				end;
			Except
			end;

			// 事業所内訳---支払金額
			try
				if CheckFieldOnReport(pIndex,sField_BumonSateiKin) then
				begin
					FieldIndex := CoRepDataJigyou.AddData(sField_BumonSateiKin ,sBumonSateiKin);
					CoRep_FontRatio(CoRepDataJigyou,FieldIndex);
				end;
			Except
			end;

			// 事業所内訳---相殺金額
			try
				if CheckFieldOnReport(pIndex,sField_BumonSousaiKin) then
				begin
					FieldIndex := CoRepDataJigyou.AddData(sField_BumonSousaiKin ,sBumonSousaiKin);
					CoRep_FontRatio(CoRepDataJigyou,FieldIndex);
				end;
			Except
			end;

			NextJigyo(DMem_CSInfo.FieldByName('GCode').AsString);
            if i = iMaxRow then
            begin
            	//	事業所行数まできたら出力
				SetData_DTMAIN(CoRepDataJigyou);
                SetData_CSInfo(CoRepDataJigyou);
				SetPageCnt(CoRepDataJigyou);
                CoReportsPrintObj.AddData(CoRepDataJigyou);

                CoRepDataJigyou := MjsCoReportsData3.TMjsCoReportsData.Create;
                CoRepDataJigyou.LayerNameList.Add(JIGYOUDETAIL);
                CoRepDataJigyou.FormIndex := iFormIndex[3];

                i := 0;
            end;
        end;

		//	最終行に合計出力
        SetTotalLine(iMaxRow,i,ltJigyou,CoRepDataJigyou);

        //	通知書事業所明細にもデータがある場合は出力
        //	合計行出力のみの場合(i = 0)があるため
        if i <> 0 then
        begin
            SetData_DTMAIN(CoRepDataJigyou);
            SetData_CSInfo(CoRepDataJigyou);
            SetPageCnt(CoRepDataJigyou);
            CoReportsPrintObj.AddData(CoRepDataJigyou);
        end;

		Result := True;
	end;
end;

//**************************************************************************
//  Proccess    :   値があふれている場合のMem（期日指定振込残高）をセット
//  Name        :   K.IKEMURA
//  Date        :	2001/02/06
//  Parameter   :
//
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPay510100f.SetData_KijitsuDetailAdd(pIndex: Integer): Boolean;
var
	i : Integer;
	iMaxRow	:	Integer;			//	期日指定振込行数

	FieldIndex : Integer;

    sMankibi	 		: 	String;
    sSiharaiKin 		: 	String;
    sTashaFee			: 	String;
    sTKanriNo			:	String;

    //CoReportsフィールド
    sField_Mankibi		:	String;
    sField_SiharaiKin	:	String;
    sField_TashaFee		:	String;
    sField_TKanriNo		:	String;
begin
	Result := False;
	i := 0;

	//===========================================================
	// 既に一度件数チェックしているのであれば前回の内容から取得
	//===========================================================
	if ( bSecondFormMaxLineGetFlg[4] = False )then
    begin
		if (GetLineCount_Kijitsu(iMaxRow,pIndex) = True )then
        begin
        	bSecondFormMaxLineGetFlg[4] := True;
            iSecondFormMaxLine[4] := iMaxRow;
        end
        else
        	Exit;
    end
    else
    	iMaxRow := iSecondFormMaxLine[4];

	with DMem_Kijitsu do
    begin
        while Eof <> True do
        begin
            Inc(i);
            sMankibi	 		:=	SetFormatMankibi(FieldByName( 'Mankibi').AsInteger);
            sSiharaiKin 		:=	Edit_Kingaku(FieldByName( 'SiharaiKin').AsCurrency);
            sTashaFee			:=	Edit_Kingaku(FieldByName( 'TashaFee').AsCurrency);
            sTKanriNo			:=  FieldByName('TKanriNo').AsString;
			BankSqNoEdit(sTKanriNo);

            sField_Mankibi		:=	Format( CORPNM_KijituMankibi	+	'%-d', [i] );
            sField_SiharaiKin	:=	Format( CORPNM_KijituShiharaiKin+	'%-d', [i] );
            sField_TashaFee		:=	Format( CORPNM_KijituTashaFee	+	'%-d', [i] );
            sField_TKanriNo		:=	Format( CORPNM_KanriNo			+	'%-d', [i] );

            // 期日指定振込残高---支払期日
            try
                if CheckFieldOnReport(pIndex,sField_Mankibi) then
                begin
                    FieldIndex := CoRepDataKijitsu.AddData(sField_Mankibi ,sMankibi);
                    CoRep_FontRatio(CoRepDataKijitsu,FieldIndex);
                end;
            Except
            end;

            // 期日指定振込残高---金額
            try
                if CheckFieldOnReport(pIndex,sField_SiharaiKin) then
                begin
                    FieldIndex := CoRepDataKijitsu.AddData(sField_SiharaiKin ,sSiharaiKin);
                    CoRep_FontRatio(CoRepDataKijitsu,FieldIndex);
                end;
            Except
            end;

            // 期日指定振込残高---手数料
            try
				//手数料がゼロの場合、０を出力させない（空欄表示）
				//他社手数料控除区分(0:控除する)　かつ 手数料負担区分(1:他社負担) かつ 手数料仕訳起票区分（0:未済み）
				if (CalcParam.BaseInfo6005 = 0) and
                   (FieldByName('FeePayKbn').AsInteger = 1) and
                   (FieldByName('FeeSwkKbn').AsInteger = 0) then
                begin
					//CoReportsで設定されている枠ｻｲｽﾞより文字数が超える場合,長体をかける
                	if CheckFieldOnReport(pIndex,sField_TashaFee) then
                	begin
                    	FieldIndex := CoRepDataKijitsu.AddData(sField_TashaFee ,sTashaFee);
                    	CoRep_FontRatio(CoRepDataKijitsu,FieldIndex);
                	end;
                end;
            Except
            end;

            // 期日指定振込残高---管理NO.
            try
                if CheckFieldOnReport(pIndex,sField_TKanriNo) then
                begin
                    FieldIndex := CoRepDataKijitsu.AddData(sField_TKanriNo ,sTKanriNo);
                    CoRep_FontRatio(CoRepDataKijitsu,FieldIndex);

                    CoRep_KanriNo(CoRepDataKijitsu,FieldIndex);
                end;
            Except
            end;

			NextKijitsu(DMem_CSInfo.FieldByName('GCode').AsString);
            if i = iMaxRow then
            begin
            	//	期日指定振込残高行数まできたら出力
                SetData_DTMAIN(CoRepDataKijitsu);
                SetData_CSInfo(CoRepDataKijitsu);
				SetPageCnt(CoRepDataKijitsu);
                CoReportsPrintObj.AddData(CoRepDataKijitsu);

                CoRepDataKijitsu := MjsCoReportsData3.TMjsCoReportsData.Create;
                CoRepDataKijitsu.LayerNameList.Add(KIJITSUDETAIL);
                CoRepDataKijitsu.FormIndex := iFormIndex[4];
                i := 0;
            end;
        end;

		//	最終行に合計出力
        SetTotalLine(iMaxRow,i,ltKijitsuDtl,CoRepDataKijitsu);

        //	通知書取引明細にもデータがある場合は出力
        //	合計行出力のみの場合(i = 0)があるため
        if i <> 0 then
        begin
            SetData_DTMAIN(CoRepDataKijitsu);
            SetData_CSInfo(CoRepDataKijitsu);
            SetPageCnt(CoRepDataKijitsu);
            CoReportsPrintObj.AddData(CoRepDataKijitsu);
        end;

		Result := True;
	end;
end;

//**************************************************************************
//  Proccess    :
//  Name        :   K.IKEMURA
//  Date        :	2001/12/14
//  Parameter   :	TotalCnt : レイアウトの最大行数
//  			:	RecCount : レコード数
//  Return      :	編集後のコード
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPay510100f.SetTotalLine(MaxLine, RecCount: Integer;Lt:TLayoutType;
// <#032> MOD-STR
//CoData: TMjsCoReportsData);
CoData: TMjsCoReportsData;bAddPage:Boolean=True);
// <#032> MOD-END
	//	DTMAIN,CSInfoの設定
	procedure SetCsInfoandDTMAIN(pCoRepData: TMjsCoReportsData);
	begin
		SetData_DTMAIN(pCoRepData);
        SetData_CSInfo(pCoRepData);
		SetPageCnt(pCoRepData);
	end;

	//	TMjsCoReportsPrintへTMjsCoReportsDataの設定
    procedure AddCoRepData(pCoRepData: TMjsCoReportsData);
	begin
		CoReportsPrintObj.AddData( pCoRepData );
    end;
var
    iOutputLine : Integer;
	sWkField 	: String;
    wCoRepData	: TMjsCoReportsData;
begin
    wCoRepData := CoData;

    if not GetOutputLine(RecCount,MaxLine,iOutputLine) then Exit;

	case Lt of
    	ltToriDtl:	//	取引明細
        begin
        	if iOutputLine = 1 then
			begin
				CreateCoRepData(ltToriDtl);
                wCoRepData := CoRepDataTori;
                SetCsInfoandDTMAIN(wCoRepData);
            end;

            sWkField		:=	Format( CORPNM_ToriTekiyou + '%-d', [iOutputLine] );
// <#020> ADD-STR
        	try
                //摘要欄が存在する場合は摘要に出力
                CheckFieldOnReport(CoData.FormIndex, sWkField);
            Except
                if (m_GnPuKbn_12 <> 0) then
                    //摘要欄が存在せず、番号1が採用ありの場合は番号１に出力
                    sWkField		:=	Format( CORPNM_ToriNumValue1 + '%-d', [iOutputLine] );
            end;
// <#020> ADD-END
        end;
    	ltTegataDtl://	手形明細
        begin
// <#032> MOD-STR
//			if iOutputLine = 1 then
			if (bAddPage and (iOutputLine = 1)) then
// <#032> MOD-END
            begin
            	CreateCoRepData(ltTegataDtl);
                wCoRepData := CoRepDataTeg;
                SetCsInfoandDTMAIN(wCoRepData);
            end;

            sWkField		:=	Format( CORPNM_PayPlace + '%-d', [iOutputLine] );
        end;
    	ltKoujyoDtl://	控除明細
        begin
        	if iOutputLine = 1 then
            begin
            	CreateCoRepData(ltKoujyoDtl);
                wCoRepData := CoRepDataKoujyo;
                SetCsInfoandDTMAIN(wCoRepData);
            end;

           	sWkField 		:= Format( CORPNM_Koujyo + '%-d', [iOutputLine] );

		end;
		ltJigyou:	//	事業所内訳
		begin
			if iOutputLine = 1 then
			begin
				CreateCoRepData(ltJigyou);
				wCoRepData := CoRepDataJigyou;
				SetCsInfoandDTMAIN(wCoRepData);
			end;

			sWkField		:= Format( CORPNM_BumonName + '%-d', [iOutputLine] );
        end;
		ltKijitsuDtl://	期日指定振込残高
        begin
        	if iOutputLine = 1 then
            begin
            	CreateCoRepData(ltKijitsuDtl);
                wCoRepData := CoRepDataKijitsu;
                SetCsInfoandDTMAIN(wCoRepData);
            end;

            sWkField		:=	Format( CORPNM_KijituMankibi + '%-d', [iOutputLine] );
        end;
    else ;
    end;

  	if FindPayPlan(DMem_CSInfo.FieldByName( 'GCode').AsString) then
    begin
		//	合計行出力
		OutPutTotal(Lt,sWkField,wCoRepData);
		OutPutSum(Lt,iOutputLine,wCoRepData);

// <#032> MOD-STR
//		if iOutputLine = 1 then AddCoRepData(wCoRepData);
		if (bAddPage and (iOutputLine = 1)) then AddCoRepData(wCoRepData);
// <#032> MOD-END
	end;
end;

//**************************************************************************
//  Proccess    :   合計行出力
//  Name        :   K.IKEMURA
//  Date        :	2001/12/14
//  Parameter   :	pLeyoutType : レイアウトパターン
//  			:	sField : 出力フィールド
//  			:	CoData : 出力CoRepData
//  Return      :	編集後のコード
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPay510100f.OutPutTotal(pLeyoutType: TLayoutType; sField: String;
  CoData: TMjsCoReportsData);
var
	FieldIndex : Integer;
	pIndex : Integer;
begin
	FieldIndex := 0;
	pIndex := CoData.FormIndex;
	try
		if CheckFieldOnReport(pIndex,sField) then
		case pLeyoutType of
			ltToriDtl:		//	今回取引計
				FieldIndex := CoData.AddData(sField ,TOTAL_TORI);
			ltTegataDtl:	//	手形金額計
// <#032> ADD-STR
            	if (m_iCurrTegKbn = 2) then
	    			FieldIndex := CoData.AddData(sField ,TOTAL_ER_PRICE)
                else
// <#032> ADD-END
    				FieldIndex := CoData.AddData(sField ,TOTAL_PRICE);
			ltKoujyoDtl:	//	控除計
				FieldIndex := CoData.AddData(sField ,TOTAL_DED);
			ltJigyou,
			ltKijitsuDtl:	//	合計
				FieldIndex := CoData.AddData(sField ,TOTAL);
		end;
		CoRep_AlignCenter(CoData,FieldIndex);
		CoRep_FontRatio(CoData,FieldIndex);
	Except
	end;
end;

//**************************************************************************
//  Proccess    :   合計金額出力
//  Name        :   K.IKEMURA
//  Date        :	2001/12/14
//  Parameter   :	pLeyoutType : レイアウトパターン
//  			:	sField : 出力フィールド
//  			:	CoData : 出力CoRepData
//  Return      :	編集後のコード
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPay510100f.OutPutSum(pLeyoutType: TLayoutType;idx: integer;
  CoData: TMjsCoReportsData);
var
	FieldIndex : Integer;
    pIndex : Integer;
    sField1,sField2 : String;
    wSum: String;
begin
    pIndex := CoData.FormIndex;
    case pLeyoutType of
        ltToriDtl:		//	今回取引計
        begin
            sField1 := Format( CORPNM_HasseiKin + '%-d', [idx] );
            wSum := Edit_Kingaku(DMem_PayPlanData.FieldByName( 'SumTori').AsCurrency);	//	今回取引計
            try
                if CheckFieldOnReport(pIndex,sField1) then
                begin
                    FieldIndex := CoData.AddData(sField1 ,wSum);
                    CoRep_FontRatio(CoData,FieldIndex);
				end;
            Except
            end;
        end;
        ltTegataDtl:	//	手形金額計
        begin
            sField1 := Format( CORPNM_ShiharaiKin + '%-d', [idx] );
// <#032> MOD-STR
//          wSum := Edit_Kingaku(DMem_PayPlanData.FieldByName( 'SumNote').AsCurrency);	//	手形金額計
            wSum := Edit_Kingaku(m_nTegSubTotal);	            // 小計金額

            // 手形小計クリア
            m_nTegSubTotal := 0;
// <#032> MOD-END
            try
                if CheckFieldOnReport(pIndex,sField1) then
                begin
                    FieldIndex := CoData.AddData(sField1 ,wSum);
                    CoRep_FontRatio(CoData,FieldIndex);
                end;
            Except
            end;
        end;
        ltKoujyoDtl:	//	控除計
        begin
            sField1 := Format( CORPNM_Fee + '%-d', [idx] );
            wSum := Edit_Kingaku(DMem_PayPlanData.FieldByName( 'SumDed').AsCurrency);	//	控除計
            try
                if CheckFieldOnReport(pIndex,sField1) then
                begin
                    FieldIndex := CoData.AddData(sField1 ,wSum);
                    CoRep_FontRatio(CoData,FieldIndex);
                end;
            Except
            end;
        end;
		ltJigyou:
        begin
            sField1 := Format( CORPNM_BumonSateiKin + '%-d', [idx] );
            wSum := Edit_Kingaku(DMem_PayPlanData.FieldByName( 'SumBmnSatei').AsCurrency);	//	支払金額
            try		//	支払金額
                if CheckFieldOnReport(pIndex,sField1) then
                begin
                    FieldIndex := CoData.AddData(sField1 ,wSum);
                    CoRep_FontRatio(CoData,FieldIndex);
                end;
            Except
            end;
            sField2 := Format( CORPNM_BumonSousaiKin + '%-d', [idx] );
            wSum := Edit_Kingaku(DMem_PayPlanData.FieldByName( 'SumBmnSousai').AsCurrency);	//	相殺金額
            try		//	相殺金額
                if CheckFieldOnReport(pIndex,sField2) then
                begin
                    FieldIndex := CoData.AddData(sField2 ,wSum);
                    CoRep_FontRatio(CoData,FieldIndex);
                end;
            Except
            end;

        end;
        ltKijitsuDtl:
        begin
			//	金額
            sField1 := Format( CORPNM_KijituShiharaiKin + '%-d', [idx] );
            wSum := Edit_Kingaku(DMem_PayPlanData.FieldByName( 'SumKijSatei').AsCurrency);	//	金額
            try
                if CheckFieldOnReport(pIndex,sField1) then
                begin
                    FieldIndex := CoData.AddData(sField1 ,wSum);
                    CoRep_FontRatio(CoData,FieldIndex);
                end;
            Except
            end;

           	//	手数料
// 2006/08/01 <#008> Y.Naganuma Mod
{// 2005/11/25 <#003> Y.Kabashima Mod
//			//他社手数料控除区分(0:控除する)　かつ 手数料負担区分(1:他社負担)
//            if (CalcParam.BaseInfo6005 = 0) and
//               (DMem_PayPlanData.FieldByName('SumKijFee').AsCurrency > -1) then
			//他社手数料控除区分(0:控除する)
			if (CalcParam.BaseInfo6005 = 0) then
// 2005/11/25 <#003> Y.Kabashima Mod
}
			//他社手数料控除区分(0:控除する) かつ 手数料が０円より大きい場合
            if	(CalcParam.BaseInfo6005 = 0) and
				(DMem_PayPlanData.FieldByName('SumKijFee').AsCurrency > 0) then
// 2006/08/01 <#008> Y.Naganuma Mod
			begin
            	sField2 := Format( CORPNM_KijituTashaFee + '%-d', [idx] );
            	wSum := Edit_Kingaku(DMem_PayPlanData.FieldByName('SumKijFee').AsCurrency);	//	手数料
            	try
	                if CheckFieldOnReport(pIndex,sField2) then
    	            begin
        	            FieldIndex := CoData.AddData(sField2 ,wSum);
            	        CoRep_FontRatio(CoData,FieldIndex);
                	end;
	            Except
    	        end;
			end;
        end;
    end;
end;

//**************************************************************************
//  Proccess    :   合計出力行の取得
//  Name        :   K.IKEMURA
//  Date        :	2001/12/14
//  Parameter   :	MaxLine : レイアウトの最大行数
//  			:	RecCount : レコード数
//  Return      :	合計出力行
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPay510100f.GetOutputLine(RecCount, MaxLine: Integer;
  var iOutputLine: Integer): Boolean;
begin
    Result := False;

    if	(RecCount = MaxLine) or
		(RecCount = 0      ) then			//	改頁
        iOutputLine := 1
    else if (RecCount) = (MaxLine-1) then	//	最終行
        iOutputLine := MaxLine
    else if (1 <= RecCount) and (RecCount <= (MaxLine-2)) then
        iOutputLine := (RecCount+2)			//	現在位置より一行あけた行
    else Exit;

    Result := True;
end;

//**************************************************************************
//  Component   :   BPrint
//  Event       :	OnClick
//  Name        :   K.IKEMURA
//**************************************************************************
procedure TPay510100f.BPrintClick(Sender: TObject);
begin
    PrintCtl();
end;

//**************************************************************************
//  Proccess    :   印刷処理
//  Name        :   K.Ikemura
//  Date        :	2001/12/14
//  Parameter   :
//  Return      :
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPay510100f.DoPrint();
var
    iRtn	:   Integer;
	MsgRec  :   TMjsMsgRec;
	iIdx 	:	Integer;
begin
	for iIdx := 0 to 4 do
    begin
		bFirstFormMaxLineGetFlg[iIdx]	:= False;
		iFirstFormMaxLine[iIdx]			:= 0;
		bSecondFormMaxLineGetFlg[iIdx]	:= False;
		iSecondFormMaxLine[iIdx]		:= 0;
    end;
	CreatePropertyObj;

    bPrintCancel 			:= FALSE;

    with CoReportsPrintObj do
    begin
        OpenPrint(CrDraw1);
        ParentForm 			:= Self;    //Application.MainForm
        PrintAbortedProc 	:= AbortingPrint;

        if m_DlgParam.Layout = 1 then   //	手形送付案内時のみ分割印刷対応
        begin
            DivisionRowCount := TEGATAROWCOUNT;		// 分割行数
            DivisionColumnCount := 1;  				// 分割列数（Default）
        end;
    end;

    m_PrnSupport.iSysCode               := m_pRec^.m_iSystemCode;
	m_PrnSupport.iReportID              := 230300;
	m_PrnSupport.MdataModule            := m_DataModule;
	m_PrnSupport.pComArea               := m_pRec^.m_pCommonArea;
	m_PrnSupport.ApRB                   := Nil;
    m_PrnSupport.MjsCoRep               := CoReportsPrintObj;
    m_PrnSupport.MjsCoProper            := PropertyObj[0];
    m_PrnSupport.iManuscriptSize        := PropertyObj[0].ManuscriptSize;
    m_PrnSupport.iOrientation           := PropertyObj[0].Orientation;		// 用紙方向
    m_PrnSupport.iDspPreviewBtn         := 0;       //プレビューボタン
	m_PrnSupport.iDspFileBtn            := 0;       //ファイル出力非表示
    m_PrnSupport.iEnableCorpNameCombo   := 1;		//会社名ｺﾝﾎﾞﾎﾞｯｸｽ非表示
    m_PrnSupport.iEnableCorpCodeCombo   := 1;		//会社ｺｰﾄﾞｺﾝﾎﾞﾎﾞｯｸｽ非表示
    m_PrnSupport.iEnableDateCombo       := 1;		//日時ｺﾝﾎﾞﾎﾞｯｸｽ非表示
    m_PrnSupport.iEnablePageCombo       := 1;		//ﾍﾟｰｼﾞｺﾝﾎﾞﾎﾞｯｸｽ非表示
    m_PrnSupport.iDspOfficeBtn          := 1;       //会計事務所ﾁｪｯｸﾎﾞｯｸｽ非表示

    m_PrnSupport.pApRec                 := m_pRec;  // <#013> ADD

	//印刷ﾀﾞｲｱﾛｸﾞの両面印刷を無効にする
   	m_PrnSupport.iFixDuplex       		:= 1;     	//両面無効

    case m_DlgParam.Layout of
    	0: m_PrnSupport.strDocName      := '支払通知書' ;
    	1: m_PrnSupport.strDocName      := '手形送付案内' ;
    	2: m_PrnSupport.strDocName      := '書留郵便受領証' ;
    	3: m_PrnSupport.strDocName      := 'タックシール' ;     // <#024> ADD
    else Exit;
    end;

// <#017> ADD-STR
    // 印刷履歴スプール情報セット
    InitPrintDocName(m_rPrintDocName);
    SetPrintSystemCode(m_rPrintDocName, 1);
    if (EPayDataName.Visible) then
        SetPrintDataName(m_rPrintDocName, EPayDataName.Text);
    SetPrintPayDay(m_rPrintDocName, m_iPayDate, m_DTMAIN.YearKbn);
    SetPrintRepoName(m_rPrintDocName, m_PrnSupport.strDocName);
	with CalcParam do
	begin
        case OutputNo of
            0: SetPrintAddInfoFromText(m_rPrintDocName, '支払通知書');
            1: SetPrintAddInfoFromText(m_rPrintDocName, '支払通知書(送付)');
            2: SetPrintAddInfoFromText(m_rPrintDocName, '支払通知書(簡略)');
            3: SetPrintAddInfoFromText(m_rPrintDocName, '支払通知書(手形あり)');
            4: SetPrintAddInfoFromText(m_rPrintDocName, '支払通知書(手形なし)');
            5: SetPrintAddInfoFromText(m_rPrintDocName, '支払通知書(期日指定振込)');
            6: SetPrintAddInfoFromText(m_rPrintDocName, '支払通知書(名寄せ用)');
        end;
        SetPrintAddInfoFromDate(m_rPrintDocName, StrToDate(m_DlgParam.PrnDate));
        case Order of
            0: SetPrintAddInfoFromText(m_rPrintDocName, '支払先順');
            1: SetPrintAddInfoFromText(m_rPrintDocName, '連想順');
        end;
        case LetterKbn of
            0: SetPrintAddInfoFromText(m_rPrintDocName, '全て');
            1: SetPrintAddInfoFromText(m_rPrintDocName, '標準');
            2: SetPrintAddInfoFromText(m_rPrintDocName, '送付用');
            3: SetPrintAddInfoFromText(m_rPrintDocName, '集金用');
            4: SetPrintAddInfoFromText(m_rPrintDocName, 'その他');
        end;
// <#024> MOD-STR
//      if (OutputNo = 7) or (OutputNo = 8) then
        if (OutputNo = 7) or (OutputNo = 8) or (OutputNo = 9) then
// <#024> MOD-END
        begin
            case YusouKbn of
                0: SetPrintAddInfoFromText(m_rPrintDocName, '郵送する');
                1: SetPrintAddInfoFromText(m_rPrintDocName, '郵送しない');
                2: SetPrintAddInfoFromText(m_rPrintDocName, '全て');
            end;
        end;
	end;
    m_PrnSupport.strDocName := GetPrintDocName(m_rPrintDocName);
// <#017> ADD-END

    iRtn := m_PrnDlg.DoDLG(m_PrnSupport);

    if iRtn > 0 then
    begin
        if (m_Preview.IsExistPreview ) and
           (m_PrnSupport.iCommand = PDLG_PREVIEW ) then
        begin
            TMasCom(m_pRec^.m_pSystemArea^).m_MsgStd.GetMsg(MsgRec,10040,1);
            MjsMessageBoxEx(Self, MsgRec.sMsg,
                            MsgRec.sTitle,
                            MsgRec.icontype,
                            MsgRec.btntype,
                            MsgRec.btndef,
                            MsgRec.LogType );
            PropertyObj[0].free;
            Exit;
        end;

        case m_PrnSupport.iCommand of
            PDLG_PRINT,
            PDLG_PREVIEW:
            begin
                if m_PrnSupport.iCommand = PDLG_PREVIEW then
                begin
                    if m_Preview.StartPreview(m_PrnSupport) < 0 then
                    begin
                        PropertyObj[0].free;
                        Exit;
                    end;

                    CoReportsPrintObj.PreviewFlag:=1;
                end
                else
                    CoReportsPrintObj.PreviewFlag:=0;

                // プリント開始
                CoReportsPrintObj.StartDialog;
                CoReportsPrintObj.StartPrintPhase;

                //シーオーレポートファイル選択
				SetFormFile;

                case m_DlgParam.Layout of
                	0:
                    begin
                        for iIdx := 0 to 4 do
						begin
							if 	PropertyObj[iIdx].FormFileName = ' ' then
								iFormIndex[iIdx] := -1
							else
							begin
								//印刷ダイアログで指定した用紙サイズを他のオブジェクトに反映させる
								if iIdx > 0 then
									PropertyObj[iIdx].PaperSize   :=  PropertyObj[0].PaperSize;
								iFormIndex[iIdx] := CoReportsPrintObj.SetPropertyObject(PropertyObj[iIdx]);
							end;
						end;
                    end;
// <#024> MOD-STR
//                  1,2:
                    1,2,3:
// <#024> MOD-END
                    begin
                        iFormIndex[0] := CoReportsPrintObj.SetPropertyObject(PropertyObj[0]);
                    end;
                end;

                CoReportsPrintObj.StartPrint;

                m_nTegSubTotal := 0;                // 手形金額小計クリア <#034> MOV

            	m_sTegataExistGCode := '';          // <#037> ADD

                // ＣｏＲｅｐｏｒｔデータ部作成
                case m_DlgParam.Layout of
				    0:  // 支払通知書
						SetPayData(iFormIndex[0]);
                    1:  // 手形送付案内
                        SetTegataData(iFormIndex[0]);
                    2:  // 書留郵便物受領証
                        SetKakitomeCSVData(iFormIndex[0]);
// <#024> ADD-STR
                    3:  // タックシール
                        SetTackSealCSVData(iFormIndex[0]);
// <#024> ADD-END
					else exit;
                end;

                // プリント終了
                CoReportsPrintObj.EndPrint;
                CoReportsPrintObj.EndPrintPhase;

                while True do
                begin
// 2005/11/02 <#001> Y.Kabashima Mod
//					Application.ProcessMessages;
					Manager.ProcessMessages;
// 2005/11/02 <#001> Y.Kabashima Mod

                    if CoReportsPrintObj.IsPrinting = 0 then
						break;
                    if bPrintCancel = TRUE then
				   		break;
                end;

                // プリントダイアログ終了
                CoReportsPrintObj.EndDialog;
                CoReportsPrintObj.ClosePrint;

                if m_PrnSupport.iCommand = PDLG_PREVIEW then
					m_Preview.EndPreview();
            end;
			else
			begin
// 2005/11/02 <#001> Y.Kabashima Add
				PropertyObj[0].free;
				Exit;
// 2005/11/02 <#001> Y.Kabashima Add
			end;
        end;
    end
    else
    begin
        ShowMessage('印刷確認でエラーが発生しました。');

        case m_DlgParam.Layout of
            0:		//支払通知書
            begin
                for iIdx := 0 to 4 do
				begin
                    if PropertyObj[iIdx] <> nil then
                        PropertyObj[iIdx].Free;
				end;
            end;
// <#024> MOD-STR
//          1,2:	//手形送付案内、書留郵便物受領証
            1,2,3:	//手形送付案内、書留郵便物受領証、タックシール
// <#024> MOD-END
            begin
                if PropertyObj[0] <> nil then
                    PropertyObj[0].Free;
            end;
        end;
    end;
end;

//**************************************************************************
//  Proccess    :   印刷プロパティオブジェクト作成
//  Name        :   K.Ikemura
//  Date        :	2001/12/14
//  Parameter   :
//  Return      :
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPay510100f.CreatePropertyObj;
var
	iIdx : Integer;
	CrDraw  :CoReports_TLB.TCrDraw;
begin
    CrDraw := CoReports_TLB.TCrDraw.Create(Self);	//Application.MainForm
    try
	    case m_DlgParam.Layout of
    	    0:		// 支払通知書
        	begin
				//支払通知書（期日指定振込）の場合も、取引明細を出力させる
	            for iIdx := 0 to 4 do
    	        begin
        	        PropertyObj[iIdx] := MjsCoReportsProperty3.TMjsCoReportsProperty.Create;
            	    if iIdx > 0 then
                	    PropertyObj[iIdx].Assign(PropertyObj[0]);

					PropertyObj[iIdx].ManuscriptSize    := CrDraw.OpenForm(m_LayoutInfo.BasicLayout).PaperSize;
					PropertyObj[iIdx].Orientation       := CrDraw.OpenForm(m_LayoutInfo.BasicLayout).Orientation;
        	    end;
	        end;
// <#024> MOD-STR
//    	    1,2:	// 手形通知書、書留郵便物受領証
    	    1,2,3:	// 手形通知書、書留郵便物受領証、タックシール
// <#024> MOD-END
        	begin
            	PropertyObj[0] := MjsCoReportsProperty3.TMjsCoReportsProperty.Create;
				PropertyObj[0].ManuscriptSize    := CrDraw.OpenForm(m_LayoutInfo.BasicLayout).PaperSize;
				PropertyObj[0].Orientation       := CrDraw.OpenForm(m_LayoutInfo.BasicLayout).Orientation;
        	end;
	    end;
    finally
        CrDraw.Free;
    end;
end;

//**************************************************************************
//  Proccess    :   フォームファイル設定
//  Name        :   K.Ikemura
//  Date        :	2001/12/14
//  Parameter   :
//  Return      :
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPay510100f.SetFormFile;
begin
    case m_DlgParam.Layout of
        0:  	// 支払通知書
        begin
            with m_LayoutInfo do
            begin
                case m_DlgParam.LayoutPtn of
                    0..6:
                    begin
                        PropertyObj[0].FormFileName := BasicLayout; //基本レイアウト
                        PropertyObj[1].FormFileName := ToriDtl;		//取引明細
                        PropertyObj[2].FormFileName := TegataDtl;	//手形明細
                        PropertyObj[3].FormFileName := KoujoDtl;	//控除明細 OR 事業所内訳
                        PropertyObj[4].FormFileName := KijitsuDtl;	//期日指定振込残高
                    end;
                    else
                    	Exit;
                end;
            end;
		end;
// <#024> MOD-STR
//      1,2:	//	手形送付案内,書留郵便物受領証
        1,2,3:	//	手形送付案内,書留郵便物受領証、タックシール
// <#024> MOD-END
        begin
            PropertyObj[0].FormFileName := m_LayoutInfo.BasicLayout; //基本レイアウト
        end;
	end;
end;

//**************************************************************************
//  Proccess    :   TMjsCoReportsDataクラス生成
//  Name        :   K.Ikemura
//  Date        :	2001/12/14
//  Parameter   :
//  Return      :
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPay510100f.CreateCoRepData(pLayoutType: TLayoutType);
begin
    case pLayoutType of
        ltBasic:
        begin
            //	基本レイアウト
            CoRepData 	  := MjsCoReportsData3.TMjsCoReportsData.Create;
            CoRepData.LayerNameList.Add(GetBasicLayout);
            CoRepData.FormIndex := iFormIndex[0];
        end;
        ltToriDtl:
        begin
            //	取引明細
            CoRepDataTori 	  := MjsCoReportsData3.TMjsCoReportsData.Create;
            CoRepDataTori.LayerNameList.Add(TORIDETAIL);
            CoRepDataTori.FormIndex := iFormIndex[1];
        end;
        ltTegataDtl:
        begin
            //	手形明細
            CoRepDataTeg  := MjsCoReportsData3.TMjsCoReportsData.Create;
            CoRepDataTeg.LayerNameList.Add(TEGDETAIL);
            CoRepDataTeg.FormIndex := iFormIndex[2];
        end;
        ltKoujyoDtl:
        begin
            //	控除明細
            CoRepDataKoujyo  := MjsCoReportsData3.TMjsCoReportsData.Create;
            CoRepDataKoujyo.LayerNameList.Add(KOUJYOIDETAIL);
            CoRepDataKoujyo.FormIndex := iFormIndex[3];
        end;
		ltJigyou:
        begin
            //	事業所明細
            CoRepDataJigyou  := MjsCoReportsData3.TMjsCoReportsData.Create;
            CoRepDataJigyou.LayerNameList.Add(JIGYOUDETAIL);
            CoRepDataJigyou.FormIndex := iFormIndex[3];
        end;
        ltKijitsuDtl:
        begin
            //	期日指定振込残高
            CoRepDataKijitsu  := MjsCoReportsData3.TMjsCoReportsData.Create;
            CoRepDataKijitsu.LayerNameList.Add(KIJITSUDETAIL);
            CoRepDataKijitsu.FormIndex := iFormIndex[4];
        end;
    end;
end;

//**************************************************************************
//	Proccess  :	アボート処理
//	Name	  :	K.Ikemura
//	Date	  :	2001/12/14
//	Parameter :
//	Retrun	  :
//	History	　:	9999/99/99	X.Xxxxxx
//				XXXXXXXX修正内容
//**************************************************************************
procedure TPay510100f.AbortingPrint;
begin
    bPrintCancel := TRUE;
end;

//**************************************************************************
//	Proccess  :	支払通知書
//	Name	  :	K.Ikemura
//	Date	  :	2001/12/14
//	Parameter : pIndex (標準レイアウトのFormIdx)
//	Retrun	  :
//	History	　:	9999/99/99
//**************************************************************************
procedure TPay510100f.SetPayData(pIndex: Integer);
var
	//	改頁フラグ
	bNextPageDed	:	Boolean;	//	控除明細
	bNextPageTori	:	Boolean;	//	取引明細
	bNextPageNote	:	Boolean;	//	手形明細
	bNextPageBumon	:	Boolean;	//	事業所内訳
	bNextPageKijitu	:	Boolean;	//	期日指定振込残高

	sGCode : String;
begin
	try
		DMem_CSInfo.First;

		while DMem_CSInfo.Eof <> True do
		begin
			sGCode := DMem_CSInfo.FieldByName('GCode').AsString;
			iPageCnt := 0;
// <#040> ADD-STR
            // 支払先別の手形金額小計をクリア
            m_nTegSubTotal := 0;
// <#040> ADD-END

			//支払先各設定
			CreateCoRepData(ltBasic);
			CreateCoRepData(ltToriDtl);
			CreateCoRepData(ltTegataDtl);

			if m_DlgParam.LayoutPtn <> 5 then	//	通知書（控除なし）以外のレイアウト
				CreateCoRepData(ltKoujyoDtl)
			else								//	通知書（控除なし）
			begin
				CreateCoRepData(ltJigyou);
                CreateCoRepData(ltKijitsuDtl);
            end;

            bNextPageDed	:= False;
            bNextPageTori	:= False;
            bNextPageNote	:= False;
		    bNextPageBumon	:= False;
            bNextPageKijitu := False;

            //	( 基本レイアウト )
            //	支払先情報設定
            SetData_CSInfo(CoRepData);

			//	金額設定
		    if FindPayPlan(sGcode) then
	            SetData_PayPrice(pIndex);

            //	内訳情報設定
		    if FindUchiwake(sGCode) then
	            SetData_Uchiwake(pIndex);

			//	取引明細設定
			if FindTori(sGCode) then
			begin
				if not SetData_ToriDetail(pIndex) then
					bNextPageTori := True;
			end;

// <#034> MOV   m_nTegSubTotal := 0;                // 手形金額小計クリア <#032> ADD

			//	手形明細設定
			if FindTegata(sGCode) then
			begin
				if not SetData_TegataDetail(pIndex) then
					bNextPageNote := True;
			end;

			if m_DlgParam.LayoutPtn <> 5 then	//	通知書（控除なし）以外のレイアウト
			begin
				//	控除情報設定
				if FindKoujyo(sGCode) then
				begin
					if not SetData_Koujyo(pIndex) then
						bNextPageDed := True;
				end;
            end
            else    							//	通知書（控除なし）レイアウト
            begin
				//	事業所内訳設定
				if FindJigyo(sGCode) then
				begin
					if not SetData_Jigyosho(pIndex) then
						bNextPageBumon := True;
				end;
				//	期日指定振込残高
                if FindKijitsu(sGCode) then
                begin
                    if not SetData_Kijitsu(pIndex) then
                        bNextPageKijitu := True;
                end;
            end;

            //	自社情報設定
            SetData_DTMAIN(CoRepData);

            //	文書
            SetData_Bunsho(pIndex);

            // 1ページ印刷
            SetPageCnt(CoRepData);
            CoReportsPrintObj.AddData(CoRepData);

			{支払通知書（期日指定振込）の場合も、取引明細を出力させる}
            //	( 次ページへデータセット )
			if 	iFormIndex[1] <> -1 then	// 出力しない設定になっている
			begin
				//	取引明細レイアウトにも出力しているか？
				if bNextPageTori then
					SetData_ToriDetailAdd(iFormIndex[1]);
			end;						// <#4> M.Tarui Add

			if 	iFormIndex[2] <> -1 then	// 出力しない設定になっている
			begin
				//	手形明細レイアウトにも出力しているか？
				if bNextPageNote then
					SetData_TegDetailAdd(iFormIndex[2]);
			end;						// <#4> M.Tarui Add

			if 	iFormIndex[3] <> -1 then	// 出力しない設定になっている
			begin
				//	控除明細レイアウトにも出力しているか？
				if bNextPageDed then
					SetData_KoujyoDetailAdd(iFormIndex[3]);

				//	事業所内訳明細レイアウトにも出力しているか？
				if bNextPageBumon then
					SetData_JigyouDetailAdd(iFormIndex[3]);
			end;						// <#4> M.Tarui Add

			if 	iFormIndex[4] <> -1 then	// 出力しない設定になっている
			begin
				//	期日支払残高レイアウトにも出力しているか？
				if bNextPageKijitu then
					SetData_KijitsuDetailAdd(iFormIndex[4]);
			end;

            DMem_CSInfo.Next;
        end;
    except
        if m_PrnSupport.iCommand = PDLG_PREVIEW then
            m_Preview.EndPreview();
    end;
end;

//**************************************************************************
//	Proccess  :	手形送付案内(支払先レコード検索処理)
//	Name	  :	K.Ikemura
//	Date	  :	2001/12/14
//	Parameter : pIndex (標準レイアウトのFormIdx)
//	Retrun	  :
//	History	　:	9999/99/99
//**************************************************************************
function TPay510100f.FindTegata(pGcode: String):Boolean;
begin
   	Result := False;
	with DMem_Teg do
    begin
    	First;
        while (Eof <> True) do
        begin
			if FieldByName('GCode').AsString = pGcode then
            begin
            	Result := True;
            	m_sTegataExistGCode := pGcode;      // <#037> ADD
            	Exit;
            end;
        	Next;
        end;
    end;
end;

//**************************************************************************
//	Proccess  :	手形送付案内、手形明細(支払先レコード検索処理)
//	Name	  :	K.Ikemura
//	Date	  :	2001/12/14
//	Parameter : pIndex (標準レイアウトのFormIdx)
//	Retrun	  :
//	History	　:	9999/99/99
//**************************************************************************
function TPay510100f.NextTegata(pGcode: String):Boolean;
begin
   	Result := False;
	with DMem_Teg do
    begin
        Next;

        while (Eof <> True) do
        begin
			if FieldByName('GCode').AsString = pGcode then
            begin
            	Result := True;
            	Exit;
            end;
        	Next;
        end;
    end;
end;

//**************************************************************************
//	Proccess  :	手形送付案内、手形明細
//	Name	  :	K.Ikemura
//	Date	  :	2001/12/14
//	Parameter : pIndex (標準レイアウトのFormIdx)
//	Retrun	  :
//	History	　:	9999/99/99
//**************************************************************************
procedure TPay510100f.SetTegataData(pIndex: Integer);
begin
    DMem_CSInfo.First;
    with m_DlgParam do
    begin
        if PageChangChk = 0 then				//	連続印刷
        	PrintTegata_Contenue(pIndex)
        else if PageChangChk = 1 then			//	支払先毎に改頁
            PrintTegata_PageChange(pIndex);
    end;
end;

//**************************************************************************
//	Proccess  :	手形送付案内 （連続印刷）
//	Name	  :	K.Ikemura
//	Date	  :	2001/12/14
//	Parameter : pIndex (標準レイアウトのFormIdx)
//	Retrun	  :
//	History	　:	9999/99/99
//**************************************************************************
procedure TPay510100f.PrintTegata_Contenue(pIndex: Integer);
	function GetValue(DataCnt:Integer):Boolean;
    begin
        Result := (DataCnt = TEGATAROWCOUNT);
    end;

    //	カラム取得
    function GetDataCnt( i : Integer):integer;
    begin
		if i >= TEGATAROWCOUNT then
        	Result := 0
        else
        	Result := i;
    end;

    //	CoRepData生成
    procedure CreateCoRepTeg(var iDataCnt : Integer);
    begin
        CoRepData 	  := MjsCoReportsData3.TMjsCoReportsData.Create;
        CoRepData.LayerNameList.Add(TEGSENDINFO);
        CoRepData.FormIndex := iFormIndex[0];

        iDataCnt := GetDataCnt(iDataCnt);
        CoRepData.DivisionRow := iDataCnt;
        CoRepData.DivisionColumn := 0;

        m_RenCnt := iDataCnt;

		inc(iDataCnt);

        //	支払先情報設定
        SetData_CSInfo(CoRepData);
        //	文書
        SetData_Bunsho(pIndex);
        //	自社情報設定
        SetData_DTMAIN(CoRepData);
        SetPageCnt(CoRepData);
    end;

   	//	合計行出力
    procedure SetSum;
	var
	    Layout : TLayoutType;
		sField	:	String;
	begin
		Layout := ltTegataDtl;
        sField		:=	Format( CORPNM_PayPlace + '%-d', [iOutPutLastRow] );
        OutPutTotal(Layout,sField,CoRepData);
        OutPutSum(Layout,iOutPutLastRow,CoRepData);
    end;
var
	DataCnt : Integer;
    sGcode : String;
begin
    iOutPutLastRow := 0;
    DataCnt := 0;
    m_RenCnt:= 0;

	try
		sGcode := DMem_CSInfo.FieldByName('GCode').AsString;
        (*支払先が変わっても改頁なし連続で出力*)
        iPageCnt := 0;

        if FindTegata(sGcode) then
		begin
	        while (DMem_Teg.Eof <> True) do
    	    begin
        	    CreateCoRepTeg(DataCnt);
            	//	手形明細設定
	            if SetData_TegataDetail(pIndex) then
    	        begin	//	合計行出力あり
        	        //	改カラム必要時処理
            	    if iOutPutLastRow = 1 then
                	begin
                    	CoReportsPrintObj.AddData( CoRepData,GetValue(DataCnt)) ;
	                    CreateCoRepTeg(DataCnt);
    	            end;

        	        //	指定行に合計設定
            	    //	金額設定
                	if FindPayPlan(DMem_CSInfo.FieldByName('GCode').AsString) then
		                SetSum;

	                //	最終データの場合は無条件に出力
    	            DMem_CSInfo.Next;
        	        if DMem_CSInfo.Eof then
            	    begin
                	    CoReportsPrintObj.AddData( CoRepData,True) ;
                    	Exit;
	                end
    	            else
        	        begin
            	        CoReportsPrintObj.AddData( CoRepData,GetValue(DataCnt)) ;

                	    sGcode := DMem_CSInfo.FieldByName('GCode').AsString;
	                    //	次の支払先検索
    	                if FindTegata(sGcode) then
        	            begin
            	            //	合計出力行の初期化
							iPageCnt := 0;											//<#1>
                    	    iOutPutLastRow := 0;
                        	Continue;
	                    end
	                    else
        	            	 Exit;
                	end;
	            end;
	   	        CoReportsPrintObj.AddData( CoRepData,GetValue(DataCnt)) ;
	        end;	//end while
    	end;		//end if
    except
        if m_PrnSupport.iCommand = PDLG_PREVIEW then
            m_Preview.EndPreview();
    end;
end;

//**************************************************************************
//	Proccess  :	手形送付案内 （支払先ごと改頁）
//	Name	  :	K.Ikemura
//	Date	  :	2001/12/14
//	Parameter : pIndex (標準レイアウトのFormIdx)
//	Retrun	  :
//	History	　:	9999/99/99
//**************************************************************************
procedure TPay510100f.PrintTegata_PageChange(pIndex: Integer);
	function GetValue(DataCnt:Integer):Boolean;
    begin
        Result := (DataCnt = TEGATAROWCOUNT);
    end;

    //	カラム取得
    function GetDataCnt( i : Integer):integer;
    begin
		if i >= TEGATAROWCOUNT then
        	Result := 0
        else
        	Result := i;
    end;

    //	CoRepData生成
    procedure CreateCoRepTeg(var iDataCnt : Integer);
    begin
        CoRepData 	  := MjsCoReportsData3.TMjsCoReportsData.Create;
        CoRepData.LayerNameList.Add(TEGSENDINFO);
        CoRepData.FormIndex := iFormIndex[0];

        iDataCnt := GetDataCnt(iDataCnt);
        CoRepData.DivisionRow := iDataCnt;
        CoRepData.DivisionColumn := 0;

		//連続出力の場合、折り目区切り線の重複があるため判定する
        m_RenCnt := iDataCnt;

		inc(iDataCnt);

        //	支払先情報設定
        SetData_CSInfo(CoRepData);
        //	文書
        SetData_Bunsho(pIndex);
        //	自社情報設定
        SetData_DTMAIN(CoRepData);
        SetPageCnt(CoRepData);

    end;

   	//	合計行出力
    procedure SetSum;
	var
	    Layout : TLayoutType;
		sField	:	String;
	begin
		Layout := ltTegataDtl;

        sField		:=	Format( CORPNM_PayPlace + '%-d', [iOutPutLastRow] );
        OutPutTotal(Layout,sField,CoRepData);
        OutPutSum(Layout,iOutPutLastRow,CoRepData);
    end;
var
	DataCnt : Integer;
    sGcode : String;
begin
    iOutPutLastRow 	:= 0;
    DataCnt 		:= 0;
    m_RenCnt		:= 0;

	try
		sGcode := DMem_CSInfo.FieldByName('GCode').AsString;

        (*支払先が変わる = 改頁出力*)
        iPageCnt := 0;

        if FindTegata(sGcode) then
		begin
	        while (DMem_Teg.Eof <> True) do
    	    begin
        	    CreateCoRepTeg(DataCnt);
            	//	手形明細設定
	            if SetData_TegataDetail(pIndex) then
    	        begin
					{合計行出力あり}
            	    //	改カラム必要時処理
                	if iOutPutLastRow = 1 then
	                begin
    	                CoReportsPrintObj.AddData( CoRepData,GetValue(DataCnt)) ;
        	            CreateCoRepTeg(DataCnt);
            	    end;

	                //	指定行に合計設定
    	            //	金額設定
        	        if FindPayPlan(DMem_CSInfo.FieldByName('GCode').AsString) then SetSum;

            	    CoReportsPrintObj.AddData( CoRepData,True);

                	DMem_CSInfo.Next;
	                if DMem_CSInfo.Eof then
    	                Exit
        	        else
            	    begin
                	    sGcode := DMem_CSInfo.FieldByName('GCode').AsString;

                    	//	次の支払先検索
	                    if FindTegata(sGcode) then
    	                begin
        	                //	合計出力行の初期化
					        iPageCnt := 0;
                	        DataCnt := 0;
                    	    iOutPutLastRow := 0;
                        	Continue;
	                    end;
    	            end;
        	    end;
            	CoReportsPrintObj.AddData( CoRepData,GetValue(DataCnt)) ;
	        end;		//end while
		end;			//end if
    except
        if m_PrnSupport.iCommand = PDLG_PREVIEW then
            m_Preview.EndPreview();
    end;
end;

//**************************************************************************
//	Proccess  :	書留郵便物受領証
//	Name	  :	K.Ikemura
//	Date	  :	2001/12/14
//	Parameter : pIndex (標準レイアウトのFormIdx)
//	Retrun	  :
//	History	　:	9999/99/99
//**************************************************************************
procedure TPay510100f.SetKakitomeCSVData(pIndex: Integer);
    //	CoRepData生成
    procedure CreateCoRepMail;
    begin
        // 印刷対象レイヤ
        CoRepData 	  := TMjsCoReportsData.Create;
        //	基本レイアウト
        CoRepData.LayerNameList.Add(KAKITOME);
        CoRepData.FormIndex := iFormIndex[0];
        //	自社情報設定
        SetData_DTMAIN(CoRepData);
    end;
begin
	try
	    DMem_Kakitome.First;
		while not DMem_Kakitome.Eof do
        begin
			CreateCoRepMail;

	       	if SetData_Kakitome(pIndex) then
            begin
                CoReportsPrintObj.AddData( CoRepData );
                Exit;
            end
            else
                CoReportsPrintObj.AddData( CoRepData );
        end;
    except
        if m_PrnSupport.iCommand = PDLG_PREVIEW then
            m_Preview.EndPreview();
    end;
end;

//**************************************************************************
//	Proccess  :	CoReport公開プロパティオブジェクト(長体使用)変更
//	Name	  :	K.Ikemura
//	Date	  :	2001/12/14
//	Parameter : pIndex  :   フィールドのインデックス
//	Retrun	  :
//	History	　:	9999/99/99	X.XXXX
//				XXXXXXXX修正内容
//**************************************************************************
procedure TPay510100f.CoRep_FontRatio(wCoRepData : TMjsCoReportsData;pIndex: Integer);
var
    CoRepFieldProp  :   TMjsCoReportsFieldProperty;
begin
    CoRepFieldProp := wCoRepData.GetfieldProperty(pIndex);
    CoRepFieldProp.MjsFontRatioAuto    := True;     // 長体使用有無
    CoRepFieldProp.MjsFontRatioMinimum := 50;       // 長体率下限
end;

//**************************************************************************
//	Proccess  :	CoReport公開プロパティオブジェクト(中央設定)変更
//	Name	  :	K.Ikemura
//	Date	  :	2002/03/12
//	Parameter : pIndex  :   フィールドのインデックス
//	Retrun	  :
//	History	　:	9999/99/99	X.XXXX
//				XXXXXXXX修正内容
//**************************************************************************
procedure TPay510100f.CoRep_AlignCenter(wCoRepData: TMjsCoReportsData;
  pIndex: Integer);
var
    CoRepFieldProp  :   TMjsCoReportsFieldProperty;
begin
    CoRepFieldProp := wCoRepData.GetfieldProperty(pIndex);
    CoRepFieldProp.Alignment    := corAlignCenter;
end;

//**************************************************************************
//	Proccess  :	CoReport公開プロパティオブジェクト(左詰設定)変更
//	Name	  :	K.Ikemura
//	Date	  :	2002/03/12
//	Parameter : pIndex  :   フィールドのインデックス
//	Retrun	  :
//	History	　:	9999/99/99	X.XXXX
//				XXXXXXXX修正内容
//**************************************************************************
procedure TPay510100f.CoRep_AlignLeft(wCoRepData: TMjsCoReportsData;
  pIndex: Integer);
var
    CoRepFieldProp  :   TMjsCoReportsFieldProperty;
begin
    CoRepFieldProp := wCoRepData.GetfieldProperty(pIndex);
    CoRepFieldProp.Alignment    := corAlignLeft;
end;

// <#012> 2008/03/26 T.Kawahata Add
//**************************************************************************
//	Proccess  :	CoReport公開プロパティオブジェクト(右詰設定)変更
//	Name	  :	T.Kawahata
//	Date	  :	2008/03/28
//	Parameter : pIndex  :   フィールドのインデックス
//	Retrun	  :
//	History	　:	9999/99/99	X.XXXX
//				XXXXXXXX修正内容
//**************************************************************************
procedure TPay510100f.CoRep_AlignRight(wCoRepData: TMjsCoReportsData;
  pIndex: Integer);
var
    CoRepFieldProp  :   TMjsCoReportsFieldProperty;
begin
    CoRepFieldProp := wCoRepData.GetfieldProperty(pIndex);
    CoRepFieldProp.Alignment    := corAlignRight;
end;
// <#012> 2008/03/26 T.Kawahata Add

// <#027> ADD-STR
//**************************************************************************
//	Proccess  :	CoReport公開プロパティオブジェクト(均等割設定)変更
//	Name	  :	T.SATOH(GSOL)
//	Date	  :	2011/05/19
//	Parameter : pIndex  :   フィールドのインデックス
//	Retrun	  :
//	History	　:	9999/99/99	X.XXXX
//				XXXXXXXX修正内容
//**************************************************************************
procedure TPay510100f.CoRep_AlignEven(wCoRepData: TMjsCoReportsData;
  pIndex: Integer);
var
    CoRepFieldProp  :   TMjsCoReportsFieldProperty;
begin
    CoRepFieldProp := wCoRepData.GetfieldProperty(pIndex);
    CoRepFieldProp.Alignment    := corAlignEven;
end;
// <#027> ADD-END

//**********************************************************************
//*		Proccess	:  管理NO.編集処理
//*		Name		:  K.Ikemura
//*		Create		:  2002/02/08
//*		Parameter   :
//*		Return		:
//*		History		:  9999/99/99	X.Xxxx
//*									XXXXXXXXXXXXXXXXXX
//**********************************************************************
procedure TPay510100f.CoRep_KanriNo(wCoRepData : TMjsCoReportsData;pIndex: Integer);
var
    CoRepFieldProp  :   TMjsCoReportsFieldProperty;
begin
	//無条件に左寄せに設定
    CoRepFieldProp 			:= wCoRepData.GetfieldProperty(pIndex);
	CoRepFieldProp.Alignment:= corAlignLeft;
end;

// 2005/11/02 <#001> Y.Kabashima Del 未使用の為
{//**********************************************************************
//*		Proccess	:  取引先NO.編集処理
//*		Name		:  K.Ikemura
//*		Create		:  2002/02/08
//*		Parameter   :
//*		Return		:
//*		History		:  9999/99/99	X.Xxxx
//*									XXXXXXXXXXXXXXXXXX
//**********************************************************************
procedure TPay510100f.CodeEdit(var Code: String);
begin
	if Code = '' then Exit;

	case m_MasterInfo.CodeDigit of
	  0: Code := MjsEditNum(StrToInt64Def(Code,0), 'C__0', m_MasterInfo.CodeDigit);
	  1: Code := MjsEditNum(StrToInt64Def(Code,0), '___0', m_MasterInfo.CodeDigit);
      else Exit;
	end;
end;
}
// 2005/11/02 <#001> Y.Kabashima Del

//**************************************************************************
//  Proccess    :   コード編集処理
//  Name        :   A.TAKARA
//  Date        :	2001/12/14
//  Parameter   :	Code	編集前のコード
//  Return      :	編集後のコード
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPay510100f.BankSqNoEdit(var Code: String);
begin
	if Code = '' then Exit;

    //手形管理ＮＯ属性
    if m_GnPuKbn_10 = 0 then //	0：数値（前ゼロあり）
    begin
        try
	    	StrToInt(Code);
        except
			Exit;
        end;
        Code := StringOfChar('0',(10 - Length(Code))) + Code;
    end;
end;

//**************************************************************************
//	Proccess  :	CoReportsに該当フィールドが存在するか
//	Name	  :	K.Ikemura
//	Date	  :	2001/12/14
//	Parameter : pIndex	  :   ファイルのインデックス
//			  : pString	  :   フィールド名称
//	Retrun	  :
//	History	　:	9999/99/99	X.XXXX
//				XXXXXXXX修正内容
//**************************************************************************
function TPay510100f.CheckFieldOnReport(pIndex: Integer;
  pString: String): Boolean;
begin
	Result := CoReportsPrintObj.CrFormArray[pIndex].CrObjects[pString] <> nil;
end;

//**********************************************************************
//*		Proccess	:	Ｍｊｓフォント対応(マイナス金額を△表示用に変換する)
//*					:					  ('-'→';'に変換)
//*		Name		:	K.Ikemura
//*		Date		:	2001/12/14
//*		Parameter	:   pKingaku	:	変換対象金額
//*					:
//*		Return		:	金額変換後
//*		History		:
//**********************************************************************
function TPay510100f.Edit_Kingaku(pKingaku: Currency): String;
var
	sKingaku		:	String;			// 金額変換後
    TRFlags			:	TReplaceFlags;	// 文字列置換フラグ
begin
	sKingaku := MjsStrCtrl.MjsEditNum(pKingaku,'  C0');
    result     := sKingaku;

	if (pKingaku < 0) then
    begin
    	// '-' → ';' に置換
        TRFlags := [rfReplaceAll, rfIgnoreCase];
        sKingaku := StringReplace(sKingaku, '-', ';', TRFlags);
		result   := sKingaku;
    end;
end;

//**********************************************************************
//*		Proccess	:	テキスト内の空白文字列(全角ｽﾍﾟｰｽor半角ｽﾍﾟｰｽ)を削除する
//*		Name		:	K.Ikemura
//*		Date		:	2001/12/14
//*		Parameter	:   pString	:	変換対象文字列
//*					:
//*		Return		:	Nathing
//*		History		:
//**********************************************************************
function TPay510100f.DelSpace(pString: String): String;
var
    sWString		:	WideString;	// 削除後文字列
    sWHanSp         :	WideString;	// 半角ｽﾍﾟｰｽ文字列
    sWZenSp         :	WideString;	// 全角ｽﾍﾟｰｽ文字列
    iCnt            :   Integer;
begin
	sWString := pString;
    sWHanSp  := ' ';
    sWZenSp  := '　';

	for iCnt := Length(sWString) downto 1 do
	begin
		// 全角ｽﾍﾟｰｽ・半角ｽﾍﾟｰｽ以外の場合処理終了
		if ((copy(sWString, iCnt, 1) = sWHanSp) or
            (copy(sWString, iCnt, 1) = sWZenSp)) then
        begin
            if (iCnt = 1) then
            begin
                sWString := '';
                Break;
            end;
        end
        else
		begin
			sWString := copy(sWString, 1, iCnt);
			Break;
		end;
	end;
	result := sWString;
end;

//**************************************************************************
//  Proccess    :   進捗チェック
//  Name        :   K.IKEMURA
//  Date        :	2001/12/14
//  Parameter   :	Query
//  Return      :	True or False
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPay510100f.GetActionInfo: Boolean;
var
// 2005/11/02 <#001> Y.Kabashima Del 未使用の為
//    iProc   : Integer;
//    iFuncNo : Integer;
//    iDataNo : Integer;
//    kChkPara: TPAYCheckParam;
// 2005/11/02 <#001> Y.Kabashima Del
//	Qry				: TMQuery;			//2006/07/24 <#007> Y.Naganuma Del
	iRCd, iPayKbn	: Integer;
	cCallPram		: TPAYComCallParam;
	cPdsPram		: TPayDataSelectParam;
	mPayRec			: TPayActionInfoREC;
    Qry				: TMQuery;			// <#037> ADD
begin
	Result := False;
	try
		// ダイアログパラメータ設定
		iRCd	:= 0;
	    iPayKbn	:= PAY_PROC_TUCH;
		m_iDataNo := 1;

		cPdsPram.iSysCode := 1;
		cPdsPram.iProgKbn := PAY_PROC_TUCH;
		cPdsPram.iPayKbn  := iPayKbn;
		cPdsPram.iImpKbn  := 0;
		cPdsPram.pRCd     := @iRCd;
		cPdsPram.pPayRec  := @mPayRec;
		cPdsPram.pPayExc  := @m_cExcluseive;
		cCallPram.pAppRecord := m_pRec;
		cCallPram.pSepParam := @cPdsPram;
		cCallPram.pForm		:= @Self;		// 2005/11/02 <#001> Y.Kabashima Add

		// ダイアログ呼出
		if m_cSystemCom.CallInit(@cCallPram,
        						 Self,
		                         PAYCOMPDSPROC_BPLNAME,
		                         PAYCOMCALL_MODE_NORMAL) <> PAYCOMCALL_RET_OK then
		begin
            m_cSystemCom.CallTerm();	// ダイアログ処理終了
			Beep;
			MjsMessageBoxEx(Self, '支払データ選択ダイアログの初期処理に失敗しました。',
			                '支払通知書印刷', mjError, mjOk, mjDefOk);
			Self.Close;
			Exit;
		end;

		// ダイアログ処理終了
		m_cSystemCom.CallTerm();

		// 結果判定
		if iRCd > 0 then
		begin
			if cPdsPram.iSaiyou = 1 then
			begin
                EPayDataName.Text := mPayRec.sPayDataName;
                EPayDataName.Visible := True;
			end
			else
                EPayDataName.Visible := False;

			EPayDataName.Static := True;
//2006/07/24 <#007> Y.Naganuma Add
			m_iSystemCode	:= mPayRec.iSystemCode;	//システムコード
			m_iFuncNo		:= mPayRec.iFuncNo;	   	//処理No
            m_iPayDate		:= mPayRec.iPayDate;	//支払日
//2006/07/24 <#007> Y.Naganuma Add
			m_iDataNo		:= mPayRec.iDataNo;		//データNo
		end
		else
		begin
			Self.Close;
			Exit;
		end;
	except
		Self.Close;
		Exit;
	end;

// <#037> ADD-STR
    m_iTegSitKijun := 0;

    if (GetPayCommonValue(Pointer(m_pRec), 'Shiharai', 'PAYDAY_TEG') = '1') then
    begin
        // 手形 サイト基準日 取得
        Qry := TMQuery.Create(Self);
        try
            m_DataModule.SetDBInfoToQuery(m_DBCorp, Qry);

            with Qry do
            begin
                Close;
                SQL.Clear;
                SQL.Add('SELECT TegSitKijun FROM PayActionInfo ');
                SQL.Add(' WHERE SystemCode = ' + IntToStr(m_iSystemCode));
                SQL.Add('   AND FuncNo     = ' + IntToStr(m_iFuncNo));

                try
                    Open(True);
                except
                    ErrorMessageDsp(Qry);
                    Exit;
                end;

                m_iTegSitKijun := GetFld('TegSitKijun').AsInteger;
            end;
        finally
            Qry.Close;
            Qry.Free;
        end;
    end;
// <#037> ADD-END

//2006/07/24 <#007> Y.Naganuma Del
(*	{------情報取得------------------------------------------------------------}
    Qry := TMQuery.Create(Self);
    try
        m_DataModule.SetDBInfoToQuery(m_DBCorp, Qry);

        with Qry do
        begin
        	Close;
            SQL.Clear;
			SQL.Add('SELECT * FROM PayActionInfo ');
			SQL.Add('WHERE SystemCode = 1        ');
			SQL.Add('  AND SyoriKbn   = 1        ');
			SQL.Add('  AND DataNo     = ' + IntToStr(m_iDataNo));
			SQL.Add('  AND Condition  = 0        ');

            try
                Open(True);
            except
                ErrorMessageDsp(Qry);
                Exit;
            end;

       		if Eof then
            begin
	    		beep;
// 2006/01/25 <#005> Y.Kabashima Mod
//				MjsMessageBoxEx(Self, '支払予定データ作成を実行してください。', '支払管理', mjWarning, mjOk, mjDefOk);
				MjsMessageBoxEx(Self, '支払予定データ作成を実行してください。', '債務管理', mjWarning, mjOk, mjDefOk);
// 2006/01/25 <#005> Y.Kabashima Mod
                Exit;
            end;

        	Close;
            SQL.Clear;

			SQL.Add('SELECT SystemCode, ProgHigh,    ProgLow,   ');
			SQL.Add('       KfriCnt,    KFriDivMake, KFriManki, ');
			SQL.Add('       TegCnt,     TegDivMake,  TegManki,  ');
			SQL.Add('       KogCnt,     KogDivMake,  FuncNO,    ');
			SQL.Add('       DataNO                              ');
			SQL.Add( 'FROM PayActionInfo                        ');
			SQL.Add( 'WHERE SystemCode = 1                      ');	//1:支払管理
			SQL.Add( '  AND SyoriKbn   = 1                      ');	//1:通常支払
			SQL.Add( '  AND DataNo 	   = ' + IntToStr(m_iDataNo));	//(1:支払データNO　2002/02/15追加)
			SQL.Add( '  AND Condition  = 0                      ');	//(0:支払処理中	  2002/03/13追加)

            try
                Open(True);
            except
                ErrorMessageDsp(Qry);
                Exit;
            end;
        end;
    finally
        Qry.Free;
    end;
*)
//2006/07/24 <#007> Y.Naganuma Del
	Result := True;
end;

//**************************************************************************
//  Proccess    :   会社情報取得処理
//  Name        :   K.IKEMURA
//  Date        :	2001/12/14
//  Parameter   :	Query
//  Return      :	True or False
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPay510100f.GetDTMAIN(Query: TMQuery): Boolean;
var
    iZipCode1,iZipCode2	: Integer;
	sSql				: String;	//2006/07/24 <#007> Y.Naganuma Add
begin
	Result := False;

	with Query do
	begin
		Close;
//2006/07/24 <#007> Y.Naganuma Add
		UnPrepare;
		Errors.Clear;
//2006/07/24 <#007> Y.Naganuma Add
		SQL.Clear;

//2006/07/24 <#007> Y.Naganuma Mod
//		SQL.Add( 'SELECT'			);
//		SQL.Add( ' LComName'       	);
//		SQL.Add( ',YearKbn'			);
//		SQL.Add( ',ZipCode1'		);
//		SQL.Add( ',ZipCode2'		);
//		SQL.Add( ',Address1'		);
//		SQL.Add( ',Address2'		);
//		SQL.Add( ',TelNo'			);
//		SQL.Add( 'FROM'				);
//		SQL.Add( ' MV_MAS_DTMAIN'	);
		sSql := 'SELECT ';
		sSql := sSql + ' KStDate, ';                                // <#025> ADD
		sSql := sSql + ' LComName, ';
		sSql := sSql + ' YearKbn, ';
		sSql := sSql + ' ZipCode1, ';
		sSql := sSql + ' ZipCode2, ';
		sSql := sSql + ' Address1, ';
		sSql := sSql + ' Address2, ';
		sSql := sSql + ' TelNo ';
		sSql := sSql + 'FROM ';
		sSql := sSql + ' MV_MAS_DTMAIN ';

        ParamCheck := False;
		SQL.Add(sSql);
		Prepare;
//2006/07/24 <#007> Y.Naganuma Mod

		try
			Open(True);

		except
			ErrorMessageDsp(Query);
			Exit;
		end;

        with m_DTMAIN do
        begin
            m_iKStDate  := StrToInt(FormatDateTime('yyyymmdd', GetFld('KStDate').AsDateTime));  // <#025> ADD

            SComName	:= GetFld('LComName').AsString;
            YearKbn 	:= GetFld('YearKbn').AsInteger;

            iZipCode1	:= GetFld('ZipCode1').AsInteger;
            iZipCode2	:= GetFld('ZipCode2').AsInteger;
            if (iZipCode1 <> 0) then
            begin
                ZipCode	:= ShortString(Format('%.3d', [iZipCode1]));
//                if (iZipCode2 <> 0) then      // <#041> del
                    ZipCode := ShortString(String(ZipCode) + '-' + Format('%.4d', [iZipCode2]));
            end;

            Address1	:= GetFld('Address1').AsString;
            Address2	:= GetFld('Address2').AsString;
            TelNo		:= GetFld('TelNo'   ).AsString;
        end;
	end;
	Result := True;
end;

//**************************************************************************
//  Proccess    :   MasterInfo取得処理
//  Name        :   K.IKEMURA
//  Date        :	2001/12/14
//  Parameter   :	Query
//  Return      :	True or False
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPay510100f.GetMasterInfo(Query: TMQuery): Boolean;
//2006/07/24 <#007> Y.Naganuma Add
var
	sSql	: String;
//2006/07/24 <#007> Y.Naganuma Add
begin
	Result := False;

	with Query do
	begin
		Close;
//2006/07/24 <#007> Y.Naganuma Add
		UnPrepare;
		Errors.Clear;
//2006/07/24 <#007> Y.Naganuma Add
		SQL.Clear;

//2006/07/24 <#007> Y.Naganuma Mod
//		SQL.Add( 'SELECT'			                        );
//		SQL.Add( ' CodeDigit'		                        );
//		SQL.Add( ',CodeAttr'		                        );
//		SQL.Add( 'FROM'				                        );
//		SQL.Add( ' MasterInfo'		                        );
//		SQL.Add( 'WHERE'			                        );
//		SQL.Add( '    MasterKbn = 22'						);
//		SQL.Add( 'and UseKbn = 1'							);
//		SQL.Add( 'ORDER BY'									);
//		SQL.Add( ' MasterKbn'								);
		sSql := 'SELECT ';
		sSql := sSql + ' CodeDigit, ';
		sSql := sSql + ' CodeAttr ';
		sSql := sSql + 'FROM ';
		sSql := sSql + ' MasterInfo ';
// <#033> MOD-STR
//		sSql := sSql + 'WHERE MasterKbn = 22 ';
//		sSql := sSql + ' AND  UseKbn = 1 ';
		sSql := sSql + 'WHERE MasterKbn IN (22, 41) ';
		sSql := sSql + ' AND  UseKbn <> 0 ';
// <#033> MOD-END
		sSql := sSql + 'ORDER BY ';
		sSql := sSql + ' MasterKbn';

        ParamCheck := False;
		SQL.Add(sSql);
		Prepare;
//2006/07/24 <#007> Y.Naganuma Mod

		try
			Open(True);

		except
			ErrorMessageDsp(Query);
			Exit;
		end;

        if Eof then
        begin
       		m_sFirstMSG	:= 'この会社では取引先が採用されていないため、処理を行なえません。';
         	Exit;
        end;

        with m_MasterInfo do
        begin
            CodeDigit	:= GetFld( 'CodeDigit'	).AsInteger;
            CodeAttr	:= GetFld( 'CodeAttr'	).AsInteger;
        end;

// <#033> ADD-STR
        Next;

        // 部門コード
        with m_BmnInfo do
        begin
            if not Eof then
            begin
                CodeDigit	:= GetFld( 'CodeDigit'	).AsInteger;
                CodeAttr	:= GetFld( 'CodeAttr'	).AsInteger;
            end
            else
            begin
                CodeDigit	:= 6;
                CodeAttr	:= 0;
            end;
        end;
// <#033> ADD-END
	end;
	Result := True;
end;

//**************************************************************************
//  Proccess    :   文書エリアのセット
//  Name        :   K.IKEMURA
//  Date        :	2001/02/06
//  Parameter   :
//  Return      :
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPay510100f.SetData_Bunsho(pIndex: Integer);
begin
    // 文書1
    try
        if CheckFieldOnReport(pIndex,CORPNM_Lbl_Bunsho1) then
            CoRepData.AddData(CORPNM_Lbl_Bunsho1 ,m_LayoutInfo.Bunsho1);
    Except
    end;

    // 文書2
    try
        if CheckFieldOnReport(pIndex,CORPNM_Lbl_Bunsho2) then
            CoRepData.AddData(CORPNM_Lbl_Bunsho2 ,m_LayoutInfo.Bunsho2);
    Except
    end;

    // 文書3
    try
        if CheckFieldOnReport(pIndex,CORPNM_Lbl_Bunsho3) then
            CoRepData.AddData(CORPNM_Lbl_Bunsho3 ,m_LayoutInfo.Bunsho3);
    Except
    end;
end;

//**************************************************************************
//  Proccess    :   折り目区切り線のセット
//  Name        :   K.IKEMURA
//  Date        :	2001/02/06
//  Parameter   :
//  Return      :
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPay510100f.SetFoldLine(CoData: TMjsCoReportsData);
var
    Value : Boolean;
    pIndex : Integer;
begin
	case m_LayoutCtrl.Foldline of
    	0: Value := False ;
    	1: Value := True ;
	    else Value := True;;
    end;

	//連続出力の場合、折り目区切り線の重複があるため判定
    if (m_LayoutCtrl.Foldline = 1) and
       (m_RenCnt > 0) then
        Value := False;

    pIndex := CoData.FormIndex;

    //CoReportsに追加
    try
        if CheckFieldOnReport(pIndex,CORPNM_Line_Orime1_1) then
            CoData.AddData(CORPNM_Line_Orime1_1 ,'',Value);
    Except
    end;

    try
        if CheckFieldOnReport(pIndex,CORPNM_Line_Orime1_2) then
            CoData.AddData(CORPNM_Line_Orime1_2 ,'',Value);
    Except
    end;

    try
        if CheckFieldOnReport(pIndex,CORPNM_Line_Orime2_1) then
            CoData.AddData(CORPNM_Line_Orime2_1 ,'',Value);
    Except
    end;

    try
        if CheckFieldOnReport(pIndex,CORPNM_Line_Orime2_2) then
            CoData.AddData(CORPNM_Line_Orime2_2 ,'',Value);
    Except
    end;
end;

//**************************************************************************
//  Proccess    :   Mem（書留）をセット
//  Name        :   K.IKEMURA
//  Date        :	2001/02/06
//  Parameter   :
//  Return      :
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
function TPay510100f.SetData_Kakitome(pIndex: Integer): Boolean;
var
	i : Integer;
	FieldIndex : Integer;
    sLongName 	: 	String;
    sBunkatusuu : 	String;
    //CoReportsフィールド
    sField_LongName		:	String;
    sField_Bunkatusuu	:	String;
begin
    i := 0;
	with DMem_Kakitome do
    begin
        while Eof <> True do
        begin
            Inc(i);

            if i = KAKITOMELINE + 1 then Break;

            sLongName 	:= 	FieldByName('LongName').AsString;
            sBunkatusuu := 	IntToStr(FieldByName('Bunkatusuu').AsInteger) + '枚';   // <#015> 「枚」を追加出力

           	sField_LongName		:= Format( CORPNM_PayLongName + '%-d', [i] );
           	sField_Bunkatusuu 	:= Format( CORPNM_Bunkatusuu  + '%-d', [i] );

            // 書留---受取人
            try
                if CheckFieldOnReport(pIndex,sField_LongName) then
                begin
                    FieldIndex := CoRepData.AddData(sField_LongName ,sLongName);
                    CoRep_FontRatio(CoRepData,FieldIndex);
                end;
            Except
            end;

            // 書留---摘要
            try
                if CheckFieldOnReport(pIndex,sField_Bunkatusuu) then
                begin
                    CoRepData.AddData(sField_Bunkatusuu ,sBunkatusuu);
                end;
            Except
            end;
            
    		// 次レコードの支払先を検索
            Next;
        end;

        Result := Eof;
	end;
end;

//**********************************************************************
//*		Proccess	:  取引先NO属性出力
//*		Name		:  J.HIDAKA(RIT)
//*		Create		:  2002/06/11
//*		Parameter   :
//*		Return		:
//*		History		:  9999/99/99	X.Xxxx
//*									XXXXXXXXXXXXXXXXXX
//**********************************************************************
procedure TPay510100f.CoRep_TorihikiNo(wCoRepData : TMjsCoReportsData;pIndex: Integer);
var
    CoRepFieldProp  :   TMjsCoReportsFieldProperty;
begin
    CoRepFieldProp := wCoRepData.GetfieldProperty(pIndex);

    //取引先ＮＯ属性
    case m_MasterInfo.CodeAttr of
    //0:数値 1:前ゼロあり(右寄せ)
	    0,1:CoRepFieldProp.Alignment	:= corAlignRight;
    //2:フリー(左寄せ)
	    2:CoRepFieldProp.Alignment		:= corAlignLeft	;
    end;
end;

//**********************************************************************
//*		Proccess	:   コード属性により表示形態の変更
//*                 :
//*  	Name        :   J.HIDAKA(RIT)
//*  	Date        :	2002/09/09
//*		Parameter   :   pCode: 	  String			変換コード
//*						pCodeType: Integer			変換コードタイプ(0…10桁 1…指定桁数)
//*		Return		:   変換後コード
//*		History		:   9999/99/99	X.Xxxx
//*									XXXXXXXXXXXXXXXXXX
//**********************************************************************
function TPay510100f.Edit_Code(pAttr: Integer; pDigit: Integer; pCode: String; pCodeType: Integer): String;
var
	strRetCode	:	String;		// 変換後コード
begin
	result 		:= pCode;
    strRetCode  := '';

    if pCode = '' then exit;

    case pAttr of
        ATTR_MAEZERO:
        begin
        	if (pCodeType = DISPLAY_TYPE) then
				strRetCode	:= Format('%.' + CurrToStr(pDigit) + 'd', [StrToInt64Def(pCode,0)])
            else
				strRetCode 	:= Format('%.10d', [StrToInt64Def(pCode,0)]);
        end;
        ATTR_FREE:
        	strRetCode 		:= pCode;
        else
        begin
        	if (pCodeType = DISPLAY_TYPE) then
        		strRetCode 	:= CurrToStr(StrToInt64Def(pCode,0))
			else
            	strRetCode 	:= Format('%.10d', [StrToInt64Def(pCode,0)]);
        end;
    end;
    result := strRetCode;
end;

// <#012> 2008/03/26 T.Kawahata Add
//**********************************************************************
//*		Proccess	:   番号1の編集と属性の取得
//*                 :
//*  	Name        :   T.Kawahata@MSI
//*  	Date        :	2008/03/28
//*		Parameter   :   pNumValue : String			番号1
//*						pAlignment: TAlignment		属性
//*		Return		:
//*		History		:   9999/99/99	X.Xxxx
//*									XXXXXXXXXXXXXXXXXX
//**********************************************************************
procedure TPay510100f.EditNumValue1(var pNumValue: String; var pAlignment: TAlignment);
begin
	//番号1が採用なしの場合は番号1を編集しない
    if m_GnPuKbn_12 in [0] then
    begin
    	pNumValue  := '';
    	pAlignment := taLeftJustify;
    end;

    case m_GnPuKbn_14 of
        0: begin
        	if Trim(pNumValue) <> '' then
            begin
                pNumValue  := StringOfChar(' ', 20) +
                              FormatFloat('0', StrToInt64Def(pNumValue, 0));
                pNumValue  := Copy(pNumValue, Length(pNumValue) - m_GnPuKbn_13 + 1, m_GnPuKbn_13);
                pNumValue  := Trim(pNumValue);
            end;
	    	pAlignment := taRightJustify;
        end;
        1: begin
        	if Trim(pNumValue) <> '' then
            begin
                pNumValue  := StringOfChar('0', 20) +
                              FormatFloat('0', StrToInt64Def(pNumValue, 0));
                //桁数分を返却
                pNumValue  := Copy(pNumValue, Length(pNumValue) - m_GnPuKbn_13 + 1, m_GnPuKbn_13);
            end;
	    	pAlignment := taRightJustify;
        end;
        2,3: begin
            //そのまま返却
	    	pAlignment := taLeftJustify;
        end;
    end;
end;

//**********************************************************************
//*		Proccess	:   番号2の編集と属性の取得
//*                 :
//*  	Name        :   T.Kawahata@MSI
//*  	Date        :	2008/03/28
//*		Parameter   :   pNumValue : String			番号2
//*						pAlignment: TAlignment		属性
//*		Return		:
//*		History		:   9999/99/99	X.Xxxx
//*									XXXXXXXXXXXXXXXXXX
//**********************************************************************
procedure TPay510100f.EditNumValue2(var pNumValue: String; var pAlignment: TAlignment);
begin
	//番号2が採用なしの場合は番号2を編集しない
    if m_GnPuKbn_12 in [0, 1] then
    begin
    	pNumValue  := '';
    	pAlignment := taLeftJustify;
    end;

    case m_GnPuKbn_16 of
        0: begin
        	if Trim(pNumValue) <> '' then
            begin
                pNumValue  := StringOfChar(' ', 20) +
                              FormatFloat('0', StrToInt64Def(pNumValue, 0));
                pNumValue  := Copy(pNumValue, Length(pNumValue) - m_GnPuKbn_15 + 1, m_GnPuKbn_15);
                pNumValue  := Trim(pNumValue);
            end;
	    	pAlignment := taRightJustify;
        end;
        1: begin
        	if Trim(pNumValue) <> '' then
            begin
                pNumValue  := StringOfChar('0', 20) +
                              FormatFloat('0', StrToInt64Def(pNumValue, 0));
                //桁数分を返却
                pNumValue  := Copy(pNumValue, Length(pNumValue) - m_GnPuKbn_15 + 1, m_GnPuKbn_15);
            end;
	    	pAlignment := taRightJustify;
        end;
        2,3: begin
            //そのまま返却
	    	pAlignment := taLeftJustify;
        end;
    end;
end;
// <#012> 2008/03/26 T.Kawahata Add

// <#024> ADD-STR
//**************************************************************************
//	Proccess  :	タックシール
//	Name	  :	T.SATOH(IDC)
//	Date	  :	2009/07/08
//	Parameter : pIndex (標準レイアウトのFormIdx)
//	Retrun	  :
//	History	　:	9999/99/99
//**************************************************************************
procedure TPay510100f.SetTackSealCSVData(pIndex: Integer);
var
    iObjNumber          :   Integer;
	sField_PayLongName	:	String;
    bAddData            :   Boolean;
begin
	try
		DMem_CSInfo.First;
        iObjNumber := 1;
        bAddData := False;

		while DMem_CSInfo.Eof <> True do
		begin
            if (iObjNumber = 1) then
            begin
                CoRepData 	  := TMjsCoReportsData.Create;
                CoRepData.LayerNameList.Add(TACKSEALLAYOUT);
                CoRepData.FormIndex := iFormIndex[0];
            end;

            // 支払先情報設定
            SetData_CSInfo2(CoRepData, iObjNumber);

            DMem_CSInfo.Next;

            iObjNumber := iObjNumber + 1;

            try
                sField_PayLongName	:=	CORPNM_PayLongName + Format('%d', [iObjNumber]);
                if (CheckFieldOnReport(pIndex, sField_PayLongName) = False) then
                begin
                    bAddData := True;
                    iObjNumber := 1;
                end;
            Except
                bAddData := True;
                iObjNumber := 1;
            end;

            if DMem_CSInfo.Eof then
                bAddData := True;

            if bAddData then
            begin
                CoReportsPrintObj.AddData(CoRepData);
                bAddData := False;
            end;
        end;
    except
        if m_PrnSupport.iCommand = PDLG_PREVIEW then
            m_Preview.EndPreview();
    end;
end;

//**************************************************************************
//  Proccess    :   Mem（支払先）にデータをセット
//	Name	    :	T.SATOH(IDC)
//	Date	    :	2009/07/08
//  Parameter   :
//  Return      :
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPay510100f.SetData_CSInfo2(var CoData: TMjsCoReportsData; iObjNumber: Integer);
var
	FieldIndex : Integer;
    pIndex : Integer;

    sPayDay 				: 	String;
    sGCode					:	String;
    sCSInfo         		:   TMasCSInfo;	// 取引先詳細ﾚｺｰﾄﾞ
	iZipCode1,iZipCode2		:   Integer;
    sZipCode				:	String;
    sTitleName				:	String;
	sField_PayDay			:	String;
	sField_GCode			:	String;
	sField_PayZipCode		:	String;
	sField_PayAdress1		:	String;
	sField_PayAdress2		:	String;
	sField_PayLongName		:	String;
	sField_PaySectionName	:	String;
	sField_PersonName		:	String;
	sField_PayTelNo		    :	String;     // 支払先電話番号

    sObjNumber              :   String;
begin
    pIndex := CoData.FormIndex;

	if DMem_CSInfo.RecordCount = 0 then Exit;

    if (iObjNumber <> 0) then
        sObjNumber := Format('%d', [iObjNumber])
    else
        sObjNumber := '';

    with DMem_CSInfo do
    begin
        // お支払日
        sPayDay := SetFormatInt(FieldByName('PayDay').AsInteger,True);
// <#037> ADD-STR
        if (m_iTegSitKijun <> 0) and ((FieldByName('GCode').AsString = m_sTegataExistGCode) or FindTegata(FieldByName('GCode').AsString)) then
            sPayDay := SetFormatInt(m_iTegSitKijun, True);
// <#037> ADD-END
        try
			sField_PayDay	:=	CORPNM_PayDay + sObjNumber;
	        if CheckFieldOnReport(pIndex,sField_PayDay) then
			begin
				CoData.AddData(sField_PayDay ,sPayDay);
			end;
        Except
        end;

        // 得意先ｺｰﾄﾞ
        try
			sField_GCode	:=	CORPNM_GCode + sObjNumber;
	        if  CheckFieldOnReport(pIndex,sField_GCode) then
			begin
				sGCode := Edit_Code(m_MasterInfo.CodeAttr,m_MasterInfo.CodeDigit,FieldByName('GCode').AsString,DISPLAY_TYPE);
				FieldIndex := CoData.AddData(sField_GCode ,sGCode);
				CoRep_TorihikiNo(CoData,FieldIndex);
			end;
        Except
        end;

        // 郵便番号
        iZipCode1 := FieldByName('ZipCode1').AsInteger;
        iZipCode2 := FieldByName('ZipCode2').AsInteger;
        sZipCode := '';
        if (iZipCode1 <> 0) then
        begin
            // <#041> mod st
//            sZipCode := Format('%.3d', [iZipCode1]);
//            if (iZipCode2 <> 0) then
//                sZipCode := sZipCode + '-' + Format('%.4d', [iZipCode2]);
//            if (sZipCode <> '') then
//                sZipCode := '〒' + sZipCode;
//<#043>ADD-STR
            if (m_DlgParam.YubinMarkChk = 1) then
            	sZipCode := Format('%.3d', [iZipCode1]) + '-' + Format('%.4d', [iZipCode2])
            else
//<#043>ADD-END
            	sZipCode := '〒' + Format('%.3d', [iZipCode1]) + '-' + Format('%.4d', [iZipCode2]);
            // <#041> mod ed
        end;
        try
			sField_PayZipCode	:=	CORPNM_PayZipCode + sObjNumber;
	        if  CheckFieldOnReport(pIndex,sField_PayZipCode) then
			begin
				FieldIndex := CoData.AddData(sField_PayZipCode ,sZipCode);								// 取引先詳細情報(CSInfo)郵便番号(基番+枝番)
				CoRep_FontRatio(CoData,FieldIndex);
			end;
        Except
        end;

        // 住所(上段)
        try
			sField_PayAdress1	:=	CORPNM_PayAdress1 + sObjNumber;
	        if  CheckFieldOnReport(pIndex,sField_PayAdress1) then
			begin
				FieldIndex := CoData.AddData(sField_PayAdress1 ,FieldByName('Address1').AsString);				// 取引先詳細情報(CSInfo)住所（上段）
				CoRep_FontRatio(CoData,FieldIndex);
			end;
        Except
        end;

        // 住所(下段)
        try
			sField_PayAdress2	:=	CORPNM_PayAdress2 + sObjNumber;
	        if  CheckFieldOnReport(pIndex,sField_PayAdress2) then
			begin
				FieldIndex := CoData.AddData(sField_PayAdress2 ,FieldByName('Address2').AsString);				// 取引先詳細情報(CSInfo)住所（下段）
				CoRep_FontRatio(CoData,FieldIndex);
			end;
        Except
        end;

        // 支払先電話番号
        try
			sField_PayTelNo	    :=	'支払先電話番号' + sObjNumber;
	        if  CheckFieldOnReport(pIndex,sField_PayTelNo) then
			begin
				FieldIndex  := CoData.AddData(sField_PayTelNo ,FieldByName('TelNo').AsString);				// 取引先詳細情報(CSInfo)支払先電話番号
				CoRep_FontRatio(CoData,FieldIndex);
			end;
        Except
        end;

        // 取引先名称取得
        sCSInfo.LongName 	:= ShortString(DelSpace(FieldByName('LongName').AsString));
        // 部署名
        sCSInfo.SectionName := ShortString(FieldByName('SectionName').AsString);
        // 担当者
        sCSInfo.PersonName 	:= ShortString(FieldByName('PersonName').AsString);
        // 敬称
        sTitleName 		 	:= FieldByName('TitleName').AsString;

        if (trim(String(sCSInfo.LongName)) <> '') and (trim(String(sCSInfo.SectionName)) <> '') and (trim(String(sCSInfo.PersonName)) <> '') then
        begin
            try
            	sCSInfo.PersonName := ShortString(String(sCSInfo.PersonName) + ' ' + sTitleName);
            Except
            end;
        end
        else if (trim(String(sCSInfo.LongName)) <> '') and (trim(String(sCSInfo.SectionName)) <> '') and (trim(String(sCSInfo.PersonName)) = '') then
        begin
            try
            	sCSInfo.SectionName := ShortString(String(sCSInfo.SectionName) + ' ' + sTitleName);
            Except
            end;
        end
        else if (trim(String(sCSInfo.LongName)) <> '') and (trim(String(sCSInfo.SectionName)) = '') and (trim(String(sCSInfo.PersonName)) = '') then
        begin
            try
            	sCSInfo.LongName := ShortString(String(sCSInfo.LongName) + ' ' + sTitleName);
            Except
            end;
        end
        else if (trim(String(sCSInfo.LongName)) <> '') and (trim(String(sCSInfo.SectionName)) = '') and (trim(String(sCSInfo.PersonName)) <> '') then
        begin
            try
            	sCSInfo.PersonName := ShortString(String(sCSInfo.PersonName) + ' ' + sTitleName);
            Except
            end;
        end;

        // 取引先名称取得
        try
			sField_PayLongName	:=	CORPNM_PayLongName + sObjNumber;
	        if  CheckFieldOnReport(pIndex,sField_PayLongName) then
			begin
				FieldIndex := CoData.AddData(sField_PayLongName ,String(sCSInfo.LongName));
				CoRep_FontRatio(CoData,FieldIndex);
			end;
        Except
        end;

        // 部署名
        try
			sField_PaySectionName	:=	CORPNM_PaySectionName + sObjNumber;
	        if  CheckFieldOnReport(pIndex,sField_PaySectionName) then
			begin
				FieldIndex := CoData.AddData(sField_PaySectionName ,String(sCSInfo.SectionName));
				CoRep_FontRatio(CoData,FieldIndex);
			end;
        Except
        end;

        // 担当者
        try
			sField_PersonName	:=	CORPNM_PayPersonName + sObjNumber;
	        if CheckFieldOnReport(pIndex,sField_PersonName) then
			begin
				FieldIndex := CoData.AddData(sField_PersonName ,String(sCSInfo.PersonName));
				CoRep_FontRatio(CoData,FieldIndex);
			end;
        Except
        end;
    end;
end;
// <#024> ADD-END

// <#025> ADD-STR
//**************************************************************************
//  Proccess    :   メール送信処理
//  Name        :   T.SATOH(GSOL)
//  Date        :	2010/11/22
//  Parameter   :
//  Return      :
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPay510100f.DoSendMail();
var
    bReSend:   Boolean;
    iRet:      Integer;
	lvJobNo:   Currency;
	lvStamp:   TTimeStamp;
	lvSTime:   Integer;
	lvETime:   Integer;
	lvLoopFlg: Boolean;
    dSize:     DWORD;
    pPcName:   PChar;
    sPcName:   String;
	oQuery:	   TMQuery;
    iLength:   Integer;
    aSQL:      array of String;
    i:         Integer;
    ii:        Integer;         // <#031> ADD
    sSQL:      String;
    sGCode:    String;
    iEdaNo:    Integer;
    iStatus:   Integer;
    sLogFile:  String;
	cService:  TPAYTrnServiceClient;
    sTitle:    TStringList;
    sMemFld:   TStringList;
    PrnSupport:TMjsPrnSupport;
    iErrCount: Integer;
    sTblNm:    String;
// <#035> ADD-STR
    iFileComp: Integer;
// <#039> ADD-STR
    sPath:      String;
    sl:         TStringlist;
    sFolder:    String;
    iOverCount: Integer;
// <#039> ADD-END    

    function iGetFileComp(): Integer;
    begin
        oQuery := Nil;
        try
            Result := 0;

            oQuery	:= TMQuery.Create(Nil);
            m_DataModule.SetDBInfoToQuery(m_DBCorp, oQuery);

            with oQuery do
            begin
                Close;
                SQL.Clear;
                Params.Clear;

                SQL.Add('SELECT FileComp' +
                        '  FROM PayMailSendInfo' +
                        ' WHERE SystemCode = ' + IntToSTr(m_iSystemCode));

                if (Open = False) or Eof then
                begin
                    MjsMessageBoxEx(Self, 'メール配信基本情報の取得に失敗しました。',
                                    '支払通知書', mjError, mjOk, mjDefOk);
                    Exit;
                end;

                Result := GetFld('FileComp').AsInteger;
            end;
        finally
            if Assigned(oQuery) then oQuery.Free;
        end;
    end;
// <#035> ADD-END

    // JobNo取得
    function dfnInzJobNo(fvsTableName:String): Integer;
    var
        oStoredProc 	: TFDStoredProc;
    begin
        Result := -1;


        oStoredProc := Nil;
        try
            oStoredProc := TFDStoredProc.Create(Nil);
            m_DataModule.SetDBInfoToSProc(m_DBCorp, oStoredProc);

            with oStoredProc do
            begin
                StoredProcName := 'MP_PAY_JobControl';
                ParamBindMode  := pbByName;

                Params.Clear;

// Delphi10 ST
//                Params.CreateParam(ftString,  '@MTABLE', ptInput);
//                Params.CreateParam(ftInteger, '@JOB_NO', ptOutput);
//                Params.CreateParam(ftInteger, '@RETURN_VALUE', ptOutput);

                MjsPrepareStoredProc(oStoredProc);
// Delphi10 ED
                ParamByName('@MTABLE').AsString := fvsTableName;

                ExecProc;

                if ParamByName('@RETURN_VALUE').AsInteger = 0 then
                    Result := ParamByName('@JOB_NO').AsInteger;
            end;
        finally
            if Assigned(oStoredProc) then oStoredProc.Free;
        end;
    end;

    // ＳＱＬ実行
    procedure ExecPoolSQL();
    begin
        sSQL := 'BEGIN ' + sSQL + 'END';
        with oQuery do
        begin
            Close;
            SQL.Clear;
            SQL.Add(sSQL);
            ExecSQL;
        end;
        sSQL := '';
    end;
begin
// <#039> ADD-STR
    // ＰＤＦファイル保存ありの場合
    if m_MailPDFSave = 1 then
    begin
        if m_DlgParam.MailPDFSaveMode = 1 then
        begin
	        if (MjsMessageBoxEx(Self, 'ＰＤＦファイルの保存を行います。よろしいですか？', '確認', mjQuestion, mjYesNo, mjDefYes) <> mrYes) then
            begin
                Exit;
            end;
        end
        else
        begin
            // 実行確認
    	    if (MjsMessageBoxEx(Self, 'メール配信を行います。よろしいですか？', '確認', mjQuestion, mjYesNo, mjDefYes) <> mrYes) then
            begin
                Exit;
            end;
        end;
    end
    else
    begin
// <#039> ADD-END
        // 実行確認
    	if (MjsMessageBoxEx(Self, 'メール配信を行います。よろしいですか？', '確認', mjQuestion, mjYesNo, mjDefYes) <> mrYes) then
        begin
            Exit;
        end;
    end;    // <#039> ADD

// <#039> ADD-STR
    sPath := '';

    // ＰＤＦファイル保存ありの場合
    if m_MailPDFSave = 1 then
    begin
        if m_DlgParam.MailPDFSaveMode = 1 then
        begin
            sPath := GetPayCommonValue(Pointer(m_pRec), 'Shiharai', 'MAIL_PDF_SAVE_PATH1');

            //指定されたディレクトリが存在するかチェック
            if not SysUtils.DirectoryExists(sPath) then
            begin
        	    MjsMessageBoxEx(Self, 'ＰＤＦファイル保存フォルダを参照できません。' + #13#10 +
                    '設定内容を確認してください。'+ #13#10 +
                    '保存フォルダ：' + sPath,
	                '支払通知書印刷', mjWarning, mjOk, mjDefOk);

                Exit;
            end;

            //書き込みができるかチェック
            try
                sl := TStringList.Create;
                try
                    sl.add('Test');
                    sl.SaveToFile(sPath + '\PayMailTest.txt');
                except
                    MjsMessageBoxEx(Self, 'ＰＤＦファイル保存フォルダに書き込みができません。'+ #13#10 +
                        'フォルダの権限などについて確認してください。'+ #13#10 +
                        '保存フォルダ：' + sPath,
                         '支払通知書印刷', mjWarning, mjOk, mjDefOk);

                    Exit;
                end;

            finally
                sl.Free;
            end;

            //ファイルが存在するか確認
            if FileExists(sPath + '\PayMailTest.txt') then
            begin
                //作成したファイルを削除
      			DeleteFile (sPath + '\PayMailTest.txt');
           	end;
        end;
// <#039> ADD-END        
    end;

    // 再送信確認
    bReSend := False;
    with DMem_CSInfo do
    begin
        First;

        while not Eof do
        begin
            if ((not bReSend) and (FieldByName('MailSendKbn').AsInteger <> 0) and (FieldByName('MailCount').AsInteger <> 0)) then
            begin
// <#039> ADD-STR
                if m_MailPDFSave = 1 then
                begin
                    //ファイル保存の場合送信済みの支払先も保存対象とする
                    if m_DlgParam.MailPDFSaveMode = 1 then
                        iRet := mrNo
                    else
                        // 既送信データ発見
                        iRet := MjsMessageBoxEx(Self,
                                                'すでに送信済みの支払先が含まれています。' + #13#10 +
                                                '未送信の支払先のみ送信しますか？' + #13#10 + #13#10 +
                                                'はい・・・未送信の支払先のみ送信する' + #13#10 +
                                                'いいえ・・送信済みの支払先も含めて送信する',
                                                '確認', mjQuestion, mjYesNoCancel, mjDefYes);
                end
                else
// <#039> ADD-END
                    // 既送信データ発見
                    iRet := MjsMessageBoxEx(Self,
                                            'すでに送信済みの支払先が含まれています。' + #13#10 +
                                            '未送信の支払先のみ送信しますか？' + #13#10 + #13#10 +
			    							'はい・・・未送信の支払先のみ送信する' + #13#10 +
				    						'いいえ・・送信済みの支払先も含めて送信する',
                                            '確認', mjQuestion, mjYesNoCancel, mjDefYes);

				if (iRet = mrCancel) then
                    Exit
				else if (iRet = mrNo) then
                    Break;

                bReSend := True;
            end;

            if bReSend then
            begin
                // 未送信の支払先のみ送信
                if ((FieldByName('MailSendKbn').AsInteger <> 0) and (FieldByName('MailCount').AsInteger <> 0)) then
                begin
                    // 既送信データは送信対象外とする
                    Edit;
                    FieldByName('MailSendKbn').AsInteger := 2;      // 2:配信済み除外
                    Post;
                end;
            end;

            Next;
        end;
    end;

    // JobNoを取得
	lvJobNo := 0;
	lvStamp := DateTimeToTimeStamp(Now);
	lvSTime := lvStamp.Time;

	lvLoopFlg := True;
	while lvLoopFlg do
	begin
		lvJobNo := dfnInzJobNo('PAY510_TMP01_Base');
		if lvJobNo > 0 then
			break;

		lvStamp := DateTimeToTimeStamp(Now);
		lvETime := lvStamp.Time;
		if (lvETime - lvSTime) > 30000 then
			lvLoopFlg := False;
	end;

    // 端末名を取得
// <#028> ADD-STR
    if (GetClientName(sPcName) < 0) then
    begin
// <#028> ADD-END
    	dSize := MAX_COMPUTERNAME_LENGTH + 1;
	    GetMem(pPcName, dSize * SizeOf(Char));
    	GetComputerName(pPcName,dSize);
	    sPcName   := pPcName;          //端末名
    	FreeMem(pPcName, dSize);
    end;        // <#028> ADD

// <#039> ADD-STR
    sFolder := '';

    // ＰＤＦファイル保存ありの場合、保存用フォルダの作成    
    if m_MailPDFSave = 1 then
    begin
        if m_DlgParam.MailPDFSaveMode = 1 then
        begin
            sFolder := 'PAYMAIL_' +
                        Format('%.8d', [m_pRec^.m_iCorpCode]) + '_' +
                        Format('%.8d', [m_iKStDate]) + '_' +
                        Format('%.8d', [m_iPayDate]) + '_' +
                        Format('%.10d',[Trunc(lvJobNo)]);

            if not CreateDir(sPath + '\' + sFolder) then
            begin
                MjsMessageBoxEx(Self, 'ＰＤＦファイル保存フォルダが作成できません。' + #13#10 +
                                        'フォルダの権限などについて確認してください。' + #13#10 +
                                        '作成フォルダ：'+ sPath + '\' + sFolder,
    	            '支払通知書印刷', mjWarning, mjOk, mjDefOk);

                Exit;
            end;
        end;
    end;
// <#039> ADD-END
    
    // 各MemDataをワークテーブルに登録
    iLength := 1;
    SetLength(aSQL, iLength);
    i := 0;

    with m_DTMAIN, m_DlgParam, m_LayoutInfo, m_LayoutCtrl, rcCOMMONAREA(m_pRec^.m_pCommonArea^) do
    begin
        // 支払通知書データ基本情報
        sSQL := FloatToStr(lvJobNo) + ',';
        sSQL := sSQL + IntToSTr(m_iSystemCode) + ',';
        sSQL := sSQL + IntToSTr(m_iFuncNo) + ',';
        sSQL := sSQL + IntToSTr(m_iPayDate) + ',';                  // 支払日
        sSQL := sSQL + AnsiQuotedStr(PrnDate, '''') + ',';          // 送付日
        sSQL := sSQL + AnsiQuotedStr(String(ZipCode), '''') + ',';          // 自社郵便番号
        sSQL := sSQL + AnsiQuotedStr(Address1, '''') + ',';         // 自社住所(上段)
        sSQL := sSQL + AnsiQuotedStr(Address2, '''') + ',';         // 自社住所(下段)
        sSQL := sSQL + AnsiQuotedStr(SComName, '''') + ',';         // 自社名
        sSQL := sSQL + AnsiQuotedStr(TelNo, '''') + ',';            // 自社電話番号
        sSQL := sSQL + AnsiQuotedStr(Jishabushoname, '''') + ',';   // 自社部門名
        sSQL := sSQL + AnsiQuotedStr(Bunsho1, '''') + ',';          // 文書1
        sSQL := sSQL + AnsiQuotedStr(Bunsho2, '''') + ',';          // 文書2
        sSQL := sSQL + AnsiQuotedStr(Bunsho3, '''') + ',';          // 文書3
        sSQL := sSQL + IntToStr(Foldline) + ',';                    // 折目線
        sSQL := sSQL + IntToStr(YearKbn) + ',';                     // 和暦／西暦区分
        sSQL := sSQL + IntToStr(Tashatskoujokbn) + ',';             // 他社手数料控除区分
        sSQL := sSQL + IntToStr(m_GnPuKbn_12) + ',';                // 番号管理採用区分
        sSQL := sSQL + IntToStr(m_GnPuKbn_13) + ',';                // 番号１桁数
        sSQL := sSQL + IntToStr(m_GnPuKbn_14) + ',';                // 番号１属性
        sSQL := sSQL + IntToStr(m_GnPuKbn_15) + ',';                // 番号２桁数
        sSQL := sSQL + IntToStr(m_GnPuKbn_16) + ',';                // 番号２属性
        sSQL := sSQL + IntToStr(m_MasterInfo.CodeDigit) + ',';      // 支払先／社員コード桁数
        sSQL := sSQL + IntToStr(m_MasterInfo.CodeAttr) + ',';       // 支払先／社員コード属性
        sSQL := sSQL + IntToStr(LayoutPtn) + ',';                   // 通知書レイアウト
        sSQL := sSQL + IntToStr(Order) + ',';                       // 出力順序
        sSQL := sSQL + FloatToStr(DMem_CSInfo.RecordCount) + ',';   // データ総件数
        sSQL := sSQL + '0,';                                        // 処理済件数
        sSQL := sSQL + '0,';                                        // ＰＤＦファイル作成件数
        sSQL := sSQL + '0,';                                        // メール送信件数
        sSQL := sSQL + '0,';                                        // エラー件数
        sSQL := sSQL + '0,';                                        // 状況
        sSQL := sSQL + AnsiQuotedStr('', '''') + ',';				// メッセージ
        sSQL := sSQL + 'GETDATE(),';                                // 更新日付
        sSQL := sSQL + 'GETDATE(),';                                // 登録日付
        sSQL := sSQL + FloatToStr(TantoNCD) + ',';                  // 処理者
        sSQL := sSQL + AnsiQuotedStr(sPcName, '''') + ',';          // 端末名
        if (EPayDataName.Visible) then                              // 支払データ名称
            sSQL := sSQL + AnsiQuotedStr(EPayDataName.Text, '''')
        else
            sSQL := sSQL + AnsiQuotedStr('', '''');
// <#031> ADD-STR
        for ii := 1 to 5 do
        begin
            sSQL := sSQL + ',' + AnsiQuotedStr(GetSyubetsu(ii), '''');  // 支払方法名称１～５
        end;
// <#031> ADD-END
// <#035> ADD-STR
        sSQL := sSQL + ',0';                                        // 債務区分１
        sSQL := sSQL + ',0';                                        // 債務区分２
        sSQL := sSQL + ',0';                                        // 債務区分３

// <#039> ADD-STR
        sSQL := sSQL + ',';
        sSQL := sSQL + AnsiQuotedStr('', '''') + ',';               //支払方法名称６
        sSQL := sSQL + AnsiQuotedStr('', '''') + ',';               //BCC送信先メールアドレス

        if m_MailPDFSave = 1 then
        begin
            //ファイル保存のみモード以外の場合、ファイル保存方法は「0」をセットする
            if m_DlgParam.MailPDFSaveMode <> 1 then
                m_DlgParam.MailPDFSaveMode := 0;

            sSQL := sSQL + IntToStr(m_DlgParam.MailPDFSaveMode) + ',' ; //PDFファイル保存方法

            sSQL := sSQL + AnsiQuotedStr(StringReplace(sPath + '\' + sFolder, '\', '\\', [rfReplaceAll, rfIgnoreCase]), '''') + ',';//PDFファイル保存先フォルダ
        end
        else
        begin
            sSQL := sSQL + '0,';                                        //ファイル保存方法
            sSQL := sSQL + AnsiQuotedStr('', '''') + ',';               //PDFファイル保存先フォルダ
        end;

        sSQL := sSQL + '0,';                                        //数値型ダミー１
        sSQL := sSQL + '0,';                                        //数値型ダミー２
        sSQL := sSQL + '0,';                                        //数値型ダミー３
        sSQL := sSQL + '0,';                                        //数値型ダミー４
        sSQL := sSQL + '0,';                                        //数値型ダミー５
        sSQL := sSQL + '0,';                                        //数値型ダミー６
        sSQL := sSQL + AnsiQuotedStr('', '''') + ',';               //文字型ダミー１
        sSQL := sSQL + AnsiQuotedStr('', '''') + ',';               //文字型ダミー２
        sSQL := sSQL + AnsiQuotedStr('', '''') + ',';               //文字型ダミー３
        sSQL := sSQL + AnsiQuotedStr('', '''');                     //文字型ダミー４
// <#039> ADD-END 

        iFileComp := iGetFileComp;                                  // 圧縮区分
// <#035> ADD-END

        aSQL[i] := 'INSERT INTO PAY510_TMP01_Base VALUES (' + sSQL + ')';
    end;

    with DMem_CSInfo do
    begin
        // 支払通知書データ支払先情報
        iLength := (iLength + RecordCount);
        SetLength(aSQL, iLength);

        First;

        while not Eof do
        begin
            i := i + 1;

            sSQL := FloatToStr(lvJobNo) + ',';
            sSQL := sSQL + AnsiQuotedStr(FieldByName('GCode').AsString, '''') + ',';        // 外部コード
            if (m_iSystemCode <> 1) then
                sSQL := sSQL +  '0,'
            else
                sSQL := sSQL + FloatToStr(FieldByName('SpotInfoNo').AsCurrency) + ',';          // スポット支払情報No
            sSQL := sSQL + IntToStr(FieldByName('ZipCode1').AsInteger) + ',';               // 郵便番号1
            sSQL := sSQL + IntToStr(FieldByName('ZipCode2').AsInteger) + ',';               // 郵便番号2
            sSQL := sSQL + AnsiQuotedStr(FieldByName('Address1').AsString, '''') + ',';     // 住所上段
            sSQL := sSQL + AnsiQuotedStr(FieldByName('Address2').AsString, '''') + ',';     // 住所下段
            sSQL := sSQL + AnsiQuotedStr(FieldByName('TelNo').AsString, '''') + ',';        // 電話番号
            sSQL := sSQL + AnsiQuotedStr(FieldByName('LongName').AsString, '''') + ',';     // 名称
            sSQL := sSQL + AnsiQuotedStr(FieldByName('SectionName').AsString, '''') + ',';  // 部署名
            sSQL := sSQL + AnsiQuotedStr(FieldByName('PersonName').AsString, '''') + ',';   // 担当者
            sSQL := sSQL + AnsiQuotedStr(FieldByName('TitleName').AsString, '''') + ',';    // 敬称
            sSQL := sSQL + IntToStr(FieldByName('LetterMailKbn').AsInteger) + ',';          // 支払通知書メール配信採用区分
            sSQL := sSQL + AnsiQuotedStr(FieldByName('MailAddress').AsString, '''') + ',';  // メールアドレス
            sSQL := sSQL + AnsiQuotedStr(FieldByName('ZipPass').AsString, '''') + ',';      // 支払通知書解凍パスワード
            sSQL := sSQL + '0,';                                                            // ステータス
            sSQL := sSQL + AnsiQuotedStr('', '''') + ',';									// メッセージ
            sSQL := sSQL + FloatToStr(FieldByName('Ncode').AsCurrency) + ',';               // 内部コード
            sSQL := sSQL + IntToStr(FieldByName('MailSendKbn').AsInteger) + ',';            // メール配信区分

            sSQL := sSQL + AnsiQuotedStr(FieldByName('GCode').AsString, '''') + ',';        // 支払先コード
            sSQL := sSQL + AnsiQuotedStr(FieldByName('KM1100140').AsString, '''') + ',';    // 支払先名称カナ
            sSQL := sSQL + AnsiQuotedStr(FieldByName('KM1100150').AsString, '''') + ',';    // 支払先名称
            sSQL := sSQL + AnsiQuotedStr(FieldByName('KM1200021').AsString, '''') + ',';    // 郵便番号
            sSQL := sSQL + AnsiQuotedStr(FieldByName('KM1200050').AsString, '''') + ',';    // 住所上段
            sSQL := sSQL + AnsiQuotedStr(FieldByName('KM1200060').AsString, '''') + ',';    // 住所下段
            sSQL := sSQL + AnsiQuotedStr(FieldByName('KM1200070').AsString, '''') + ',';    // 電話番号
            sSQL := sSQL + AnsiQuotedStr(FieldByName('KM1200100').AsString, '''') + ',';    // 送付先部署名
            sSQL := sSQL + AnsiQuotedStr(FieldByName('KM1200110').AsString, '''') + ',';    // 担当者名
            sSQL := sSQL + AnsiQuotedStr(FieldByName('KM1200120').AsString, '''') + ',';    // 担当者敬称
            sSQL := sSQL + AnsiQuotedStr(FieldByName('KM1200230').AsString, '''') + ',';    // 受取人名
            sSQL := sSQL + IntToStr(FieldByName('KM1410061').AsInteger) + ',';              // （振込）振込先銀行コード
            sSQL := sSQL + AnsiQuotedStr(FieldByName('KM1410062').AsString, '''') + ',';    // （振込）振込先銀行名称
            sSQL := sSQL + AnsiQuotedStr(FieldByName('KM1410063').AsString, '''') + ',';    // （振込）振込先銀行名称カナ
            sSQL := sSQL + IntToStr(FieldByName('KM1410064').AsInteger) + ',';              // （振込）振込先支店コード
            sSQL := sSQL + AnsiQuotedStr(FieldByName('KM1410065').AsString, '''') + ',';    // （振込）振込先支店名称
            sSQL := sSQL + AnsiQuotedStr(FieldByName('KM1410066').AsString, '''') + ',';    // （振込）振込先支店名称カナ
            sSQL := sSQL + AnsiQuotedStr(FieldByName('KM1410080').AsString, '''') + ',';    // （振込）口座番号
            sSQL := sSQL + AnsiQuotedStr(FieldByName('KM1410100').AsString, '''') + ',';    // （振込）受取人名／名義人
            sSQL := sSQL + AnsiQuotedStr(FieldByName('KM1410110').AsString, '''') + ',';    // （振込）カナ振込先名／カナ名義人
            sSQL := sSQL + AnsiQuotedStr(FieldByName('KM1410150').AsString, '''') + ',';    // （振込）ＥＤＩ情報
            sSQL := sSQL + AnsiQuotedStr(FieldByName('KM1410160').AsString, '''') + ',';    // （振込）顧客コード１
            sSQL := sSQL + AnsiQuotedStr(FieldByName('KM1410170').AsString, '''') + ',';    // （振込）顧客コード２
            sSQL := sSQL + IntToStr(FieldByName('KM1420061').AsInteger) + ',';              // （期日）振込先銀行コード
            sSQL := sSQL + AnsiQuotedStr(FieldByName('KM1420062').AsString, '''') + ',';    // （期日）振込先銀行名称
            sSQL := sSQL + AnsiQuotedStr(FieldByName('KM1420063').AsString, '''') + ',';    // （期日）振込先銀行名称カナ
            sSQL := sSQL + IntToStr(FieldByName('KM1420064').AsInteger) + ',';              // （期日）振込先支店コード
            sSQL := sSQL + AnsiQuotedStr(FieldByName('KM1420065').AsString, '''') + ',';    // （期日）振込先支店名称
            sSQL := sSQL + AnsiQuotedStr(FieldByName('KM1420066').AsString, '''') + ',';    // （期日）振込先支店名称カナ
            sSQL := sSQL + AnsiQuotedStr(FieldByName('KM1420080').AsString, '''') + ',';    // （期日）口座番号
            sSQL := sSQL + AnsiQuotedStr(FieldByName('KM1420100').AsString, '''') + ',';    // （期日）受取人名／名義人
            sSQL := sSQL + AnsiQuotedStr(FieldByName('KM1420110').AsString, '''') + ',';    // （期日）カナ振込先名／カナ名義人
            sSQL := sSQL + AnsiQuotedStr(FieldByName('KM1420150').AsString, '''') + ',';    // （期日）ＥＤＩ情報'
            sSQL := sSQL + AnsiQuotedStr(FieldByName('KM1420160').AsString, '''') + ',';    // （期日）顧客コード１
            sSQL := sSQL + AnsiQuotedStr(FieldByName('KM1420170').AsString, '''') + ',';    // （期日）顧客コード２

            sSQL := sSQL + AnsiQuotedStr('', '''') + ',';									// 氏名
            sSQL := sSQL + AnsiQuotedStr('', '''') + ',';									// カナ
            sSQL := sSQL + '0,';															// 生年月日
            sSQL := sSQL + AnsiQuotedStr('', '''') + ',';									// 郵便番号
            sSQL := sSQL + AnsiQuotedStr('', '''') + ',';									// 現住所上段
            sSQL := sSQL + AnsiQuotedStr('', '''') + ',';									// 現住所下段
            sSQL := sSQL + AnsiQuotedStr('', '''') + ',';									// 電話番号
            sSQL := sSQL + AnsiQuotedStr('', '''') + ',';									// 社員コード
            sSQL := sSQL + AnsiQuotedStr('', '''') + ',';									// 所属No
            sSQL := sSQL + AnsiQuotedStr('', '''') + ',';									// 所属名
            sSQL := sSQL + '0,';															// 振込先銀行コード
            sSQL := sSQL + AnsiQuotedStr('', '''') + ',';									// 振込先銀行名称
            sSQL := sSQL + AnsiQuotedStr('', '''') + ',';									// 振込先銀行名称カナ
            sSQL := sSQL + '0,';															// 振込先支店コード
            sSQL := sSQL + AnsiQuotedStr('', '''') + ',';									// 振込先支店名称
            sSQL := sSQL + AnsiQuotedStr('', '''') + ',';									// 振込先支店名称カナ
            sSQL := sSQL + AnsiQuotedStr('', '''') + ',';									// 口座番号
            sSQL := sSQL + AnsiQuotedStr('', '''') + ',';									// 受取人名／名義人
            sSQL := sSQL + AnsiQuotedStr('', '''') + ',';									// カナ振込先名／カナ名義人

            sSQL := sSQL + AnsiQuotedStr(FieldByName('Renso').AsString, '''') + ',';        // 連想
            sSQL := sSQL + IntToStr(i);                                                     // 印刷順序
            sSQL := sSQL + ',0,0';                                                          // 手形明細件数・電子債権明細件数 <#032> ADD
// <#035> ADD-STR
            sSQL := sSQL + ',' + IntToStr(iFileComp);                                       // 圧縮区分
            sSQL := sSQL + ',0';                                                            // 債務区分１
            sSQL := sSQL + ',0';                                                            // 債務区分２
            sSQL := sSQL + ',0';                                                            // 債務区分３
// <#035> ADD-END

            aSQL[i] := 'INSERT INTO PAY510_TMP02_CSInfo VALUES (' + sSQL + ')';

            Next;
        end;
    end;

    with DMem_Uchiwake do
    begin
        // 支払通知書データ内訳情報
        iLength := (iLength + RecordCount);
        SetLength(aSQL, iLength);

        sGCode := '';
        iEdaNo := 0;

        First;

        while not Eof do
        begin
            i := i + 1;

            if (sGCode <> FieldByName('GCode').AsString) then
            begin
                sGCode := FieldByName('GCode').AsString;
                iEdaNo := 1;
            end
            else
                iEdaNo := iEdaNo + 1;

            sSQL := FloatToStr(lvJobNo) + ',';
            sSQL := sSQL + AnsiQuotedStr(sGCode, '''') + ',';                               // 支払先外部コード
            if (m_iSystemCode <> 1) then
                sSQL := sSQL +  '0,'
            else
                sSQL := sSQL + FloatToStr(FieldByName('SpotInfoNo').AsCurrency) + ',';          // スポット支払情報No
            sSQL := sSQL + IntToStr(iEdaNo) + ',';                                          // 枝番
// <#032> ADD-STR
            if (FieldByName('ERKbn').AsBoolean) then
                sSQL := sSQL + '13,'        // 電子債権の場合、レコード種別を13としてセットする
            else
// <#032> ADD-END
                sSQL := sSQL + IntToStr(FieldByName('RecSyubetu').AsInteger) + ',';             // レコード種別
            sSQL := sSQL + IntToStr(FieldByName('Site').AsInteger) + ',';                   // サイト
            sSQL := sSQL + FloatToStr(FieldByName('ShiharaiKin').AsCurrency) + ',';         // 金額
            sSQL := sSQL + FloatToStr(FieldByName('TashaFee').AsCurrency) + ',';            // 他社手数料
            sSQL := sSQL + IntToStr(FieldByName('FeePayKbn').AsInteger) + ',';              // 手数料負担区分
            sSQL := sSQL + AnsiQuotedStr(FieldByName('BankName').AsString, '''') + ',';     // 振込先銀行名
            sSQL := sSQL + AnsiQuotedStr(FieldByName('BkBraName').AsString, '''') + ',';    // 振込先支店名
            sSQL := sSQL + IntToStr(FieldByName('AccKbn').AsInteger) + ',';                 // 預金種目
            sSQL := sSQL + AnsiQuotedStr(FieldByName('AccNo').AsString, '''') + ',';        // 口座番号
            sSQL := sSQL + IntToStr(FieldByName('Mankibi').AsInteger) + ',';                // 満期日
            sSQL := sSQL + AnsiQuotedStr(FieldByName('LongName').AsString, '''') + ',';     // 銀行名称
            sSQL := sSQL + IntToStr(FieldByName('PayDay').AsInteger) + ',';                 // 支払日
            sSQL := sSQL + IntToStr(FieldByName('Bunkatusuu').AsInteger);                   // 手形枚数
// <#039> ADD-STR
            sSQL := sSQL + ',';
            sSQL := sSQL + '0,';                                                            //手形・小切手郵送区分
            sSQL := sSQL + '0';                                                             //手形・小切手郵送料負担区分
// <#039> ADD-END

            aSQL[i] := 'INSERT INTO PAY510_TMP03_Uchiwake VALUES (' + sSQL + ')';

            Next;
        end;
    end;

    with DMem_PayPlanData do
    begin
        // 支払通知書データ集計情報
        iLength := (iLength + RecordCount);
        SetLength(aSQL, iLength);

        First;

        while not Eof do
        begin
            i := i + 1;

            sSQL := FloatToStr(lvJobNo) + ',';
            sSQL := sSQL + AnsiQuotedStr(FieldByName('GCode').AsString, '''') + ',';        // 外部コード
            if (m_iSystemCode <> 1) then
                sSQL := sSQL +  '0,'
            else
                sSQL := sSQL + FloatToStr(FieldByName('SpotInfoNo').AsCurrency) + ',';          // スポット支払情報No
            sSQL := sSQL + FloatToStr(FieldByName('ZenkaiKin').AsCurrency) + ',';           // 前回繰越額
            sSQL := sSQL + FloatToStr(FieldByName('ToukaiKin').AsCurrency) + ',';           // 当回取引額
            sSQL := sSQL + FloatToStr(FieldByName('SateiKin').AsCurrency) + ',';            // 今回合計額
            sSQL := sSQL + FloatToStr(FieldByName('JikaiKin').AsCurrency) + ',';            // 次回繰越額
            sSQL := sSQL + FloatToStr(FieldByName('KoujyoKin').AsCurrency) + ',';           // 控除金額
            sSQL := sSQL + FloatToStr(FieldByName('SousaiKin').AsCurrency) + ',';           // 相殺金額
            sSQL := sSQL + FloatToStr(FieldByName('PayPrice').AsCurrency) + ',';            // 今回支払額
            sSQL := sSQL + FloatToStr(FieldByName('SumTori').AsCurrency) + ',';             // 取引明細金額
            sSQL := sSQL + FloatToStr(FieldByName('SumNote').AsCurrency) + ',';             // 手形明細金額
            sSQL := sSQL + FloatToStr(FieldByName('SumDed').AsCurrency) + ',';              // 控除明細金額
            sSQL := sSQL + FloatToStr(FieldByName('SumBmnSatei').AsCurrency) + ',';         // 事業所査定金額
            sSQL := sSQL + FloatToStr(FieldByName('SumBmnSousai').AsCurrency) + ',';        // 事業所相殺金額
            sSQL := sSQL + FloatToStr(FieldByName('SumKijSatei').AsCurrency) + ',';         // 期日指定振込支払金額
            sSQL := sSQL + FloatToStr(FieldByName('SumKijFee').AsCurrency);                 // 期日指定振込手数料金額

            aSQL[i] := 'INSERT INTO PAY510_TMP04_PayPlanData VALUES (' + sSQL + ')';

            Next;
        end;
    end;

    with DMem_Koujyo do
    begin
        // 支払通知書データ控除情報
        iLength := (iLength + RecordCount);
        SetLength(aSQL, iLength);

        sGCode := '';
        iEdaNo := 0;

        First;

        while not Eof do
        begin
            i := i + 1;

            if (sGCode <> FieldByName('GCode').AsString) then
            begin
                sGCode := FieldByName('GCode').AsString;
                iEdaNo := 1;
            end
            else
                iEdaNo := iEdaNo + 1;

            sSQL := FloatToStr(lvJobNo) + ',';
            sSQL := sSQL + AnsiQuotedStr(sGCode, '''') + ',';                               // 支払先外部コード
            if (m_iSystemCode <> 1) then
                sSQL := sSQL +  '0,'
            else
                sSQL := sSQL + FloatToStr(FieldByName('SpotInfoNo').AsCurrency) + ',';          // スポット支払情報No
            sSQL := sSQL + IntToStr(iEdaNo) + ',';                                          // 枝番
            sSQL := sSQL + AnsiQuotedStr(FieldByName('SimpleName').AsString, '''') + ',';   // 控除科目名
            sSQL := sSQL + FloatToStr(FieldByName('SousaiKin').AsCurrency);                 // 控除額

            aSQL[i] := 'INSERT INTO PAY510_TMP05_Koujo VALUES (' + sSQL + ')';

            Next;
        end;
    end;

    with DMem_Tori do
    begin
        // 支払通知書データ取引明細情報
        iLength := (iLength + RecordCount);
        SetLength(aSQL, iLength);

        sGCode := '';
        iEdaNo := 0;

        First;

        while not Eof do
        begin
            i := i + 1;

            if (sGCode <> FieldByName('GCode').AsString) then
            begin
                sGCode := FieldByName('GCode').AsString;
                iEdaNo := 1;
            end
            else
                iEdaNo := iEdaNo + 1;

            sSQL := FloatToStr(lvJobNo) + ',';
            sSQL := sSQL + AnsiQuotedStr(sGCode, '''') + ',';                               // 支払先外部コード
            if (m_iSystemCode <> 1) then
                sSQL := sSQL +  '0,'
            else
                sSQL := sSQL + FloatToStr(FieldByName('SpotInfoNo').AsCurrency) + ',';          // スポット支払情報No
            sSQL := sSQL + IntToStr(iEdaNo) + ',';                                          // 枝番
            sSQL := sSQL + AnsiQuotedStr(FieldByName('HasseiDay').AsString, '''') + ',';    // 発生日
            sSQL := sSQL + AnsiQuotedStr(FieldByName('Tekiyou').AsString, '''') + ',';      // 摘要
            sSQL := sSQL + AnsiQuotedStr(FieldByName('CNumValue1').AsString, '''') + ',';   // 番号1
            sSQL := sSQL + AnsiQuotedStr(FieldByName('CNumValue2').AsString, '''') + ',';   // 番号2
            sSQL := sSQL + FloatToStr(FieldByName('THasseiKin').AsCurrency);                // 金額
// <#039> ADD-STR
            sSQL := sSQL + ',';
            sSQL := sSQL + AnsiQuotedStr('', '''') + ',';                                   //相手科目コード
            sSQL := sSQL + AnsiQuotedStr('', '''') + ',';                                   //相手科目名称
            sSQL := sSQL + AnsiQuotedStr('', '''') + ',';                                   //相手部門コード
            sSQL := sSQL + AnsiQuotedStr('', '''') + ',';                                   //相手部門名称
            sSQL := sSQL + AnsiQuotedStr('', '''');                                         //事業所名
// <#039> ADD-END

            aSQL[i] := 'INSERT INTO PAY510_TMP06_Tori VALUES (' + sSQL + ')';

            Next;
        end;
    end;

    with DMem_Teg do
    begin
        // 支払通知書データ手形明細情報
        iLength := (iLength + RecordCount);
        SetLength(aSQL, iLength);

        sGCode := '';
        iEdaNo := 0;

        First;

        while not Eof do
        begin
            i := i + 1;

            if (sGCode <> FieldByName('GCode').AsString) then
            begin
                sGCode := FieldByName('GCode').AsString;
                iEdaNo := 1;
            end
            else
                iEdaNo := iEdaNo + 1;

            sSQL := FloatToStr(lvJobNo) + ',';
            sSQL := sSQL + AnsiQuotedStr(sGCode, '''') + ',';                               // 支払先外部コード
            sSQL := sSQL + IntToStr(iEdaNo) + ',';                                          // 枝番
            sSQL := sSQL + AnsiQuotedStr(FieldByName('BankSqNo').AsString, '''') + ',';     // 手形NO
            sSQL := sSQL + IntToStr(FieldByName('Mankibi').AsInteger) + ',';                // 満期日
            sSQL := sSQL + IntToStr(FieldByName('Fridasibi').AsInteger) + ',';              // 振出日
            sSQL := sSQL + FloatToStr(FieldByName('SiharaiKin').AsCurrency) + ',';          // 金額
            sSQL := sSQL + AnsiQuotedStr(FieldByName('LongName').AsString, '''');           // 支払場所
            sSQL := sSQL + ',' + IntToStr(FieldByName('TegKbn').AsInteger);                 // 支払手形区分 <#032> ADD

            aSQL[i] := 'INSERT INTO PAY510_TMP07_Teg VALUES (' + sSQL + ')';

            Next;
        end;
    end;

// <#032> ADD-STR
    // 手形明細件数・電子債権明細件数集計
    iLength := (iLength + 1);
    SetLength(aSQL, iLength);

    i := i + 1;
    aSQL[i] := 'UPDATE PAY510_TMP02_CSInfo SET TegCnt = ISNULL(B.TegSum, 0), ErCnt = ISNULL(B.ErSum, 0)' +
               '  FROM PAY510_TMP02_CSInfo' +
               ' INNER JOIN (SELECT C.JobNo, C.GCode, T.CNT TegSum, E.CNT ErSum' +
                            '  FROM PAY510_TMP02_CSInfo C' +
                            '  LEFT JOIN (SELECT JobNo, GCode, COUNT(TegKbn) CNT FROM PAY510_TMP07_Teg WHERE TegKbn <> 2 GROUP BY JobNo, GCode) T ON C.JobNo = T.JobNo AND C.GCode = T.GCode' +
                            '  LEFT JOIN (SELECT JobNo, GCode, COUNT(TegKbn) CNT FROM PAY510_TMP07_Teg WHERE TegKbn = 2 GROUP BY JobNo, GCode) E ON C.JobNo = E.JobNo AND C.GCode = E.GCode' +
                            ' WHERE C.JobNo = ' + FloatToStr(lvJobNo) + ') B' +
               '    ON PAY510_TMP02_CSInfo.JobNo = B.JobNo' +
               '   AND PAY510_TMP02_CSInfo.GCode = B.GCode' +
               ' WHERE PAY510_TMP02_CSInfo.JobNo = ' + FloatToStr(lvJobNo);
// <#032> ADD-END

    with DMem_Jigyousho do
    begin
        // 支払通知書データ事業所情報
        iLength := (iLength + RecordCount);
        SetLength(aSQL, iLength);

        sGCode := '';
        iEdaNo := 0;

        First;

        while not Eof do
        begin
            i := i + 1;

            if (sGCode <> FieldByName('GCode').AsString) then
            begin
                sGCode := FieldByName('GCode').AsString;
                iEdaNo := 1;
            end
            else
                iEdaNo := iEdaNo + 1;

            sSQL := FloatToStr(lvJobNo) + ',';
            sSQL := sSQL + AnsiQuotedStr(sGCode, '''') + ',';                               // 支払先外部コード
            if (m_iSystemCode <> 1) then
                sSQL := sSQL +  '0,'
            else
                sSQL := sSQL + FloatToStr(FieldByName('SpotInfoNo').AsCurrency) + ',';          // スポット支払情報No
            sSQL := sSQL + IntToStr(iEdaNo) + ',';                                          // 枝番
            sSQL := sSQL + AnsiQuotedStr(FieldByName('LongName').AsString, '''') + ',';     // 事業所名
            sSQL := sSQL + FloatToStr(FieldByName('SateiKin').AsCurrency) + ',';            // 支払金額
            sSQL := sSQL + FloatToStr(FieldByName('SousaiKin').AsCurrency);                 // 相殺金額

            aSQL[i] := 'INSERT INTO PAY510_TMP08_Jigyousho VALUES (' + sSQL + ')';

            Next;
        end;
    end;

    with DMem_Kijitsu do
    begin
        // 支払通知書データ期日指定残高情報
        iLength := (iLength + RecordCount);
        SetLength(aSQL, iLength);

        sGCode := '';
        iEdaNo := 0;

        First;

        while not Eof do
        begin
            i := i + 1;

            if (sGCode <> FieldByName('GCode').AsString) then
            begin
                sGCode := FieldByName('GCode').AsString;
                iEdaNo := 1;
            end
            else
                iEdaNo := iEdaNo + 1;

            sSQL := FloatToStr(lvJobNo) + ',';
            sSQL := sSQL + AnsiQuotedStr(sGCode, '''') + ',';                               // 支払先外部コード
            sSQL := sSQL + IntToStr(iEdaNo) + ',';                                          // 枝番
            sSQL := sSQL + IntToStr(FieldByName('Mankibi').AsInteger) + ',';                // 満期日
            sSQL := sSQL + FloatToStr(FieldByName('SiharaiKin').AsCurrency) + ',';          // 残高金額
            sSQL := sSQL + FloatToStr(FieldByName('TashaFee').AsCurrency) + ',';            // 他社手数料
            sSQL := sSQL + IntToStr(FieldByName('FeePayKbn').AsInteger) + ',';              // 手数料負担区分
            sSQL := sSQL + IntToStr(FieldByName('FeeSwkKbn').AsInteger) + ',';              // 手数料仕訳起票区分
            sSQL := sSQL + AnsiQuotedStr(FieldByName('TKanriNo').AsString, '''');           // 管理ＮＯ

            aSQL[i] := 'INSERT INTO PAY510_TMP09_Kijitsu VALUES (' + sSQL + ')';

            Next;
        end;
    end;

    oQuery := Nil;
    try
    	oQuery	:= TMQuery.Create(Nil);
	    m_DataModule.SetDBInfoToQuery(m_DBCorp, oQuery);

        sSQL := '';

        try
            for i := 0 to iLength - 1 do
            begin
                sSQL := sSQL + aSQL[i] + ' ' ;

                if (((i + 1) mod 100) = 0) then
                    ExecPoolSQL();
            end;

            if (sSQL <> '') then
                ExecPoolSQL();
        except
          on E: Exception do MjsMessageBoxEx(Self, 'メール配信データの登録処理に失敗しました。' + #13#10 + #13#10 + E.Message,
                                            '支払通知書', mjError, mjOk, mjDefOk);
        end;
    finally
    	if Assigned(oQuery) then oQuery.Free;
    end;

    // メール配信サービス呼び出し
	cService := TPAYTrnServiceClient.Create;
	with cService do
	begin
		try
			AppRecord	:= m_pRec;
			Owner		:= Self;
			JobNo		:= Trunc(lvJobNo);
            PayNCode    := 0;

    		//実行
			iStatus     := Execute;
		finally
			Free;
		end;
    end;	//end with

    // ログファイル作成
    sLogFile := rcCOMMONAREA(m_pRec^.m_pCommonArea^).SysCliRoot +
                '\tmp\PAYMAILS_' +
                Format('%.8d', [m_pRec^.m_iCorpCode]) + '_' +
                Format('%.8d', [m_iKStDate]) + '_' +
                Format('%.10d',[Trunc(lvJobNo)]) + '.Log';

    sTitle   := Nil;
    sMemFld   := TStringList.Create;

	sMemFld.Add('GCode');
	sMemFld.Add('LongName');
	sMemFld.Add('MailSendKbnNm');
	sMemFld.Add('MailAddress');
	sMemFld.Add('StateNm');

    PrnSupport := TMjsPrnSupport.Create;

    PrnSupport.iFileType    := 0;               //出力形式（0：csv）
    PrnSupport.strFileName  := sLogFile;        //ファイル名
    PrnSupport.bTitleOut    := false;           //タイトル出すか出さないか（出さない固定）
	PrnSupport.pApRec		:= pointer(m_pRec);

    oQuery := Nil;
    try
    	oQuery	:= TMQuery.Create(Nil);
	    m_DataModule.SetDBInfoToQuery(m_DBCorp, oQuery);

        with oQuery do
        begin
            Close;
            SQL.Clear;
            Params.Clear;

            SQL.Add('SELECT GCode, LongName,');
            SQL.Add('       CASE MailSendKbn');
            SQL.Add('       WHEN 1 THEN ' + AnsiQuotedStr('メール配信あり', ''''));
            SQL.Add('       WHEN 2 THEN ' + AnsiQuotedStr('配信済み', ''''));
            SQL.Add('              ELSE ' + AnsiQuotedStr('', ''''));
            SQL.Add('        END MailSendKbnNm,');
            SQL.Add('       MailAddress,');
            SQL.Add('       CASE State');
            SQL.Add('       WHEN 0 THEN ' + AnsiQuotedStr('', ''''));
            SQL.Add('       WHEN 2 THEN ' + AnsiQuotedStr('正常終了', ''''));
            SQL.Add('              ELSE IF ISNULL(Msg, ' + AnsiQuotedStr('', '''') + ') = ' + AnsiQuotedStr('', '''') + ' THEN ' + AnsiQuotedStr('メール送信できませんでした', '''') + ' ELSE Msg ENDIF');
            SQL.Add('        END StateNm');
            SQL.Add('  FROM PAY510_TMP02_CSInfo');
            SQL.Add(' WHERE JobNo  = ' + FloatToStr(Trunc(lvJobNo)));
            SQL.Add(' ORDER BY GCode');

            if Open = False then
            begin
                MjsMessageBoxEx(Self, 'メール配信データログの作成処理に失敗しました。',
                                '支払通知書', mjError, mjOk, mjDefOk);
                Exit;
            end;

            // CSVアウト
            if MjsFileOut(oQuery, sMemFld, sTitle, PrnSupport, m_pRec ,True) <> 0 then
            begin
                MjsMessageBoxEx(Self, 'メール配信データログの出力処理に失敗しました。',
                                '支払通知書', mjError, mjOk, mjDefOk);
                Exit;
            end;
        end;
    finally
    	if Assigned(oQuery) then oQuery.Free;
    end;

    sTitle.Free;
    sMemFld.Free;

   	if Assigned(PrnSupport) then
   	begin
   		FreeAndNil(PrnSupport); //印刷情報登録パラメータオブジェクト破棄
   	end;

    // メール配信結果取得
    oQuery := Nil;
    try
    	oQuery	:= TMQuery.Create(Nil);
	    m_DataModule.SetDBInfoToQuery(m_DBCorp, oQuery);

        with oQuery do
        begin
            Close;
            SQL.Clear;
            Params.Clear;

            SQL.Add('SELECT COUNT(*) ErrorCount');
            SQL.Add('  FROM PAY510_TMP02_CSInfo');
            SQL.Add(' WHERE JobNo  = ' + FloatToStr(Trunc(lvJobNo)));
            SQL.Add('   AND State < 0');

            if Open = False then
            begin
                MjsMessageBoxEx(Self, 'メール配信結果の取得処理に失敗しました。',
                                '支払通知書', mjError, mjOk, mjDefOk);
                Exit;
            end;

            iErrCount := FieldByName('ErrorCount').AsInteger;
        end;
    finally
    	if Assigned(oQuery) then oQuery.Free;
    end;

    // ログ表示
    if (iErrCount <> 0) then
    begin
        MjsMessageBoxEx(Self, '送信できなかった支払先がありましたので、ログを表示します。',
			                '支払通知書', mjInformation, mjOk, mjDefOk);

        PAYCallProgram(Self.Handle, sLogFile, '', '');
    end;

// <#039> ADD-STR
    if m_MailPDFSave = 1 then
    begin
        //今回保存フォルダが1件以上作成されている場合（作成されていればsFolderは空ではない）
        //保存フォルダを規定のシェルで表示
        if (sFolder <> '') and (SysUtils.DirectoryExists(sPath + '\' + sFolder)) then
        begin
            oQuery := Nil;
            try
    	        oQuery	:= TMQuery.Create(Nil);
        	    m_DataModule.SetDBInfoToQuery(m_DBCorp, oQuery);

                with oQuery do
                begin
                    Close;
                    SQL.Clear;
                    Params.Clear;

                    SQL.Add('SELECT OverCount ');
                    SQL.Add('  FROM PAY510_TMP01_Base');
                    SQL.Add(' WHERE JobNo  = ' + FloatToStr(Trunc(lvJobNo)));

                    if Open = False then
                    begin
                        MjsMessageBoxEx(Self, '処理済件数の取得処理に失敗しました。',
                                        '支払通知書', mjError, mjOk, mjDefOk);
                        Exit;
                    end;

                    iOverCount := FieldByName('OverCount').AsInteger;   //処理済件数を取得
                end;
            finally
    	        if Assigned(oQuery) then oQuery.Free;
            end;

            if iOverCount >= 1 then
                PAYCallProgram(Self.Handle, sPath + '\' + sFolder, '', '');
        end;
    end;
// <#039> ADD-END
    
    // ワークテーブル削除
//	if (MjsMessageBoxEx(Self, 'ワークテーブルを削除しちゃいます。よろしいですか？', '確認', mjQuestion, mjYesNo, mjDefYes) <> mrYes) then
        Exit;

    oQuery := Nil;
    try
    	oQuery	:= TMQuery.Create(Nil);
	    m_DataModule.SetDBInfoToQuery(m_DBCorp, oQuery);

        sSQL := '';

        try
            for i := 1 to 9 do
            begin
            	case i of
                    1:  sTblNm := 'Base';
                    2:  sTblNm := 'CSInfo';
                    3:  sTblNm := 'Uchiwake';
                    4:  sTblNm := 'PayPlanData';
                    5:  sTblNm := 'Koujo';
                    6:  sTblNm := 'Tori';
                    7:  sTblNm := 'Teg';
                    8:  sTblNm := 'Jigyousho';
                    9:  sTblNm := 'Kijitsu';
                end;

                sSQL := sSQL + 'DELETE FROM PAY510_TMP0' + IntToStr(i) + '_' + sTblNm +
                               ' WHERE JobNo = ' + FloatToStr(Trunc(lvJobNo)) + ' ';
            end;

            ExecPoolSQL();
        except
          on E: Exception do MjsMessageBoxEx(Self, 'メール配信データの削除処理に失敗しました。' + #13#10 + #13#10 + E.Message,
                                            '支払通知書', mjError, mjOk, mjDefOk);
        end;
    finally
    	if Assigned(oQuery) then oQuery.Free;
    end;
end;

//**************************************************************************
//  Proccess    :   プログラムを実行する
//  Name        :   T.SATOH(GSOL)
//  Date        :	2010/11/22
//  Parameter   :
//  Return      :
//  History     :   2000/99/99  X.Xxxxxx
//                  XXXXXXXX修正内容
//**************************************************************************
procedure TPay510100f.PAYCallProgram(aHandle: HWND; const aFileName: String; const aParam: String; const aFilePath: String);
var
    cFileName: String;
    pFileName: PChar;
    cParam: String;
    pParam: PChar;
    cFilePath: String;
    pFilePath: PChar;
begin
    cFileName := aFileName;
    pFileName := StrAlloc((Length(cFileName)+1) * SizeOf(Char));
    StrPCopy(pFileName, cFileName);

    cParam := aParam;
    pParam := StrAlloc((Length(cParam)+1) * SizeOf(Char));
    StrPCopy(pParam, cParam);

    cFilePath := aFilePath;
    pFilePath := StrAlloc((Length(cFilePath)+1) * SizeOf(Char));
    StrPCopy(pFilePath, cFilePath);

    ShellExecute(aHandle, 'open', pFileName, pParam, pFilePath, SW_SHOW);

    StrDispose(pFileName);
    StrDispose(pParam);
    StrDispose(pFilePath);
end;
// <#025> ADD-END

end.
