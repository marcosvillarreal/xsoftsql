package mllib  ;

import com4j.*;

/**
 * Dispatch interface for MLService Object
 */
@IID("{90017972-481D-4FCA-B30B-010158B9FACB}")
public interface IMLService extends Com4jObject {
  // Methods:
  /**
   * @return  Returns a value of type boolean
   */

  @DISPID(201) //= 0xc9. The runtime will prefer the VTID if present
  @VTID(7)
  boolean authorize();


  /**
   * @param filter Mandatory mllib.IJsonObject parameter.
   * @return  Returns a value of type boolean
   */

  @DISPID(202) //= 0xca. The runtime will prefer the VTID if present
  @VTID(8)
  boolean getItems(
    mllib.IJsonObject filter);


  /**
   * <p>
   * Getter method for the COM property "GetItemsResponse"
   * </p>
   * @return  Returns a value of type mllib.IJsonObject
   */

  @DISPID(203) //= 0xcb. The runtime will prefer the VTID if present
  @VTID(9)
  mllib.IJsonObject getItemsResponse();


  /**
   * @param filter Mandatory mllib.IJsonObject parameter.
   * @return  Returns a value of type boolean
   */

  @DISPID(204) //= 0xcc. The runtime will prefer the VTID if present
  @VTID(10)
  boolean getRecentOrders(
    mllib.IJsonObject filter);


  /**
   * <p>
   * Getter method for the COM property "GetRecentOrdersResponse"
   * </p>
   * @return  Returns a value of type mllib.IJsonObject
   */

  @DISPID(205) //= 0xcd. The runtime will prefer the VTID if present
  @VTID(11)
  mllib.IJsonObject getRecentOrdersResponse();


  /**
   * <p>
   * Getter method for the COM property "ErrorDesc"
   * </p>
   * @return  Returns a value of type java.lang.String
   */

  @DISPID(206) //= 0xce. The runtime will prefer the VTID if present
  @VTID(12)
  java.lang.String errorDesc();


  /**
   * @return  Returns a value of type boolean
   */

  @DISPID(207) //= 0xcf. The runtime will prefer the VTID if present
  @VTID(13)
  boolean getUsersMe();


  /**
   * @return  Returns a value of type mllib.IJsonObject
   */

  @DISPID(209) //= 0xd1. The runtime will prefer the VTID if present
  @VTID(14)
  mllib.IJsonObject createFilter();


  /**
   * @param packId Mandatory java.lang.String parameter.
   * @param fiscalDocument Mandatory java.lang.String parameter.
   * @return  Returns a value of type boolean
   */

  @DISPID(210) //= 0xd2. The runtime will prefer the VTID if present
  @VTID(15)
  boolean postPacksFiscalDocuments(
    java.lang.String packId,
    java.lang.String fiscalDocument);


  /**
   * <p>
   * Getter method for the COM property "PostPacksFiscalDocumentsResponse"
   * </p>
   * @return  Returns a value of type mllib.IJsonObject
   */

  @DISPID(211) //= 0xd3. The runtime will prefer the VTID if present
  @VTID(16)
  mllib.IJsonObject postPacksFiscalDocumentsResponse();


  /**
   * <p>
   * Getter method for the COM property "UserId"
   * </p>
   * @return  Returns a value of type java.lang.String
   */

  @DISPID(208) //= 0xd0. The runtime will prefer the VTID if present
  @VTID(17)
  java.lang.String userId();


  /**
   * @param packId Mandatory java.lang.String parameter.
   * @param fiscalDocumentId Mandatory java.lang.String parameter.
   * @param fiscalDocumentPath Mandatory java.lang.String parameter.
   * @return  Returns a value of type boolean
   */

  @DISPID(212) //= 0xd4. The runtime will prefer the VTID if present
  @VTID(18)
  boolean getPacksFiscalDocument(
    java.lang.String packId,
    java.lang.String fiscalDocumentId,
    java.lang.String fiscalDocumentPath);


  /**
   * @param packId Mandatory java.lang.String parameter.
   * @return  Returns a value of type boolean
   */

  @DISPID(213) //= 0xd5. The runtime will prefer the VTID if present
  @VTID(19)
  boolean getPacksFiscalDocumentsId(
    java.lang.String packId);


  /**
   * <p>
   * Getter method for the COM property "GetPacksFiscalDocumentsIdResponse"
   * </p>
   * @return  Returns a value of type mllib.IJsonObject
   */

  @DISPID(214) //= 0xd6. The runtime will prefer the VTID if present
  @VTID(20)
  mllib.IJsonObject getPacksFiscalDocumentsIdResponse();


  /**
   * @param filter Mandatory mllib.IJsonObject parameter.
   * @return  Returns a value of type boolean
   */

  @DISPID(215) //= 0xd7. The runtime will prefer the VTID if present
  @VTID(21)
  boolean getUserItems(
    mllib.IJsonObject filter);


  /**
   * @param itemId Mandatory java.lang.String parameter.
   * @param filter Mandatory mllib.IJsonObject parameter.
   * @return  Returns a value of type boolean
   */

  @DISPID(216) //= 0xd8. The runtime will prefer the VTID if present
  @VTID(22)
  boolean putItems(
    java.lang.String itemId,
    mllib.IJsonObject filter);


  /**
   * @param orderId Mandatory java.lang.String parameter.
   * @return  Returns a value of type boolean
   */

  @DISPID(217) //= 0xd9. The runtime will prefer the VTID if present
  @VTID(23)
  boolean getOrders(
    java.lang.String orderId);


  /**
   * <p>
   * Getter method for the COM property "GetOrdersResponse"
   * </p>
   * @return  Returns a value of type mllib.IJsonObject
   */

  @DISPID(218) //= 0xda. The runtime will prefer the VTID if present
  @VTID(24)
  mllib.IJsonObject getOrdersResponse();


  /**
   * @param orderId Mandatory java.lang.String parameter.
   * @return  Returns a value of type boolean
   */

  @DISPID(219) //= 0xdb. The runtime will prefer the VTID if present
  @VTID(25)
  boolean getBillingInfo(
    java.lang.String orderId);


  /**
   * <p>
   * Getter method for the COM property "GetBillingInfoResponse"
   * </p>
   * @return  Returns a value of type mllib.IJsonObject
   */

  @DISPID(220) //= 0xdc. The runtime will prefer the VTID if present
  @VTID(26)
  mllib.IJsonObject getBillingInfoResponse();


  /**
   */

  @DISPID(221) //= 0xdd. The runtime will prefer the VTID if present
  @VTID(27)
  void frmOrders();


  /**
   * <p>
   * Getter method for the COM property "GetUsersMeResponse"
   * </p>
   * @return  Returns a value of type mllib.IJsonObject
   */

  @DISPID(222) //= 0xde. The runtime will prefer the VTID if present
  @VTID(28)
  mllib.IJsonObject getUsersMeResponse();


  // Properties:
}
