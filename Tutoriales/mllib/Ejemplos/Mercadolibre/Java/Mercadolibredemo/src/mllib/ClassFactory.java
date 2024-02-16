package mllib  ;

import com4j.*;

/**
 * Defines methods to create COM objects
 */
public abstract class ClassFactory {
  private ClassFactory() {} // instanciation is not allowed


  /**
   * MPService Object
   */
  public static mllib.IMPService createMPService() {
    return COM4J.createInstance( mllib.IMPService.class, "{50FF357E-C78D-4C42-9F03-E405EF0DC786}" );
  }

  public static mllib.Imerchant_order createmerchant_order() {
    return COM4J.createInstance( mllib.Imerchant_order.class, "{B4D14995-2F7A-47C4-822E-04C1795036A6}" );
  }

  public static mllib.Iloyalty createloyalty() {
    return COM4J.createInstance( mllib.Iloyalty.class, "{902D80C8-8D60-4AA6-9906-61A3AA929B42}" );
  }

  public static mllib.IPayment createPayment() {
    return COM4J.createInstance( mllib.IPayment.class, "{0D662A74-0FE0-4802-8DB3-9FF7819DDE39}" );
  }

  /**
   * MLService Object
   */
  public static mllib.IMLService createMLService() {
    return COM4J.createInstance( mllib.IMLService.class, "{661294D3-313C-463A-B1A3-1C713398876B}" );
  }

  public static mllib.IJsonObject createJsonObject() {
    return COM4J.createInstance( mllib.IJsonObject.class, "{650F2776-069D-4534-9674-9DBC9A964A37}" );
  }

  public static mllib.IJsonArray createJsonArray() {
    return COM4J.createInstance( mllib.IJsonArray.class, "{06146A09-CCCE-48EC-8651-EB7C0CB80A42}" );
  }
}
