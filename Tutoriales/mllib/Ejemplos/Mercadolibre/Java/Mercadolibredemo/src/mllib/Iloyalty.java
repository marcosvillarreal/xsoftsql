package mllib  ;

import com4j.*;

@IID("{8ADFA135-E2A7-4DEE-8D17-674F4730FB6E}")
public interface Iloyalty extends Com4jObject {
  // Methods:
  /**
   * <p>
   * Setter method for the COM property "program"
   * </p>
   * @param rhs Mandatory java.lang.String parameter.
   */

  @DISPID(201) //= 0xc9. The runtime will prefer the VTID if present
  @VTID(7)
  void program(
    java.lang.String rhs);


  /**
   * <p>
   * Setter method for the COM property "transaction_id"
   * </p>
   * @param rhs Mandatory java.lang.String parameter.
   */

  @DISPID(202) //= 0xca. The runtime will prefer the VTID if present
  @VTID(8)
  void transaction_id(
    java.lang.String rhs);


  /**
   * <p>
   * Setter method for the COM property "invoice_number"
   * </p>
   * @param rhs Mandatory java.lang.String parameter.
   */

  @DISPID(203) //= 0xcb. The runtime will prefer the VTID if present
  @VTID(9)
  void invoice_number(
    java.lang.String rhs);


  /**
   * <p>
   * Setter method for the COM property "transaction_date"
   * </p>
   * @param rhs Mandatory java.lang.String parameter.
   */

  @DISPID(204) //= 0xcc. The runtime will prefer the VTID if present
  @VTID(10)
  void transaction_date(
    java.lang.String rhs);


  /**
   * <p>
   * Setter method for the COM property "transaction_amount"
   * </p>
   * @param rhs Mandatory double parameter.
   */

  @DISPID(205) //= 0xcd. The runtime will prefer the VTID if present
  @VTID(11)
  void transaction_amount(
    double rhs);


  /**
   * <p>
   * Setter method for the COM property "store_id"
   * </p>
   * @param rhs Mandatory java.lang.String parameter.
   */

  @DISPID(206) //= 0xce. The runtime will prefer the VTID if present
  @VTID(12)
  void store_id(
    java.lang.String rhs);


  /**
   * @param code Mandatory java.lang.String parameter.
   * @param quantity Mandatory double parameter.
   * @param unit Mandatory java.lang.String parameter.
   * @param unit_price Mandatory double parameter.
   */

  @DISPID(207) //= 0xcf. The runtime will prefer the VTID if present
  @VTID(13)
  void addProduct(
    java.lang.String code,
    double quantity,
    java.lang.String unit,
    double unit_price);


  /**
   * @param type Mandatory java.lang.String parameter.
   * @param number Mandatory java.lang.String parameter.
   */

  @DISPID(208) //= 0xd0. The runtime will prefer the VTID if present
  @VTID(14)
  void cashier_identification(
    java.lang.String type,
    java.lang.String number);


  /**
   * <p>
   * Setter method for the COM property "period"
   * </p>
   * @param rhs Mandatory java.lang.String parameter.
   */

  @DISPID(209) //= 0xd1. The runtime will prefer the VTID if present
  @VTID(15)
  void period(
    java.lang.String rhs);


  /**
   * <p>
   * Setter method for the COM property "shift"
   * </p>
   * @param rhs Mandatory java.lang.String parameter.
   */

  @DISPID(210) //= 0xd2. The runtime will prefer the VTID if present
  @VTID(16)
  void shift(
    java.lang.String rhs);


  /**
   * <p>
   * Setter method for the COM property "affinity_plan"
   * </p>
   * @param rhs Mandatory java.lang.String parameter.
   */

  @DISPID(211) //= 0xd3. The runtime will prefer the VTID if present
  @VTID(17)
  void affinity_plan(
    java.lang.String rhs);


  // Properties:
}
