package mllib  ;

import com4j.*;

/**
 * Dispatch interface for MPService Object
 */
@IID("{B544FCE1-C458-4F1F-9E0A-156EAF4CC682}")
public interface IMPService extends Com4jObject {
  // Methods:
  /**
   * <p>
   * Getter method for the COM property "access_token"
   * </p>
   * @return  Returns a value of type java.lang.String
   */

  @DISPID(201) //= 0xc9. The runtime will prefer the VTID if present
  @VTID(7)
  java.lang.String access_token();


  /**
   * <p>
   * Setter method for the COM property "access_token"
   * </p>
   * @param value Mandatory java.lang.String parameter.
   */

  @DISPID(201) //= 0xc9. The runtime will prefer the VTID if present
  @VTID(8)
  void access_token(
    java.lang.String value);


  /**
   * <p>
   * Getter method for the COM property "pos_id"
   * </p>
   * @return  Returns a value of type int
   */

  @DISPID(202) //= 0xca. The runtime will prefer the VTID if present
  @VTID(9)
  int pos_id();


  /**
   * <p>
   * Setter method for the COM property "pos_id"
   * </p>
   * @param value Mandatory int parameter.
   */

  @DISPID(202) //= 0xca. The runtime will prefer the VTID if present
  @VTID(10)
  void pos_id(
    int value);


  /**
   * @return  Returns a value of type mllib.Imerchant_order
   */

  @DISPID(203) //= 0xcb. The runtime will prefer the VTID if present
  @VTID(11)
  mllib.Imerchant_order newMerchant_order();


  /**
   * @return  Returns a value of type boolean
   */

  @DISPID(204) //= 0xcc. The runtime will prefer the VTID if present
  @VTID(12)
  boolean sendMerchant_order();


  /**
   * @param external_reference Mandatory java.lang.String parameter.
   * @return  Returns a value of type boolean
   */

  @DISPID(205) //= 0xcd. The runtime will prefer the VTID if present
  @VTID(13)
  boolean getMerchant_order(
    java.lang.String external_reference);


  /**
   * <p>
   * Getter method for the COM property "getMerchant_order_result"
   * </p>
   * @return  Returns a value of type mllib.Imerchant_order
   */

  @DISPID(206) //= 0xce. The runtime will prefer the VTID if present
  @VTID(14)
  mllib.Imerchant_order getMerchant_order_result();


  /**
   * @return  Returns a value of type java.lang.String
   */

  @DISPID(207) //= 0xcf. The runtime will prefer the VTID if present
  @VTID(15)
  java.lang.String newUuid();


  /**
   * @return  Returns a value of type boolean
   */

  @DISPID(208) //= 0xd0. The runtime will prefer the VTID if present
  @VTID(16)
  boolean deleteMerchant_order();


  /**
   */

  @DISPID(209) //= 0xd1. The runtime will prefer the VTID if present
  @VTID(17)
  void configuracion();


  /**
   * @param external_reference Mandatory java.lang.String parameter.
   * @return  Returns a value of type boolean
   */

  @DISPID(210) //= 0xd2. The runtime will prefer the VTID if present
  @VTID(18)
  boolean queryMerchant_order(
    java.lang.String external_reference);


  /**
   * @param id Mandatory java.lang.String parameter.
   * @param amount Mandatory double parameter.
   * @return  Returns a value of type boolean
   */

  @DISPID(211) //= 0xd3. The runtime will prefer the VTID if present
  @VTID(19)
  boolean paymentRefund(
    java.lang.String id,
    double amount);


  /**
   * @param id Mandatory java.lang.String parameter.
   * @return  Returns a value of type boolean
   */

  @DISPID(212) //= 0xd4. The runtime will prefer the VTID if present
  @VTID(20)
  boolean paymentCancel(
    java.lang.String id);


  // Properties:
}
