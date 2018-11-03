package hiasm.hiasmproject;

import java.net.Socket;
import java.net.InetSocketAddress;
import java.io.OutputStream;
import java.io.InputStream;
import java.io.InterruptedIOException;
import java.util.Arrays;

public class TCPClient {
  /* Private */
  private final static int RECEIVE_TIMEOUT = 2000;
  private boolean fSending;
  private ConnectRunnable fConnectRunnable;
  private SendingRunnable fSendingRunnable;
  private ReceivingThread fReceivingThread;
  
  /* Public */
  public Socket socket;
  public int connectTimeout = 10000;

  public OnConnectListener onConnectListener;
  public OnDisconnectListener onDisconnectListener;
  public OnSendListener onSendListener;
  public OnProgressListener onProgressListener;
  public OnReceiveListener onReceiveListener;

  
  public void connect(String host, int port, boolean async) {
    if ((socket != null) || (fConnectRunnable != null)) return;
    
    fConnectRunnable = new ConnectRunnable(host, port);
    if (async) fConnectRunnable.runAsync(); else fConnectRunnable.run();
  }
  
  public void disconnect() {
    if (fConnectRunnable != null){
      fConnectRunnable.stopped = true;
      fConnectRunnable = null;
    }
    if (socket == null) return;
    abortSend();
    stopReceiving();
    try{
      socket.shutdownInput();
      socket.shutdownOutput();
      socket.close();
    }
    catch (Exception e){}
    socket = null;
  }
  
  private void internalDisconnect() {
    disconnect();
    if (onDisconnectListener != null) onDisconnectListener.onDisconnect(this);
  }
  
  public boolean isConnected() {
    return (socket != null) && (socket.isConnected()) && (!socket.isInputShutdown());
  }
  
  public void startReceiving() {
    if ((fReceivingThread == null) && (isConnected())){
      fReceivingThread = new ReceivingThread();
      fReceivingThread.start();
    }
  }
  
  public void stopReceiving() {
    if (fReceivingThread != null){
      fReceivingThread.stopped = true;
      fReceivingThread = null;
    }
  }
  
  private void internalSend(byte[] data, boolean async) {
    if ((data.length == 0) || fSending || !isConnected()) return;
    fSending = true;
    fSendingRunnable = new SendingRunnable();
    fSendingRunnable.data = data;
    if (async) fSendingRunnable.runAsync(); else fSendingRunnable.run();
  }
  
  public void send(byte[] data) {
    internalSend(data, false);
  }
  
  public void send(String data) {
    internalSend(data.getBytes(), false);
  }
  
  public void sendAsync(byte[] data) {
    internalSend(data, true);
  }
  
  public void sendAsync(String data) {
    internalSend(data.getBytes(), true);
  }
  
  public void abortSend() {
    if (!fSending) return;
    
    if (fSendingRunnable != null){
      fSendingRunnable.stopped = true;
      fSendingRunnable = null;
    }

    fSending = false;
  }
  
  @Override
  protected void finalize() {
    disconnect();
  }
  
  /*-------------------------------*/
  
  /*------- ReceivingThread -------*/
  
  class ReceivingThread extends Thread {
    public boolean stopped = false;
    
    @Override
    public void run() {
      if (!TCPClient.this.isConnected()) return;
      InputStream is = null;
      
      try {
        is = TCPClient.this.socket.getInputStream();
      }
      catch (Exception ex) {
        TCPClient.this.internalDisconnect();
        return;
      }
      
      byte[] dt = new byte[10*1024];
      int count = 0;
      
      while (!stopped){
        try {
          count = is.read(dt);
          if (stopped) return;
          
          if (count > 0) {
            if (TCPClient.this.onReceiveListener != null) {
              TCPClient.this.onReceiveListener.onReceive(TCPClient.this, Arrays.copyOf(dt, count));
            }
          }
          else {
            TCPClient.this.internalDisconnect();
          }
        }
        catch (InterruptedIOException ex) { // Таймаут
          continue;
        }
        catch (Exception ex) {
          if (!stopped) TCPClient.this.internalDisconnect();
          return;
        }
      }
      
      if (!stopped) TCPClient.this.fReceivingThread = null;
    }
  }
  
  /*-------------------------------*/
  
  /*------- ConnectRunnable -------*/
 
  class ConnectRunnable implements Runnable {
    private String fHost;
    private int fPort;
    
    public boolean stopped = false;
    
    ConnectRunnable(String host, int port){
      fHost = host;
      fPort = port;
    }
    
    @Override
    public void run() {
      InetSocketAddress addr = null;
      try {
        addr = new InetSocketAddress(fHost, fPort);
      }
      catch (Exception e) {
        if (!stopped){
          raiseError();
          return;
        }
      }
      
      if (stopped) return;
      
      Socket sock = new Socket();
      try {
        sock.bind(null);
        sock.connect(addr, TCPClient.this.connectTimeout);
      }
      catch (Exception ex) {
        if (!stopped){
          raiseError();
          return;
        }
      }
      
      if (stopped){ // Соединение успешно, но было отменено
        try{
          socket.close();
        }
        catch (Exception e){}
        return;
      }
      try {
        sock.setSoTimeout(TCPClient.RECEIVE_TIMEOUT);
      }
      catch (Exception ex) {};
      
      TCPClient.this.socket = sock;
      TCPClient.this.fConnectRunnable = null;
      if (TCPClient.this.onConnectListener != null) TCPClient.this.onConnectListener.onConnect(TCPClient.this);
    }
    
    public void runAsync() {
      new Thread(this).start();
    }
    
    private void raiseError(){
      TCPClient.this.fConnectRunnable = null;
      if (TCPClient.this.onConnectListener != null) TCPClient.this.onConnectListener.onConnectError(TCPClient.this);
    }
  }
  
  /*-------------------------------*/
  
  /*------- SendingRunnable -------*/
  
  class SendingRunnable implements Runnable {
    public boolean stopped = false;
    public byte[] data;
    
    @Override
    public void run() {
      if ((data == null) || (data.length == 0)) {
        TCPClient.this.fSendingRunnable = null;
        TCPClient.this.fSending = false;
        return;
      }

      OutputStream os = null;
      try {
        os = TCPClient.this.socket.getOutputStream();
      }
      catch (Exception ex) {
        TCPClient.this.fSendingRunnable = null;
        TCPClient.this.fSending = false;
        if (TCPClient.this.onSendListener != null) TCPClient.this.onSendListener.onSendError(TCPClient.this);
        return;
      }
      
      int total = 0;
      int count = 10*1024;
      int len = data.length;
      try {
        while(total < len){
          if (count > len - total) count = len - total;
          os.write(data, total, count);
          total += count;
          if (stopped) return;
          if (TCPClient.this.onProgressListener != null) TCPClient.this.onProgressListener.onProgress(TCPClient.this, total);
        }
      }
      catch(Exception ex) {
        if (stopped) return;
        if (!TCPClient.this.isConnected()) TCPClient.this.internalDisconnect();
        TCPClient.this.fSending = false;
        if (TCPClient.this.onSendListener != null) TCPClient.this.onSendListener.onSendError(TCPClient.this);
        return;
      }
      
      if (stopped) return;
      TCPClient.this.fSending = false;
      if (TCPClient.this.onSendListener != null) TCPClient.this.onSendListener.onSend(TCPClient.this);
    }
    
    public void runAsync() {
      new Thread(this).start();
    }
  }
  
  /*-------------------------------*/
  
  /*------- Интерфейсы событий -------*/
  
  public interface OnConnectListener {
    public void onConnect(TCPClient tcp);
    public void onConnectError(TCPClient tcp);
  }
  
  public interface OnDisconnectListener {
    public void onDisconnect(TCPClient tcp);
  }
  
  public interface OnSendListener {
    public void onSend(TCPClient tcp);
    public void onSendError(TCPClient tcp);
  }
  
  public interface OnProgressListener {
    public void onProgress(TCPClient tcp, int progress);
  }
  
  public interface OnReceiveListener {
    public void onReceive(TCPClient tcp, byte[] data);
  }
  
  /*-------------------------------*/
}


