package mllib  ;

import com4j.*;

@IID("{0C34D73D-3752-49CD-87F9-FAD942A7F982}")
public interface IJsonArray extends Com4jObject {
  // Methods:
  /**
   * <p>
   * Getter method for the COM property "Str"
   * </p>
   * @param indice Mandatory int parameter.
   * @return  Returns a value of type java.lang.String
   */

  @DISPID(201) //= 0xc9. The runtime will prefer the VTID if present
  @VTID(7)
  java.lang.String str(
    int indice);


  /**
   * <p>
   * Getter method for the COM property "Int"
   * </p>
   * @param indice Mandatory int parameter.
   * @return  Returns a value of type int
   */

  @DISPID(202) //= 0xca. The runtime will prefer the VTID if present
  @VTID(8)
  int _int(
    int indice);


  /**
   * <p>
   * Getter method for the COM property "Dbl"
   * </p>
   * @param indice Mandatory int parameter.
   * @return  Returns a value of type double
   */

  @DISPID(203) //= 0xcb. The runtime will prefer the VTID if present
  @VTID(9)
  double dbl(
    int indice);


  /**
   * <p>
   * Getter method for the COM property "Obj"
   * </p>
   * @param indice Mandatory int parameter.
   * @return  Returns a value of type mllib.IJsonObject
   */

  @DISPID(204) //= 0xcc. The runtime will prefer the VTID if present
  @VTID(10)
  mllib.IJsonObject obj(
    int indice);


  /**
   * <p>
   * Getter method for the COM property "Count"
   * </p>
   * @return  Returns a value of type int
   */

  @DISPID(205) //= 0xcd. The runtime will prefer the VTID if present
  @VTID(11)
  int count();


  /**
   * <p>
   * Getter method for the COM property "AsJson"
   * </p>
   * @return  Returns a value of type java.lang.String
   */

  @DISPID(206) //= 0xce. The runtime will prefer the VTID if present
  @VTID(12)
  java.lang.String asJson();


  /**
   * <p>
   * Getter method for the COM property "AsCommaDelimited"
   * </p>
   * @return  Returns a value of type java.lang.String
   */

  @DISPID(207) //= 0xcf. The runtime will prefer the VTID if present
  @VTID(13)
  java.lang.String asCommaDelimited();


  // Properties:
}
