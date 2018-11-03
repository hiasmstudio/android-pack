package hiasm.hiasmproject;

import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.Method;

import android.content.Context;

public class StreamUtils {

	public interface OnDataListener {
		public abstract void onData(Memory data);
		public abstract void onError(String text);
	}
	
	Context mContext;
	OnDataListener mListener;
	DataStructure mDataStructure = new DataStructure();
	ReaderThread mReaderThread;
	byte[] mBuffer;
	
	public StreamUtils(Context context) {
		mContext = context;
	}
	
	public void setListener(OnDataListener listener) {
		mListener = listener;
	}
	
	public void setReaderState(boolean state, InputStream inputStream) {
		if(state)
			startReading(inputStream);
		else stopReading();
	}
	
	public void startReading(InputStream inputStream) {
		mReaderThread = new ReaderThread(inputStream);
		mReaderThread.start();
	}
	
	public void stopReading() {
		mReaderThread.stopReading();
		mReaderThread.interrupt();
	}
	
	public void write(OutputStream outputStream, Memory memory) {
		try {
			outputStream.write(memory.readString().getBytes());
			outputStream.flush();
		} catch (Exception e) {
			mDataStructure.exception(e);
		}
	}
	
	
	/* Internal implementations */
	
	static class DataStructure {
		
		public boolean isData;
		public byte[] data;
		public Exception error;
		
		public void data(byte[] data) {
			this.isData = true;
			this.data = data;
		}
		
		public void exception(Exception e) {
			this.isData = false;
			this.error = e;
			e.printStackTrace();
		}
		
	}
	
	void tryUiThread(Runnable runnable) {
		boolean hasUiThread = false; 
		Method uiMethod = null;
		try {
			uiMethod = mContext.getClass().getMethod("runOnUiThread", Runnable.class);
			if(uiMethod != null) hasUiThread = true;
		} catch (Exception e) {
			hasUiThread = false;
		}
		
		if(hasUiThread) {
			try {
				uiMethod.invoke(mContext, runnable);
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else {
			runnable.run();
		}

	}
	
	Runnable mExecData = new Runnable() {
		
		@Override
		public void run() {
			mListener.onData(new Memory().setValue(mDataStructure.data));
		}
	};
	
	Runnable mExecError = new Runnable() {
		
		@Override
		public void run() {
			mListener.onError(mDataStructure.error.getMessage());
		}
	};
	
	class ReaderThread extends Thread {
		
		InputStream mInputStream;
		boolean mToggle = true;
		
		public ReaderThread(InputStream inputStream) {
			mInputStream = inputStream;
		}
		
		public void stopReading() {
			mToggle = false;
		}
		
		@Override
		public void run() {
			int avilable = 0;
			byte[] buffer;
			try {
				while(mToggle) {
					avilable = mInputStream.available();
					if(avilable > 0) {
						buffer = new byte[avilable];
						mInputStream.read(buffer);
						mDataStructure.data(buffer);
						tryUiThread(mExecData);
					}
				}
			} catch (Exception e) {
				mDataStructure.exception(e);
				tryUiThread(mExecError);
			}
		}
		
	}
	
}