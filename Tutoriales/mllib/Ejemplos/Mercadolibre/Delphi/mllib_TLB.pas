unit mllib_TLB;

// ************************************************************************ //
// WARNING
// -------
// The types declared in this file were generated from data read from a
// Type Library. If this type library is explicitly or indirectly (via
// another type library referring to this type library) re-imported, or the
// 'Refresh' command of the Type Library Editor activated while editing the
// Type Library, the contents of this file will be regenerated and all
// manual modifications will be lost.
// ************************************************************************ //

// $Rev: 52393 $
// File generated on 26/9/2022 10:37:45 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Users\elect\OneDrive\Documentos\Embarcadero\Studio\Projects\mplib\mllib (1)
// LIBID: {4EA5C8BC-5560-439F-A1DA-984D0B82AD5A}
// LCID: 0
// Helpfile:
// HelpString: mllib - Mercadolibre by Bit Ingenieria
// DepndLst:
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
//   (2) v4.0 StdVCL, (stdvcl40.dll)
// SYS_KIND: SYS_WIN32
// Errors:
//   Hint: Member 'program' of 'Iloyalty' changed to 'program_'
//   Hint: Parameter 'unit' of Iloyalty.addProduct changed to 'unit_'
//   Hint: Parameter 'type' of Iloyalty.cashier_identification changed to 'type_'
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers.
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ALIGN 4}

interface

uses Winapi.Windows, System.Classes, System.Variants, System.Win.StdVCL, Vcl.Graphics, Vcl.OleServer, Winapi.ActiveX;


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:
//   Type Libraries     : LIBID_xxxx
//   CoClasses          : CLASS_xxxx
//   DISPInterfaces     : DIID_xxxx
//   Non-DISP interfaces: IID_xxxx
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  mllibMajorVersion = 1;
  mllibMinorVersion = 0;

  LIBID_mllib: TGUID = '{4EA5C8BC-5560-439F-A1DA-984D0B82AD5A}';

  IID_IMPService: TGUID = '{B544FCE1-C458-4F1F-9E0A-156EAF4CC682}';
  CLASS_MPService: TGUID = '{50FF357E-C78D-4C42-9F03-E405EF0DC786}';
  IID_Imerchant_order: TGUID = '{F4BA50DF-98B8-48B0-91FC-8087516A9C84}';
  CLASS_merchant_order: TGUID = '{B4D14995-2F7A-47C4-822E-04C1795036A6}';
  IID_Iloyalty: TGUID = '{8ADFA135-E2A7-4DEE-8D17-674F4730FB6E}';
  CLASS_loyalty: TGUID = '{902D80C8-8D60-4AA6-9906-61A3AA929B42}';
  IID_IPayment: TGUID = '{6B8837F3-4EAE-4738-BDCC-F3F6E60008B7}';
  CLASS_Payment: TGUID = '{0D662A74-0FE0-4802-8DB3-9FF7819DDE39}';
  IID_IMLService: TGUID = '{90017972-481D-4FCA-B30B-010158B9FACB}';
  CLASS_MLService: TGUID = '{661294D3-313C-463A-B1A3-1C713398876B}';
  IID_IJsonObject: TGUID = '{CBD2FC29-AA2C-4A03-AC0E-F8004DBDF4C7}';
  CLASS_JsonObject: TGUID = '{650F2776-069D-4534-9674-9DBC9A964A37}';
  IID_IJsonArray: TGUID = '{0C34D73D-3752-49CD-87F9-FAD942A7F982}';
  CLASS_JsonArray: TGUID = '{06146A09-CCCE-48EC-8651-EB7C0CB80A42}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary
// *********************************************************************//
  IMPService = interface;
  IMPServiceDisp = dispinterface;
  Imerchant_order = interface;
  Imerchant_orderDisp = dispinterface;
  Iloyalty = interface;
  IloyaltyDisp = dispinterface;
  IPayment = interface;
  IPaymentDisp = dispinterface;
  IMLService = interface;
  IMLServiceDisp = dispinterface;
  IJsonObject = interface;
  IJsonObjectDisp = dispinterface;
  IJsonArray = interface;
  IJsonArrayDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library
// (NOTE: Here we map each CoClass to its Default Interface)
// *********************************************************************//
  MPService = IMPService;
  merchant_order = Imerchant_order;
  loyalty = Iloyalty;
  Payment = IPayment;
  MLService = IMLService;
  JsonObject = IJsonObject;
  JsonArray = IJsonArray;


// *********************************************************************//
// Interface: IMPService
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B544FCE1-C458-4F1F-9E0A-156EAF4CC682}
// *********************************************************************//
  IMPService = interface(IDispatch)
    ['{B544FCE1-C458-4F1F-9E0A-156EAF4CC682}']
    function Get_pos_id: Integer; safecall;
    procedure Set_pos_id(Value: Integer); safecall;
    function newMerchant_order: Imerchant_order; safecall;
    function sendMerchant_order: OLE_CANCELBOOL; safecall;
    function getMerchant_order(const external_reference: WideString): OLE_CANCELBOOL; safecall;
    function Get_getMerchant_order_result: Imerchant_order; safecall;
    function newUuid: WideString; safecall;
    function deleteMerchant_order: OLE_CANCELBOOL; safecall;
    procedure configuracion; safecall;
    function queryMerchant_order(const external_reference: WideString): OLE_CANCELBOOL; safecall;
    function paymentRefund(const id: WideString; amount: Double): OLE_CANCELBOOL; safecall;
    function paymentCancel(const id: WideString): OLE_CANCELBOOL; safecall;
    function Authorize: OLE_CANCELBOOL; safecall;
    function GetPointDevices(const Filter: JsonObject): OLE_CANCELBOOL; safecall;
    function GetPointDevicesResponse: IJsonObject; safecall;
    function Get_ErrorDesc: WideString; safecall;
    function GetPos(const Filter: IJsonObject): OLE_CANCELBOOL; safecall;
    function GetPosResponse: IJsonObject; safecall;
    function CreateFilter: IJsonObject; safecall;
    function ChangePointOperatingMode(const DeviceId: WideString; const Mode: WideString): OLE_CANCELBOOL; safecall;
    procedure ReleaseFilter(const Filter: IJsonObject); safecall;
    function CreatePaymentIntent(const DeviceId: WideString; amount2Decimals: Double;
                                 const external_reference: WideString;
                                 print_on_terminal: OLE_CANCELBOOL; const ticket_number: WideString): OLE_CANCELBOOL; safecall;
    function GetPaymentIntents(const Filter: IJsonObject): OLE_CANCELBOOL; safecall;
    function Get_GetPaymentIntentsResponse: IJsonObject; safecall;
    function GetPaymentIntent(const paymentIntentId: WideString): OLE_CANCELBOOL; safecall;
    function Get_GetPaymentIntentResponse: IJsonObject; safecall;
    function Get_CreatePaymentIntentResponse: IJsonObject; safecall;
    function DetelePaymentIntent(const DeviceId: WideString; const PaymentIntentId: WideString): OLE_CANCELBOOL; safecall;
    function Logout: OLE_CANCELBOOL; safecall;
    function ConfigurePoint: OLE_CANCELBOOL; safecall;
    function Get_DefaultPoint: WideString; safecall;
    function WaitPaymentIntent: OLE_CANCELBOOL; safecall;
    procedure ShowLastPaymentIntents; safecall;
    function GetPayment(const PaymentId: WideString): OLE_CANCELBOOL; safecall;
    function Get_GetPaymentResponse: IJsonObject; safecall;
    property pos_id: Integer read Get_pos_id write Set_pos_id;
    property getMerchant_order_result: Imerchant_order read Get_getMerchant_order_result;
    property ErrorDesc: WideString read Get_ErrorDesc;
    property GetPaymentIntentsResponse: IJsonObject read Get_GetPaymentIntentsResponse;
    property GetPaymentIntentResponse: IJsonObject read Get_GetPaymentIntentResponse;
    property CreatePaymentIntentResponse: IJsonObject read Get_CreatePaymentIntentResponse;
    property DefaultPoint: WideString read Get_DefaultPoint;
    property GetPaymentResponse: IJsonObject read Get_GetPaymentResponse;
  end;

// *********************************************************************//
// DispIntf:  IMPServiceDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B544FCE1-C458-4F1F-9E0A-156EAF4CC682}
// *********************************************************************//
  IMPServiceDisp = dispinterface
    ['{B544FCE1-C458-4F1F-9E0A-156EAF4CC682}']
    property pos_id: Integer dispid 202;
    function newMerchant_order: Imerchant_order; dispid 203;
    function sendMerchant_order: OLE_CANCELBOOL; dispid 204;
    function getMerchant_order(const external_reference: WideString): OLE_CANCELBOOL; dispid 205;
    property getMerchant_order_result: Imerchant_order readonly dispid 206;
    function newUuid: WideString; dispid 207;
    function deleteMerchant_order: OLE_CANCELBOOL; dispid 208;
    procedure configuracion; dispid 209;
    function queryMerchant_order(const external_reference: WideString): OLE_CANCELBOOL; dispid 210;
    function paymentRefund(const id: WideString; amount: Double): OLE_CANCELBOOL; dispid 211;
    function paymentCancel(const id: WideString): OLE_CANCELBOOL; dispid 212;
    function Authorize: OLE_CANCELBOOL; dispid 213;
    function GetPointDevices(const Filter: JsonObject): OLE_CANCELBOOL; dispid 201;
    function GetPointDevicesResponse: IJsonObject; dispid 214;
    property ErrorDesc: WideString readonly dispid 215;
    function GetPos(const Filter: IJsonObject): OLE_CANCELBOOL; dispid 216;
    function GetPosResponse: IJsonObject; dispid 217;
    function CreateFilter: IJsonObject; dispid 218;
    function ChangePointOperatingMode(const DeviceId: WideString; const Mode: WideString): OLE_CANCELBOOL; dispid 219;
    procedure ReleaseFilter(const Filter: IJsonObject); dispid 220;
    function CreatePaymentIntent(const DeviceId: WideString; amount2Decimals: Double;
                                 const external_reference: WideString;
                                 print_on_terminal: OLE_CANCELBOOL; const ticket_number: WideString): OLE_CANCELBOOL; dispid 221;
    function GetPaymentIntents(const Filter: IJsonObject): OLE_CANCELBOOL; dispid 222;
    property GetPaymentIntentsResponse: IJsonObject readonly dispid 223;
    function GetPaymentIntent(const paymentIntentId: WideString): OLE_CANCELBOOL; dispid 224;
    property GetPaymentIntentResponse: IJsonObject readonly dispid 225;
    property CreatePaymentIntentResponse: IJsonObject readonly dispid 226;
    function DetelePaymentIntent(const DeviceId: WideString; const PaymentIntentId: WideString): OLE_CANCELBOOL; dispid 227;
    function Logout: OLE_CANCELBOOL; dispid 228;
    function ConfigurePoint: OLE_CANCELBOOL; dispid 229;
    property DefaultPoint: WideString readonly dispid 230;
    function WaitPaymentIntent: OLE_CANCELBOOL; dispid 231;
    procedure ShowLastPaymentIntents; dispid 232;
    function GetPayment(const PaymentId: WideString): OLE_CANCELBOOL; dispid 233;
    property GetPaymentResponse: IJsonObject readonly dispid 234;
  end;

// *********************************************************************//
// Interface: Imerchant_order
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F4BA50DF-98B8-48B0-91FC-8087516A9C84}
// *********************************************************************//
  Imerchant_order = interface(IDispatch)
    ['{F4BA50DF-98B8-48B0-91FC-8087516A9C84}']
    function Get_external_reference: WideString; safecall;
    procedure Set_external_reference(const Value: WideString); safecall;
    procedure addItem(const title: WideString; const currency_id: WideString;
                      const description: WideString; quantity: Double; unit_price: Double); safecall;
    function Get_order_status: WideString; safecall;
    function Get_loyalty: Iloyalty; safecall;
    procedure Set_sponsor_id(Value: Integer); safecall;
    function Get_payment(Index: Integer): IPayment; safecall;
    function Get_paymentCount: Integer; safecall;
    property external_reference: WideString read Get_external_reference write Set_external_reference;
    property order_status: WideString read Get_order_status;
    property loyalty: Iloyalty read Get_loyalty;
    property sponsor_id: Integer write Set_sponsor_id;
    property payment[Index: Integer]: IPayment read Get_payment;
    property paymentCount: Integer read Get_paymentCount;
  end;

// *********************************************************************//
// DispIntf:  Imerchant_orderDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F4BA50DF-98B8-48B0-91FC-8087516A9C84}
// *********************************************************************//
  Imerchant_orderDisp = dispinterface
    ['{F4BA50DF-98B8-48B0-91FC-8087516A9C84}']
    property external_reference: WideString dispid 202;
    procedure addItem(const title: WideString; const currency_id: WideString;
                      const description: WideString; quantity: Double; unit_price: Double); dispid 204;
    property order_status: WideString readonly dispid 201;
    property loyalty: Iloyalty readonly dispid 203;
    property sponsor_id: Integer writeonly dispid 205;
    property payment[Index: Integer]: IPayment readonly dispid 206;
    property paymentCount: Integer readonly dispid 207;
  end;

// *********************************************************************//
// Interface: Iloyalty
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8ADFA135-E2A7-4DEE-8D17-674F4730FB6E}
// *********************************************************************//
  Iloyalty = interface(IDispatch)
    ['{8ADFA135-E2A7-4DEE-8D17-674F4730FB6E}']
    procedure Set_program_(const Value: WideString); safecall;
    procedure Set_transaction_id(const Value: WideString); safecall;
    procedure Set_invoice_number(const Value: WideString); safecall;
    procedure Set_transaction_date(const Value: WideString); safecall;
    procedure Set_transaction_amount(Value: Double); safecall;
    procedure Set_store_id(const Value: WideString); safecall;
    procedure addProduct(const code: WideString; quantity: Double; const unit_: WideString;
                         unit_price: Double); safecall;
    procedure cashier_identification(const type_: WideString; const number: WideString); safecall;
    procedure Set_period(const Value: WideString); safecall;
    procedure Set_shift(const Value: WideString); safecall;
    procedure Set_affinity_plan(const Value: WideString); safecall;
    property program_: WideString write Set_program_;
    property transaction_id: WideString write Set_transaction_id;
    property invoice_number: WideString write Set_invoice_number;
    property transaction_date: WideString write Set_transaction_date;
    property transaction_amount: Double write Set_transaction_amount;
    property store_id: WideString write Set_store_id;
    property period: WideString write Set_period;
    property shift: WideString write Set_shift;
    property affinity_plan: WideString write Set_affinity_plan;
  end;

// *********************************************************************//
// DispIntf:  IloyaltyDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8ADFA135-E2A7-4DEE-8D17-674F4730FB6E}
// *********************************************************************//
  IloyaltyDisp = dispinterface
    ['{8ADFA135-E2A7-4DEE-8D17-674F4730FB6E}']
    property program_: WideString writeonly dispid 201;
    property transaction_id: WideString writeonly dispid 202;
    property invoice_number: WideString writeonly dispid 203;
    property transaction_date: WideString writeonly dispid 204;
    property transaction_amount: Double writeonly dispid 205;
    property store_id: WideString writeonly dispid 206;
    procedure addProduct(const code: WideString; quantity: Double; const unit_: WideString;
                         unit_price: Double); dispid 207;
    procedure cashier_identification(const type_: WideString; const number: WideString); dispid 208;
    property period: WideString writeonly dispid 209;
    property shift: WideString writeonly dispid 210;
    property affinity_plan: WideString writeonly dispid 211;
  end;

// *********************************************************************//
// Interface: IPayment
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6B8837F3-4EAE-4738-BDCC-F3F6E60008B7}
// *********************************************************************//
  IPayment = interface(IDispatch)
    ['{6B8837F3-4EAE-4738-BDCC-F3F6E60008B7}']
    function Get_id: WideString; safecall;
    function Get_total_paid_amount: Double; safecall;
    function Get_shipping_cost: Double; safecall;
    function Get_currency_id: WideString; safecall;
    function Get_status: WideString; safecall;
    function Get_status_detail: WideString; safecall;
    function Get_date_approved: WideString; safecall;
    function Get_date_created: WideString; safecall;
    function Get_last_modified: WideString; safecall;
    function Get_amount_refunded: Double; safecall;
    property id: WideString read Get_id;
    property total_paid_amount: Double read Get_total_paid_amount;
    property shipping_cost: Double read Get_shipping_cost;
    property currency_id: WideString read Get_currency_id;
    property status: WideString read Get_status;
    property status_detail: WideString read Get_status_detail;
    property date_approved: WideString read Get_date_approved;
    property date_created: WideString read Get_date_created;
    property last_modified: WideString read Get_last_modified;
    property amount_refunded: Double read Get_amount_refunded;
  end;

// *********************************************************************//
// DispIntf:  IPaymentDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6B8837F3-4EAE-4738-BDCC-F3F6E60008B7}
// *********************************************************************//
  IPaymentDisp = dispinterface
    ['{6B8837F3-4EAE-4738-BDCC-F3F6E60008B7}']
    property id: WideString readonly dispid 201;
    property total_paid_amount: Double readonly dispid 202;
    property shipping_cost: Double readonly dispid 203;
    property currency_id: WideString readonly dispid 204;
    property status: WideString readonly dispid 205;
    property status_detail: WideString readonly dispid 206;
    property date_approved: WideString readonly dispid 207;
    property date_created: WideString readonly dispid 208;
    property last_modified: WideString readonly dispid 209;
    property amount_refunded: Double readonly dispid 210;
  end;

// *********************************************************************//
// Interface: IMLService
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {90017972-481D-4FCA-B30B-010158B9FACB}
// *********************************************************************//
  IMLService = interface(IDispatch)
    ['{90017972-481D-4FCA-B30B-010158B9FACB}']
    function Authorize: OLE_CANCELBOOL; safecall;
    function GetItems(const Filter: IJsonObject): OLE_CANCELBOOL; safecall;
    function Get_GetItemsResponse: IJsonObject; safecall;
    function GetRecentOrders(const Filter: IJsonObject): OLE_CANCELBOOL; safecall;
    function Get_GetRecentOrdersResponse: IJsonObject; safecall;
    function Get_ErrorDesc: WideString; safecall;
    function GetUsersMe: OLE_CANCELBOOL; safecall;
    function CreateFilter: IJsonObject; safecall;
    function PostPacksFiscalDocuments(const PackId: WideString; const FiscalDocument: WideString): OLE_CANCELBOOL; safecall;
    function Get_PostPacksFiscalDocumentsResponse: IJsonObject; safecall;
    function Get_UserId: WideString; safecall;
    function GetPacksFiscalDocument(const PackId: WideString; const FiscalDocumentId: WideString;
                                    const FiscalDocumentPath: WideString): OLE_CANCELBOOL; safecall;
    function GetPacksFiscalDocumentsId(const PackId: WideString): OLE_CANCELBOOL; safecall;
    function Get_GetPacksFiscalDocumentsIdResponse: IJsonObject; safecall;
    function GetUserItems(const Filter: IJsonObject): OLE_CANCELBOOL; safecall;
    function PutItems(const ItemId: WideString; const Filter: IJsonObject): OLE_CANCELBOOL; safecall;
    function GetOrders(const OrderId: WideString): OLE_CANCELBOOL; safecall;
    function Get_GetOrdersResponse: IJsonObject; safecall;
    function GetBillingInfo(const OrderId: WideString): OLE_CANCELBOOL; safecall;
    function Get_GetBillingInfoResponse: IJsonObject; safecall;
    procedure FrmOrders; safecall;
    function Get_GetUsersMeResponse: IJsonObject; safecall;
    function Logout: OLE_CANCELBOOL; safecall;
    property GetItemsResponse: IJsonObject read Get_GetItemsResponse;
    property GetRecentOrdersResponse: IJsonObject read Get_GetRecentOrdersResponse;
    property ErrorDesc: WideString read Get_ErrorDesc;
    property PostPacksFiscalDocumentsResponse: IJsonObject read Get_PostPacksFiscalDocumentsResponse;
    property UserId: WideString read Get_UserId;
    property GetPacksFiscalDocumentsIdResponse: IJsonObject read Get_GetPacksFiscalDocumentsIdResponse;
    property GetOrdersResponse: IJsonObject read Get_GetOrdersResponse;
    property GetBillingInfoResponse: IJsonObject read Get_GetBillingInfoResponse;
    property GetUsersMeResponse: IJsonObject read Get_GetUsersMeResponse;
  end;

// *********************************************************************//
// DispIntf:  IMLServiceDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {90017972-481D-4FCA-B30B-010158B9FACB}
// *********************************************************************//
  IMLServiceDisp = dispinterface
    ['{90017972-481D-4FCA-B30B-010158B9FACB}']
    function Authorize: OLE_CANCELBOOL; dispid 201;
    function GetItems(const Filter: IJsonObject): OLE_CANCELBOOL; dispid 202;
    property GetItemsResponse: IJsonObject readonly dispid 203;
    function GetRecentOrders(const Filter: IJsonObject): OLE_CANCELBOOL; dispid 204;
    property GetRecentOrdersResponse: IJsonObject readonly dispid 205;
    property ErrorDesc: WideString readonly dispid 206;
    function GetUsersMe: OLE_CANCELBOOL; dispid 207;
    function CreateFilter: IJsonObject; dispid 209;
    function PostPacksFiscalDocuments(const PackId: WideString; const FiscalDocument: WideString): OLE_CANCELBOOL; dispid 210;
    property PostPacksFiscalDocumentsResponse: IJsonObject readonly dispid 211;
    property UserId: WideString readonly dispid 208;
    function GetPacksFiscalDocument(const PackId: WideString; const FiscalDocumentId: WideString;
                                    const FiscalDocumentPath: WideString): OLE_CANCELBOOL; dispid 212;
    function GetPacksFiscalDocumentsId(const PackId: WideString): OLE_CANCELBOOL; dispid 213;
    property GetPacksFiscalDocumentsIdResponse: IJsonObject readonly dispid 214;
    function GetUserItems(const Filter: IJsonObject): OLE_CANCELBOOL; dispid 215;
    function PutItems(const ItemId: WideString; const Filter: IJsonObject): OLE_CANCELBOOL; dispid 216;
    function GetOrders(const OrderId: WideString): OLE_CANCELBOOL; dispid 217;
    property GetOrdersResponse: IJsonObject readonly dispid 218;
    function GetBillingInfo(const OrderId: WideString): OLE_CANCELBOOL; dispid 219;
    property GetBillingInfoResponse: IJsonObject readonly dispid 220;
    procedure FrmOrders; dispid 221;
    property GetUsersMeResponse: IJsonObject readonly dispid 222;
    function Logout: OLE_CANCELBOOL; dispid 223;
  end;

// *********************************************************************//
// Interface: IJsonObject
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CBD2FC29-AA2C-4A03-AC0E-F8004DBDF4C7}
// *********************************************************************//
  IJsonObject = interface(IDispatch)
    ['{CBD2FC29-AA2C-4A03-AC0E-F8004DBDF4C7}']
    function Get_Str(const Name: WideString): WideString; safecall;
    procedure Set_Str(const Name: WideString; const Value: WideString); safecall;
    function Get_Int(const Name: WideString): Integer; safecall;
    procedure Set_Int(const Name: WideString; Value: Integer); safecall;
    function Get_Dbl(const Name: WideString): Double; safecall;
    procedure Set_Dbl(const Name: WideString; Value: Double); safecall;
    function Get_Obj(const Name: WideString): IJsonObject; safecall;
    function Get_Arr(const Name: WideString): IJsonArray; safecall;
    function Get_AsJson: WideString; safecall;
    function Get_Bool(const Name: WideString): OLE_CANCELBOOL; safecall;
    procedure Set_Bool(const Name: WideString; Value: OLE_CANCELBOOL); safecall;
    function HasValue(const Name: WideString): OLE_CANCELBOOL; safecall;
    property Str[const Name: WideString]: WideString read Get_Str write Set_Str;
    property Int[const Name: WideString]: Integer read Get_Int write Set_Int;
    property Dbl[const Name: WideString]: Double read Get_Dbl write Set_Dbl;
    property Obj[const Name: WideString]: IJsonObject read Get_Obj;
    property Arr[const Name: WideString]: IJsonArray read Get_Arr;
    property AsJson: WideString read Get_AsJson;
    property Bool[const Name: WideString]: OLE_CANCELBOOL read Get_Bool write Set_Bool;
  end;

// *********************************************************************//
// DispIntf:  IJsonObjectDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CBD2FC29-AA2C-4A03-AC0E-F8004DBDF4C7}
// *********************************************************************//
  IJsonObjectDisp = dispinterface
    ['{CBD2FC29-AA2C-4A03-AC0E-F8004DBDF4C7}']
    property Str[const Name: WideString]: WideString dispid 201;
    property Int[const Name: WideString]: Integer dispid 202;
    property Dbl[const Name: WideString]: Double dispid 203;
    property Obj[const Name: WideString]: IJsonObject readonly dispid 204;
    property Arr[const Name: WideString]: IJsonArray readonly dispid 205;
    property AsJson: WideString readonly dispid 206;
    property Bool[const Name: WideString]: OLE_CANCELBOOL dispid 207;
    function HasValue(const Name: WideString): OLE_CANCELBOOL; dispid 208;
  end;

// *********************************************************************//
// Interface: IJsonArray
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0C34D73D-3752-49CD-87F9-FAD942A7F982}
// *********************************************************************//
  IJsonArray = interface(IDispatch)
    ['{0C34D73D-3752-49CD-87F9-FAD942A7F982}']
    function Get_Str(Indice: Integer): WideString; safecall;
    function Get_Int(Indice: Integer): Integer; safecall;
    function Get_Dbl(Indice: Integer): Double; safecall;
    function Get_Obj(Indice: Integer): IJsonObject; safecall;
    function Get_Count: Integer; safecall;
    function Get_AsJson: WideString; safecall;
    function Get_AsCommaDelimited: WideString; safecall;
    property Str[Indice: Integer]: WideString read Get_Str;
    property Int[Indice: Integer]: Integer read Get_Int;
    property Dbl[Indice: Integer]: Double read Get_Dbl;
    property Obj[Indice: Integer]: IJsonObject read Get_Obj;
    property Count: Integer read Get_Count;
    property AsJson: WideString read Get_AsJson;
    property AsCommaDelimited: WideString read Get_AsCommaDelimited;
  end;

// *********************************************************************//
// DispIntf:  IJsonArrayDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0C34D73D-3752-49CD-87F9-FAD942A7F982}
// *********************************************************************//
  IJsonArrayDisp = dispinterface
    ['{0C34D73D-3752-49CD-87F9-FAD942A7F982}']
    property Str[Indice: Integer]: WideString readonly dispid 201;
    property Int[Indice: Integer]: Integer readonly dispid 202;
    property Dbl[Indice: Integer]: Double readonly dispid 203;
    property Obj[Indice: Integer]: IJsonObject readonly dispid 204;
    property Count: Integer readonly dispid 205;
    property AsJson: WideString readonly dispid 206;
    property AsCommaDelimited: WideString readonly dispid 207;
  end;

// *********************************************************************//
// The Class CoMPService provides a Create and CreateRemote method to
// create instances of the default interface IMPService exposed by
// the CoClass MPService. The functions are intended to be used by
// clients wishing to automate the CoClass objects exposed by the
// server of this typelibrary.
// *********************************************************************//
  CoMPService = class
    class function Create: IMPService;
    class function CreateRemote(const MachineName: string): IMPService;
  end;

// *********************************************************************//
// The Class Comerchant_order provides a Create and CreateRemote method to
// create instances of the default interface Imerchant_order exposed by
// the CoClass merchant_order. The functions are intended to be used by
// clients wishing to automate the CoClass objects exposed by the
// server of this typelibrary.
// *********************************************************************//
  Comerchant_order = class
    class function Create: Imerchant_order;
    class function CreateRemote(const MachineName: string): Imerchant_order;
  end;

// *********************************************************************//
// The Class Coloyalty provides a Create and CreateRemote method to
// create instances of the default interface Iloyalty exposed by
// the CoClass loyalty. The functions are intended to be used by
// clients wishing to automate the CoClass objects exposed by the
// server of this typelibrary.
// *********************************************************************//
  Coloyalty = class
    class function Create: Iloyalty;
    class function CreateRemote(const MachineName: string): Iloyalty;
  end;

// *********************************************************************//
// The Class CoPayment provides a Create and CreateRemote method to
// create instances of the default interface IPayment exposed by
// the CoClass Payment. The functions are intended to be used by
// clients wishing to automate the CoClass objects exposed by the
// server of this typelibrary.
// *********************************************************************//
  CoPayment = class
    class function Create: IPayment;
    class function CreateRemote(const MachineName: string): IPayment;
  end;

// *********************************************************************//
// The Class CoMLService provides a Create and CreateRemote method to
// create instances of the default interface IMLService exposed by
// the CoClass MLService. The functions are intended to be used by
// clients wishing to automate the CoClass objects exposed by the
// server of this typelibrary.
// *********************************************************************//
  CoMLService = class
    class function Create: IMLService;
    class function CreateRemote(const MachineName: string): IMLService;
  end;

// *********************************************************************//
// The Class CoJsonObject provides a Create and CreateRemote method to
// create instances of the default interface IJsonObject exposed by
// the CoClass JsonObject. The functions are intended to be used by
// clients wishing to automate the CoClass objects exposed by the
// server of this typelibrary.
// *********************************************************************//
  CoJsonObject = class
    class function Create: IJsonObject;
    class function CreateRemote(const MachineName: string): IJsonObject;
  end;

// *********************************************************************//
// The Class CoJsonArray provides a Create and CreateRemote method to
// create instances of the default interface IJsonArray exposed by
// the CoClass JsonArray. The functions are intended to be used by
// clients wishing to automate the CoClass objects exposed by the
// server of this typelibrary.
// *********************************************************************//
  CoJsonArray = class
    class function Create: IJsonArray;
    class function CreateRemote(const MachineName: string): IJsonArray;
  end;

implementation

uses System.Win.ComObj;

class function CoMPService.Create: IMPService;
begin
  Result := CreateComObject(CLASS_MPService) as IMPService;
end;

class function CoMPService.CreateRemote(const MachineName: string): IMPService;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MPService) as IMPService;
end;

class function Comerchant_order.Create: Imerchant_order;
begin
  Result := CreateComObject(CLASS_merchant_order) as Imerchant_order;
end;

class function Comerchant_order.CreateRemote(const MachineName: string): Imerchant_order;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_merchant_order) as Imerchant_order;
end;

class function Coloyalty.Create: Iloyalty;
begin
  Result := CreateComObject(CLASS_loyalty) as Iloyalty;
end;

class function Coloyalty.CreateRemote(const MachineName: string): Iloyalty;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_loyalty) as Iloyalty;
end;

class function CoPayment.Create: IPayment;
begin
  Result := CreateComObject(CLASS_Payment) as IPayment;
end;

class function CoPayment.CreateRemote(const MachineName: string): IPayment;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Payment) as IPayment;
end;

class function CoMLService.Create: IMLService;
begin
  Result := CreateComObject(CLASS_MLService) as IMLService;
end;

class function CoMLService.CreateRemote(const MachineName: string): IMLService;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MLService) as IMLService;
end;

class function CoJsonObject.Create: IJsonObject;
begin
  Result := CreateComObject(CLASS_JsonObject) as IJsonObject;
end;

class function CoJsonObject.CreateRemote(const MachineName: string): IJsonObject;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_JsonObject) as IJsonObject;
end;

class function CoJsonArray.Create: IJsonArray;
begin
  Result := CreateComObject(CLASS_JsonArray) as IJsonArray;
end;

class function CoJsonArray.CreateRemote(const MachineName: string): IJsonArray;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_JsonArray) as IJsonArray;
end;

end.

