package mllib  ;

import com4j.*;

@IID("{F4BA50DF-98B8-48B0-91FC-8087516A9C84}")
public interface Imerchant_order extends Com4jObject {
  // Methods:
  /**
   * <p>
   * Getter method for the COM property "external_reference"
   * </p>
   * @return  Returns a value of type java.lang.String
   */

  @DISPID(202) //= 0xca. The runtime will prefer the VTID if present
  @VTID(7)
  java.lang.String external_reference();


  /**
   * <p>
   * Setter method for the COM property "external_reference"
   * </p>
   * @param value Mandatory java.lang.String parameter.
   */

  @DISPID(202) //= 0xca. The runtime will prefer the VTID if present
  @VTID(8)
  void external_reference(
    java.lang.String value);


  /**
   * @param title Mandatory java.lang.String parameter.
   * @param currency_id Mandatory java.lang.String parameter.
   * @param description Mandatory java.lang.String parameter.
   * @param quantity Mandatory double parameter.
   * @param unit_price Mandatory double parameter.
   */

  @DISPID(204) //= 0xcc. The runtime will prefer the VTID if present
  @VTID(9)
  void addItem(
    java.lang.String title,
    java.lang.String currency_id,
    java.lang.String description,
    double quantity,
    double unit_price);


  /**
   * <p>
   * Getter method for the COM property "order_status"
   * </p>
   * @return  Returns a value of type java.lang.String
   */

  @DISPID(201) //= 0xc9. The runtime will prefer the VTID if present
  @VTID(10)
  java.lang.String order_status();


  /**
   * <p>
   * Getter method for the COM property "loyalty"
   * </p>
   * @return  Returns a value of type mllib.Iloyalty
   */

  @DISPID(203) //= 0xcb. The runtime will prefer the VTID if present
  @VTID(11)
  mllib.Iloyalty loyalty();


  /**
   * <p>
   * Setter method for the COM property "sponsor_id"
   * </p>
   * @param rhs Mandatory int parameter.
   */

  @DISPID(205) //= 0xcd. The runtime will prefer the VTID if present
  @VTID(12)
  void sponsor_id(
    int rhs);


  /**
   * <p>
   * Getter method for the COM property "Payment"
   * </p>
   * @param index Mandatory int parameter.
   * @return  Returns a value of type mllib.IPayment
   */

  @DISPID(206) //= 0xce. The runtime will prefer the VTID if present
  @VTID(13)
  mllib.IPayment payment(
    int index);


  /**
   * <p>
   * Getter method for the COM property "paymentCount"
   * </p>
   * @return  Returns a value of type int
   */

  @DISPID(207) //= 0xcf. The runtime will prefer the VTID if present
  @VTID(14)
  int paymentCount();


  // Properties:
}
