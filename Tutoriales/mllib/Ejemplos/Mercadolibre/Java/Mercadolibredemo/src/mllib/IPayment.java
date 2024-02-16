package mllib  ;

import com4j.*;

@IID("{6B8837F3-4EAE-4738-BDCC-F3F6E60008B7}")
public interface IPayment extends Com4jObject {
  // Methods:
  /**
   * <p>
   * Getter method for the COM property "id"
   * </p>
   * @return  Returns a value of type java.lang.String
   */

  @DISPID(201) //= 0xc9. The runtime will prefer the VTID if present
  @VTID(7)
  java.lang.String id();


  /**
   * <p>
   * Getter method for the COM property "total_paid_amount"
   * </p>
   * @return  Returns a value of type double
   */

  @DISPID(202) //= 0xca. The runtime will prefer the VTID if present
  @VTID(8)
  double total_paid_amount();


  /**
   * <p>
   * Getter method for the COM property "shipping_cost"
   * </p>
   * @return  Returns a value of type double
   */

  @DISPID(203) //= 0xcb. The runtime will prefer the VTID if present
  @VTID(9)
  double shipping_cost();


  /**
   * <p>
   * Getter method for the COM property "currency_id"
   * </p>
   * @return  Returns a value of type java.lang.String
   */

  @DISPID(204) //= 0xcc. The runtime will prefer the VTID if present
  @VTID(10)
  java.lang.String currency_id();


  /**
   * <p>
   * Getter method for the COM property "status"
   * </p>
   * @return  Returns a value of type java.lang.String
   */

  @DISPID(205) //= 0xcd. The runtime will prefer the VTID if present
  @VTID(11)
  java.lang.String status();


  /**
   * <p>
   * Getter method for the COM property "status_detail"
   * </p>
   * @return  Returns a value of type java.lang.String
   */

  @DISPID(206) //= 0xce. The runtime will prefer the VTID if present
  @VTID(12)
  java.lang.String status_detail();


  /**
   * <p>
   * Getter method for the COM property "date_approved"
   * </p>
   * @return  Returns a value of type java.lang.String
   */

  @DISPID(207) //= 0xcf. The runtime will prefer the VTID if present
  @VTID(13)
  java.lang.String date_approved();


  /**
   * <p>
   * Getter method for the COM property "date_created"
   * </p>
   * @return  Returns a value of type java.lang.String
   */

  @DISPID(208) //= 0xd0. The runtime will prefer the VTID if present
  @VTID(14)
  java.lang.String date_created();


  /**
   * <p>
   * Getter method for the COM property "last_modified"
   * </p>
   * @return  Returns a value of type java.lang.String
   */

  @DISPID(209) //= 0xd1. The runtime will prefer the VTID if present
  @VTID(15)
  java.lang.String last_modified();


  /**
   * <p>
   * Getter method for the COM property "amount_refunded"
   * </p>
   * @return  Returns a value of type double
   */

  @DISPID(210) //= 0xd2. The runtime will prefer the VTID if present
  @VTID(16)
  double amount_refunded();


  // Properties:
}
