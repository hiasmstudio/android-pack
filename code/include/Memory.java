package hiasm.hiasmproject;

public class Memory {

  private final byte DT_EMPTY = 0;
  private final byte DT_LONG = 1;
  private final byte DT_FLOAT = 2;
  private final byte DT_DOUBLE = 3;
  private final byte DT_CHAR = 4;
  private final byte DT_STRING = 5;
  private final byte DT_OBJECT = 6;

  private byte dataType = 0;
  
  private long longValue;
  private float floatValue;
  private double doubleValue;
  private String stringValue = "";
  private Object objectValue;
  
  public Memory clear() {
    objectValue = null;
    stringValue = "";
    dataType = DT_EMPTY;
    return this;
  }

  // Методы записи
  public Memory setValue(boolean v) {
    longValue = v?1:0;
    dataType = DT_LONG;
    return this;
  }
  public Memory setValue(byte v) {
    longValue = v;
    dataType = DT_LONG;
    return this;
  }
  public Memory setValue(short v) {
    longValue = v;
    dataType = DT_LONG;
    return this;
  }
  public Memory setValue(int v) {
    longValue = v;
    dataType = DT_LONG;
    return this;
  }
  public Memory setValue(long v) {
    longValue = v;
    dataType = DT_LONG;
    return this;
  }
  public Memory setValue(float v) {
    floatValue = v;
    dataType = DT_FLOAT;
    return this;
  }
  public Memory setValue(double v) {
    doubleValue = v;
    dataType = DT_DOUBLE;
    return this;
  }
  public Memory setValue(char v) {
    longValue = v;
    dataType = DT_CHAR;
    return this;
  }
  public Memory setValue(String v) {
    stringValue = v;
    dataType = DT_STRING;
    return this;
  }
  public Memory setValue(Object v) {
    objectValue = v;
    dataType = DT_OBJECT;
    return this;
  }
  public Memory setValue(byte[] v) {
    return setValue(new String(v));
  }
  
  // Методы чтения
  public boolean readBool() {
    switch (dataType) {
      case DT_LONG: case DT_CHAR:
        return (longValue != 0);
      case DT_FLOAT:
        return (floatValue != 0.0);
      case DT_DOUBLE:
        return (doubleValue != 0.0);
      case DT_STRING:
        return !(stringValue.isEmpty() || stringValue.compareTo("0") == 0);
      default:
        return false;
    }
  }
  
  public byte readByte() {
    switch (dataType) {
      case DT_LONG: case DT_CHAR:
        return (byte) longValue;
      case DT_FLOAT:
        return (byte) floatValue;
      case DT_DOUBLE:
        return (byte) doubleValue;
      case DT_STRING:
        try {
          return Byte.parseByte(stringValue);
        }
        catch(Exception e){
          return 0;
        }
      default:
        return 0;
    }
  }
  
  public short readShort() {
    switch (dataType) {
      case DT_LONG: case DT_CHAR:
        return (short) longValue;
      case DT_FLOAT:
        return (short) floatValue;
      case DT_DOUBLE:
        return (short) doubleValue;
      case DT_STRING:
        try {
          return Short.parseShort(stringValue);
        }
        catch(Exception e){
          return 0;
        }
      default:
        return 0;
    }
  }
  
  public int readInt() {
    switch (dataType) {
      case DT_LONG: case DT_CHAR:
        return (int) longValue;
      case DT_FLOAT:
        return (int) floatValue;
      case DT_DOUBLE:
        return (int) doubleValue;
      case DT_STRING:
        try {
          return Integer.parseInt(stringValue);
        }
        catch(Exception e){
          return 0;
        }
      default:
        return 0;
    }
  }
  
  public long readLong() {
    switch (dataType) {
      case DT_LONG: case DT_CHAR:
        return longValue;
      case DT_FLOAT:
        return (long) floatValue;
      case DT_DOUBLE:
        return (long) doubleValue;
      case DT_STRING:
        try {
          return Long.parseLong(stringValue);
        }
        catch(Exception e){
          return 0;
        }
      default:
        return 0;
    }
  }
  
  public float readFloat() {
    switch (dataType) {
      case DT_LONG: case DT_CHAR:
        return (float) longValue;
      case DT_FLOAT:
        return floatValue;
      case DT_DOUBLE:
        return (float) doubleValue;
      case DT_STRING:
        try {
          return Float.parseFloat(stringValue);
        }
        catch(Exception e){
          return 0;
        }
      default:
        return 0;
    }
  }
  
  public double readDouble() {
    switch (dataType) {
      case DT_LONG: case DT_CHAR:
        return (double) longValue;
      case DT_FLOAT:
        return (double) floatValue;
      case DT_DOUBLE:
        return doubleValue;
      case DT_STRING:
        try {
          return Double.parseDouble(stringValue);
        }
        catch(Exception e){
          return 0.0;
        }
      default:
        return 0.0;
    }
  }
  
  public char readChar() {
    switch (dataType) {
      case DT_LONG: case DT_CHAR:
        return (char) longValue;
      case DT_FLOAT:
        return (char) floatValue;
      case DT_DOUBLE:
        return (char) doubleValue;
      case DT_STRING:
        try {
          return stringValue.charAt(0);
        }
        catch(Exception e){
          return 0;
        }
      default:
        return 0;
    }
  }
  
  public String readString() {
    switch (dataType) {
      case DT_LONG:
        return String.valueOf(longValue);
      case DT_FLOAT:
        return String.valueOf(floatValue);
      case DT_DOUBLE:
        return String.valueOf(doubleValue);
      case DT_CHAR:
        return String.valueOf((char) longValue); // Выдается строка из 1 символа, а не текстовое значение его кода
      case DT_STRING:
        return stringValue;
      default:
        return "";
    }
    
  }

  public <T> T readObject(Class<T> c) {
    return ((dataType == DT_OBJECT) && c.isInstance(objectValue))?(T) objectValue:null;
  }

}