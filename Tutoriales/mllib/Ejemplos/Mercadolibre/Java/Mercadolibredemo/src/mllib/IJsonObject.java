package mllib  ;

import com4j.*;

@IID("{CBD2FC29-AA2C-4A03-AC0E-F8004DBDF4C7}")
public interface IJsonObject extends Com4jObject {
  // Methods:
  /**
   * <p>
   * Getter method for the COM property "Str"
   * </p>
   * @param name Mandatory java.lang.String parameter.
   * @return  Returns a value of type java.lang.String
   */

  @DISPID(201) //= 0xc9. The runtime will prefer the VTID if present
  @VTID(7)
  java.lang.String str(
    java.lang.String name);


  /**
   * <p>
   * Setter method for the COM property "Str"
   * </p>
   * @param name Mandatory java.lang.String parameter.
   * @param value Mandatory java.lang.String parameter.
   */

  @DISPID(201) //= 0xc9. The runtime will prefer the VTID if present
  @VTID(8)
  void str(
    java.lang.String name,
    java.lang.String value);


  /**
   * <p>
   * Getter method for the COM property "Int"
   * </p>
   * @param name Mandatory java.lang.String parameter.
   * @return  Returns a value of type int
   */

  @DISPID(202) //= 0xca. The runtime will prefer the VTID if present
  @VTID(9)
  int _int(
    java.lang.String name);


  /**
   * <p>
   * Setter method for the COM property "Int"
   * </p>
   * @param name Mandatory java.lang.String parameter.
   * @param value Mandatory int parameter.
   */

  @DISPID(202) //= 0xca. The runtime will prefer the VTID if present
  @VTID(10)
  void _int(
    java.lang.String name,
    int value);


  /**
   * <p>
   * Getter method for the COM property "Dbl"
   * </p>
   * @param name Mandatory java.lang.String parameter.
   * @return  Returns a value of type double
   */

  @DISPID(203) //= 0xcb. The runtime will prefer the VTID if present
  @VTID(11)
  double dbl(
    java.lang.String name);


  /**
   * <p>
   * Getter method for the COM property "Obj"
   * </p>
   * @param name Mandatory java.lang.String parameter.
   * @return  Returns a value of type mllib.IJsonObject
   */

  @DISPID(204) //= 0xcc. The runtime will prefer the VTID if present
  @VTID(12)
  mllib.IJsonObject obj(
    java.lang.String name);


  /**
   * <p>
   * Getter method for the COM property "Arr"
   * </p>
   * @param name Mandatory java.lang.String parameter.
   * @return  Returns a value of type mllib.IJsonArray
   */

  @DISPID(205) //= 0xcd. The runtime will prefer the VTID if present
  @VTID(13)
  mllib.IJsonArray arr(
    java.lang.String name);


  /**
   * <p>
   * Getter method for the COM property "AsJson"
   * </p>
   * @return  Returns a value of type java.lang.String
   */

  @DISPID(206) //= 0xce. The runtime will prefer the VTID if present
  @VTID(14)
  java.lang.String asJson();


  // Properties:
}
